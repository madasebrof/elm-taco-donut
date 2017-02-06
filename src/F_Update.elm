module F_Update exposing (update)

import Navigation
import A_Model exposing (..)
import B_Message exposing (..)
import C_Data exposing (Translations)
import D_Command exposing (getTranslations)
import E_Init exposing (parseLocation, reverseRoute)
import Updates.Home exposing (updateHome)
import Updates.Taco exposing (updateTaco, updateTranslations)
import Updates.Donut exposing (updateDonut)


----------------------------------------------------------------
-- Top level Message processing. Note that we handle each message
-- case explicitly in this function and in all helper update
-- functions. E.g., there are no '_' case matches.
--
-- Super clean.
--
----------------------------------------------------------------


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        TimeChange time ->
            ( updateTaco (UpdateTime time) model, Cmd.none )

        HandleTranslationsResponse webData ->
            updateTranslations webData model

        UrlChange location ->
            ( { model | route = parseLocation location }, Cmd.none )

        NavigateTo route ->
            ( model, Navigation.newUrl (reverseRoute route) )

        SelectLanguage lang ->
            ( { model | selectedLanguage = lang }, getTranslations lang )

        Home homeMsg ->
            updateHome homeMsg model

        Donut donutmsg donutId ->
            ( { model | donuts = updateDonut donutmsg donutId model.donuts }, Cmd.none )
