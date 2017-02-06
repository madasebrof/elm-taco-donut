module Views.Page.Donuts exposing (viewDonuts)

import Html exposing (Html, div)
import A_Model exposing (Model)
import B_Message exposing (Msg, DonutId(..))
import Views.Widget.Donut exposing (viewDonut)


viewDonuts : Model -> Html Msg
viewDonuts model =
    div []
        [ viewDonut DonutA model
        , viewDonut DonutB model
        , viewDonut DonutC model
        ]
