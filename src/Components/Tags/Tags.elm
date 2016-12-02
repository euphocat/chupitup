module Components.Tags.Tags exposing (..)


type Tag
    = Place String
    | Category String


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


tagToString : Tag -> String
tagToString tag =
    case tag of
        Place tagPayload ->
            tagPayload

        Category tagPayload ->
            tagPayload
