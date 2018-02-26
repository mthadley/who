port module Views.Toolbar exposing (Model, Msg, init, subscriptions, update, view)

import Css
import Dom
import Elements
import Elements.Toolbar as Elements
import Html.Styled as Html exposing (..)
import Html.Styled.Attributes as Attr
import Html.Styled.Events as Events
import Json.Decode as Decode
import List.Extra exposing (getAt, interweave)
import Navigation exposing (newUrl)
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
                    , Events.on "keydown" (Decode.map filterKeypress Events.keyCode)
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
            ++ List.map (uncurry <| viewLink currentRoute) links


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
            , div []
                [ highlight item.name query
                , br [] []
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
        let
            regex =
                Regex.caseInsensitive <| Regex.regex query
        in
        Regex.find Regex.All regex input
            |> List.map (b [] << List.singleton << text << .match)
            |> interweave (List.map text <| Regex.split Regex.All regex input)
            |> span []
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
            model ! []

        SetSelection index ->
            { model | selectedIndex = index } ! []

        ChangeSelection dir ->
            let
                change =
                    case dir of
                        Up ->
                            1

                        Down ->
                            -1

                selectedIndex =
                    (model.selectedIndex + change)
                        % (max 1 <| List.length model.searchResults)
            in
            { model | selectedIndex = selectedIndex } ! []

        GoToSelection ->
            let
                ( name, cmd ) =
                    case getAt model.selectedIndex model.searchResults of
                        Just item ->
                            ( item.name
                            , newUrl <| Router.reverse <| ViewLegislator <| item.id
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
            { model
                | query = query
                , searchResults = searchResults
                , selectedIndex = 0
                , show = True
            }
                ! []

        Toggle show ->
            { model | show = show } ! []


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


filterKeypress : Int -> Msg
filterKeypress code =
    case code of
        13 ->
            GoToSelection

        38 ->
            ChangeSelection Down

        40 ->
            ChangeSelection Up

        _ ->
            Noop


port searchOutsideClicks : (() -> msg) -> Sub msg


subscriptions : Model -> Sub Msg
subscriptions model =
    if model.show then
        searchOutsideClicks <| always <| Toggle False
    else
        Sub.none
