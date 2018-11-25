module Api exposing (requestIndex, send)

import Http exposing (Request)
import Json.Decode exposing (list)
import RemoteData exposing (WebData)
import Types.Index as Index



-- [[[cog
-- import cog
-- cog.outl("baseUrl : String")
-- cog.outl(f"baseUrl = \"{url_base}/data/\"")
-- ]]]


baseUrl : String
baseUrl =
    "/data/"



-- [[[end]]]


getUrl : String -> String
getUrl =
    (++) baseUrl


requestIndex : Request (List Index.Item)
requestIndex =
    Http.get (getUrl "index.json") <| list Index.decodeItem


send : Request a -> Cmd (WebData a)
send =
    RemoteData.sendRequest
