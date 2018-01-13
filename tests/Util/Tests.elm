module Util.Tests exposing (toQuery)

import Html.Styled as Styled
import Test.Html.Query as Query


toQuery : Styled.Html msg -> Query.Single msg
toQuery =
    Query.fromHtml << Styled.toUnstyled
