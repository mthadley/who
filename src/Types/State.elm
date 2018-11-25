module Types.State exposing
    ( State
    , decode
    , toString
    , toStringShort
    )

import Json.Decode as Decode exposing (Decoder, string)


type State
    = AK
    | AL
    | AR
    | AS
    | AZ
    | CA
    | CO
    | CT
    | DE
    | DC
    | FL
    | GA
    | GU
    | HI
    | IA
    | ID
    | IL
    | IN
    | KS
    | KY
    | LA
    | MA
    | MD
    | ME
    | MI
    | MN
    | MO
    | MP
    | MS
    | MT
    | NC
    | ND
    | NE
    | NH
    | NJ
    | NM
    | NV
    | NY
    | OH
    | OK
    | OR
    | PA
    | PR
    | RI
    | SC
    | SD
    | TN
    | TX
    | UT
    | UM
    | VA
    | VT
    | VI
    | WA
    | WI
    | WV
    | WY


decode : Decoder State
decode =
    string |> Decode.andThen decodeAbbr


decodeAbbr : String -> Decoder State
decodeAbbr input =
    case input of
        "AK" ->
            Decode.succeed AK

        "AL" ->
            Decode.succeed AL

        "AR" ->
            Decode.succeed AR

        "AS" ->
            Decode.succeed AS

        "AZ" ->
            Decode.succeed AZ

        "CA" ->
            Decode.succeed CA

        "CO" ->
            Decode.succeed CO

        "CT" ->
            Decode.succeed CT

        "DC" ->
            Decode.succeed DC

        "DE" ->
            Decode.succeed DE

        "FL" ->
            Decode.succeed FL

        "GA" ->
            Decode.succeed GA

        "GU" ->
            Decode.succeed GU

        "HI" ->
            Decode.succeed HI

        "IA" ->
            Decode.succeed IA

        "ID" ->
            Decode.succeed ID

        "IL" ->
            Decode.succeed IL

        "IN" ->
            Decode.succeed IN

        "KS" ->
            Decode.succeed KS

        "KY" ->
            Decode.succeed KY

        "LA" ->
            Decode.succeed LA

        "MA" ->
            Decode.succeed MA

        "MD" ->
            Decode.succeed MD

        "ME" ->
            Decode.succeed ME

        "MI" ->
            Decode.succeed MI

        "MN" ->
            Decode.succeed MN

        "MO" ->
            Decode.succeed MO

        "MS" ->
            Decode.succeed MS

        "MP" ->
            Decode.succeed MP

        "MT" ->
            Decode.succeed MT

        "NC" ->
            Decode.succeed NC

        "ND" ->
            Decode.succeed ND

        "NE" ->
            Decode.succeed NE

        "NH" ->
            Decode.succeed NH

        "NJ" ->
            Decode.succeed NJ

        "NM" ->
            Decode.succeed NM

        "NV" ->
            Decode.succeed NV

        "NY" ->
            Decode.succeed NY

        "OH" ->
            Decode.succeed OH

        "OK" ->
            Decode.succeed OK

        "OR" ->
            Decode.succeed OR

        "PA" ->
            Decode.succeed PA

        "PR" ->
            Decode.succeed PR

        "RI" ->
            Decode.succeed RI

        "SC" ->
            Decode.succeed SC

        "SD" ->
            Decode.succeed SD

        "TN" ->
            Decode.succeed TN

        "TX" ->
            Decode.succeed TX

        "UT" ->
            Decode.succeed UT

        "UM" ->
            Decode.succeed UM

        "VA" ->
            Decode.succeed VA

        "VI" ->
            Decode.succeed VI

        "VT" ->
            Decode.succeed VT

        "WA" ->
            Decode.succeed WA

        "WI" ->
            Decode.succeed WI

        "WV" ->
            Decode.succeed WV

        "WY" ->
            Decode.succeed WY

        state ->
            Decode.fail <| "Not a valid state abbreviation: " ++ state


