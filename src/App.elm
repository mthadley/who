module App exposing (Model, Msg(RouteChange), init, subscriptions, update, view)

import Elements
import Html.Styled as Html exposing (..)
import Pages.Home
import Pages.Legislator
import Pages.LegislatorIndex
import Pages.NotFound
import Router exposing (Route)
import Store exposing (Store)
import Styles
import Views.Toolbar as Toolbar


-- MODEL


type Page
    = Home
    | LegislatorPage Pages.Legislator.Model
    | LegislatorIndex Pages.LegislatorIndex.Model
    | NotFound


type alias Model =
    { toolbarModel : Toolbar.Model
    , page : Page
    , store : Store
    }


init : Route -> ( Model, Cmd Msg )
init route =
    let
        ( store, storeCmd ) =
            Store.init route

        ( page, pageCmd ) =
            initPage route
    in
    ( { toolbarModel = Toolbar.init
      , page = page
      , store = store
      }
    , Cmd.batch
        [ Cmd.map StoreMsg storeCmd
        , pageCmd
        ]
    )


initPage : Route -> ( Page, Cmd Msg )
initPage route =
    case route of
        Router.Home ->
            Home ! []

        Router.LegislatorIndex char ->
            (LegislatorIndex <| Pages.LegislatorIndex.init char) ! []

        Router.NotFound ->
            NotFound ! []

        Router.ViewLegislator id ->
            Pages.Legislator.init id
                |> Tuple.mapFirst LegislatorPage



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ Styles.styles
        , Html.map ToolbarMsg <| Toolbar.view model.store model.toolbarModel
        , Elements.main_ []
            [ viewPage model.store model.page
            ]
        ]


viewPage : Store -> Page -> Html msg
viewPage store route =
    case route of
        Home ->
            Pages.Home.view store

        NotFound ->
            Pages.NotFound.view

        LegislatorIndex model ->
            Pages.LegislatorIndex.view store model

        LegislatorPage model ->
            Pages.Legislator.view model



-- UPDATE


type Msg
    = Noop
    | StoreMsg Store.Msg
    | ToolbarMsg Toolbar.Msg
    | RouteChange Route


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Noop ->
            model ! []

        ToolbarMsg msg ->
            let
                ( toolbarModel, cmd ) =
                    Toolbar.update msg model.store model.toolbarModel
            in
            ( { model | toolbarModel = toolbarModel }
            , Cmd.map ToolbarMsg cmd
            )

        RouteChange route ->
            let
                ( page, cmd ) =
                    initPage route
            in
            ( { model
                | page = page
                , store = Store.setRoute route model.store
              }
            , cmd
            )

        StoreMsg msg ->
            let
                ( store, cmd ) =
                    Store.update msg model.store
            in
            ( { model | store = store }, Cmd.map StoreMsg cmd )



-- SUBS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.map ToolbarMsg <| Toolbar.subscriptions model.toolbarModel
