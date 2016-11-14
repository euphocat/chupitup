module Admin.Views.Admin exposing (..)

import Helpers.Events exposing (onClick)
import Html exposing (Html, a, div, h1, li, text, ul)
import Html.Attributes exposing (href)
import Messages exposing (Msg(EditArticle))
import Models exposing (Article, State)
import Routing.Routes exposing (Route(AdminArticle), reverse)


viewArticle : Article -> Html Msg
viewArticle { id, title } =
    li [] [ a [ (onClick (EditArticle id)), href (reverse (AdminArticle id)) ] [ text title ] ]


listArticles : Maybe (List Article) -> Html Msg
listArticles articles =
    case articles of
        Nothing ->
            div [] [ text "Aucun article" ]

        Just a ->
            ul [] (List.map viewArticle a)


viewAdmin : State -> List (Html Msg)
viewAdmin { articles } =
    [ h1 [] [ text "Admin" ]
    , listArticles articles
    ]
