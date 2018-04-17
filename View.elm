module View exposing (..)

import Html exposing
  ( Html
  , div
  , text
  , h3
  )
import Html.App
import Messages exposing (Msg(..))
import Models exposing (Model)


view : Model -> Html Msg
view model =
  div []
      [ list model
      , addBtn model
      ]

list : Model -> Html Msg
list model =
  div []
      [ text "Yeah" ]

addBtn : Model -> Html Msg
addBtn model =
  div []
      [ input [] []
      , button [] [ text "Add another" ]
      ]

-- page : Model -> Html Msg
-- page model =
--     Html.App.map StatesMsg (States.DropDown.view model.stateModel)
