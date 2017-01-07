module Views.Article exposing (..)

import Html exposing (Html, aside, div, h1, h2, h3, li, span, text, ul)
import Html.Attributes exposing (class)
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
    [ div [ class "sidebar pure-u-1 pure-u-lg-1-3" ]
        [ SideBar.title "En résumé..."
        , div [ class "tags" ] [ text resume ]
        , SideBar.title "Partage"
        , ul []
            [ li [] [ text "Facebook" ]
            , li [] [ text "Twitter" ]
            ]
        ]
    , div [ class "article-details pure-u-1 pure-u-lg-2-3" ]
        [ h1 [] [ text <| title ]
        , div [] [ text description ]
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
