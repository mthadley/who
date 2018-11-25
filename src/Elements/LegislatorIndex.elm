module Elements.LegislatorIndex exposing (letter, letterList)

import Css exposing (..)
import Elements exposing (Element, onPhone, truncate, ul)
import Html.Styled as Html exposing (styled)


letter : Element msg
letter =
    styled Html.li [ margin <| px 8 ]


letterList : Element msg
letterList =
    styled ul
        [ displayFlex
        , flexDirection column
        , alignItems center
        , flexWrap wrap
        , onPhone [ flexDirection Css.row ]
        ]
