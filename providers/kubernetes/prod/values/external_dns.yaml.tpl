aws:
  region: "eu-west-1"
policy: sync
txtOwnerId: pfm-prod-cluster
txtPrefix: pfm-prod-cluster-
replicas: 2
rbac:
  create: true
  pspEnabled: true
  serviceAccountAnnotations:
    eks.amazonaws.com/role-arn: ${role}
resources:
  requests:
    memory: 64Mi
    cpu: 50m
  limits:
    memory: 64Mi