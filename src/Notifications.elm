port module Notifications exposing (..)


type alias Notification =
    { message : String
    , notificationType : String
    }


type NotificationType
    = Success


notify : String -> NotificationType -> Cmd msg
notify message notificationType =
    let
        stringType =
            case notificationType of
                Success ->
                    "success"
    in
        sendNotification { message = message, notificationType = stringType }


port sendNotification : Notification -> Cmd msg
