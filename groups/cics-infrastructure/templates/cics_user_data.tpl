#!/bin/bash
# Redirect the user-data output to the console logs
exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1

/sbin/semanage permissive -a automount_t
#Run Ansible playbook for server setup using provided inputs
/usr/local/bin/ansible-playbook /root/deployment.yml -e '${ANSIBLE_INPUTS}'

su -l ec2-user bootstrap
