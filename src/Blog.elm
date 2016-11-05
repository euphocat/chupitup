module Blog exposing (..)

import Http
import Messages exposing (Msg(ShowArticle, ShowHome, ToggleVisibleTag, FetchFailed, FetchSucceed))
import Models exposing (..)
import Routing.Parsers exposing (urlParser)
import Routing.Routes exposing (..)
import Helpers.Tags as Tags exposing (Tag)
import Navigation
import Task
import View exposing (view)
import Json.Decode as Json


update : Msg -> State -> ( State, Cmd Msg )
update msg state =
    let
        toggleVisibleTag tag =
            { state | visibleTags = Tags.toggleVisibleTag tag state.visibleTags }

        navigationToRoute route =
            Navigation.newUrl (reverse route)
    in
        case msg of
            ToggleVisibleTag tag ->
                ( toggleVisibleTag tag, Cmd.none )

            ShowArticle articleId ->
                ( state, navigationToRoute (ArticleRoute articleId) )

            ShowHome ->
                ( state, navigationToRoute HomeRoute )

            FetchFailed err ->
                let
                    _ =
                        Debug.log "Error fetching article" err
                in
                    ( state, Cmd.none )

            FetchSucceed articles ->
                ( { state | articles = Just articles }, Cmd.none )


decodeArticle =
    Json.object7 Article
        (Json.at [ "id" ] Json.int)
        (Json.at [ "title" ] Json.string)
        (Json.at [ "description" ] Json.string)
        (Json.at [ "body" ] Json.string)
        (Json.at [ "photoThumbnail" ] Json.string)
        (Json.at [ "tags" ] (Json.list Json.string))
        (Json.at [ "place" ] Json.string)


decodeArticles =
    Json.list decodeArticle


fetchArticles url =
    Task.perform FetchFailed FetchSucceed (Http.get decodeArticles url)


init : Route -> ( State, Cmd Msg )
init route =
    let
        url =
            "http://localhost:3000/articles"
    in
        ( newState route, fetchArticles url )


urlUpdate : Route -> State -> ( State, Cmd Msg )
urlUpdate route state =
    ( { state | route = route }, Cmd.none )


subscriptions : State -> Sub Msg
subscriptions state =
    Sub.none


main : Program Never
main =
    Navigation.program urlParser
        { init = init
        , view = view
        , update = update
        , urlUpdate = urlUpdate
        , subscriptions = subscriptions
        }
