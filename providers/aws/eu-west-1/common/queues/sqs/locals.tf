locals {
  sqs_env = [
    "Production",
  ]
  queue_names = [
    "DeletePushToken",
    "SavePushToken",
    "SendUserNotification",
    "SendPushNotification",
    "SyncTransactions",
    "UserTokenConnected",
    "SaveCpr",
    "SaveNotificationsUserInfo", 
  ]
}
