module Views.Page.Settings exposing (..)

import Html exposing (..)
import Html.Events exposing (..)
import WebData exposing (WebData(..))
import WebData.Http
import A_Model exposing (..)
import B_Message exposing (..)
import E_Init exposing (..)
import Misc.Style exposing (..)


viewSettings : Model -> Html Msg
viewSettings model =
    div []
        [ h2 [] [ text (model.taco.translate "language-selection-heading") ]
        , selectionButton model English "English"
        , selectionButton model FinnishFormal "Suomi (virallinen)"
        , selectionButton model Finnish "Suomi (puhekieli)"
        , pre [ styles card ] [ text ("taco == " ++ toString model.taco) ]
        ]


selectionButton : Model -> Language -> String -> Html Msg
selectionButton model language shownName =
    let
        buttonStyles =
            if model.selectedLanguage == language then
                actionButtonActive ++ gutterRight
            else
                actionButton ++ gutterRight
    in
        button
            [ styles buttonStyles
            , onClick (SelectLanguage language)
            ]
            [ text shownName ]
