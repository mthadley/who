module Pages.LegislatorIndex exposing (Model, init, view)

import Char
import Css
import Elements
import Elements.LegislatorIndex as Elements
import Html.Styled as Html exposing (..)
import Html.Styled.Attributes as Attr
import RemoteData exposing (WebData)
import Router exposing (Route(..), linkTo)
import Set exposing (Set)
import Store exposing (Store)
import Types.Index as Index
import Types.State as State
import Util.String exposing (firstChar)
import Views.Avatar as Avatar
import Views.Link as Link exposing (view)


-- MODEL


type alias Model =
    { activeLetter : Char
    }


init : Maybe Char -> Model
init =
    Maybe.map Char.toLower
        >> Maybe.withDefault 'a'
        >> Model


buildNames : List Index.Item -> Set Char
buildNames =
    let
        helper =
            .lastName
                >> firstChar
                >> Maybe.withDefault 'z'
                >> Char.toLower
                >> Set.insert
    in
    List.foldl helper Set.empty



-- VIEW


view : Store -> Model -> Html msg
view store model =
    Elements.pageCard []
        [ Elements.row []
            [ viewLetters store model
            , div [ Attr.css [ Css.flexGrow <| Css.num 1 ] ]
                [ viewCards store.index model.activeLetter
                ]
            ]
        ]


viewCards : WebData (List Index.Item) -> Char -> Html msg
viewCards index activeLetter =
    index
        |> RemoteData.withDefault []
        |> List.filter (byName activeLetter)
        |> List.map (li [] << List.singleton << viewCard)
        |> Elements.cardList []


viewCard : Index.Item -> Html msg
viewCard item =
    Elements.a [ linkTo <| Router.ViewLegislator item.id ]
        [ Elements.indexCard []
            [ Avatar.view
                [ Attr.css [ Css.marginBottom <| Css.px 12 ] ]
                Avatar.Md
                item
            , Elements.cardName [] [ text item.name ]
            , Elements.stateLabel [] [ text <| State.toString item.state ]
            ]
        ]


byName : Char -> Index.Item -> Bool
byName char =
    .lastName
        >> String.toLower
        >> String.startsWith (String.fromChar char)


viewLetters : Store -> Model -> Html msg
viewLetters store model =
    let
        names =
            store.index
                |> RemoteData.withDefault []
                |> buildNames

        route =
            case store.route of
                LegislatorIndex Nothing ->
                    LegislatorIndex <| Just 'a'

                other ->
                    other

        viewHelper char =
            viewLetter
                route
                (Set.member char names)
                char
    in
    letters
        |> List.map viewHelper
        |> Elements.letterList []


viewLetter : Route -> Bool -> Char -> Html msg
viewLetter currentRoute hasItems char =
    let
        content =
            text <| String.fromChar <| Char.toUpper char
    in
    Elements.letter []
        [ if hasItems then
            Link.view
                [ Attr.css [ Css.padding <| Css.px 16 ] ]
                currentRoute
                (LegislatorIndex <| Just char)
                content
          else
            Elements.currentLink [] [ content ]
        ]


letters : List Char
letters =
    [ 'a'
    , 'b'
    , 'c'
    , 'd'
    , 'e'
    , 'f'
    , 'g'
    , 'h'
    , 'i'
    , 'j'
    , 'k'
    , 'l'
    , 'm'
    , 'n'
    , 'o'
    , 'p'
    , 'q'
    , 'r'
    , 's'
    , 't'
    , 'u'
    , 'v'
    , 'w'
    , 'x'
    , 'y'
    , 'z'
    ]
