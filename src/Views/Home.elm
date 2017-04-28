module Views.Home exposing (viewHome)

import Components.Tags exposing (TagKind(Category, Place))
import Helpers.Events exposing (onClick)
import Components.SideBar as SideBar
import Html exposing (Html, a, article, div, h1, h2, header, img, p, span, text)
import Html.Attributes exposing (alt, class, classList, href, src)
import Messages exposing (..)
import Models exposing (Article, State)
import Routing.Routes exposing (Route(ArticleRoute), reverse)


viewHome : State -> List (Html Msg)
viewHome state =
    case state.articles of
        Nothing ->
            [ div [] [ text "No articles to display" ] ]

        Just articles ->
            [ viewSideBar state
            , div [ class "main" ]
                [ div [ class "article-wrapper" ] (viewArticles articles)
                ]
            ]


viewSideBar : State -> Html Msg
viewSideBar { tags } =
    div
        [ class "sidebar" ]
        [ SideBar.title "Filtrer par type d'endroit"
        , SideBar.tags ( Category, tags )
        , SideBar.title "Filtrer par lieu"
        , SideBar.tags ( Place, tags )
        ]


linkToArticle : ArticleSlug -> List (Html Msg) -> Html Msg
linkToArticle slug =
    a [ onClick <| ShowArticle slug, href <| reverse <| ArticleRoute slug ]


viewArticle : Article -> Html Msg
viewArticle { slug, title, description, photoThumbnail } =
    article
        []
        [ div
            [ class "post-thumbnail" ]
            [ linkToArticle slug
                [ img [ alt title, src <| photoThumbnail ++ "?h=500&w=950&fit=fill&fl=progressive" ] []
                ]
            ]
        , div
            []
            [ h2 [ class "double-line-bg" ] [ linkToArticle slug [ text title ] ]
            , p [] [ linkToArticle slug [ text description ] ]
            ]
        ]


viewArticles : List Article -> List (Html Msg)
viewArticles articles =
    if List.isEmpty articles then
        [ div [] [ text "Aucun endroit sympa n'existe avec les critères souhaités :(" ] ]
    else
        articles
            |> List.sortBy .id
            |> List.map viewArticle
