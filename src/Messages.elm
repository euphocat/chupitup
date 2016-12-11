module Messages exposing (..)

import Components.Tags.Tags exposing (Tag)
import Http
import Models exposing (Article)
import Routing.Routes exposing (Route)


type alias ArticleId =
    String


type Msg
    = UpdateUrl Route
    | ToggleVisibleTag Tag
    | EditorContent String
    | SaveEditor
    | SetEditor ArticleId
    | ShowHome
    | ShowAdmin
    | EditArticle ArticleId
    | ShowArticle ArticleId
    | FetchArticles (Result Http.Error ( List Article, Maybe ArticleId ))
    | FetchFilteredArticles (Result Http.Error ( List Article, ( List Tag, List Tag ) ))
    | UpdateArticle (Result Http.Error Article)
    | FetchPlaces (Result Http.Error (List Tag))
    | FetchCategories (Result Http.Error (List Tag))
    | NoOp
