module Updates.Home exposing (..)

import Time exposing (Time)
import Misc.I18n as I18n exposing (get)
import WebData exposing (WebData(..))
import A_Model exposing (..)
import B_Message exposing (..)
import D_Command exposing (fetchData)


updateHome : HomeMsg -> Model -> ( Model, Cmd Msg )
updateHome msg model =
    let
        homeModel =
            model.home

        ( updatedHomeModel, cmdMsg ) =
            case msg of
                ReloadData ->
                    ( { homeModel | commits = Loading, stargazers = Loading }, fetchData )

                HandleCommits webData ->
                    ( { homeModel | commits = webData }, Cmd.none )

                HandleStargazers webData ->
                    ( { homeModel | stargazers = webData }, Cmd.none )
    in
        ( { model | home = updatedHomeModel }, cmdMsg )
