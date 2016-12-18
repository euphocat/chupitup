module Routing.Parsers exposing (parse)

import Navigation
import Routing.Routes exposing (..)
import UrlParser exposing (Parser, (</>), map, oneOf, parsePath, s, string)


parse : Navigation.Location -> Route
parse location =
    case parsePath routeParser location of
        Nothing ->
            NotFound

        Just route ->
            route


homeParser : Parser a a
homeParser =
    oneOf
        [ (s "index.html")
        , (s "")
        ]


routeParser : Parser (Route -> a) a
routeParser =
    oneOf
        [ map HomeRoute homeParser
        , map ArticleRoute (s "article" </> string)
        ]
