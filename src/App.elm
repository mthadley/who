module App exposing (Model, Msg(..), init, subscriptions, update, view)

import Browser exposing (Document)
import Browser.Navigation as Navigation exposing (Key)
import Elements
import Html.Styled as Html exposing (..)
import Pages.Home
import Pages.Legislator
import Pages.LegislatorIndex
import Pages.NotFound
import Router exposing (Route)
import Store exposing (Store)
import Styles
import Url exposing (Url)
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


init : () -> Url -> Key -> ( Model, Cmd Msg )
init flags url key =
    let
        route =
            Router.parse url

        ( store, storeCmd ) =
            Store.init key route

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
            ( Home, Cmd.none )

        Router.LegislatorIndex char ->
            ( LegislatorIndex <| Pages.LegislatorIndex.init char, Cmd.none )

        Router.NotFound ->
            ( NotFound, Cmd.none )

        Router.ViewLegislator id ->
            Pages.Legislator.init id
                |> Tuple.mapFirst LegislatorPage



-- VIEW


view : Model -> Document Msg
view model =
    let
        content =
            [ Styles.styles
            , Html.map ToolbarMsg <| Toolbar.view model.store model.toolbarModel
            , Elements.main_ []
                [ viewPage model.store model.page
                ]
            ]
    in
    { title = "W.H.O."
    , body = List.map Html.toUnstyled content
    }


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
    | ClickedLink Browser.UrlRequest
    | StoreMsg Store.Msg
    | ToolbarMsg Toolbar.Msg
    | RouteChange Route


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Noop ->
            ( model, Cmd.none )

        ClickedLink request ->
            case request of
                Browser.Internal url ->
                    ( model
                    , Navigation.pushUrl model.store.key (Url.toString url)
                    )

                Browser.External href ->
                    ( model, Navigation.load href )

        ToolbarMsg toolbarMsg ->
            let
                ( toolbarModel, cmd ) =
                    Toolbar.update toolbarMsg model.store model.toolbarModel
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

        StoreMsg storeMsg ->
            let
                ( store, cmd ) =
                    Store.update storeMsg model.store
            in
            ( { model | store = store }, Cmd.map StoreMsg cmd )



-- SUBS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.map ToolbarMsg <| Toolbar.subscriptions model.toolbarModel
