module Routing.Routes exposing (..)

import Admin.Routes exposing (..)
import Navigation


type alias ArticleId =
    String


type Route
    = HomeRoute
    | ArticleRoute ArticleId
    | AdminRoute AdminRoutes
    | NotFound String


navigationToRoute : Route -> Cmd a
navigationToRoute route =
    Navigation.newUrl (reverse route)


reverse : Route -> String
reverse route =
    case Debug.log "route" route of
        ArticleRoute articleId ->
            "/article/" ++ articleId

        AdminRoute AdminHome ->
            "/admin"

        AdminRoute (AdminArticle articleId) ->
            "/admin/article/" ++ articleId

        _ ->
            "/"
