module G_View exposing (..)

import Navigation exposing (Location)
import Html exposing (..)
import Html.Attributes exposing (href)
import Html.Events exposing (..)
import A_Model exposing (..)
import B_Message exposing (..)
import Misc.Style exposing (..)
import Views.Page.Home exposing (viewHome)
import Views.Page.Settings exposing (viewSettings)
import Views.Page.Donuts exposing (viewDonuts)


view : Model -> Html Msg
view model =
    case model.appState of
        Ready ->
            routerView model

        NotReady _ ->
            text "Loading"


routerView : Model -> Html Msg
routerView model =
    let
        buttonStyles route =
            if model.route == route then
                styles navigationButtonActive
            else
                styles navigationButton
    in
        div [ styles [ bg ] ]
            [ div [ styles (appStyles ++ wrapper) ]
                [ header [ styles headerSection ]
                    [ h1 [] [ text (model.taco.translate "site-title") ]
                    ]
                , nav [ styles navigationBar ]
                    [ button
                        [ onClick (NavigateTo HomeRoute)
                        , buttonStyles HomeRoute
                        ]
                        [ text (model.taco.translate "page-title-home") ]
                    , button
                        [ onClick (NavigateTo SettingsRoute)
                        , buttonStyles SettingsRoute
                        ]
                        [ text (model.taco.translate "page-title-settings") ]
                    , button
                        [ onClick (NavigateTo DonutsRoute)
                        , buttonStyles DonutsRoute
                        ]
                        [ text (model.taco.translate "page-title-donuts") ]
                    ]
                , pageView model
                , footer [ styles footerSection ]
                    [ text (model.taco.translate "footer-github-before" ++ " ")
                    , a
                        [ href "https://github.com/ohanhi/elm-taco/"
                        , styles footerLink
                        ]
                        [ text "Github" ]
                    , text (model.taco.translate "footer-github-after")
                    ]
                ]
            ]


pageView : Model -> Html Msg
pageView model =
    div [ styles activeView ]
        [ (case model.route of
            HomeRoute ->
                viewHome model

            SettingsRoute ->
                viewSettings model

            DonutsRoute ->
                viewDonuts model

            NotFoundRoute ->
                h1 [] [ text "404 :(" ]
          )
        ]
