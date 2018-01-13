module Types.Party exposing (Party(..), decode, toString)

import Json.Decode exposing (Decoder, map, string)


type Party
    = Democrat
    | Republican
    | Independent
    | Other


decode : Decoder Party
decode =
    map fromString string


fromString : String -> Party
fromString name =
    case name of
        "Democrat" ->
            Democrat

        "Republican" ->
            Republican

        "Independent" ->
            Independent

        _ ->
            Other


toString : Party -> String
toString =
    Basics.toString
