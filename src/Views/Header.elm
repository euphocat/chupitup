module Views.Header exposing (..)

import Helpers.Events exposing (onClick)
import Html exposing (Html, a, div, h1, header, text)
import Html.Attributes exposing (class, classList, href)
import Messages exposing (Msg(ShowHome))
import Routing.Routes exposing (Route(HomeRoute), reverse)


viewHeader : Bool -> Html Msg
viewHeader isLoading =
    header
        [ class "pure-u-1" ]
        [ h1 [] [ a [ onClick ShowHome, href (reverse HomeRoute) ] [ text "Chupitup" ] ]
        , div
            [ classList
                [ ( "isHidden", not isLoading )
                , ( "loading", True )
                ]
            ]
            [ text "Chargement" ]
        , div
            [ class "pure-u-1 wrapper-photo" ]
            [ div [ class "landscape-photo" ] [ div [] [] ] ]
        ]
