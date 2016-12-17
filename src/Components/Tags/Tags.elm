module Components.Tags.Tags exposing (..)


type alias Tag =
    { id : String
    , name : String
    }


toggleVisibleTag : Tag -> List Tag -> List Tag
toggleVisibleTag tag visibleTags =
    if List.member tag visibleTags then
        visibleTags
            |> List.filter ((/=) tag)
    else
        tag :: visibleTags


isTagActive : Tag -> List Tag -> Bool
isTagActive =
    List.member
