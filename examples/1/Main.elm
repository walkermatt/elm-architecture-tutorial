
import Counter exposing (update, view)
import StartApp.Simple exposing (start)

-- Define our model, the value gets set to initial before we start the app
model = { value = 0, initial = 5, lower = 0, upper = 10 }

main =
  start
    { model = { model | value = model.initial }
    , update = update
    , view = view
    }
