module Blog exposing (..)

import Components.Articles exposing (getArticles, getTags)
import Components.Tags exposing (TagKind(Category, Place))
import Messages exposing (FetchMsg(FetchArticles), Msg(FetchTask, NoOp, UpdateUrl))
import Models exposing (State, newState)
import Update exposing (update)
import View exposing (view)
import Navigation
import Platform.Cmd
import Dict
import Routing.Parsers exposing (parse)
import Routing.Routes exposing (Route(ArticleRoute))


init : Navigation.Location -> ( State, Cmd Msg )
init location =
    let
        route : Route
        route =
            parse location

        requests : List (Cmd Msg)
        requests =
            [ getArticles Dict.empty
            , getTags Place
            , getTags Category
            ]
    in
        ( newState route, Cmd.batch requests )


urlUpdate : Navigation.Location -> Msg
urlUpdate =
    UpdateUrl << parse


main : Program Never State Msg
main =
    Navigation.program urlUpdate
        { init = init
        , view = view
        , update = update
        , subscriptions = (\_ -> Sub.none)
        }
