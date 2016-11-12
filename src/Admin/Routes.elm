module Admin.Routes exposing (..)


type alias ArticleId =
    String


type AdminRoutes
    = AdminHome
    | AdminArticle ArticleId
