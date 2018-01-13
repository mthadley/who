module Pages.NotFound exposing (view)

import Elements
import Html.Styled exposing (..)


view : Html msg
view =
    Elements.pageCard []
        [ h1 [] [ text "Sorry, I'm not sure what you were looking for..." ]
        ]
