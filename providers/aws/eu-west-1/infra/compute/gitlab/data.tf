data "aws_caller_identity" "current" {
}

data "aws_kms_secrets" "gitlab_token" {
  secret {
    name    = "gitlab"
    payload = "AQICAHgI6guE+J26KRDmKmotyhUiKRFnRLoVcUOdybzZqrgFbwFFaVVDPNsgSszBBxgdPcT6AAAAcjBwBgkqhkiG9w0BBwagYzBhAgEAMFwGCSqGSIb3DQEHATAeBglghkgBZQMEAS4wEQQMZdN7CWnljgqGXfq7AgEQgC/s/wJWcFXS8vIpoBNpilHqHX49oq8dFheRwT8iBFgocP4t0rsygT5Fx4e1Vdq0nw=="
  }
}