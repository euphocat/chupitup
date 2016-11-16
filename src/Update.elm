module Update exposing (..)

import Components.Articles.Articles exposing (patchArticle, updateArticles)
import Components.Tags.Tags exposing (toggleVisibleTag)
import Messages exposing (..)
import Models exposing (Article, State)
import Notifications exposing (notify)
import Routing.Routes exposing (..)
import Views.Article exposing (findArticle)


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
        NoOp ->
            ( state, Cmd.none )

        ToggleVisibleTag tag ->
            ( { state | visibleTags = toggleVisibleTag tag state.visibleTags }, Cmd.none )

        EditorContent content ->
            ( { state | editor = updateEditor state.editor content }, Cmd.none )

        SaveEditor ->
            ( state, patchArticle state.editor )

        ShowArticle articleId ->
            ( state, navigationToRoute <| ArticleRoute articleId )

        ShowHome ->
            ( state, navigationToRoute HomeRoute )

        ShowAdmin ->
            ( state, navigationToRoute AdminHome )

        EditArticle id ->
            ( { state | editor = findArticle state.articles id }, navigationToRoute <| AdminArticle id )

        SetEditor id ->
            ( { state | editor = findArticle state.articles id }, Cmd.none )

        FetchArticles (Err error) ->
            ( state, Cmd.none )

        FetchArticles (Ok ( articles, id )) ->
            ( { state
                | articles = Just articles
                , editor = findArticle (Just articles) (Maybe.withDefault "" id)
              }
            , Cmd.none
            )

        UpdateArticle (Err error) ->
            ( state, Cmd.none )

        UpdateUrl route ->
            ( { state | route = route }, Cmd.none )

        UpdateArticle (Ok article) ->
            ( { state | articles = updateArticles state article }
            , notify "Article modifié" Notifications.Success
            )
