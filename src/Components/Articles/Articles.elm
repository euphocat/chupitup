module Components.Articles.Articles exposing (..)

import Messages exposing (..)
import Models exposing (Article, State, Url)
import Json.Decode as Decode
import Json.Encode
import Http exposing (expectJson, request)
import Task


articleApi : String
articleApi =
    "http://localhost:3000/articles"


decodeArticle : Decode.Decoder Article
decodeArticle =
    Decode.map7 Article
        (Decode.at [ "id" ] Decode.string)
        (Decode.at [ "title" ] Decode.string)
        (Decode.at [ "description" ] Decode.string)
        (Decode.at [ "body" ] Decode.string)
        (Decode.at [ "photoThumbnail" ] Decode.string)
        (Decode.at [ "tags" ] (Decode.list Decode.string))
        (Decode.at [ "place" ] Decode.string)


decodeArticles : Decode.Decoder (List Article)
decodeArticles =
    Decode.list decodeArticle


encodeArticle : Article -> Json.Encode.Value
encodeArticle article =
    Json.Encode.object [ ( "body", Json.Encode.string article.body ) ]


getArticles : String -> Task.Task Http.Error (List Article)
getArticles url =
    Http.toTask <| Http.get url decodeArticles


updateArticles : State -> Article -> Maybe (List Article)
updateArticles state article =
    state.articles
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
                , url = articleApi ++ "/" ++ article.id
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
                Http.send UpdateArticle (put article)
