module Util.Css exposing (contentEmpty)

import Css exposing (..)


contentEmpty : Style
contentEmpty =
    property "content" "''"
