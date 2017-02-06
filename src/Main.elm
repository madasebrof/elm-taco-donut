module Main exposing (..)

import Navigation
import Time exposing (Time)
import A_Model exposing (Model)
import B_Message exposing (Msg(TimeChange, UrlChange))
import E_Init exposing (init)
import F_Update exposing (update)
import G_View exposing (view)


main : Program Never Model Msg
main =
    Navigation.program UrlChange
        { init = init
        , update = update
        , view = view
        , subscriptions = \_ -> Time.every Time.second TimeChange
        }
