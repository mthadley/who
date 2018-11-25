module Main exposing (main)

import App exposing (Model, Msg, init, subscriptions, update, view)
import Browser
import Router


main : Program () Model Msg
main =
    Browser.application
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        , onUrlChange = App.RouteChange << Router.parse
        , onUrlRequest = App.ClickedLink
        }
