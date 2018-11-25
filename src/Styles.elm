module Styles exposing (styles)

import Css exposing (..)
import Css.Global exposing (..)
import Html.Styled exposing (Html)
import Theme exposing (theme)


styles : Html msg
styles =
    global
        [ everything
            [ boxSizing borderBox
            ]
        , body
            [ backgroundColor theme.background
            , color theme.primary
            , margin zero
            , minHeight <| vh 100
            , systemFonts
            ]
        ]


systemFonts : Style
systemFonts =
    fontFamilies
        [ "-apple-system"
        , "Blink"
        , "MacSystemFont"
        , qt "Segoe UI"
        , "Roboto"
        , "Helvetica"
        , "Arial"
        , "sans-serif"
        , qt "Apple Color Emoji"
        , qt "Segoe UI Emoji"
        , qt "Segoe UI Symbol"
        ]
