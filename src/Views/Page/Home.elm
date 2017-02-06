module Views.Page.Home exposing (viewHome)

import Date exposing (Date)
import WebData exposing (WebData(..))
import WebData.Http
import Html exposing (..)
import Html.Attributes exposing (href, src)
import Html.Events exposing (..)
import A_Model exposing (..)
import B_Message exposing (..)
import C_Data exposing (..)
import E_Init exposing (..)
import Misc.Style exposing (..)


viewHome : Model -> Html Msg
viewHome model =
    div []
        [ a
            [ styles appStyles
            , href "https://github.com/ohanhi/elm-model.taco/"
            ]
            [ h2 [] [ text "ohanhi/elm-model.taco" ] ]
        , div []
            [ button
                [ onClick (Home ReloadData)
                , styles actionButton
                ]
                [ text ("↻ " ++ model.taco.translate "commits-refresh") ]
            ]
        , div [ styles (flexContainer ++ gutterTop) ]
            [ div [ styles (flex2 ++ gutterRight) ]
                [ h3 [] [ text (model.taco.translate "commits-heading") ]
                , viewCommits model
                ]
            , div [ styles flex1 ]
                [ h3 [] [ text (model.taco.translate "stargazers-heading") ]
                , viewStargazers model
                ]
            ]
        ]


viewCommits : Model -> Html Msg
viewCommits model =
    case model.home.commits of
        Loading ->
            text (model.taco.translate "status-loading")

        Failure _ ->
            text (model.taco.translate "status-network-error")

        Success commits ->
            commits
                |> List.sortBy (\commit -> -(Date.toTime commit.date))
                |> List.map (viewCommit model)
                |> ul [ styles commitList ]

        _ ->
            text ""


viewCommit : Model -> Commit -> Html Msg
viewCommit model commit =
    li [ styles card ]
        [ h4 [] [ text commit.userName ]
        , em [] [ text (formatTimestamp model commit.date) ]
        , p [] [ text commit.message ]
        ]


formatTimestamp : Model -> Date -> String
formatTimestamp model date =
    let
        minutes =
            floor ((model.taco.currentTime - (Date.toTime date)) / 1000 / 60)
    in
        case minutes of
            0 ->
                model.taco.translate "timeformat-zero-minutes"

            1 ->
                model.taco.translate "timeformat-one-minute-ago"

            n ->
                model.taco.translate "timeformat-n-minutes-ago-before"
                    ++ " "
                    ++ toString n
                    ++ " "
                    ++ model.taco.translate "timeformat-n-minutes-ago-after"


viewStargazers : Model -> Html Msg
viewStargazers model =
    case model.home.stargazers of
        Loading ->
            text (model.taco.translate "status-loading")

        Failure _ ->
            text (model.taco.translate "status-network-error")

        Success stargazers ->
            stargazers
                |> List.reverse
                |> List.map viewStargazer
                |> ul [ styles commitList ]

        _ ->
            text ""


viewStargazer : Stargazer -> Html Msg
viewStargazer stargazer =
    li [ styles (card ++ flexContainer) ]
        [ img
            [ styles avatarPicture
            , src stargazer.avatarUrl
            ]
            []
        , a
            [ styles stargazerName
            , href stargazer.url
            ]
            [ text stargazer.login ]
        ]
