module Types.Index exposing (Item, decodeItem)

import Json.Decode exposing (Decoder, nullable, string)
import Json.Decode.Pipeline as Pipeline exposing (custom, decode, required)
import Types.Party as Party exposing (Party)
import Types.State as State exposing (State)


type alias Item =
    { name : String
    , lastName : String
    , id : String
    , party : Party
    , state : State
    , photoUrl : Maybe String
    }


decodeItem : Decoder Item
decodeItem =
    Pipeline.decode Item
        |> required "name" string
        |> required "last_name" string
        |> required "id" string
        |> required "party" Party.decode
        |> required "state" State.decode
        |> required "photo_url" (nullable string)
