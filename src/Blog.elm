module Blog exposing (..)

import Html exposing (Html, div, text, label, input, header, h1, h2, article, p, img, span, a)
import Html.Attributes exposing (class, classList, src, alt)
import Html.Events exposing (onClick)
import Html.App as App
import Set
import Helpers.Tags as Tags


-- Model


type alias Model =
    { articles : List Article
    , tags : List Tags.Tag
    , visibleTags : Set.Set Tags.Tag
    }


type alias Url =
    String


type alias Article =
    { title : String
    , description : String
    , photoThumbnail : Url
    , tags : List Tags.Tag
    }


model : Model
model =
    { articles =
        [ { title = "Le Francois 2"
          , description = "L'adresse ultime à Coueron. Il reste notre endroit incontournable et pourtant il n'est pas si connu !"
          , photoThumbnail = "http://www.institut-nignon.com/images/tele/francois-2-cours-2979.jpg"
          , tags = [ "restaurant" ]
          }
        , { title = "Le Baroque"
          , description = "Envie d'un endroit sympa au Hangar à Bananes ? Une équipe de choc et un cadre superbe."
          , photoThumbnail = "http://www.hangarabananes.fr/wp-content/uploads/photo2-553x368.jpg"
          , tags = [ "bar" ]
          }
        , { title = "Jo le Boucher"
          , description = "Atlantis grand lieu de la consomation. Un restaurant de chaine mais aussi une bonne surprise"
          , photoThumbnail = "https://media-cdn.tripadvisor.com/media/photo-s/07/83/cb/50/jo-le-boucher-tout-un.jpg"
          , tags = [ "atlantis" ]
          }
        , { title = "Le Vaporetto"
          , description = "Trentemoult et ses couleur et son restaurant italien. Quel rapport ? Aucun fils unique."
          , photoThumbnail = "http://www.videgrenier-trentemoult.fr/partenaires/LeVaporetto.jpeg"
          , tags = [ "restaurant" ]
          }
        ]
    , tags = [ "restaurant", "bar", "atlantis" ]
    , visibleTags = Set.empty
    }



-- Update


type Msg
    = UpdateName String
    | ToggleVisibleTag String


update : Msg -> Model -> Model
update msg model =
    case msg of
        ToggleVisibleTag tag ->
            { model | visibleTags = Tags.toggleVisibleTag tag model.visibleTags }

        _ ->
            model



-- View


view : Model -> Html Msg
view model =
    let
        viewArticle : Article -> Html Msg
        viewArticle { title, description, photoThumbnail } =
            article [ class "pure-u-5-12" ]
                [ div [ class "post-thumbnail" ]
                    [ img [ alt title, src photoThumbnail ]
                        []
                    ]
                , div []
                    [ h2 []
                        [ text title ]
                    , p []
                        [ text description ]
                    ]
                ]

        isArticleTagsDisplayed : Set.Set Tags.Tag -> Article -> Bool
        isArticleTagsDisplayed visibleTags article =
            let
                setArticleTags =
                    Set.fromList article.tags
            in
                not <| Set.isEmpty <| Set.intersect visibleTags setArticleTags

        filterArticles : List Article -> Set.Set Tags.Tag -> List Article
        filterArticles articles visibleTags =
            if List.isEmpty (Set.toList visibleTags) then
                articles
            else
                List.filter (isArticleTagsDisplayed visibleTags) articles

        viewArticles articles visibleTags =
            List.map viewArticle (filterArticles articles visibleTags)

        viewHeader : Html Msg
        viewHeader =
            header [ class "pure-u-1" ]
                [ h1 [ class "" ]
                    [ text "Chupitup" ]
                , div [ class "pure-u-1 wrapper-photo" ]
                    [ div [ class "landscape-photo" ]
                        [ div []
                            []
                        ]
                    ]
                ]

        viewTags tags visibleTags =
            let
                tagToA tag =
                    a
                        [ classList
                            [ ( "pure-button", True )
                            , ( "pure-button-primary"
                              , Tags.isTagActive tag visibleTags
                              )
                            ]
                        , onClick (ToggleVisibleTag tag)
                        ]
                        [ text tag ]
            in
                List.map tagToA tags
    in
        div [ class "pure-g" ]
            [ viewHeader
            , div [ class "sidebar pure-u-1 pure-u-lg-1-3" ]
                [ div [ class "tags" ] (viewTags model.tags model.visibleTags) ]
            , div [ class "main pure-u-1 pure-u-lg-2-3" ]
                (viewArticles model.articles model.visibleTags)
            ]


main : Program Never
main =
    App.beginnerProgram { model = model, view = view, update = update }
