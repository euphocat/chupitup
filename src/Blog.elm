module Blog exposing (..)

import Messages exposing (Msg(ShowArticle, ShowHome, ToggleVisibleTag))
import Models exposing (..)
import Routing.Parsers exposing (urlParser)
import Routing.Routes exposing (..)
import Helpers.Tags as Tags
import Navigation
import View exposing (view)


update : Msg -> State -> ( State, Cmd Msg )
update msg state =
    let
        toggleVisibleTag tag =
            { state | visibleTags = Tags.toggleVisibleTag tag state.visibleTags }

        navigationToRoute route =
            Navigation.newUrl (reverse route)
    in
        case Debug.log "Update with message" msg of
            ToggleVisibleTag tag ->
                ( toggleVisibleTag tag, Cmd.none )

            ShowArticle articleId ->
                ( state, navigationToRoute (ArticleRoute articleId) )

            ShowHome ->
                ( state, navigationToRoute HomeRoute )

            _ ->
                ( state, Cmd.none )


init : Route -> ( State, Cmd Msg )
init route =
    ( newState route, Cmd.none )


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
