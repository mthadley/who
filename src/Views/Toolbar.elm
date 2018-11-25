port module Views.Toolbar exposing (Model, Msg, init, subscriptions, update, view)

import Browser.Dom as Dom
import Browser.Navigation exposing (pushUrl)
import Css
import Elements
import Elements.Toolbar as Elements
import Html.Styled as Html exposing (..)
import Html.Styled.Attributes as Attr
import Html.Styled.Events as Events
import Json.Decode as Decode
import List.Extra exposing (getAt, interweave)
import Regex
import RemoteData exposing (RemoteData(..), WebData)
import Router exposing (Route(..))
import Store exposing (Store)
import Task
import Theme exposing (getPartyColor, theme)
import Types.Index as Index
import Types.Party as Party exposing (Party(..))
import Types.State as State
import Util.Html exposing (empty)
import Views.Avatar as Avatar
import Views.Link as Link



-- MODEL


maxItems : Int
maxItems =
    5


searchInputId : String
searchInputId =
    "searchInput"


type alias Model =
    { searchResults : List Index.Item
    , query : String
    , show : Bool
    , selectedIndex : Int
    }


init : Model
init =
    { searchResults = []
    , query = ""
    , show = False
    , selectedIndex = 0
    }



-- VIEW


view : Store -> Model -> Html Msg
view store ({ query, show } as model) =
    Elements.toolbar []
        [ Elements.toolbarContent []
            [ viewLinks store.route
            , Elements.searchContainer [ Attr.id "searchContainer" ]
                [ Elements.searchInput
                    [ Attr.disabled <| not <| RemoteData.isSuccess store.index
                    , Attr.id searchInputId
                    , Attr.placeholder "Search..."
                    , Attr.value query
                    , Events.custom "keydown" (Decode.map filterKeypress Events.keyCode)
                    , Events.onFocus <| Toggle True
                    , Events.onInput Search
                    ]
                    []
                , if show && String.length query > 0 then
                    viewResults model

                  else
                    empty
                ]
            ]
        ]


links : List ( Route, String )
links =
    [ ( Router.LegislatorIndex Nothing, "Legislators" )
    , ( Router.NotFound, "States" )
    ]


viewLink : Route -> Route -> String -> Html msg
viewLink currentRoute route label =
    Elements.toolbarLinkItem []
        [ Link.viewLoose [] currentRoute route (text label) ]


viewLinks : Route -> Html msg
viewLinks currentRoute =
    Elements.toolbarLinks [] <|
        [ Elements.toolbarLinkItem []
            [ Elements.a [ Router.linkTo Router.Home ]
                [ Elements.brand [] [ text "W.H.O" ] ]
            ]
        ]
            ++ List.map (\( route, name ) -> viewLink currentRoute route name) links


viewResults : Model -> Html Msg
viewResults { searchResults, query, selectedIndex } =
    Elements.searchResults []
        [ if List.length searchResults == 0 then
            Elements.noResults []
                [ text <| "No results for \""
                , b [] [ text query ]
                , text "\"..."
                ]

          else
            Elements.resultsList [] <|
                List.indexedMap
                    (viewItem query selectedIndex)
                    searchResults
        ]


viewItem : String -> Int -> Int -> Index.Item -> Html Msg
viewItem query selectedIndex index item =
    let
        ( activeColor, activeBg ) =
            if selectedIndex == index then
                ( theme.secondary, theme.primary )

            else
                ( theme.primary, theme.secondary )
    in
    Elements.searchItem
        [ Attr.css
            [ Css.color activeColor
            , Css.backgroundColor activeBg
            ]
        ]
        [ Elements.searchLink
            [ Router.linkTo <| Router.ViewLegislator item.id
            , Events.onClick GoToSelection
            , Events.onMouseEnter <| SetSelection index
            ]
            [ Avatar.view
                [ Attr.css [ Css.marginRight <| Css.px 8 ] ]
                Avatar.Sm
                item
            , styled div
                [ Css.overflow Css.hidden ]
                []
                [ highlight item.name query
                , viewPartyLabel item.party
                , Elements.stateLabel []
                    [ text <| " - " ++ State.toString item.state ]
                ]
            ]
        ]


viewPartyLabel : Party -> Html msg
viewPartyLabel party =
    Elements.partyLabel [ Attr.css [ Css.color <| getPartyColor party ] ]
        [ text <| Party.toString party ]


highlight : String -> String -> Html msg
highlight input query =
    if String.length query > 1 then
        case Regex.fromStringWith { caseInsensitive = True, multiline = False } query of
            Just regex ->
                Regex.find regex input
                    |> List.map (b [] << List.singleton << text << .match)
                    |> interweave (List.map text <| Regex.split regex input)
                    |> Elements.name []

            Nothing ->
                text input

    else
        text input



-- UPDATE


type Msg
    = Noop
    | Search String
    | Toggle Bool
    | ChangeSelection Dir
    | SetSelection Int
    | GoToSelection


type Dir
    = Up
    | Down


update : Msg -> Store -> Model -> ( Model, Cmd Msg )
update msg store model =
    case msg of
        Noop ->
            ( model, Cmd.none )

        SetSelection index ->
            ( { model | selectedIndex = index }, Cmd.none )

        ChangeSelection dir ->
            let
                change =
                    case dir of
                        Up ->
                            1

                        Down ->
                            -1

                selectedIndex =
                    modBy
                        (max 1 <| List.length model.searchResults)
                        (model.selectedIndex + change)
            in
            ( { model | selectedIndex = selectedIndex }, Cmd.none )

        GoToSelection ->
            let
                ( name, cmd ) =
                    case getAt model.selectedIndex model.searchResults of
                        Just item ->
                            ( item.name
                            , pushUrl store.key <| Router.reverse <| ViewLegislator <| item.id
                            )

                        Nothing ->
                            ( model.query, Cmd.none )
            in
            ( { model | show = False, query = name }
            , Cmd.batch
                [ cmd
                , Task.attempt (always Noop) <| Dom.blur searchInputId
                ]
            )

        Search query ->
            let
                searchResults =
                    RemoteData.withDefault [] store.index
                        |> filterResults query
                        |> List.take maxItems
            in
            ( { model
                | query = query
                , searchResults = searchResults
                , selectedIndex = 0
                , show = True
              }
            , Cmd.none
            )

        Toggle show ->
            ( { model | show = show }, Cmd.none )


filterResults : String -> List Index.Item -> List Index.Item
filterResults query =
    List.filter
        (.name
            >> String.toLower
            >> String.contains (String.toLower query)
        )
        >> List.sortWith (startsWith query)


startsWith : String -> Index.Item -> Index.Item -> Order
startsWith query first second =
    case
        ( String.startsWith query first.name
        , String.startsWith query second.name
        )
    of
        ( True, False ) ->
            LT

        ( False, True ) ->
            GT

        ( a, b ) ->
            compare first.name second.name


filterKeypress : Int -> { message : Msg, preventDefault : Bool, stopPropagation : Bool }
filterKeypress code =
    let
        preventDefaultWith msg =
            { message = msg
            , preventDefault = True
            , stopPropagation = True
            }
    in
    case code of
        13 ->
            preventDefaultWith GoToSelection

        38 ->
            preventDefaultWith (ChangeSelection Down)

        40 ->
            preventDefaultWith (ChangeSelection Up)

        _ ->
            { message = Noop
            , preventDefault = False
            , stopPropagation = False
            }


port searchOutsideClicks : (() -> msg) -> Sub msg


subscriptions : Model -> Sub Msg
subscriptions model =
    if model.show then
        searchOutsideClicks <| always <| Toggle False

    else
        Sub.none
