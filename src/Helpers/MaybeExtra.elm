module Helpers.MaybeExtra exposing (..)


isNothing : Maybe a -> Bool
isNothing a =
    case a of
        Nothing ->
            True

        Just a ->
            False
