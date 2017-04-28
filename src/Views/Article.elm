module Views.Article exposing (..)

import Html exposing (Html, aside, div, h1, h2, h3, iframe, li, span, text, ul)
import Html.Attributes exposing (attribute, class, height, src, style, width)
import Markdown
import Components.SideBar as SideBar exposing (socialSharer, viewIframe)
import Messages exposing (Msg)
import Models exposing (Article, State)


findArticle : Maybe (List Article) -> String -> Maybe Article
findArticle articles slug =
    articles
        |> Maybe.withDefault []
        |> List.filter (\a -> a.slug == slug)
        |> List.head


renderPageArticle : Article -> List (Html Msg)
renderPageArticle { description, title, resume, body, googleMapUrl } =
    [ div [ class "sidebar" ]
        [ SideBar.title "En résumé..."
        , div [ class "tags" ] [ text resume ]
        , SideBar.title "Adresse"
        , div [] [ viewIframe googleMapUrl ]
        , SideBar.title "Partage"
        , socialSharer
        ]
    , div [ class "article-details" ]
        [ h1 [] [ text <| title ]
        , Markdown.toHtml [] body
        ]
    ]


viewArticle : String -> State -> List (Html Msg)
viewArticle slug state =
    let
        article =
            findArticle state.articles slug
    in
        case article of
            Just article ->
                renderPageArticle article

            Nothing ->
                [ aside [ class "pure-u-1" ]
                    [ div
                        [ class "error-message" ]
                        [ text <| (++) "Error: no article found with slug " <| toString slug ]
                    ]
                ]
