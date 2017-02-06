module Views.Widget.Donut exposing (viewDonut)

import Html exposing (Html, button, div, text, br, h2, h3, h4, hr)
import Html.Attributes exposing (style, align, disabled, class)
import Html.Events exposing (onClick)
import A_Model exposing (DonutModel, Model)
import B_Message exposing (Msg(..), DonutMsg(..), DonutId(..))
import Misc.Style exposing (..)


-- This a "pure" view helper class. This view has no internal state.


viewDonut : DonutId -> Model -> Html Msg
viewDonut donutId model =
    let
        idmatch =
            List.filter (\el -> el.donutId == donutId) model.donuts

        translate =
            model.taco.translate
    in
        case idmatch of
            donut :: [] ->
                div []
                    [ h3 [] [ text ((translate "donut-hi") ++ donut.name ++ (translate "donut-love")) ]
                    , h3 [] [ text (translate "donut-what") ]
                    , eatButton donut model
                    , br [] []
                    , dipButton donut model
                    , br [] []
                    , button [ styles donutButtonActive, onClick (Donut OrderOneMore donut.donutId), class "btn btn-primary donut" ] [ text "Get another donut" ]
                    , br [] []
                    , div [ styles donutWidget, class "alert alert-info" ] [ text ("Number of donuts == " ++ (toString donut.numDonuts)) ]
                    , div [ styles donutWidget, class "alert alert-info" ] [ text ("Donut in coffee == " ++ (toString donut.inCOffee)) ]
                    , div [ styles donutWidget, class "alert alert-info" ] [ text ("Total donuts eaten == " ++ (toString donut.numEaten)) ]
                    , hr [] []
                    ]

            donut :: _ ->
                div []
                    [ text ("You have two elements in the model (" ++ (toString donutId) ++ ") with the same ID! IDs must be unique for every element, please!")
                    ]

            [] ->
                div []
                    [ text ("You need to add '" ++ (toString donutId) ++ "' to your model before you can use it! Also, check the 'donutId' record to make sure it matches the donutId you think you want!")
                    ]



---------------------
-- Local Functions --
---------------------


eatButton : DonutModel -> Model -> Html Msg
eatButton donut model =
    case donut.numDonuts of
        0 ->
            button [ styles donutButtonDisabled, class "btn btn-primary donut", disabled True ] [ text "Man, out of donuts!" ]

        _ ->
            case donut.inCOffee of
                True ->
                    button [ styles donutButtonDisabled, class "btn btn-primary donut", disabled True ] [ text "Can't eat it if it's in the coffee!" ]

                False ->
                    case donut.numEaten of
                        0 ->
                            button [ styles donutButtonActive, class "btn btn-primary donut", onClick (Donut Eat donut.donutId) ] [ text "Eat donut" ]

                        _ ->
                            button [ styles donutButtonActive, class "btn btn-primary donut", onClick (Donut Eat donut.donutId) ] [ text "Eat another donut" ]


dipButton : DonutModel -> Model -> Html Msg
dipButton donut model =
    case donut.numDonuts of
        0 ->
            button [ styles donutButtonDisabled, class "btn btn-primary donut", disabled True ] [ text "If only I had a donut to dip in coffee!!" ]

        _ ->
            case donut.inCOffee of
                False ->
                    button [ styles donutButtonActive, onClick (Donut DipInCoffee donut.donutId), class "btn btn-primary donut" ] [ text "Dip donut in coffee" ]

                True ->
                    button [ styles donutButtonActive, onClick (Donut DipInCoffee donut.donutId), class "btn btn-primary donut" ] [ text "Take donut out of coffee" ]