toString : State -> String
toString state =
    case state of
        AK ->
            "Alaska"

        AL ->
            "Alabama"

        AR ->
            "Arkansas"

        AS ->
            "American Samoa"

        AZ ->
            "Arizona"

        CA ->
            "California"

        CO ->
            "Colorado"

        CT ->
            "Connecticut"

        DE ->
            "Delaware"

        DC ->
            "District of Columbia"

        FL ->
            "Florida"

        GA ->
            "Georgia"

        GU ->
            "Guam"

        HI ->
            "Hawaii"

        IA ->
            "Iowa"

        ID ->
            "Idaho"

        IL ->
            "Illinois"

        IN ->
            "Indiana"

        KS ->
            "Kansas"

        KY ->
            "Kentucky"

        LA ->
            "Louisiana"

        MA ->
            "Massachusetts"

        MD ->
            "Maryland"

        ME ->
            "Maine"

        MI ->
            "Michigan"

        MN ->
            "Minnesota"

        MO ->
            "Missouri"

        MP ->
            "Northern Mariana Islands"

        MS ->
            "Mississippi"

        MT ->
            "Montana"

        NC ->
            "North Carolina"

        ND ->
            "North Dakota"

        NE ->
            "Nebraska"

        NH ->
            "New Hampshire"

        NJ ->
            "New Jersey"

        NM ->
            "New Mexico"

        NV ->
            "Nevada"

        NY ->
            "New York"

        OH ->
            "Ohio"

        OK ->
            "Oklahoma"

        OR ->
            "Oregon"

        PA ->
            "Pennsylvania"

        PR ->
            "Puerto Rico"

        RI ->
            "Rhode Island"

        SC ->
            "South Carolina"

        SD ->
            "South Dakota"

        TN ->
            "Tennessee"

        TX ->
            "Texas"

        UM ->
            "U.S. Minor Outlying Islands"

        UT ->
            "Utah"

        VA ->
            "Virginia"

        VI ->
            "U.S. Virgin Islands"

        VT ->
            "Vermont"

        WA ->
            "Washington"

        WI ->
            "Wisconsin"

        WV ->
            "West Virginia"

        WY ->
            "Wyoming"


toStringShort : State -> String
toStringShort state =
    case state of
        AK ->
            "AK"

        AL ->
            "AL"

        AR ->
            "AR"

        AS ->
            "AS"

        AZ ->
            "AZ"

        CA ->
            "CA"

        CO ->
            "CO"

        CT ->
            "CT"

        DE ->
            "DE"

        DC ->
            "DC"

        FL ->
            "FL"

        GA ->
            "GA"

        GU ->
            "GU"

        HI ->
            "HI"

        IA ->
            "IA"

        ID ->
            "ID"

        IL ->
            "IL"

        IN ->
            "IN"

        KS ->
            "KS"

        KY ->
            "KY"

        LA ->
            "LA"

        MA ->
            "MA"

        MD ->
            "MD"

        ME ->
            "ME"

        MI ->
            "MI"

        MN ->
            "MN"

        MO ->
            "MO"

        MP ->
            "MP"

        MS ->
            "MS"

        MT ->
            "MT"

        NC ->
            "NC"

        ND ->
            "ND"

        NE ->
            "NE"

        NH ->
            "NH"

        NJ ->
            "NJ"

        NM ->
            "NM"

        NV ->
            "NV"

        NY ->
            "NY"

        OH ->
            "OH"

        OK ->
            "OK"

        OR ->
            "OR"

        PA ->
            "PA"

        PR ->
            "PR"

        RI ->
            "RI"

        SC ->
            "SC"

        SD ->
            "SD"

        TN ->
            "TN"

        TX ->
            "TX"

        UM ->
            "UM"

        UT ->
            "UT"

        VA ->
            "VA"

        VI ->
            "VI"

        VT ->
            "VT"

        WA ->
            "WA"

        WI ->
            "WI"

        WV ->
            "WV"

        WY ->
            "WY"
