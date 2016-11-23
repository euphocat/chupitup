module Models exposing (..)

import Components.Tags.Tags exposing (Tag)
import Routing.Routes exposing (Route)
import Set exposing (Set)


type alias Url =
    String


type alias Article =
    { id : String
    , title : String
    , description : String
    , body : String
    , photoThumbnail : Url
    , tags : List Tag
    , place : Tag
    }


type alias State =
    { route : Route
    , editor : Maybe Article
    , articles : Maybe (List Article)
    , categories : Maybe (Set Tag)
    , places : Maybe (Set Tag)
    , visibleTags : Set Tag
    }


newState : Route -> State
newState route =
    { route = route
    , editor = Nothing
    , articles = Nothing
    , categories = Nothing
    , places = Nothing
    , visibleTags = Set.empty
    }
