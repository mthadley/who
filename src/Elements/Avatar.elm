module Elements.Avatar exposing (avatar)

import Css exposing (..)
import Elements exposing (Element)
import Html.Styled as Html exposing (styled)
import Theme exposing (theme)


avatar : Element msg
avatar =
    styled Html.div
        [ backgroundSize cover
        , backgroundColor <| theme.background
        , borderRadius <| pct 50
        , borderStyle solid
        , displayFlex
        , alignItems center
        , justifyContent center
        , flexShrink <| num 0
        ]
