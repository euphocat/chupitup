module Blog exposing (..)

import Html exposing (Html, div, text, label, input)
import Html.App as App
import Html.Events exposing (onInput)
import String exposing (left, toUpper, dropLeft, words, join)


-- Model


type alias Model =
    String


model : String
model =
    ""



-- Update


type Msg
    = UpdateName String


upperCaseFirst : String -> String
upperCaseFirst value =
    value
        |> left 1
        |> toUpper
        |> \x -> (++) x (dropLeft 1 value)


upperAll : String -> String
upperAll value =
    value
        |> words
        |> List.map upperCaseFirst
        |> join " "


sayHello : String -> String
sayHello name =
    "Hello " ++ name ++ " ! :)"


update : Msg -> Model -> Model
update msg model =
    case msg of
        UpdateName name ->
            name
                |> upperAll
                |> sayHello



-- View


view : String -> Html Msg
view model =
    div []
        [ label [] [ text "Your name : " ]
        , input [ onInput UpdateName ] []
        , div [] [ text model ]
        ]


main : Program Never
main =
    App.beginnerProgram { model = model, view = view, update = update }
