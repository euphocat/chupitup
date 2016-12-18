module Routing.Routes exposing (..)

import Navigation


type alias ArticleId =
    String


type Route
    = HomeRoute
    | ArticleRoute ArticleId
    | NotFound


navigationToRoute : Route -> Cmd a
navigationToRoute route =
    Navigation.newUrl (reverse route)


reverse : Route -> String
reverse route =
    case {- Debug.log "route" -} route of
        ArticleRoute articleId ->
            "/article/" ++ articleId

        _ ->
            "/"
