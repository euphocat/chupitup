module Messages exposing (..)

import Http
import Models exposing (Article)
import Routing.Routes exposing (Route)


type alias ArticleId =
    String


type Msg
    = UpdateUrl Route
    | ToggleVisibleTag String
    | EditorContent String
    | SaveEditor
    | SetEditor ArticleId
    | ShowHome
    | ShowAdmin
    | EditArticle ArticleId
    | ShowArticle ArticleId
    | FetchArticles (Result Http.Error ( List Article, Maybe ArticleId ))
    | UpdateArticle (Result Http.Error Article)
    | NoOp
