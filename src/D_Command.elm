module D_Command exposing (..)

import Date exposing (Date)
import WebData exposing (WebData(..))
import WebData.Http
import B_Message exposing (..)
import C_Data exposing (..)


-------------------------------------------------------------
-- Side effects go here, e.g. getting data from a database,
-- an API, etc.
--
-- Also, we want all Commands to return a Msg so we can process
-- it within the top level 'Update' function.
--
-- We can map or 'wrap' commnads that return sub messages
-- to a message if we want to break out processing of sub messages
-- to an update helper.
-------------------------------------------------------------


fetchData : Cmd Msg
fetchData =
    Cmd.batch
        [ fetchCommits
        , fetchStargazers
        ]


mapSubMessage submsg msg =
    Cmd.map (\m -> msg m) submsg


fetchCommits : Cmd Msg
fetchCommits =
    let
        homeMsg : Cmd HomeMsg
        homeMsg =
            WebData.Http.getWithCache
                "https://api.github.com/repos/ohanhi/elm-taco/commits"
                HandleCommits
                decodeCommitList
    in
        -- instead of returning 'HandleCommits' (which is a HomeMsg)
        -- we want to return 'Home HandleCommits' (which is a Msg)
        mapSubMessage homeMsg Home


fetchStargazers : Cmd Msg
fetchStargazers =
    let
        homeMsg : Cmd HomeMsg
        homeMsg =
            WebData.Http.getWithCache
                "https://api.github.com/repos/ohanhi/elm-taco/stargazers"
                HandleStargazers
                decodeStargazerList
    in
        -- instead of returning 'HandleStargazers' (which is a HomeMsg)
        -- we want to return 'Home HandleStargazers' (which is a Msg)
        mapSubMessage homeMsg Home


getTranslations : Language -> Cmd Msg
getTranslations language =
    let
        url =
            case language of
                English ->
                    "/api/en.json"

                Finnish ->
                    "/api/fi.json"

                FinnishFormal ->
                    "/api/fi-formal.json"
    in
        WebData.Http.get url HandleTranslationsResponse decodeTranslations
