module Messages exposing (..)

import Components.Tags.Tags exposing (Tag)
import Http
import Models exposing (Article)
import Routing.Routes exposing (Route)


type alias ArticleId =
    String


type TagType
    = Place
    | Category


type Msg
    = UpdateUrl Route
    | ToggleVisibleTag TagType Tag
    | ShowHome
    | ShowAdmin
    | ShowArticle ArticleId
    | FetchArticles (Result Http.Error ( List Article, Maybe ArticleId ))
    | FetchFilteredArticles (Result Http.Error ( List Article, ( List Tag, List Tag ) ))
    | FetchPlaces (Result Http.Error (List Tag))
    | FetchCategories (Result Http.Error (List Tag))
    | NoOp
