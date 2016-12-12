module Components.Articles.Articles exposing (..)

import Components.Tags.Tags exposing (Tag(Category, Place), tagToString, toggleVisibleTag)
import Contentful exposing (decodeArticles, decodeEntries)
import Messages exposing (..)
import Models exposing (Article, State, Url)
import Json.Decode as D
import Json.Encode as E
import Http exposing (expectJson, request)
import Task
import QueryString exposing (QueryString)


api : String
api =
    "http://localhost:3000"



{- decodeArticle : D.Decoder Article
   decodeArticle =
       D.map7 Article
           (D.at [ "id" ] D.string)
           (D.at [ "title" ] D.string)
           (D.at [ "description" ] D.string)
           (D.at [ "body" ] D.string)
           (D.at [ "photoThumbnail" ] D.string)
           (D.at [ "tags" ] <| D.list <| D.map Category D.string)
           (D.at [ "place" ] <| D.map Place D.string)
-}


decodeArticle : D.Decoder Article
decodeArticle =
    let
        categoriesDecoder =
            (D.field "items" <| D.index 0 <| D.at [ "fields", "categories" ] <| D.list <| D.at [ "sys", "id" ] <| D.map Category D.string)

        placeDecoder =
            (D.at [ "place" ] <| D.map Place D.string)
    in
        D.map7 Article
            (D.field "items" <| D.index 0 <| D.at [ "sys", "id" ] <| D.string)
            (D.field "items" <| D.index 0 <| D.at [ "fields", "title" ] <| D.string)
            (D.field "items" <| D.index 0 <| D.at [ "fields", "description" ] <| D.string)
            (D.field "items" <| D.index 0 <| D.at [ "fields", "body" ] <| D.string)
            (D.at [ "includes", "Assets" ] <| D.index 0 <| D.at [ "fields", "file", "url" ] <| D.string)
            categoriesDecoder
            placeDecoder


encodeArticle : Article -> E.Value
encodeArticle article =
    E.object [ ( "body", E.string article.body ) ]


getArticles : Http.Request (List Article)
getArticles =
    let
        path =
            "/entries?content_type=articles"
    in
        get path decodeArticles


getFilteredArticles : ( List Tag, List Tag ) -> Tag -> Cmd Msg
getFilteredArticles ( visiblePlaces, visibleCategories ) tag =
    let
        formatTags key tags =
            tags
                |> List.map tagToString
                |> List.map (\s -> ( key, s ))

        addOne : ( String, String ) -> QueryString -> QueryString
        addOne ( key, value ) =
            QueryString.add key value

        tags =
            case tag of
                Place _ ->
                    ( toggleVisibleTag tag visiblePlaces, visibleCategories )

                Category _ ->
                    ( visiblePlaces, toggleVisibleTag tag visibleCategories )

        querystring ( places, categories ) =
            ((formatTags "places" places) ++ (formatTags "categories" categories))
                |> List.foldl addOne QueryString.empty
                |> QueryString.render
    in
        (Http.toTask <| Http.get (api ++ "/articles" ++ querystring tags) <| D.list decodeArticle)
            |> Task.map (\articles -> ( articles, tags ))
            |> Task.attempt FetchFilteredArticles


get : String -> D.Decoder a -> Http.Request a
get path decoder =
    request
        { method = "GET"
        , headers = [ Http.header "Authorization" "Bearer 1cad074517694d45ea6e972c4a2a0c716b7beb45daf02c260f1d7879a43f14d1" ]
        , url = "https://cdn.contentful.com/spaces/rqclkj9xcpx2" ++ path
        , body = Http.emptyBody
        , expect = expectJson decoder
        , timeout = Nothing
        , withCredentials = False
        }


getCategories : Cmd Msg
getCategories =
    let
        decodeCategories =
            D.field "items" <| D.list <| D.at [ "fields", "title" ] <| D.map Category D.string

        path =
            "/entries?content_type=categories"
    in
        Http.send FetchCategories <| get path decodeCategories


getPlaces : Cmd Msg
getPlaces =
    let
        decodePlaces =
            D.field "items" <| D.list <| D.at [ "fields", "title" ] <| D.map Place D.string

        path =
            "/entries?content_type=places"
    in
        Http.send FetchPlaces <| get path decodePlaces


updateArticles : State -> Article -> Maybe (List Article)
updateArticles { articles } article =
    articles
        |> Maybe.withDefault []
        |> List.filter (\a -> a.id /= article.id)
        |> (::) article
        |> Just


patchArticle : Maybe Article -> Cmd Msg
patchArticle article =
    let
        put : Article -> Http.Request Article
        put article =
            request
                { method = "PATCH"
                , headers = []
                , url = api ++ "/articles" ++ "/" ++ article.id
                , body = Http.jsonBody <| encodeArticle article
                , expect = expectJson decodeArticle
                , timeout = Nothing
                , withCredentials = False
                }
    in
        case article of
            Nothing ->
                Cmd.none

            Just article ->
                Http.send UpdateArticle <| put article
