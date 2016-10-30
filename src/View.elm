module View exposing (..)

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
    div [ class "pure-g wrapper" ]
        [ viewHeader, div [ class "" ] (viewBody state) ]


viewBody : State -> List (Html Msg)
viewBody state =
    case state.route of
        HomeRoute ->
            (viewHome state)

        ArticleRoute id ->
            (viewArticle id state)

        _ ->
            [ text "404 not found" ]
