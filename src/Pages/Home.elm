module Pages.Home exposing (view)

import Elements
import Html.Styled as Html exposing (..)
import RemoteData
import Store exposing (Store)
import Types.Index as Index
import Types.Party exposing (Party(..))


description : String
description =
    """
Search for currently active United States legislators in both
the House of Representatives and Senate. Find contact information,
term history, and more! We currently pull our data awesome from
open-source government projects.
"""


view : Store -> Html msg
view store =
    let
        index =
            RemoteData.withDefault [] store.index
    in
    Elements.homeCard []
        [ Elements.title []
            [ text "Who Holds Office? "
            , Elements.inverted [] [ text "Find out" ]
            , text " here."
            ]
        , Elements.p [] [ text description ]
        , Elements.row []
            [ viewStat (partyCount Democrat index) "Democrats"
            , viewStat (List.length index) "Legislators"
            , viewStat (partyCount Republican index) "Republicans"
            ]
        ]


viewStat : Int -> String -> Html msg
viewStat stat label =
    Elements.stat []
        [ Elements.statCount [] [ text <| String.fromInt stat ]
        , span [] [ text label ]
        ]


partyCount : Party -> List Index.Item -> Int
partyCount party =
    List.length << List.filter ((==) party << .party)
