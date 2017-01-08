module Components.Tags exposing (..)

import Dict exposing (Dict)


type TagKind
    = Place
    | Category


type alias Tag =
    { id : String
    , name : String
    , isActive : Bool
    , kind : TagKind
    }


toggleTag : Tag -> Tag
toggleTag tag =
    { tag | isActive = not tag.isActive }


toggleTags : Tag -> Dict String Tag -> Dict String Tag
toggleTags tag =
    Dict.update tag.id <| Maybe.map toggleTag
