module Messages exposing (..)


type alias ArticleId =
    Int


type Msg
    = UpdateName String
    | ToggleVisibleTag String
    | ShowHome
    | ShowArticle ArticleId
