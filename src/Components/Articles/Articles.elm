module Components.Articles.Articles exposing (..)

import Admin.Routes exposing (..)
import Messages exposing (..)
import Models exposing (Article, State, Url)
import Json.Decode as Decode
import Json.Encode
import Routing.Routes exposing (..)
import Http exposing (Value)
import Task


articleApi =
    "http://localhost:3000/articles"


decodeArticle : Decode.Decoder Article
decodeArticle =
    Decode.object7 Article
        (Decode.at [ "id" ] Decode.string)
        (Decode.at [ "title" ] Decode.string)
        (Decode.at [ "description" ] Decode.string)
        (Decode.at [ "body" ] Decode.string)
        (Decode.at [ "photoThumbnail" ] Decode.string)
        (Decode.at [ "tags" ] (Decode.list Decode.string))
        (Decode.at [ "place" ] Decode.string)


encodeArticle : Article -> Json.Encode.Value
encodeArticle article =
    Json.Encode.object [ ( "body", Json.Encode.string article.body ) ]


decodeArticles : Decode.Decoder (List Article)
decodeArticles =
    Decode.list decodeArticle


fetchArticles : Url -> Cmd Msg
fetchArticles url =
    Task.perform
        FetchFailed
        FetchSucceed
        (Http.get decodeArticles url)


updateArticles state article =
    state.articles
        |> Maybe.withDefault []
        |> List.filter (\a -> a.id /= article.id)
        |> (::) article
        |> Just


patchArticle : Maybe Article -> Cmd Msg
patchArticle article =
    let
        request : Article -> Http.Request
        request article =
            { verb = "PATCH"
            , headers = [ ( "Content-Type", "application/json" ) ]
            , url = articleApi ++ "/" ++ article.id
            , body = (Http.string (Json.Encode.encode 0 (encodeArticle article)))
            }

        sendTask article =
            Http.send Http.defaultSettings (request article)
    in
        case article of
            Nothing ->
                Cmd.none

            Just article ->
                Task.perform
                    PatchFailed
                    PatchSucceed
                    (Http.fromJson decodeArticle (sendTask article))
