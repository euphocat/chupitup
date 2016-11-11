module Routing.Parsers exposing (..)

import Navigation
import Routing.Routes exposing (..)
import String
import UrlParser exposing (Parser, (</>), format, int, oneOf, s, s)


parse : Navigation.Location -> Route
parse { pathname } =
    let
        one =
            Debug.log "path" pathname

        path =
            if String.startsWith "/" pathname then
                String.dropLeft 1 pathname
            else
                pathname
    in
        case UrlParser.parse identity routeParser path of
            Err err ->
                NotFound

            Ok route ->
                route


urlParser : Navigation.Parser Route
urlParser =
    Navigation.makeParser parse


articleParser : Parser (Int -> a) a
articleParser =
    s "article" </> int


homeParser : Parser a a
homeParser =
    oneOf
        [ (s "index.html")
        , (s "")
        ]


adminParser : Parser a a
adminParser =
    s "admin"


routeParser : Parser (Route -> a) a
routeParser =
    oneOf
        [ format HomeRoute homeParser
        , format ArticleRoute articleParser
        , format AdminRoute adminParser
        ]
