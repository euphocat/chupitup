module Contentful exposing (..)

import Components.Tags exposing (Tag, TagKind(Category, Place))
import Json.Decode as D
import Json.Decode.Pipeline exposing (custom, decode, requiredAt)
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
    , contentType : Maybe ChildSys
    }


type ChildSys
    = ChildSys Sys


decodeTag : Entries -> TagKind -> Sys -> Tag
decodeTag entries kind sys =
    case entries.includes of
        Just includes ->
            find (\entry -> sys.id == entry.sys.id) includes.entry
                |> Maybe.map .fields
                |> Maybe.map (D.decodeValue <| D.field "title" D.string)
                |> Maybe.map (Result.withDefault "")
                |> Maybe.withDefault ""
                |> (\title -> { name = title, id = Maybe.withDefault "" sys.id, isActive = False, kind = kind })

        Nothing ->
            { id = "", name = "", isActive = False, kind = kind }


decodeThumbnail : Entries -> Sys -> Url
decodeThumbnail entries sys =
    case entries.includes of
        Just includes ->
            find (\entry -> sys.id == entry.sys.id) includes.assets
                |> Maybe.map .fields
                |> Maybe.map (D.decodeValue <| D.at [ "file", "url" ] D.string)
                |> Maybe.map (Result.withDefault "")
                |> Maybe.withDefault ""

        Nothing ->
            ""


decodeArticle : Entries -> D.Decoder Article
decodeArticle entries =
    decode Article
        |> requiredAt [ "sys", "id" ] D.string
        |> requiredAt [ "fields", "slug" ] D.string
        |> requiredAt [ "fields", "title" ] D.string
        |> requiredAt [ "fields", "description" ] D.string
        |> requiredAt [ "fields", "resume" ] D.string
        |> requiredAt [ "fields", "body" ] D.string
        |> custom (D.map (decodeThumbnail entries) <| D.at [ "fields", "thumbnail", "sys" ] decodeSys)
        |> requiredAt [ "fields", "categories" ] (D.list <| D.field "sys" <| D.map (decodeTag entries Category) decodeSys)
        |> custom (D.map (decodeTag entries Place) <| D.at [ "fields", "place", "sys" ] decodeSys)
        |> requiredAt [ "fields", "googleMapUrl" ] D.string


decodeArticles : D.Decoder (List Article)
decodeArticles =
    let
        decodeArticleWithEntries entries =
            if List.isEmpty entries.items then
                (\_ -> D.succeed [])
            else
                D.field "items" << D.list << decodeArticle
    in
        decodeEntries
            |> D.andThen (D.field "items" << D.list << decodeArticle)


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
        (D.maybe <|
            D.field "contentType" <|
                D.map ChildSys <|
                    D.lazy (\_ -> decodeSys)
        )
