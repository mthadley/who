module Elements.Toolbar exposing
    ( arrowSize
    , brand
    , name
    , noResults
    , resultsList
    , searchContainer
    , searchInput
    , searchItem
    , searchLink
    , searchResults
    , toolbar
    , toolbarAccentHeight
    , toolbarContent
    , toolbarLinkItem
    , toolbarLinks
    )

import Css exposing (..)
import Elements
    exposing
        ( Element
        , baseBorderRadius
        , boxShadowTransition
        , card
        , centeredContent
        , invert
        , makeShadow
        , onPhone
        , truncate
        , ul
        )
import Html.Styled as Html exposing (styled)
import Theme exposing (theme)
import Util.Css exposing (contentEmpty)


arrowSize : Px
arrowSize =
    px 16


toolbarAccentHeight : Px
toolbarAccentHeight =
    px 4


brand : Element msg
brand =
    styled Html.h1
        [ boxShadowTransition
        , hover [ makeShadow 2 ]
        , invert
        , makeShadow 1
        , padding2 zero <| px 12
        ]


noResults : Element msg
noResults =
    styled Html.span
        [ display block
        , padding2 (px 12) <| px 8
        , Elements.truncate
        ]


resultsList : Element msg
resultsList =
    styled ul [ padding2 (px 8) zero ]


searchContainer : Element msg
searchContainer =
    styled Html.div
        [ position relative
        , zIndex <| int 100
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


name : Element msg
name =
    styled Html.div
        [ textOverflow ellipsis
        , whiteSpace noWrap
        , overflow hidden
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


searchResults : Element msg
searchResults =
    styled card
        [ makeShadow 2
        , left <| px -2
        , position absolute
        , top <| px 52
        , right <| px 0
        , padding2 (px 6) zero
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
            , bottom <| px -4
            ]
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


toolbarLinks : Element msg
toolbarLinks =
    styled ul
        [ displayFlex
        , alignItems center
        ]


toolbarLinkItem : Element msg
toolbarLinkItem =
    styled Html.li [ marginRight <| px 20 ]
