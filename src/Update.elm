module Update exposing (..)

import Components.Articles exposing (getArticles)
import Components.Tags exposing (toggleTags)
import Messages exposing (..)
import Models exposing (Article, State)
import Routing.Routes exposing (..)
import Dict


update : Msg -> State -> ( State, Cmd Msg )
update msg state =
    case {- Debug.log "message" -} msg of
        NoOp ->
            ( state, Cmd.none )

        ToggleVisibleTag tag ->
            let
                newState =
                    { state | tags = toggleTags tag state.tags, isLoading = True }
            in
                ( newState, getArticles newState.tags )

        ShowArticle articleId ->
            ( state, navigationToRoute <| ArticleRoute articleId )

        ShowHome ->
            ( state, navigationToRoute HomeRoute )

        UpdateUrl route ->
            ( { state | route = route }, Cmd.none )

        FetchTask task ->
            updateFetch task state


updateFetch : FetchMsg -> State -> ( State, Cmd Msg )
updateFetch msg state =
    case msg of
        FetchTags (Err error) ->
            logError msg state

        FetchTags (Ok tags) ->
            ( { state | tags = Dict.union state.tags tags }, Cmd.none )

        FetchArticles (Err error) ->
            logError msg state

        FetchArticles (Ok articles) ->
            ( { state | articles = Just articles, isLoading = False }, Cmd.none )


logError msg state =
    let
        _ =
            Debug.log "error" msg
    in
        ( state, Cmd.none )
