module Components.SideBar
    exposing
        ( title
        , tags
        )

import Components.Tags exposing (Tag, TagKind)
import Dict exposing (Dict)
import Helpers.Events exposing (onClick)
import Html exposing (Html, a, div, h2, span, text)
import Html.Attributes exposing (class, classList)
import Messages exposing (Msg(ToggleVisibleTag))


title : String -> Html msg
title content =
    h2 [] [ span [] [ text content ] ]


tags : TagKind -> Dict String Tag -> Html Msg
tags kind tags =
    tags
        |> Dict.filter (\_ t -> t.kind == kind)
        |> (div [ class "tags" ] << viewTags)


viewTags : Dict String Tag -> List (Html Msg)
viewTags tags =
    tags
        |> Dict.toList
        |> List.map (tagToLink)


tagToLink : ( String, Tag ) -> Html Msg
tagToLink ( id, tag ) =
    a
        [ classList
            [ ( "pure-button", True )
            , ( "pure-button-primary", tag.isActive )
            ]
        , onClick <| ToggleVisibleTag tag
        ]
        [ text <| tag.name ]
