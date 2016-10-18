module Blog exposing (..)

import Html exposing (Html, div, text, label, input, header, h1, h2, article, p, img, span, a)
import Html.Attributes exposing (class, classList, src, alt)
import Html.Events exposing (onClick)


-- import Html.App as App

import Set
import Helpers.Tags as Tags
import Navigation
import String
import UrlParser exposing (Parser, (</>), format, int, oneOf, s, string)


-- Model


type alias Model =
    { articles : List Article
    , tags : List Tags.Tag
    , visibleTags : Set.Set Tags.Tag
    }


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


type MsgHome
    = UpdateName String
    | ToggleVisibleTag String


updateHome : MsgHome -> Model -> Model
updateHome msg model =
    case msg of
        ToggleVisibleTag tag ->
            { model | visibleTags = Tags.toggleVisibleTag tag model.visibleTags }

        _ ->
            model



-- View


viewHome : Model -> Html MsgHome
viewHome model =
    let
        viewArticle : Article -> Html MsgHome
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

        viewHeader : Html MsgHome
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


type alias State =
    { route : Route }


initialState : Route -> State
initialState route =
    { route = route }


init : Route -> ( State, Cmd Msg )
init route =
    ( initialState route, Cmd.none )



-- Route


type alias ArticleId =
    Int


type Route
    = HomeRoute
    | ArticleRoute ArticleId
    | NotFound



-- Update


type alias Url =
    String


type Msg
    = ShowHome
    | ShowArticle ArticleId


update : Msg -> State -> ( State, Cmd Msg )
update msg state =
    ( state, Cmd.none )


urlUpdate : Route -> State -> ( State, Cmd Msg )
urlUpdate route state =
    ( { state | route = route }, Cmd.none )


view : State -> Html Msg
view state =
    case state.route of
        HomeRoute ->
            div [] [ text "home page" ]

        ArticleRoute id ->
            div [] [ text ("article " ++ toString id) ]

        _ ->
            div [] [ text "404 not found" ]


subscriptions : State -> Sub Msg
subscriptions state =
    Sub.none


urlParser : Navigation.Parser Route
urlParser =
    Navigation.makeParser parse


articleParser : Parser (Int -> a) a
articleParser =
    s "article" </> int


homeParser : Parser a a
homeParser =
    oneOf
        [ (s "index.html")
        , (s "")
        ]


routeParser : Parser (Route -> a) a
routeParser =
    oneOf
        [ format HomeRoute homeParser
        , format ArticleRoute articleParser
        ]


parse : Navigation.Location -> Route
parse { pathname } =
    let
        one =
            Debug.log "path" pathname

        path =
            if String.startsWith "/" pathname then
                String.dropLeft 1 pathname
            else
                pathname
    in
        case UrlParser.parse identity routeParser path of
            Err err ->
                NotFound

            Ok route ->
                route


main : Program Never
main =
    Navigation.program urlParser
        { init = init
        , view = view
        , update = update
        , urlUpdate = urlUpdate
        , subscriptions = subscriptions
        }



--main : Program Never
--main =
--    App.beginnerProgram { model = model, view = view, update = update }
