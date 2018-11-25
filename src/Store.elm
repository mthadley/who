module Store exposing
    ( Msg
    , Store
    , init
    , none
    , requestIndex
    , setRoute
    , update
    )

import Api
import Browser.Navigation exposing (Key)
import RemoteData exposing (RemoteData(..), WebData)
import Router exposing (Route)
import Types.Index as Index


type alias Store =
    { index : WebData (List Index.Item)
    , route : Route
    , key : Key
    }


init : Key -> Route -> ( Store, Cmd Msg )
init key route =
    update requestIndex
        { index = NotAsked
        , route = route
        , key = key
        }


type Msg
    = None
    | RequestIndex
    | RecieveIndex (WebData (List Index.Item))


update : Msg -> Store -> ( Store, Cmd Msg )
update msg model =
    case msg of
        None ->
            ( model, Cmd.none )

        RequestIndex ->
            ( { model | index = Loading }
            , Cmd.map RecieveIndex <| Api.send Api.requestIndex
            )

        RecieveIndex index ->
            ( { model | index = index }, Cmd.none )


none : Msg
none =
    None


requestIndex : Msg
requestIndex =
    RequestIndex


setRoute : Route -> Store -> Store
setRoute route store =
    { store | route = route }
