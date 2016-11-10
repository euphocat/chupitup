module Views.Home exposing (viewHome)

import Common.Events.Utils exposing (onClick)
import Helpers.Tags exposing (..)
import Html exposing (Html, a, article, div, h1, h2, header, img, p, text)
import Html.Attributes exposing (alt, class, classList, href, src)
import Messages exposing (..)
import Models exposing (Article, State)
import Routing.Routes exposing (Route(ArticleRoute), reverse)
import Set


viewHome : State -> List (Html Msg)
viewHome state =
    let
        getPlaces articles =
            List.map (\x -> x.place) articles
    in
        case state.articles of
            Nothing ->
                [ div [] [ text "Problem while fetching articles" ] ]

            Just articles ->
                [ div [ class "sidebar pure-u-1 pure-u-lg-1-3" ]
                    [ h2 [] [ text "Filtrer par type d'endroits" ]
                    , div [ class "tags" ] (viewTags state.tags state.visibleTags)
                    , h2 [] [ text "Filtrer par lieu" ]
                    , div [ class "tags" ] (viewTags (getPlaces (articles)) state.visiblePlaces)
                    ]
                , div [ class "main pure-u-1 pure-u-lg-2-3" ]
                    (viewArticles articles state.visibleTags)
                ]


linkToArticle : ArticleId -> List (Html Msg) -> Html Msg
linkToArticle id content =
    a [ (onClick (ShowArticle id)), href (reverse (ArticleRoute id)) ] content


viewArticle : Article -> Html Msg
viewArticle { id, title, description, photoThumbnail } =
    article [ class "pure-u-5-12" ]
        [ div [ class "post-thumbnail" ]
            [ linkToArticle id
                [ img [ alt title, src photoThumbnail ]
                    []
                ]
            ]
        , div []
            [ h2 []
                [ linkToArticle id [ text title ] ]
            , p []
                [ linkToArticle id [ text description ] ]
            ]
        ]


isArticleTagsDisplayed : Set.Set Tag -> Article -> Bool
isArticleTagsDisplayed visibleTags article =
    let
        setArticleTags =
            Set.fromList article.tags
    in
        not <| Set.isEmpty <| Set.intersect visibleTags setArticleTags


filterArticles : List Article -> Set.Set Tag -> List Article
filterArticles articles visibleTags =
    if List.isEmpty (Set.toList visibleTags) then
        articles
    else
        List.filter (isArticleTagsDisplayed visibleTags) articles


viewArticles : List Article -> Set.Set Tag -> List (Html Msg)
viewArticles articles visibleTags =
    List.map viewArticle (filterArticles articles visibleTags)


viewTags : List Tag -> Set.Set Tag -> List (Html Msg)
viewTags tags visibleTags =
    let
        tagToA tag =
            a
                [ classList
                    [ ( "pure-button", True )
                    , ( "pure-button-primary"
                      , isTagActive tag visibleTags
                      )
                    ]
                , onClick (ToggleVisibleTag tag)
                ]
                [ text tag ]
    in
        List.map tagToA tags
