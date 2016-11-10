module Messages exposing (..)

import Http
import Models exposing (Article)


type alias ArticleId =
    Int


type FetchResult
    = FetchSucceed (List Article)
    | FetchFailed Http.Error


type Msg
    = ToggleVisibleTag String
    | EditorContent String
    | ShowHome
    | ShowAdmin
    | ShowArticle ArticleId
    | FetchMsg FetchResult
