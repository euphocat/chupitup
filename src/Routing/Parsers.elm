module Routing.Parsers exposing (..)

import Admin.Routes exposing (AdminRoutes(AdminArticle, AdminHome))
import Navigation
import Routing.Routes exposing (..)
import String
import UrlParser exposing (Parser, (</>), format, int, oneOf, s, s, string)


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
                Debug.log "error" NotFound err

            Ok route ->
                route


urlParser : Navigation.Parser Route
urlParser =
    Navigation.makeParser parse


articleParser : Parser (String -> a) a
articleParser =
    s "article" </> string


homeParser : Parser a a
homeParser =
    oneOf
        [ (s "index.html")
        , (s "")
        ]


adminParser : Parser a a
adminParser =
    s "admin"


adminArticleParser : Parser (String -> a) a
adminArticleParser =
    s "admin" </> s "article" </> string


routeParser : Parser (Route -> a) a
routeParser =
    oneOf
        [ format HomeRoute homeParser
        , format ArticleRoute articleParser
        , format (\id -> AdminRoute (AdminArticle id)) adminArticleParser
        , format (AdminRoute AdminHome) adminParser
        ]
