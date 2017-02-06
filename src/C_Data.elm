module C_Data exposing (..)

import Json.Decode exposing (Decoder, field, at, string, int, float, dict)
import Json.Decode.Pipeline exposing (decode, required, requiredAt)
import Date exposing (Date)
import Dict exposing (Dict)


-----------------------------------------------------------------
-- 'C_Data' is designed for records that are filled in via a Cmd,
-- 'arrive' in the form of a JSON message, are decode via a
-- decoder, and are added to the model in some fashion.
-----------------------------------------------------------------


type alias Commit =
    { userName : String
    , sha : String
    , date : Date
    , message : String
    }


decodeCommit : Decoder Commit
decodeCommit =
    decode Commit
        |> requiredAt [ "commit", "author", "name" ] string
        |> requiredAt [ "sha" ] string
        |> requiredAt [ "commit", "author", "date" ] dateDecoder
        |> requiredAt [ "commit", "message" ] string


decodeCommitList : Decoder (List Commit)
decodeCommitList =
    Json.Decode.list decodeCommit


type alias Stargazer =
    { login : String
    , avatarUrl : String
    , url : String
    }


decodeStargazer : Decoder Stargazer
decodeStargazer =
    decode Stargazer
        |> required "login" string
        |> required "avatar_url" string
        |> required "html_url" string


decodeStargazerList : Decoder (List Stargazer)
decodeStargazerList =
    Json.Decode.list decodeStargazer


type alias Translations =
    Dict String String


decodeTranslations : Decoder Translations
decodeTranslations =
    dict string


dateDecoder : Decoder Date
dateDecoder =
    Json.Decode.string
        |> Json.Decode.andThen
            (\text ->
                case Date.fromString text of
                    Ok date ->
                        Json.Decode.succeed date

                    Err e ->
                        Json.Decode.fail e
            )
