#!/bin/bash

exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1

apt update && apt install jq -y

# Storage
mkdir -p ${mongodb_data_dir}

export DEVICE_NAME=$(lsblk -ip | tail -n +2 | awk '{print $1 " " ($7? "MOUNTEDPART" : "") }' | sed ':a;N;$!ba;s/\n`/ /g' | grep -v MOUNTEDPART)
if mount -o defaults -t ext4 $DEVICE_NAME ${mongodb_data_dir}; then
    echo 'Successfully mounted existing disk'
else
    echo 'Trying to mount a fresh disk'
    mkfs.ext4 -m 0 -F -E lazy_itable_init=0,lazy_journal_init=0,discard $DEVICE_NAME
    mount -o defaults -t ext4 $DEVICE_NAME ${mongodb_data_dir} && echo 'Successfully mounted a fresh disk'
fi
echo "$DEVICE_NAME ${mongodb_data_dir} ext4 defaults,nofail 0 2" | tee -a /etc/fstab
chown -R mongodb:mongodb ${mongodb_data_dir}