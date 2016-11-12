module View exposing (..)

import Admin.Routes exposing (AdminRoutes(AdminArticle, AdminHome))
import Admin.Views.Admin exposing (viewAdmin)
import Admin.Views.Editor exposing (viewEditor)
import Html exposing (Html, text, div)
import Html.Attributes exposing (class)
import Messages exposing (Msg)
import Models exposing (State)
import Routing.Routes exposing (..)
import Views.Article exposing (viewArticle)
import Views.Home exposing (viewHome)
import Views.Header exposing (..)


view : State -> Html Msg
view state =
    case Debug.log "view" state.route of
        AdminRoute (AdminArticle id) ->
            div [] (viewEditor id state)

        AdminRoute AdminHome ->
            div [] (viewAdmin state)

        _ ->
            div [ class "pure-g wrapper" ]
                [ viewHeader, div [ class "pure-u-1" ] (viewBody state) ]


viewBody : State -> List (Html Msg)
viewBody state =
    case state.route of
        HomeRoute ->
            (viewHome state)

        ArticleRoute id ->
            (viewArticle id state)

        _ ->
            [ text "404 not found" ]
