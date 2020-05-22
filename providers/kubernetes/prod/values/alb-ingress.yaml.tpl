clusterName: ${name}
autoDiscoverAwsRegion: true
autoDiscoverAwsVpcID: true
rbac:
  serviceAccount:
    annotations:
      iam.amazonaws.com/role: ${role}
