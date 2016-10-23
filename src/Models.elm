module Models exposing (..)

import Routing.Routes exposing (Route)
import Set
import Helpers.Tags exposing (Tag)


type alias Url =
    String


type alias Article =
    { id : Int
    , title : String
    , description : String
    , photoThumbnail : Url
    , tags : List Tag
    }


type alias State =
    { route : Route
    , articles : List Article
    , tags : List Tag
    , visibleTags : Set.Set Tag
    }


newState : Route -> State
newState route =
    { route = route
    , articles =
        [ { id = 1
          , title = "Le Francois 2"
          , description = "L'adresse ultime à Coueron. Il reste notre endroit incontournable et pourtant il n'est pas si connu !"
          , photoThumbnail = "http://www.institut-nignon.com/images/tele/francois-2-cours-2979.jpg"
          , tags = [ "restaurant" ]
          }
        , { id = 2
          , title = "Le Baroque"
          , description = "Envie d'un endroit sympa au Hangar à Bananes ? Une équipe de choc et un cadre superbe."
          , photoThumbnail = "http://www.hangarabananes.fr/wp-content/uploads/photo2-553x368.jpg"
          , tags = [ "bar" ]
          }
        , { id = 3
          , title = "Jo le Boucher"
          , description = "Atlantis grand lieu de la consomation. Un restaurant de chaine mais aussi une bonne surprise"
          , photoThumbnail = "https://media-cdn.tripadvisor.com/media/photo-s/07/83/cb/50/jo-le-boucher-tout-un.jpg"
          , tags = [ "atlantis" ]
          }
        , { id = 4
          , title = "Le Vaporetto"
          , description = "Trentemoult et ses couleur et son restaurant italien. Quel rapport ? Aucun fils unique."
          , photoThumbnail = "http://www.videgrenier-trentemoult.fr/partenaires/LeVaporetto.jpeg"
          , tags = [ "restaurant" ]
          }
        ]
    , tags = [ "restaurant", "bar", "atlantis" ]
    , visibleTags = Set.empty
    }
