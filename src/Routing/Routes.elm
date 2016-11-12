module Routing.Routes exposing (..)

import Admin.Routes exposing (..)


type alias ArticleId =
    String


type Route
    = HomeRoute
    | ArticleRoute ArticleId
    | AdminRoute AdminRoutes
    | NotFound String


reverse : Route -> String
reverse route =
    case Debug.log "route" route of
        ArticleRoute articleId ->
            "/article/" ++ articleId

        AdminRoute (AdminArticle articleId) ->
            "/admin/article/" ++ articleId

        _ ->
            "/"
