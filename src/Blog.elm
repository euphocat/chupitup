module Blog exposing (..)

import Components.Articles.Articles exposing (articleApi, fetchArticles)
import Messages exposing (Msg)
import Models exposing (State, newState)
import Routing.Parsers exposing (urlParser)
import Routing.Routes exposing (Route)
import Update exposing (update)
import View exposing (view)
import Navigation


init : Route -> ( State, Cmd Msg )
init route =
    ( newState route, fetchArticles articleApi )


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
