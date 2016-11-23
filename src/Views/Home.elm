module Views.Home exposing (viewHome)

import Helpers.Events exposing (onClick)
import Components.Tags.Tags exposing (Tag, isTagActive)
import Html exposing (Html, a, article, div, h1, h2, header, img, p, text)
import Html.Attributes exposing (alt, class, classList, href, src)
import Messages exposing (..)
import Models exposing (Article, State)
import Routing.Routes exposing (Route(ArticleRoute), reverse)
import Set


viewHome : State -> List (Html Msg)
viewHome state =
    case state.articles of
        Nothing ->
            [ div [] [ text "No articles to display" ] ]

        Just articles ->
            [ viewSideBar state articles
            , div [ class "main pure-u-1 pure-u-lg-2-3" ]
                (viewArticles articles state.visibleTags)
            ]


viewSideBar : State -> List Article -> Html Msg
viewSideBar { places, categories, visibleTags } articles =
    div [ class "sidebar pure-u-1 pure-u-lg-1-3" ]
        [ h2 [] [ text "Filtrer par type d'endroits" ]
        , div [ class "tags" ] (viewTags categories visibleTags)
        , h2 [] [ text "Filtrer par lieu" ]
        , div [ class "tags" ] (viewTags places visibleTags)
        ]


linkToArticle : ArticleId -> List (Html Msg) -> Html Msg
linkToArticle id content =
    a [ onClick <| ShowArticle id, href <| reverse <| ArticleRoute id ] content


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
    Set.fromList (article.place :: article.tags)
        |> Set.intersect visibleTags
        |> Set.isEmpty
        |> not


filterArticlesByTags : List Article -> Set.Set Tag -> List Article
filterArticlesByTags articles visibleTags =
    if Set.isEmpty visibleTags then
        articles
    else
        List.filter (isArticleTagsDisplayed visibleTags) articles


viewArticles : List Article -> Set.Set Tag -> List (Html Msg)
viewArticles articles visibleTags =
    filterArticlesByTags articles visibleTags
        |> List.sortBy .id
        |> List.map viewArticle


tagToLink : Set.Set Tag -> Tag -> Html Msg
tagToLink visibleTags tag =
    a
        [ classList
            [ ( "pure-button", True )
            , ( "pure-button-primary"
              , isTagActive tag visibleTags
              )
            ]
        , onClick <| ToggleVisibleTag tag
        ]
        [ text tag ]


viewTags : Maybe (Set.Set Tag) -> Set.Set Tag -> List (Html Msg)
viewTags tags visibleTags =
    List.map (tagToLink visibleTags) <| Set.toList <| Maybe.withDefault Set.empty tags
