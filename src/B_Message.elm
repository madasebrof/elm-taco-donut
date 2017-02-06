module B_Message exposing (..)

import WebData exposing (WebData(..))
import Navigation exposing (Location)
import C_Data exposing (Commit, Stargazer, Translations)
import Time exposing (Time)


type Route
    = HomeRoute
    | SettingsRoute
    | DonutsRoute
    | NotFoundRoute


type Msg
    = UrlChange Location
    | TimeChange Time
      -- router
    | NavigateTo Route
      -- home
    | Home HomeMsg
      -- settings
    | SelectLanguage Language
    | HandleTranslationsResponse (WebData Translations)
      -- donut widget
    | Donut DonutMsg DonutId


type HomeMsg
    = HandleCommits (WebData (List Commit))
    | HandleStargazers (WebData (List Stargazer))
    | ReloadData


type TacoUpdate
    = NoUpdate
    | UpdateTime Time
    | UpdateTranslations Translations


type Language
    = English
    | Finnish
    | FinnishFormal


type DonutMsg
    = Eat
    | DipInCoffee
    | OrderOneMore


type DonutId
    = DonutA
    | DonutB
    | DonutC
