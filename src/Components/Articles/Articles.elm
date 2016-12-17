module Components.Articles.Articles exposing (..)

import Components.Tags.Tags exposing (Tag, toggleVisibleTag)
import Contentful exposing (decodeArticles)
import Messages exposing (..)
import Models exposing (Article, State, Url)
import Json.Decode as D
import Json.Encode as E
import Http exposing (expectJson, request)
import Task
import QueryString exposing (QueryString)


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


getFilteredArticles : ( List Tag, List Tag ) -> TagType -> Tag -> Cmd Msg
getFilteredArticles ( visiblePlaces, visibleCategories ) tagType tag =
    let
        path =
            "/entries"

        formatTags tags =
            tags
                |> List.map .id
                |> List.foldl (++) ""

        addOne : ( String, String ) -> QueryString -> QueryString
        addOne ( key, value ) =
            QueryString.add key value

        tags =
            case tagType of
                Place ->
                    ( toggleVisibleTag tag visiblePlaces, visibleCategories )

                Category ->
                    ( visiblePlaces, toggleVisibleTag tag visibleCategories )

        querystring ( places, categories ) =
            QueryString.empty
                |> QueryString.add "fields.place.sys.id" (formatTags places)
                |> QueryString.add "fields.categories.sys.id" (formatTags categories)
                |> QueryString.add "content_type" "articles"
                |> QueryString.render
    in
        (Http.toTask <| get (path ++ (querystring tags)) decodeArticles)
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
        path =
            "/entries?content_type=categories"
    in
        Http.send FetchCategories <| get path decodeTags


getPlaces : Cmd Msg
getPlaces =
    let
        path =
            "/entries?content_type=places"
    in
        Http.send FetchPlaces <| get path decodeTags


decodeTags =
    D.field "items" <| D.list decodeTag


decodeTag =
    D.map2 Tag
        (D.at [ "sys", "id" ] D.string)
        (D.at [ "fields", "title" ] D.string)
