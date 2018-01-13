module Util.Maybe exposing (isNone)


isNone : Maybe a -> Bool
isNone maybe =
    case maybe of
        Just a ->
            False

        Nothing ->
            True
