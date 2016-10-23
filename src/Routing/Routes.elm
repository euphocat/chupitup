module Routing.Routes exposing (..)


type alias ArticleId =
    Int


type Route
    = HomeRoute
    | ArticleRoute ArticleId
    | NotFound


reverse : Route -> String
reverse route =
    case route of
        ArticleRoute articleId ->
            "/article/" ++ (toString articleId)

        _ ->
            "/"
