module Main exposing (main)

import App exposing (Model, Msg, init, subscriptions, update, view)
import Browser
import Browser.Hash as Hash
import Router


main : Program () Model Msg
main =
    Hash.application
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        , onUrlChange = App.RouteChange << Router.parse
        , onUrlRequest = App.ClickedLink
        }
