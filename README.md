# Terraform AWS Consul (single datacenter)

This is an implementation based on the OSS terraform module deploying a single Datacenter on AWS EC2. This is mostly a demo and learning purposes so far, but feel free to use it to test your skills on AWS and overall learning of AutoScaling Groups and Service Meshes.

# Features
## Modules 
* consul-cluster: Creates and manages a Consul Cluster within an EC2 ASG group.
* consul-iam-policies: Creates and manages the appropiate permissions required for the Auto Scaling Group instances to discover each other, and be able to join the cluster.

## Templates
* user-data-server.sh: Is a bash script that deploys Consul and uses the auto-discover feature to discover the other members of the cluster.

# Disclaimer
Please refer to: https://github.com/hashicorp/terraform-aws-consul for the full implementation built by HashiCorp. If you're seeing this HashiCorp, you're awesome.