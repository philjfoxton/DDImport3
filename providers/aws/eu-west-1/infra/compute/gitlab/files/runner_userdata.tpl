#!/bin/bash

cat > /etc/gitlab-runner/runners-userdata << 'EOF'
#!/bin/bash

CRED_HELPER_VERSION="0.3.1"
# This script determines the instance type and mounts NVME volume for Docker daemon and Gitlab builds path if instance is x5d.size
instance_type=$(curl http://169.254.169.254/latest/meta-data/instance-type)

if [[ $instance_type =~ .*d\..* ]];
then
mount_point="/nvme"
echo $${instance_type}
/bin/mkdir -p /builds  /var/lib/docker

/sbin/mkfs.ext4 /dev/nvme1n1
/bin/mkdir $${mount_point}
/bin/mount /dev/nvme1n1 $${mount_point}

/bin/mkdir -p $${mount_point}/builds $${mount_point}/docker
/bin/mount --bind $${mount_point}/docker /var/lib/docker
/bin/mount --bind $${mount_point}/builds /builds
fi

curl -LO https://amazon-ecr-credential-helper-releases.s3.eu-west-1.amazonaws.com/$CRED_HELPER_VERSION/linux-amd64/docker-credential-ecr-login
chmod +x docker-credential-ecr-login && mv docker-credential-ecr-login /bin/docker-credential-ecr-login
mkdir -p /root/.docker
echo "{\"credHelpers\": {\"${ecr_account_id}.dkr.ecr.${ecr_region}.amazonaws.com\": \"ecr-login\"}}" >> /root/.docker/config.json

EOF
