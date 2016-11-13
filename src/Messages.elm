module Messages exposing (..)

import Http
import Models exposing (Article)


type alias ArticleId =
    String


type Msg
    = ToggleVisibleTag String
    | EditorContent String
    | SaveEditor
    | ShowHome
    | ShowAdmin
    | EditArticle ArticleId
    | ShowArticle ArticleId
    | FetchSucceed (List Article)
    | FetchFailed Http.Error
    | PatchSucceed Article
    | PatchFailed Http.Error
