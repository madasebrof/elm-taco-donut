module Misc.I18n exposing (..)

import Dict
import B_Message exposing (..)
import C_Data exposing (Translations)


get : Translations -> String -> String
get dict key =
    dict
        |> Dict.get key
        |> Maybe.withDefault key
