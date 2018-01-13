module Views.Link exposing (view, viewLoose)

import Elements
import Html.Styled exposing (..)
import Html.Styled.Attributes as Attr
import Router exposing (Route(..))


view : List (Attribute msg) -> Route -> Route -> Html msg -> Html msg
view =
    viewWithMatch True


viewLoose : List (Attribute msg) -> Route -> Route -> Html msg -> Html msg
viewLoose =
    viewWithMatch False


viewWithMatch : Bool -> List (Attribute msg) -> Route -> Route -> Html msg -> Html msg
viewWithMatch strict attrs currentRoute route content =
    let
        element =
            if matches strict currentRoute route then
                Elements.currentLink attrs
            else
                route
                    |> Router.reverse
                    |> Attr.href
                    |> List.singleton
                    |> (++) attrs
                    |> Elements.a
    in
    element [ content ]


matches : Bool -> Route -> Route -> Bool
matches strict a b =
    if strict then
        a == b
    else
        looseMatch a b


looseMatch : Route -> Route -> Bool
looseMatch first second =
    case ( first, second ) of
        ( LegislatorIndex _, LegislatorIndex _ ) ->
            True

        ( ViewLegislator a, ViewLegislator b ) ->
            a == b

        ( a, b ) ->
            a == b
