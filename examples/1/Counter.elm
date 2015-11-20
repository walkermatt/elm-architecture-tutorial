module Counter where

import Html exposing (..)
import Html.Attributes exposing (style)
import Html.Events exposing (onClick)


-- MODEL

type alias Model = { value : Int, initial : Int, lower : Int, upper : Int }


-- UPDATE

type Action = Increment | Decrement | Reset

clampValue model n =
    clamp model.lower model.upper n

update : Action -> Model -> Model
update action model =
    let
        clamp = clampValue model
    in
       case action of
           Increment -> { model | value = (clamp (model.value + 1)) }
           Decrement -> { model | value = (clamp (model.value - 1)) }
           Reset -> { model | value = model.initial }


-- VIEW

view : Signal.Address Action -> Model -> Html
view address model =
    div []
        [ button [ onClick address Decrement ] [ text "-" ]
        , div [ countStyle ] [ text (toString model.value) ]
        , button [ onClick address Increment ] [ text "+" ]
        , button [ onClick address Reset ] [ text "Reset" ]
        ]


countStyle : Attribute
countStyle =
    style
    [ ("font-size", "20px")
    , ("font-family", "monospace")
    , ("display", "inline-block")
    , ("width", "50px")
    , ("text-align", "center")
    ]
