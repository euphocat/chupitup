module Models exposing (..)

import Components.Tags exposing (..)
import Routing.Routes exposing (Route)


type alias Url =
    String


type alias Article =
    { id : String
    , title : String
    , description : String
    , resume : String
    , body : String
    , photoThumbnail : Url
    , categories : List Tag
    , place : Tag
    }


type alias State =
    { route : Route
    , editor : Maybe Article
    , articles : Maybe (List Article)
    , categories : Maybe (List Tag)
    , places : Maybe (List Tag)
    , visiblePlaces : List Tag
    , visibleCategories : List Tag
    }


newState : Route -> State
newState route =
    { route = route
    , editor = Nothing
    , articles = Nothing
    , categories = Nothing
    , places = Nothing
    , visiblePlaces = []
    , visibleCategories = []
    }
