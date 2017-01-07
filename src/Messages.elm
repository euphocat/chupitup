module Messages exposing (..)

import Components.Tags exposing (Tag)
import Http
import Models exposing (Article)
import Routing.Routes exposing (Route)


type alias ArticleId =
    String


type TagType
    = Place
    | Category


type FetchMsg
    = FetchArticles (Result Http.Error (List Article))
    | FetchFilteredArticles (Result Http.Error ( List Article, ( List Tag, List Tag ) ))
    | FetchPlaces (Result Http.Error (List Tag))
    | FetchCategories (Result Http.Error (List Tag))


type Msg
    = UpdateUrl Route
    | ToggleVisibleTag TagType Tag
    | ShowHome
    | ShowArticle ArticleId
    | NoOp
    | FetchTask FetchMsg
