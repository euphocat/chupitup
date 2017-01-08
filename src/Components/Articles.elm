module Components.Articles exposing (getArticles, getTags)

import Components.Tags exposing (Tag, TagKind(Category, Place), toggleTags)
import Contentful exposing (decodeArticles)
import Dict exposing (Dict)
import Messages exposing (FetchMsg(FetchArticles, FetchTags), Msg(FetchTask))
import Json.Decode as D
import Http exposing (expectJson, request)
import Task
import QueryString exposing (QueryString)


getArticles : Dict String Tag -> Cmd Msg
getArticles tags =
    let
        formatTags kind tags =
            tags
                |> Dict.filter (\_ t -> t.kind == kind && t.isActive)
                |> Dict.keys
                |> String.join ","

        addNotEmpty key value querystring =
            if value /= "" then
                QueryString.add key value querystring
            else
                querystring

        querystring tags =
            QueryString.empty
                |> addNotEmpty "fields.place.sys.id[in]" (formatTags Place tags)
                |> addNotEmpty "fields.categories.sys.id[in]" (formatTags Category tags)
                |> QueryString.add "content_type" "articles"
                |> QueryString.render
                |> (++) "/entries"
    in
        (Http.toTask <| get (querystring tags) decodeArticles)
            |> Task.attempt (FetchTask << FetchArticles)


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


getTags : TagKind -> Cmd Msg
getTags kind =
    let
        path =
            case kind of
                Category ->
                    "/entries?content_type=categories"

                Place ->
                    "/entries?content_type=places"
    in
        Http.send (FetchTask << FetchTags) <| get path <| decodeTags kind


decodeTags : TagKind -> D.Decoder (Dict String Tag)
decodeTags kind =
    (D.field "items" <| D.list <| decodeTag kind)
        |> D.map (List.map tagToTuple)
        |> D.map Dict.fromList


tagToTuple : Tag -> ( String, Tag )
tagToTuple tag =
    ( tag.id, tag )


decodeTag : TagKind -> D.Decoder Tag
decodeTag kind =
    D.map4 Tag
        (D.at [ "sys", "id" ] D.string)
        (D.at [ "fields", "title" ] D.string)
        (D.succeed False)
        (D.succeed kind)
