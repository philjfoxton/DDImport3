locals {

  project_name = "pfm"
  env = [
    "production",
  ]

  new_buckets = [
    "categories-icons",
    "users-avatars",
    "goals-images",
  ]

  formated_buckets = flatten(
    [
      for e in local.env :
      [
        for n in local.new_buckets : format
        (
          "%s-%s-%s-%s-%s",
          data.aws_caller_identity.current.account_id,
          local.project_name,
          e,
          n,
          var.aws_region
        )
      ]
    ]
  )
}
