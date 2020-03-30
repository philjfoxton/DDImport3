locals {
  sqs_env = [
    "NbbProduction",
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
