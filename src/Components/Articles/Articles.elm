module Components.Articles.Articles exposing (getArticles, getFilteredArticles, getPlaces, getCategories)

import Components.Tags.Tags exposing (Tag, toggleVisibleTag)
import Contentful exposing (decodeArticles)
import Messages exposing (Msg(FetchCategories, FetchFilteredArticles, FetchPlaces), TagType(Category, Place))
import Models exposing (Article, State)
import Json.Decode as D
import Http exposing (expectJson, request)
import Task
import QueryString exposing (QueryString)


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
        formatTags tags =
            tags
                |> List.map .id
                |> String.join ","

        tags =
            case tagType of
                Place ->
                    ( toggleVisibleTag tag visiblePlaces, visibleCategories )

                Category ->
                    ( visiblePlaces, toggleVisibleTag tag visibleCategories )

        addNotEmpty key value querystring =
            if value /= "" then
                QueryString.add key value querystring
            else
                querystring

        querystring ( places, categories ) =
            QueryString.empty
                |> addNotEmpty "fields.place.sys.id[in]" (formatTags places)
                |> addNotEmpty "fields.categories.sys.id[in]" (formatTags categories)
                |> QueryString.add "content_type" "articles"
                |> QueryString.render
    in
        (Http.toTask <| get ("/entries" ++ (querystring tags)) decodeArticles)
            |> Task.map (\articles -> ( articles, tags ))
            |> Task.attempt FetchFilteredArticles


get : String -> D.Decoder a -> Http.Request a
get path decoder =
    let
        accessToken =
            "1cad074517694d45ea6e972c4a2a0c716b7beb45daf02c260f1d7879a43f14d1"

        apiUrl =
            "https://cdn.contentful.com/spaces/rqclkj9xcpx2"
    in
        request
            { method = "GET"
            , headers = [ Http.header "Authorization" <| "Bearer " ++ accessToken ]
            , url = apiUrl ++ path
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
