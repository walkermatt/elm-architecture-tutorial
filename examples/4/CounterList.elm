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
    | Remove ID
    | Modify ID Counter.Action


-- removeAtIndex idx l =
--   -- Create list of (index, value) tuples
--   List.indexedMap (,) l |>
--   -- Filter on index (using patten matching to pick apart the tuple)
--   List.filter (\(i, _) -> i /= idx) |>
--   -- Transform the list of tuples to a list of values (remove the index part)
--   List.map (\(_, val) -> val)


-- removeAtIndex idx l =
--   -- Create list of (index, value) tuples
--     List.indexedMap (,) l |>
--     -- Use foldl to perform the filter and accumalate a list of values that
--     -- should be retained
--     List.foldl (\(k, v) l -> if k == idx then l else l ++ [v]) []


removeAtIndex idx l =
  List.take idx l ++ List.drop (idx + 1) l


update : Action -> Model -> Model
update action model =
  case action of
    Insert ->
      { model |
          counters = Counter.init 0 :: model.counters
      }

    Remove id ->
      { model |
          counters = removeAtIndex id model.counters
      }

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
  let insert = button [ onClick address Insert ] [ text "Add" ]
  in
      div [] (insert :: List.indexedMap (viewCounter address) model.counters)


viewCounter : Signal.Address Action -> ID -> Counter.Model -> Html
viewCounter address id model =
  let
      remove = button [ onClick address (Remove id) ] [ text "x" ]
      counter = Counter.view (Signal.forwardTo address (Modify id)) model
  in
     div [] [counter, remove]
