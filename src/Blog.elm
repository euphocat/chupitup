module Blog exposing (..)

import Components.Articles.Articles exposing (articleApi, getArticles)
import Messages exposing (Msg(FetchArticles, NoOp, SetEditor, UpdateUrl))
import Models exposing (State, newState)
import Update exposing (update)
import View exposing (view)
import Navigation
import Platform.Cmd
import Task exposing (andThen, succeed)
import Http
import Routing.Parsers exposing (parse)
import Routing.Routes exposing (Route(AdminArticle, ArticleRoute))


init : Navigation.Location -> ( State, Cmd Msg )
init location =
    let
        route =
            parse location

        setEditor articles =
            case route of
                AdminArticle id ->
                    ( articles, Just id )

                _ ->
                    ( articles, Nothing )
    in
        ( newState route, Task.attempt FetchArticles <| Task.map setEditor <| getArticles articleApi )


urlUpdate : Navigation.Location -> Msg
urlUpdate location =
    UpdateUrl <| parse location


subscriptions : State -> Sub Msg
subscriptions state =
    Sub.none


main : Program Never State Msg
main =
    Navigation.program urlUpdate
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
