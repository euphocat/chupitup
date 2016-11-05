module Messages exposing (..)

import Http
import Models exposing (Article)


type alias ArticleId =
    Int


type Msg
    = ToggleVisibleTag String
    | ShowHome
    | ShowArticle ArticleId
    | FetchSucceed (List Article)
    | FetchFailed Http.Error
