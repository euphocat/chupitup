module Views.Admin exposing (..)

import Helpers.MaybeExtra exposing (isNothing)
import Html exposing (Html, div, form, text, textarea)
import Html.Attributes exposing (class, classList, placeholder)
import Html.Events exposing (onInput)
import Markdown
import Messages exposing (Msg(EditorContent))
import Models exposing (State)


viewAdmin : State -> List (Html Msg)
viewAdmin state =
    let
        viewerText =
            Maybe.withDefault "Pas de contenu" state.editor

        editorPlaceHoler =
            "Entrer le contenu de l'article en Markdown"

        isEditorEmpty =
            isNothing state.editor
    in
        [ div [ class "admin" ]
            [ div [ class "pure-u-1-2" ]
                [ form [ class "pure-form" ]
                    [ textarea
                        [ onInput EditorContent
                        , class "editor pure-input-1 padding5"
                        , placeholder editorPlaceHoler
                        ]
                        []
                    ]
                ]
            , div
                [ classList
                    [ ( "pure-u-1-2", True )
                    , ( "placeholder", isEditorEmpty )
                    ]
                ]
                [ Markdown.toHtml [ class "padding5 editor-view" ] viewerText ]
            ]
        ]
