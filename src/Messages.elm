module Messages exposing (..)

import Components.Tags exposing (Tag)
import Dict exposing (Dict)
import Http
import Models exposing (Article)
import Routing.Routes exposing (Route)


type alias ArticleId =
    String


type FetchMsg
    = FetchArticles (Result Http.Error (List Article))
    | FetchFilteredArticles (Result Http.Error ( List Article, Dict String Tag ))
    | FetchTags (Result Http.Error (Dict String Tag))


type Msg
    = UpdateUrl Route
    | ToggleVisibleTag Tag
    | ShowHome
    | ShowArticle ArticleId
    | NoOp
    | FetchTask FetchMsg
