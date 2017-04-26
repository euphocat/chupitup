module Views.Article exposing (..)

import Html exposing (Html, aside, div, h1, h2, h3, iframe, li, span, text, ul)
import Html.Attributes exposing (attribute, class, height, src, style, width)
import Markdown
import Components.SideBar as SideBar
import Messages exposing (Msg)
import Models exposing (Article, State)


findArticle : Maybe (List Article) -> String -> Maybe Article
findArticle articles id =
    articles
        |> Maybe.withDefault []
        |> List.filter (\a -> a.id == id)
        |> List.head


renderArticle : Article -> List (Html Msg)
renderArticle { description, title, resume, body } =
    [ div [ class "sidebar" ]
        [ SideBar.title "En résumé..."
        , div [ class "tags" ] [ text resume ]
        , SideBar.title "Adresse"
        , div []
            [ iframe
                [ src "https://www.google.com/maps/embed?pb=!1m14!1m8!1m3!1d10840.179569638232!2d-1.557046!3d47.2157039!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x0%3A0x62ac968e2950a1bc!2sSAPIO!5e0!3m2!1sfr!2sfr!4v1484597327490"
                , height 300
                , attribute "frameborder" "0"
                , style [ ( "border", "0" ) ]
                , attribute "allowfullscreen" "true"
                ]
                []
            ]
        , SideBar.title "Partage"
        , ul []
            [ li [] [ text "Facebook" ]
            , li [] [ text "Twitter" ]
            ]
        ]
    , div [ class "article-details" ]
        [ h1 [] [ text <| title ]
        , Markdown.toHtml [] body
        ]
    ]


viewArticle : String -> State -> List (Html Msg)
viewArticle articleId state =
    let
        article =
            findArticle state.articles articleId
    in
        case article of
            Just article ->
                renderArticle article

            Nothing ->
                [ aside [ class "pure-u-1" ]
                    [ div
                        [ class "error-message" ]
                        [ text <| "Error: no article found with id " ++ (toString articleId) ]
                    ]
                ]
