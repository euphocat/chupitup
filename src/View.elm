module View exposing (..)

import Html exposing (Html, text, div)
import Html.Attributes exposing (class)
import Messages exposing (Msg)
import Models exposing (State)
import Routing.Routes exposing (..)
import Views.Home exposing (viewHome)
import Views.Header exposing (..)


view : State -> Html Msg
view state =
    div [ class "pure-g wrapper" ]
        [ viewHeader, viewBody state ]


viewBody : State -> Html Msg
viewBody state =
    case state.route of
        HomeRoute ->
            div [] [ viewHome state ]

        ArticleRoute id ->
            div [] [ text ("article " ++ toString id) ]

        _ ->
            div [] [ text "404 not found" ]
