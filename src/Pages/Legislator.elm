module Pages.Legislator exposing (Model, init, view)

import Elements
import Html.Styled exposing (..)


type alias Model =
    { id : String
    }


init : String -> ( Model, Cmd msg )
init id =
    ( Model id, Cmd.none )


view : Model -> Html msg
view model =
    Elements.pageCard []
        [ h1 [] [ text model.id ]
        ]
