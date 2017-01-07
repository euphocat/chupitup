module Components.SideBar
    exposing
        ( title
        , tags
        )

import Components.Tags exposing (Tag, isTagActive)
import Helpers.Events exposing (onClick)
import Html exposing (Html, a, div, h2, span, text)
import Html.Attributes exposing (class, classList)
import Messages exposing (Msg(ToggleVisibleTag), TagType)


title : String -> Html msg
title content =
    h2 [] [ span [] [ text content ] ]


tags : TagType -> Maybe (List Tag) -> List Tag -> Html Msg
tags tagType tags visibleTags =
    div [ class "tags" ] (viewTags tagType tags visibleTags)


viewTags : TagType -> Maybe (List Tag) -> List Tag -> List (Html Msg)
viewTags tagType tags visibleTags =
    tags
        |> Maybe.withDefault []
        |> List.map (tagToLink tagType visibleTags)


tagToLink : TagType -> List Tag -> Tag -> Html Msg
tagToLink tagType visibleTags tag =
    a
        [ classList
            [ ( "pure-button", True )
            , ( "pure-button-primary"
              , isTagActive tag visibleTags
              )
            ]
        , onClick <| ToggleVisibleTag tagType tag
        ]
        [ text <| tag.name ]
