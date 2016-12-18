module Update exposing (..)

import Components.Articles.Articles exposing (getArticles, getFilteredArticles)
import Messages exposing (..)
import Models exposing (Article, State)
import Routing.Routes exposing (..)
import Views.Article exposing (findArticle)


update : Msg -> State -> ( State, Cmd Msg )
update msg state =
    case {- Debug.log "message" -} msg of
        NoOp ->
            ( state, Cmd.none )

        ToggleVisibleTag tagType tag ->
            ( state
            , getFilteredArticles ( state.visiblePlaces, state.visibleCategories ) tagType tag
            )

        ShowArticle articleId ->
            ( state, navigationToRoute <| ArticleRoute articleId )

        ShowHome ->
            ( state, navigationToRoute HomeRoute )

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

        FetchFilteredArticles (Ok ( articles, ( visiblePlaces, visibleCategories ) )) ->
            ( { state | articles = Just articles, visiblePlaces = visiblePlaces, visibleCategories = visibleCategories }
            , Cmd.none
            )

        UpdateUrl route ->
            ( { state | route = route }, Cmd.none )

        FetchPlaces (Err error) ->
            ( state, Cmd.none )

        FetchPlaces (Ok places) ->
            ( { state | places = Just places }, Cmd.none )

        FetchCategories (Err error) ->
            ( state, Cmd.none )

        FetchCategories (Ok categories) ->
            ( { state | categories = Just categories }, Cmd.none )
