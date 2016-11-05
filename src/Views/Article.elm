module Views.Article exposing (..)

import Html exposing (Html, aside, div, h1, text)
import Html.Attributes exposing (class)
import Markdown
import Messages exposing (Msg)
import Models exposing (Article, State)


findArticle : List Article -> Int -> Maybe Article
findArticle articles id =
    List.head
        (List.filter
            (\a -> a.id == id)
            articles
        )


renderArticle : Article -> List (Html Msg)
renderArticle { description, title, body } =
    [ div [ class "sidebar pure-u-1 pure-u-lg-1-3" ]
        [ div [ class "tags" ] [ text "test" ] ]
    , div [ class "article-details pure-u-1 pure-u-lg-2-3" ]
        [ h1 [] [ text title ]
        , div [] [ text description ]
        , Markdown.toHtml [] body
        ]
    ]


viewArticle : Int -> State -> List (Html Msg)
viewArticle articleId state =
    let
        one =
            Debug.log "state" state

        articles =
            (Maybe.withDefault [] state.articles)

        article =
            findArticle articles articleId
    in
        case article of
            Just article ->
                renderArticle article

            Nothing ->
                [ aside [ class "pure-u-1" ]
                    [ div [ class "error-message" ]
                        [ text ("Error: no article found with id " ++ (toString articleId))
                        ]
                    ]
                ]
