module Helpers.Events exposing (..)

import Html exposing (Attribute)
import Html.Events exposing (Options, onWithOptions)
import Json.Decode as Json


onClick : msg -> Attribute msg
onClick message =
    let
        one =
            Debug.log (toString message)
    in
        onWithOptions "click" preventDefault (Json.succeed message)


preventDefault : Options
preventDefault =
    { stopPropagation = True
    , preventDefault = True
    }
