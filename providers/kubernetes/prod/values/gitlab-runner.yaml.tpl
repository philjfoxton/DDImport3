gitlabUrl: https://gitlab.com/

rbac:
  create: false
  serviceAccountName: ${serviceAccountName}

runners:
  image: docker:19.03.8
  privileged: false
  tags: "prod-k8s-runner"
  runUntagged: false
  serviceAccountName: ${serviceAccountName}

concurrent: 10
runnerRegistrationToken: "${registration_token}"
