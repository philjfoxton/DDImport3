data "aws_caller_identity" "current" {
}

data "aws_kms_secrets" "gitlab_token" {
  secret {
    name    = "gitlab"
    payload = "AQICAHgI6guE+J26KRDmKmotyhUiKRFnRLoVcUOdybzZqrgFbwEy1lM2Xx3i8FOYcAPWc3UoAAAAcjBwBgkqhkiG9w0BBwagYzBhAgEAMFwGCSqGSIb3DQEHATAeBglghkgBZQMEAS4wEQQMB8xG5TyIOwfYjtrWAgEQgC83qS/+Fb2uPH+QyczYM/s73WAzoQNDD0bplLRdYF2RYQt3OKqsDDS+4jF31g54MQ=="
  }
}