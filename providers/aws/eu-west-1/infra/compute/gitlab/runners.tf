module "gitlab_runner" {
  source     = "npalm/gitlab-runner/aws"
  version    = "4.10.0"
  aws_region = var.aws_region

  environment              = local.environment
  runners_gitlab_url       = "https://gitlab.com/"
  runners_name             = local.runner_name
  subnet_id_runners        = data.terraform_remote_state.vpc.outputs.private_subnets[0]
  subnet_ids_gitlab_runner = data.terraform_remote_state.vpc.outputs.private_subnets
  vpc_id                   = data.terraform_remote_state.vpc.outputs.vpc_id

  enable_runner_ssm_access = true

  gitlab_runner_registration_config = {
    registration_token = data.aws_kms_secrets.gitlab_token.plaintext["gitlab"]
    tag_list           = "pfm_prod,prod_docker_runner,docker_runner"
    description        = "Production PFM Runner"
    locked_to_project  = "false"
    run_untagged       = "true"
    maximum_timeout    = "3600"
  }

  tags = {
    "gitlab-runner:instancelifecycle" = "spot:yes"
  }
  instance_type                 = "t3.small"
  docker_machine_spot_price_bid = "0.05"
  docker_machine_instance_type  = "c5d.large"

  runners_iam_instance_profile_name = aws_iam_instance_profile.gitlab_runner.name

  userdata_pre_install = templatefile("files/runner_userdata.tpl", {
    # change this if ecr uses non default registry
    ecr_account_id = data.aws_caller_identity.current.account_id,
    ecr_region     = var.aws_region
  })
  docker_machine_options = ["amazonec2-userdata=/etc/gitlab-runner/runners-userdata"]

  runners_additional_volumes = [
    "/var/run/docker.sock:/var/run/docker.sock",
  ]
  runners_idle_count          = 0
  runners_idle_time           = 1000
  runners_max_builds          = 5
  runners_off_peak_idle_count = 0
  runners_off_peak_idle_time  = 0

  runners_privileged              = "false"
  enable_gitlab_runner_ssh_access = true
  ssh_key_pair                    = "infra"
  gitlab_runner_ssh_cidr_blocks   = [data.terraform_remote_state.vpc.outputs.vpc_cidr]
  runners_image                   = "docker:19.03.8"
  gitlab_runner_version           = local.gitlab_runner_version
  enable_cloudwatch_logging       = false

  ami_filter = {
    name = ["amzn2-ami-hvm-*-x86_64-ebs"]
  }
  ami_owners = ["amazon"]

  runner_ami_filter = {
    name = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }
  runner_ami_owners = ["099720109477"]

  overrides = {
    name_runner_agent_instance  = local.runner_name
    name_sg                     = ""
    name_docker_machine_runners = ""
  }
}
