module Update exposing (..)

import Admin.Routes exposing (..)
import Components.Articles.Articles exposing (patchArticle, updateArticles)
import Components.Tags.Tags exposing (toggleVisibleTag)
import Messages exposing (..)
import Models exposing (Article, State)
import Routing.Routes exposing (..)
import Views.Article exposing (findArticle)


setEditor : State -> String -> State
setEditor state id =
    { state | editor = findArticle state.articles id }


updateEditor : Maybe Article -> String -> Maybe Article
updateEditor editor content =
    case editor of
        Nothing ->
            editor

        Just article ->
            Just { article | body = content }


update : Msg -> State -> ( State, Cmd Msg )
update msg state =
    case msg of
        ToggleVisibleTag tag ->
            ( { state | visibleTags = toggleVisibleTag tag state.visibleTags }, Cmd.none )

        EditorContent content ->
            ( { state | editor = updateEditor state.editor content }, Cmd.none )

        SaveEditor ->
            ( state, patchArticle state.editor )

        ShowArticle articleId ->
            ( state, navigationToRoute (ArticleRoute articleId) )

        ShowHome ->
            ( state, navigationToRoute HomeRoute )

        ShowAdmin ->
            ( state, navigationToRoute (AdminRoute AdminHome) )

        EditArticle id ->
            ( setEditor state id, navigationToRoute (AdminRoute (AdminArticle id)) )

        FetchFailed error ->
            ( state, Cmd.none )

        PatchFailed error ->
            ( state, Cmd.none )

        FetchSucceed articles ->
            ( { state | articles = Just articles }, Cmd.none )

        PatchSucceed article ->
            ( { state | articles = updateArticles state article }, navigationToRoute (AdminRoute AdminHome) )
