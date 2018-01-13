module Api exposing (requestIndex, send)

import Http exposing (Request)
import Json.Decode exposing (list)
import RemoteData exposing (WebData)
import Types.Index as Index


baseUrl : String
baseUrl =
    "/data/"


getUrl : String -> String
getUrl =
    (++) baseUrl


requestIndex : Request (List Index.Item)
requestIndex =
    Http.get (getUrl "index.json") <| list Index.decodeItem


send : Request a -> Cmd (WebData a)
send =
    RemoteData.sendRequest
