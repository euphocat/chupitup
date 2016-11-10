module Routing.Routes exposing (..)


type alias ArticleId =
    Int


type Route
    = HomeRoute
    | ArticleRoute ArticleId
    | AdminRoute
    | NotFound


reverse : Route -> String
reverse route =
    case Debug.log "route" route of
        ArticleRoute articleId ->
            "/article/" ++ (toString articleId)

        _ ->
            "/"
