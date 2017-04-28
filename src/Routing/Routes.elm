module Routing.Routes exposing (..)

import Navigation


type alias ArticleSlug =
    String


type Route
    = HomeRoute
    | ArticleRoute ArticleSlug
    | NotFound


navigationToRoute : Route -> Cmd a
navigationToRoute route =
    Navigation.newUrl <| reverse route


reverse : Route -> String
reverse route =
    case {- Debug.log "route" -} route of
        ArticleRoute articleSlug ->
            "/article/" ++ articleSlug

        _ ->
            "/"
