module Components.Articles.Articles exposing (..)

import Components.Tags.Tags exposing (Tag(Category, Place), tagToString, toggleVisibleTag)
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


decodeArticle : D.Decoder Article
decodeArticle =
    D.map7 Article
        (D.at [ "id" ] D.string)
        (D.at [ "title" ] D.string)
        (D.at [ "description" ] D.string)
        (D.at [ "body" ] D.string)
        (D.at [ "photoThumbnail" ] D.string)
        (D.at [ "tags" ] <| D.list <| D.map Category D.string)
        (D.at [ "place" ] <| D.map Place D.string)


encodeArticle : Article -> E.Value
encodeArticle article =
    E.object [ ( "body", E.string article.body ) ]


getArticles : Http.Request (List Article)
getArticles =
    Http.get (api ++ "/articles") <| D.list decodeArticle


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


getPlaces : Cmd Msg
getPlaces =
    Http.send FetchPlaces <| Http.get (api ++ "/places") <| D.list <| D.map Place D.string


getCategories : Cmd Msg
getCategories =
    Http.send FetchCategories <| Http.get (api ++ "/categories") <| D.list <| D.map Category D.string


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
