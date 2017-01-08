module Update exposing (..)

import Components.Articles exposing (getFilteredArticles)
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
            ( state, getFilteredArticles state.tags tag )

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
            ( state, Cmd.none )

        FetchTags (Ok tags) ->
            ( { state | tags = Dict.union state.tags tags }, Cmd.none )

        FetchArticles (Err error) ->
            let
                _ =
                    Debug.log "Error articles" error
            in
                ( state, Cmd.none )

        FetchArticles (Ok articles) ->
            ( { state | articles = Just articles }, Cmd.none )

        FetchFilteredArticles (Err error) ->
            ( state, Cmd.none )

        FetchFilteredArticles (Ok ( articles, tags )) ->
            ( { state | articles = Just articles, tags = tags }
            , Cmd.none
            )
