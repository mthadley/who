module Types.Party exposing (Party(..), decode, toString)

import Json.Decode as Decode exposing (Decoder)


type Party
    = Democrat
    | Republican
    | Independent
    | Other


decode : Decoder Party
decode =
    Decode.map fromString Decode.string


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
toString party =
    case party of
        Democrat ->
            "Democrat"

        Republican ->
            "Republican"

        Independent ->
            "Independent"

        Other ->
            "Other"
