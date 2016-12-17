module Contentful exposing (..)

import Components.Tags.Tags exposing (Tag)
import Json.Decode as D
import List.Extra exposing (find)
import Models exposing (Article, Url)


type alias Entries =
    { sys : Sys
    , items : List Item
    , includes : Maybe Includes
    }


type alias Includes =
    { entry : List Item
    , assets : List Item
    }


type alias Item =
    { sys : Sys
    , fields : D.Value
    }


type alias Sys =
    { id : Maybe String
    , sType : String
    , contentType : Maybe UnderSys
    }


type UnderSys
    = UnderSys Sys


getPlace : Entries -> Sys -> Tag
getPlace entries sys =
    case entries.includes of
        Just includes ->
            find (\entry -> sys.id == entry.sys.id) includes.entry
                |> Maybe.map .fields
                |> Maybe.map (D.decodeValue <| D.field "title" D.string)
                |> Maybe.map (Result.withDefault "")
                |> Maybe.withDefault ""
                |> (\title -> { name = title, id = Maybe.withDefault "" sys.id })

        Nothing ->
            { id = "", name = "" }


getThumbnail : Entries -> Sys -> Url
getThumbnail entries sys =
    case entries.includes of
        Just includes ->
            find (\entry -> sys.id == entry.sys.id) includes.assets
                |> Maybe.map .fields
                |> Maybe.map (D.decodeValue <| D.at [ "file", "url" ] D.string)
                |> Maybe.map (Result.withDefault "")
                |> Maybe.withDefault ""

        Nothing ->
            ""


getCategory : Entries -> Sys -> Tag
getCategory entries sys =
    case entries.includes of
        Just includes ->
            find (\entry -> sys.id == entry.sys.id) includes.entry
                |> Maybe.map .fields
                |> Maybe.map (D.decodeValue <| D.field "title" D.string)
                |> Maybe.map (Result.withDefault "")
                |> Maybe.withDefault ("")
                |> (\title -> { name = title, id = Maybe.withDefault "" sys.id })

        Nothing ->
            { id = "", name = "" }


decodeArticle : Entries -> D.Decoder Article
decodeArticle entries =
    D.map7 Article
        (D.at [ "sys", "id" ] D.string)
        (D.at [ "fields", "title" ] D.string)
        (D.at [ "fields", "description" ] D.string)
        (D.at [ "fields", "body" ] D.string)
        (D.map (getThumbnail entries) <| D.at [ "fields", "thumbnail", "sys" ] decodeSys)
        (D.at [ "fields", "categories" ] <| D.list <| D.field "sys" <| D.map (getCategory entries) decodeSys)
        (D.map (getPlace entries) <| D.at [ "fields", "place", "sys" ] decodeSys)


decodeArticles : D.Decoder (List Article)
decodeArticles =
    let
        decodeArticleWithEntries entries =
            if List.isEmpty entries.items then
                (\_ -> D.succeed [])
            else
                (\entries -> D.field "items" <| D.list <| decodeArticle entries)
    in
        decodeEntries
            |> D.andThen (\entries -> D.field "items" <| D.list <| decodeArticle entries)


decodeEntries : D.Decoder Entries
decodeEntries =
    D.map3 Entries
        (D.field "sys" decodeSys)
        (D.field "items" <| D.list <| decodeItem)
        (D.maybe <| D.field "includes" decodeIncludes)


decodeIncludes : D.Decoder Includes
decodeIncludes =
    D.map2 Includes
        (D.field "Entry" <| D.list <| decodeItem)
        (D.field "Asset" <| D.list <| decodeItem)


decodeItem : D.Decoder Item
decodeItem =
    D.map2 Item
        (D.field "sys" decodeSys)
        (D.field "fields" D.value)


decodeSys : D.Decoder Sys
decodeSys =
    D.map3 Sys
        (D.maybe <| D.field "id" D.string)
        (D.field "type" D.string)
        (D.maybe <| D.field "contentType" <| D.map UnderSys <| D.lazy (\_ -> decodeSys))
