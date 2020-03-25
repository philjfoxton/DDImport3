data "aws_kms_secrets" "mongo_credentials" {
  secret {
    name = "username"
    payload = "AQICAHgI6guE+J26KRDmKmotyhUiKRFnRLoVcUOdybzZqrgFbwFXEYPDv9ywIiAkuReVLS9KAAAAaDBmBgkqhkiG9w0BBwagWTBXAgEAMFIGCSqGSIb3DQEHATAeBglghkgBZQMEAS4wEQQMXqOixEUcNpbtAOWWAgEQgCVO+TPV+x/5T22NmuTJ5iBhxvGwF27wQbGbIsEnZTnSVrcDltt0"
  }
  secret {
    name = "password"
    payload = "AQICAHgI6guE+J26KRDmKmotyhUiKRFnRLoVcUOdybzZqrgFbwFIIpfZJeqGS9oBwNyVgAdNAAAAfjB8BgkqhkiG9w0BBwagbzBtAgEAMGgGCSqGSIb3DQEHATAeBglghkgBZQMEAS4wEQQMMYDnNNh5j2znWf7mAgEQgDvahErsVZgkPQYONqWFZeJEgasXEa/WOF2q8I8QYv7wu2FhlIZOrQ21KlTSvi44MOEdclU52ybr5gGS3Q=="
  }
}