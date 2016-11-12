module Messages exposing (..)

import Http
import Models exposing (Article)


type alias ArticleId =
    String


type FetchResult
    = FetchSucceed (List Article)
    | FetchFailed Http.Error


type Msg
    = ToggleVisibleTag String
    | EditorContent String
    | ShowHome
    | ShowAdmin
    | EditArticle ArticleId
    | ShowArticle ArticleId
    | FetchMsg FetchResult
