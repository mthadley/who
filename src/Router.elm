module Router exposing
    ( Route(..)
    , linkTo
    , parse
    , parseRoute
    , reverse
    )

import Html.Styled exposing (Attribute)
import Html.Styled.Attributes as Attr
import Url exposing (Url)
import Url.Parser as UrlParser exposing ((</>), (<?>), Parser)
import Url.Parser.Query as QueryParser
import Util.String exposing (firstChar)


type Route
    = Home
    | LegislatorIndex (Maybe Char)
    | ViewLegislator String
    | NotFound


parseRoute : Parser (Route -> a) a
parseRoute =
    UrlParser.oneOf
        [ UrlParser.map Home UrlParser.top
        , UrlParser.map LegislatorIndex <| UrlParser.s "legislators" <?> charParam "name"
        , UrlParser.map ViewLegislator <| UrlParser.s "legislator" </> UrlParser.string
        ]


charParam : String -> QueryParser.Parser (Maybe Char)
charParam name =
    QueryParser.string name
        |> QueryParser.map (Maybe.andThen firstChar)


parse : Url -> Route
parse raw =
    let
        {- We are using hash routing on Github pages, so we need to turn
           the fragment into a valid URL, and then parse that instead.

           https://github.com/rtfeldman/elm-spa-example/blob/master/src/Route.elm#L61
        -}
        url =
            { raw
                | path = Maybe.withDefault "" raw.fragment
                , fragment = Nothing
            }
    in
    url
        |> fixPathQuery
        |> UrlParser.parse parseRoute
        |> Maybe.withDefault NotFound


fixPathQuery : Url -> Url
fixPathQuery url =
    let
        ( newPath, newQuery ) =
            case String.split "?" url.path of
                path :: query :: [] ->
                    ( path, Just query )

                _ ->
                    ( url.path, url.query )
    in
    { url | path = newPath, query = newQuery }


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
