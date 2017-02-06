module Updates.Donut exposing (updateDonut)

import Html exposing (text)
import A_Model exposing (DonutModel)
import B_Message exposing (DonutMsg(..), DonutId(..))


updateDonut : DonutMsg -> DonutId -> List DonutModel -> List DonutModel
updateDonut donutmsg donutId donuts =
    let
        idmatch =
            List.filter (\el -> el.donutId == donutId) donuts

        otherdonuts =
            List.filter (\el -> el.donutId /= donutId) donuts
    in
        case idmatch of
            model :: [] ->
                case donutmsg of
                    Eat ->
                        { model
                            | status = "Yum! Eating a Donut! Err.. a Doughnut?"
                            , numEaten = model.numEaten + 1
                            , numDonuts = model.numDonuts - 1
                        }
                            :: otherdonuts

                    DipInCoffee ->
                        case model.inCOffee of
                            True ->
                                { model
                                    | status = "Mmmm! Much better!!"
                                    , inCOffee = False
                                }
                                    :: otherdonuts

                            False ->
                                { model
                                    | status = "This is stale--I think I'll dip it in coffee!"
                                    , inCOffee = True
                                }
                                    :: otherdonuts

                    OrderOneMore ->
                        { model
                            | status = "Mmmmm. Maybe just one more, please!"
                            , numDonuts = model.numDonuts + 1
                        }
                            :: otherdonuts

            x :: _ ->
                -- if we hit here, we have a coding error as we are matching on multiple IDs
                -- this should be impossible, as we check this when we create a view
                otherdonuts

            [] ->
                -- if we hit here, we have a coding error as we are matching on a non-existent ID
                -- this should be impossible, as we check this when we create a view
                otherdonuts
