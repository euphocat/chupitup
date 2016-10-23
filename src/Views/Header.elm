module Views.Header exposing (..)

import Common.Events.Utils exposing (onClick)
import Html exposing (Html, a, div, h1, header, text)
import Html.Attributes exposing (class, href)
import Messages exposing (Msg(ShowHome))
import Routing.Routes exposing (Route(HomeRoute), reverse)


viewHeader : Html Msg
viewHeader =
    header [ class "pure-u-1" ]
        [ h1 [ class "" ]
            [ a [ onClick ShowHome, href (reverse HomeRoute) ] [ text "Chupitup" ] ]
        , div [ class "pure-u-1 wrapper-photo" ]
            [ div [ class "landscape-photo" ]
                [ div []
                    []
                ]
            ]
        ]
