module Elements exposing (..)

import Css exposing (..)
import Css.Media as Media exposing (only, screen, withMedia)
import Html.Styled as Html exposing (..)
import Theme exposing (theme)
import Util.Css exposing (contentEmpty)


type alias Element msg =
    List (Attribute msg) -> List (Html msg) -> Html msg



-- HELPERS


arrowSize : Px
arrowSize =
    px 16


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


toolbarAccentHeight : Px
toolbarAccentHeight =
    px 4


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
        , margin <| px 16
        , padding <| px 8
        , width <| px 190
        ]


cardList : Element msg
cardList =
    styled ul
        [ displayFlex
        , flexWrap wrap
        , onPhone
            [ alignItems center
            , flexDirection column
            ]
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


brand : Element msg
brand =
    styled Html.h1
        [ boxShadowTransition
        , hover [ makeShadow 2 ]
        , invert
        , makeShadow 1
        , padding2 zero <| px 12
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


toolbarContent : Element msg
toolbarContent =
    styled Html.div
        [ alignItems center
        , centeredContent
        , displayFlex
        , height <| px 80
        , justifyContent spaceBetween
        , onPhone
            [ flexDirection column
            , marginBottom <| px 12
            ]
        ]


toolbar : Element msg
toolbar =
    styled Html.nav
        [ backgroundColor theme.accent
        , borderBottom3 toolbarAccentHeight solid theme.demo
        , left zero
        , position relative
        , right zero
        , top zero
        , after
            [ contentEmpty
            , backgroundImage <|
                linearGradient2
                    toRight
                    (stop2 theme.repub <| pct 0)
                    (stop2 theme.repub <| pct 50)
                    [ stop2 theme.indie <| pct 50 ]
            , position absolute
            , height toolbarAccentHeight
            , left zero
            , width <| pct 66
            , bottom <| toolbarAccentHeight |*| px -1
            ]
        ]


searchContainer : Element msg
searchContainer =
    styled Html.div
        [ position relative
        , zIndex <| int 100
        ]


resultsList : Element msg
resultsList =
    styled ul [ padding2 (px 8) zero ]


noResults : Element msg
noResults =
    styled Html.span
        [ display block
        , padding2 (px 12) <| px 8
        , truncate
        ]


toolbarLinks : Element msg
toolbarLinks =
    styled ul
        [ displayFlex
        , alignItems center
        ]


toolbarLinkItem : Element msg
toolbarLinkItem =
    styled Html.li [ marginRight <| px 20 ]


searchResults : Element msg
searchResults =
    styled card
        [ makeShadow 2
        , left <| px -2
        , position absolute
        , top <| px 52
        , right <| px 0
        , after
            [ contentEmpty
            , top <| px -28
            , position absolute
            , left <| px 8
            , borderTop3 arrowSize solid transparent
            , borderLeft3 arrowSize solid transparent
            , borderRight3 arrowSize solid transparent
            , borderBottom3 arrowSize solid <| theme.secondary
            ]
        ]


searchLink : Element msg
searchLink =
    styled Html.a
        [ displayFlex
        , alignItems center
        , color inherit
        , width <| pct 100
        , textDecoration none
        ]


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


searchItem : Element msg
searchItem =
    styled Html.li
        [ borderBottom3 (px 1) solid theme.light
        , padding <| px 8
        , lastChild
            [ borderWidth zero
            , marginBottom zero
            ]
        ]


searchInput : Element msg
searchInput =
    styled Html.input
        [ baseBorderRadius
        , borderWidth zero
        , boxShadowTransition
        , fontSize <| px 16
        , height <| px 30
        , makeShadow 1
        , minWidth <| px 240
        , outline none
        , padding2 zero <| px 16
        , focus [ makeShadow 3 ]
        , disabled [ opacity <| num 0.5 ]
        ]


letterList : Element msg
letterList =
    styled ul
        [ displayFlex
        , flexDirection column
        , alignItems center
        , flexWrap wrap
        , onPhone [ flexDirection Css.row ]
        ]


letter : Element msg
letter =
    styled Html.li [ margin <| px 8 ]


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
