module E_Init exposing (..)

import Date exposing (Date)
import Time exposing (Time, now)
import Task exposing (perform)
import WebData exposing (WebData(..))
import WebData.Http as Http
import A_Model exposing (..)
import B_Message exposing (..)
import C_Data exposing (decodeTranslations)
import Navigation exposing (Location)
import UrlParser as Url exposing ((</>))


---------------------------------------------------
-- This is where we hard-code stuff like routes,
-- init states, etc.
-- As we may need to run a 'Cmd' inside an 'init'
-- we populate this stage last.
---------------------------------------------------
--
--
--------------------------
-- routes & reverse routes
--------------------------


routeParser : Url.Parser (Route -> a) a
routeParser =
    Url.oneOf
        [ Url.map HomeRoute Url.top
        , Url.map SettingsRoute (Url.s "settings")
        , Url.map DonutsRoute (Url.s "donuts")
        ]


reverseRoute : Route -> String
reverseRoute route =
    case route of
        SettingsRoute ->
            "#/settings"

        DonutsRoute ->
            "#/donuts"

        _ ->
            "#/"



------------------
-- init
------------------


init : Location -> ( Model, Cmd Msg )
init location =
    ( model location
      -- rather than have flags to js to get the current time on
      -- app startup, use Time.now & Cmd.batch if you need more than
      -- one thing to happen on launch
    , Cmd.batch
        [ Http.get "/api/en.json" HandleTranslationsResponse decodeTranslations
        , Task.perform TimeChange Time.now
        ]
    )


model : Location -> Model
model location =
    { appState = NotReady 0
    , location = location
    , taco = Taco 0 (\s -> s)
    , selectedLanguage = English
    , route = HomeRoute
    , home = homeModel
    , donuts = [ donutA, donutB, donutC ]
    }


homeModel =
    { commits = NotAsked
    , stargazers = NotAsked
    }


parseLocation : Location -> Route
parseLocation location =
    location
        |> Url.parseHash routeParser
        |> Maybe.withDefault NotFoundRoute


donutA : DonutModel
donutA =
    { inCOffee = False
    , numEaten = 0
    , numDonuts = 1
    , status = "What ever shall I do?"
    , donutId = DonutA
    , name = "Ossi"
    }


donutB : DonutModel
donutB =
    { inCOffee = False
    , numEaten = 0
    , numDonuts = 1
    , status = "What ever shall I do?"
    , donutId = DonutB
    , name = "Matias"
    }


donutC : DonutModel
donutC =
    { inCOffee = False
    , numEaten = 0
    , numDonuts = 1
    , status = "What ever shall I do?"
    , donutId = DonutC
    , name = "Adam"
    }
