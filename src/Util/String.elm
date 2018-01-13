module Util.String exposing (firstChar)


firstChar : String -> Maybe Char
firstChar =
    Maybe.map Tuple.first << String.uncons
