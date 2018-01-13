module Router exposing (..)

import Html.Styled exposing (Attribute)
import Html.Styled.Attributes as Attr
import Navigation exposing (Location)
import UrlParser exposing (..)
import Util.String exposing (firstChar)


type Route
    = Home
    | LegislatorIndex (Maybe Char)
    | ViewLegislator String
    | NotFound


parseRoute : Parser (Route -> a) a
parseRoute =
    oneOf
        [ map Home top
        , map LegislatorIndex <| s "legislators" <?> charParam "name"
        , map ViewLegislator <| s "legislator" </> string
        ]


charParam : String -> QueryParser (Maybe Char -> b) b
charParam name =
    customParam name (Maybe.andThen firstChar)


parseLocation : Location -> Route
parseLocation =
    fixLocationQuery
        >> parseHash parseRoute
        >> Maybe.withDefault NotFound


fixLocationQuery : Location -> Location
fixLocationQuery location =
    let
        hash =
            String.split "?" location.hash
                |> List.head
                |> Maybe.withDefault ""

        search =
            String.split "?" location.hash
                |> List.drop 1
                |> String.join "?"
                |> String.append "?"
    in
    { location | hash = hash, search = search }


reverse : Route -> String
reverse route =
    let
        path =
            case route of
                NotFound ->
                    "404"

                Home ->
                    ""

                LegislatorIndex char ->
                    char
                        |> Maybe.map ((++) "?name=" << String.fromChar)
                        |> Maybe.withDefault ""
                        |> (++) "legislators"

                ViewLegislator id ->
                    "legislator/" ++ id
    in
    "#" ++ path


linkTo : Route -> Attribute msg
linkTo =
    Attr.href << reverse
