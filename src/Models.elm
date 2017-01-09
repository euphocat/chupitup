module Models exposing (..)

import Components.Tags exposing (..)
import Dict exposing (Dict)
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
    , articles : Maybe (List Article)
    , tags : Dict String Tag
    , isLoading : Bool
    }


newState : Route -> State
newState route =
    { route = route
    , articles = Nothing
    , tags = Dict.empty
    , isLoading = True
    }
