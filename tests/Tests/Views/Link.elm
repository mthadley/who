module Tests.Views.Link exposing (..)

import Html.Styled exposing (text)
import Router exposing (Route(..))
import Test exposing (..)
import Test.Html.Query as Query
import Test.Html.Selector exposing (tag)
import Util.Tests exposing (toQuery)
import Views.Link as Link


suite : Test
suite =
    describe "Link"
        [ test "Should render a link" <|
            \_ ->
                Link.view [] NotFound Home (text "link")
                    |> toQuery
                    |> Query.has [ tag "a" ]
        , test "Should render a span" <|
            \_ ->
                Link.view [] Home Home (text "link")
                    |> toQuery
                    |> Query.has [ tag "span" ]
        , test "Should render a link because routes do not exactly match" <|
            \_ ->
                Link.view []
                    (LegislatorIndex <| Just 'a')
                    (LegislatorIndex <| Just 'b')
                    (text "link")
                    |> toQuery
                    |> Query.has [ tag "a" ]
        , test "Should render a span because routes loosely match" <|
            \_ ->
                Link.viewLoose []
                    (LegislatorIndex <| Just 'a')
                    (LegislatorIndex <| Just 'b')
                    (text "link")
                    |> toQuery
                    |> Query.has [ tag "span" ]
        ]
