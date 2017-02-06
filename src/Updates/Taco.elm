module Updates.Taco exposing (updateTaco, updateTranslations)

import Time exposing (Time)
import WebData exposing (WebData(..))
import Misc.I18n as I18n exposing (get)
import A_Model exposing (..)
import B_Message exposing (..)
import C_Data exposing (Translations)
import D_Command exposing (fetchData)
import E_Init exposing (parseLocation, reverseRoute)


updateTaco : TacoUpdate -> Model -> Model
updateTaco tacoUpdate model =
    let
        updateTacoTime : Time -> Taco -> Taco
        updateTacoTime time taco =
            { taco | currentTime = time }

        updateTacoTranslations : Translations -> Taco -> Taco
        updateTacoTranslations translations taco =
            { taco | translate = I18n.get translations }
    in
        case tacoUpdate of
            UpdateTime time ->
                if model.appState == Ready then
                    { model | taco = updateTacoTime time model.taco }
                else
                    { model | appState = NotReady time }

            UpdateTranslations translations ->
                { model | taco = updateTacoTranslations translations model.taco }

            NoUpdate ->
                model


updateTranslations : WebData Translations -> Model -> ( Model, Cmd Msg )
updateTranslations webData model =
    case webData of
        Failure _ ->
            Debug.crash "OMG CANT EVEN DOWNLOAD."

        Success translations ->
            case model.appState of
                NotReady time ->
                    let
                        initTaco =
                            { currentTime = time
                            , translate = I18n.get translations
                            }

                        initHome =
                            { commits = Loading
                            , stargazers = Loading
                            }
                    in
                        ( { model
                            | appState = Ready
                            , taco = initTaco
                            , route = parseLocation model.location
                            , home = initHome
                          }
                        , fetchData
                        )

                Ready ->
                    ( updateTaco (UpdateTranslations translations) model, Cmd.none )

        _ ->
            ( model, Cmd.none )
