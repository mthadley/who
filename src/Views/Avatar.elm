module Views.Avatar exposing (Size(..), view)

import Css
import Elements
import Html.Styled exposing (..)
import Html.Styled.Attributes as Attr
import Theme exposing (getPartyColor)
import Types.Party exposing (Party)
import Util.Html exposing (empty)
import Util.Maybe exposing (isNone)


type Size
    = Sm
    | Md
    | Lg


view :
    List (Attribute msg)
    -> Size
    ->
        { a
            | photoUrl : Maybe String
            , name : String
            , party : Party
        }
    -> Html msg
view attrs size { photoUrl, party, name } =
    let
        partyColor =
            getPartyColor party
    in
    Elements.avatar
        ([ Attr.css
            [ photoUrl
                |> Maybe.map (Css.backgroundImage << Css.url)
                |> Maybe.withDefault (Css.batch [])
            , Css.borderColor partyColor
            , Css.color partyColor
            , sizeStyles size
            ]
         ]
            ++ attrs
        )
        [ if isNone photoUrl then
            text <| String.left 1 name
          else
            empty
        ]


sizeStyles : Size -> Css.Style
sizeStyles size =
    let
        mult =
            case size of
                Sm ->
                    1

                Md ->
                    2

                Lg ->
                    3

        dimen =
            Css.px <| 34 * mult
    in
    Css.batch
        [ Css.height dimen
        , Css.width dimen
        , Css.borderWidth <| Css.px <| 2 * mult
        ]
