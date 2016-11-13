module Admin.Views.Editor exposing (..)

import Helpers.MaybeExtra exposing (isNothing)
import Html exposing (Html, button, div, form, text, textarea)
import Html.Attributes exposing (class, classList, placeholder)
import Html.Events exposing (onClick, onInput)
import Markdown
import Messages exposing (Msg(EditorContent, SaveEditor))
import Models exposing (Article, State)


viewSource : Maybe Article -> String
viewSource article =
    case article of
        Nothing ->
            ""

        Just { body } ->
            body


viewEditor : String -> State -> List (Html Msg)
viewEditor id state =
    let
        viewerText : Maybe Article -> String
        viewerText article =
            case article of
                Nothing ->
                    ""

                Just { body } ->
                    body

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
                        [ text (viewSource state.editor) ]
                    ]
                ]
            , div
                [ classList
                    [ ( "pure-u-1-2", True )
                    , ( "placeholder", isEditorEmpty )
                    ]
                ]
                [ Markdown.toHtml [ class "padding5 editor-view" ] (viewerText state.editor) ]
            ]
        , div [] [ button [ onClick SaveEditor ] [ text "save" ] ]
        ]
