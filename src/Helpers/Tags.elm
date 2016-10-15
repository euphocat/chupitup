module Helpers.Tags exposing (..)

import Set


type alias Tag =
    String


toggleVisibleTag : Tag -> Set.Set Tag -> Set.Set Tag
toggleVisibleTag tag visibleTags =
    if Set.member tag visibleTags then
        Set.remove tag visibleTags
    else
        Set.insert tag visibleTags


isTagActive : Tag -> Set.Set Tag -> Bool
isTagActive tag tags =
    Set.member tag tags
