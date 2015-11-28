module CounterList where

import Counter
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)


-- MODEL

type alias Model = { counters : List Counter.Model }

type alias ID = Int


init : Model
init = { counters = [] }


-- UPDATE

type Action
    = Insert
    | Remove
    | Modify ID Counter.Action


update : Action -> Model -> Model
update action model =
  case action of
    Insert ->
      let newCounter =  Counter.init 0
          newCounters = model.counters ++ [ newCounter ]
      in
          { model |
              counters = newCounters
          }

    Remove ->
      { model | counters = List.drop 1 model.counters }

    Modify id counterAction ->
      let updateCounter counterID counterModel =
              if counterID == id then
                  Counter.update counterAction counterModel
              else
                  counterModel
      in
          { model | counters = List.indexedMap updateCounter model.counters }


-- VIEW

view : Signal.Address Action -> Model -> Html
view address model =
  let counters = List.indexedMap (viewCounter address) model.counters
      remove = button [ onClick address Remove ] [ text "Remove" ]
      insert = button [ onClick address Insert ] [ text "Add" ]
  in
      div [] ([remove, insert] ++ counters)


viewCounter : Signal.Address Action -> ID -> Counter.Model -> Html
viewCounter address id model =
  Counter.view (Signal.forwardTo address (Modify id)) model
