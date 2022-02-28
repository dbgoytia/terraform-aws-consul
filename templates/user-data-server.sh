#!/bin/bash


set -e

# Send the output from this script to user-data.log, syslog, and the console so we can troubleshoot
exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1

# Send vars throug Terraform
/opt/consul/bin/run-consul --server --cluster-tag-key "${cluster_tag_key}" --cluster-tag-value "${cluster_tag_value}"