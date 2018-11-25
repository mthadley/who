module Elements exposing (Element, a, baseBorderRadius, boxShadowTransition, card, cardList, cardName, centeredContent, currentLink, homeCard, indexCard, invert, inverted, main_, makeShadow, onPhone, p, pageCard, partyLabel, row, stat, statCount, stateLabel, title, truncate, ul)

import Css exposing (..)
import Css.Media as Media exposing (only, screen, withMedia)
import Html.Styled as Html exposing (..)
import Theme exposing (theme)


type alias Element msg =
    List (Attribute msg) -> List (Html msg) -> Html msg



-- HELPERS


boxShadowTransition : Style
boxShadowTransition =
    property "transition" "box-shadow 0.2s ease-out"


makeShadow : Float -> Style
makeShadow height =
    boxShadow4
        zero
        (px <| 1 * height)
        (px <| 4 * height)
        (rgba 0 0 0 0.2)


baseBorderRadius : Style
baseBorderRadius =
    borderRadius <| px 3


centeredContent : Style
centeredContent =
    batch
        [ maxWidth <| px 800
        , margin2 zero auto
        , padding2 zero <| px 16
        ]


truncate : Style
truncate =
    batch
        [ whiteSpace noWrap
        , overflow hidden
        , textOverflow ellipsis
        , maxWidth <| pct 100
        ]


invert : Style
invert =
    batch
        [ color theme.secondary
        , backgroundColor theme.dark
        ]


onPhone : List Style -> Style
onPhone =
    withMedia [ only screen [ Media.maxWidth <| px 600 ] ]



-- ELEMENTS


a : Element msg
a =
    styled Html.a
        [ color theme.dark
        , fontWeight bold
        , opacity <| num 1.0
        , property "transition" "opacity 0.2s ease-out"
        , textDecoration none
        , hover [ opacity <| num 0.5 ]
        ]


currentLink : Element msg
currentLink =
    styled Html.span
        [ fontWeight bold
        , opacity <| num 0.5
        ]


ul : Element msg
ul =
    styled Html.ul
        [ listStyle none
        , margin zero
        , padding zero
        ]


stat : Element msg
stat =
    styled Html.div
        [ margin <| px 32
        , textAlign center
        ]


statCount : Element msg
statCount =
    styled Html.div
        [ color theme.dark
        , fontSize <| Css.em 5
        ]


row : Element msg
row =
    styled Html.div
        [ displayFlex
        , marginBottom <| px 60
        , onPhone [ flexDirection column ]
        ]


inverted : Element msg
inverted =
    styled Html.span [ invert, padding2 zero <| px 8 ]


homeCard : Element msg
homeCard =
    styled pageCard
        [ alignItems center
        , displayFlex
        , flexDirection column
        , textAlign center
        ]


pageCard : Element msg
pageCard =
    styled card [ padding <| px 16 ]


indexCard : Element msg
indexCard =
    styled Html.div
        [ alignItems center
        , boxShadowTransition
        , displayFlex
        , flexDirection column
        , hover [ makeShadow 2 ]
        , makeShadow 0
        , padding <| px 8
        ]


cardList : Element msg
cardList =
    styled ul
        [ property "display" "grid"
        , property "grid-gap" "24px"
        , property "grid-template-columns"
            "repeat(auto-fit, minmax(150px, min-content))"
        , justifyContent center
        ]


p : Element msg
p =
    styled Html.p
        [ lineHeight <| Css.em 1.25
        , marginBottom <| px 60
        , maxWidth <| px 600
        , textAlign center
        ]


title : Element msg
title =
    styled Html.h2
        [ fontSize <| Css.em 2
        , marginBottom <| px 60
        ]


card : Element msg
card =
    styled Html.div
        [ backgroundColor theme.secondary
        , baseBorderRadius
        , makeShadow 1
        , marginBottom <| px 24
        ]


main_ : Element msg
main_ =
    styled Html.main_
        [ centeredContent
        , marginTop <| px 44
        ]


partyLabel : Element msg
partyLabel =
    styled Html.small
        [ opacity <| num 0.9
        , fontSize <| Css.em 0.7
        ]


cardName : Element msg
cardName =
    styled Html.div
        [ marginBottom <| px 8
        , textAlign center
        ]


stateLabel : Element msg
stateLabel =
    styled Html.small
        [ opacity <| num 0.4
        , truncate
        ]
