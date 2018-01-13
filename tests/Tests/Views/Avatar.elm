module Tests.Views.Avatar exposing (..)

import Test exposing (..)
import Test.Html.Query as Query
import Test.Html.Selector exposing (tag, text)
import Types.Party exposing (Party(..))
import Util.Tests exposing (toQuery)
import Views.Avatar as Avatar


item :
    { name : String
    , photoUrl : Maybe String
    , party : Party
    }
item =
    { name = "Text"
    , photoUrl = Just "/images/2.jpg"
    , party = Democrat
    }


suite : Test
suite =
    describe "Avatar"
        [ test "Should render an Avatar with photo" <|
            \_ ->
                Avatar.view [] Avatar.Sm item
                    |> toQuery
                    |> Query.hasNot [ tag "T" ]
        , test "Should render with text if photoUrl is Nothing" <|
            \_ ->
                Avatar.view [] Avatar.Sm { item | photoUrl = Nothing }
                    |> toQuery
                    |> Query.has [ text "T" ]
        ]
