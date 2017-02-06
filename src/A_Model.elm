module A_Model exposing (..)

import Navigation exposing (Location)
import WebData exposing (WebData(..))
import Dict exposing (Dict)
import Date exposing (Date)
import Time exposing (Time)
import B_Message exposing (..)
import C_Data exposing (Commit, Stargazer)


type alias Model =
    ------------------------------------------------------
    --
    -- One Model To Rule Them All.
    --
    -- As you can see when you put all the models together
    -- you really don't need a heirarchy of components.
    -- Even if we had one hundred widgets/pages/etc,
    -- we'd stil be fine!
    ------------------------------------------------------
    { appState : AppState
    , location : Location
    , taco : Taco
    , selectedLanguage : Language
    , route : Route
    , home : HomeModel
    , donuts : List DonutModel
    }


type AppState
    = NotReady Time
    | Ready


type alias Taco =
    { currentTime : Time
    , translate : String -> String
    }


type alias HomeModel =
    { commits : WebData (List Commit)
    , stargazers : WebData (List Stargazer)
    }


type alias DonutModel =
    { inCOffee : Bool
    , numEaten : Int
    , numDonuts : Int
    , status : String
    , donutId : DonutId
    , name : String
    }
