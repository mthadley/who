module Theme exposing (getPartyColor, theme)

import Css exposing (..)
import Types.Party exposing (Party(..))


theme :
    { accent : Color
    , background : Color
    , dark : Color
    , demo : Color
    , light : Color
    , primary : Color
    , repub : Color
    , indie : Color
    , secondary : Color
    }
theme =
    { accent = hex "ABC"
    , background = hex "EEE"
    , dark = hex "222"
    , demo = hex "87AAFF"
    , light = hex "EEE"
    , primary = hex "444"
    , repub = hex "FE8585"
    , indie = hex "D57AFF"
    , secondary = hex "FFF"
    }


getPartyColor : Party -> Color
getPartyColor party =
    case party of
        Democrat ->
            theme.demo

        Republican ->
            theme.repub

        Independent ->
            theme.indie

        Other ->
            theme.primary
