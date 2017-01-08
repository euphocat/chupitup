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
            , div [ class "main pure-u-1 pure-u-lg-2-3" ] (viewArticles articles)
            ]


viewSideBar : State -> Html Msg
viewSideBar { tags } =
    div
        [ class "sidebar pure-u-1 pure-u-lg-1-3" ]
        [ SideBar.title "Filtrer par type d'endroits"
        , SideBar.tags ( Category, tags )
        , SideBar.title "Filtrer par lieu"
        , SideBar.tags ( Place, tags )
        ]


linkToArticle : ArticleId -> List (Html Msg) -> Html Msg
linkToArticle id =
    a [ onClick <| ShowArticle id, href <| reverse <| ArticleRoute id ]


viewArticle : Article -> Html Msg
viewArticle { id, title, description, photoThumbnail } =
    article
        [ class "pure-u-5-12" ]
        [ div
            [ class "post-thumbnail" ]
            [ linkToArticle id
                [ img [ alt title, src photoThumbnail ] []
                ]
            ]
        , div
            []
            [ h2 [] [ linkToArticle id [ text title ] ]
            , p [] [ linkToArticle id [ text description ] ]
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
