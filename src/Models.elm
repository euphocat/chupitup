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
    , body : String
    , photoThumbnail : Url
    , tags : List Tag
    , place : Tag
    }


type alias State =
    { route : Route
    , articles : Maybe (List Article)
    , tags : List Tag
    , visibleTags : Set.Set Tag
    , visiblePlaces : Set.Set Tag
    }


newState : Route -> State
newState route =
    { route = route
    , articles = Nothing
    , tags = [ "restaurant", "bar", "atlantis" ]
    , visibleTags = Set.empty
    , visiblePlaces = Set.empty
    }
