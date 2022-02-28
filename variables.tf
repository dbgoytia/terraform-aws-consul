variable "cluster_name" {
  description = "The name of the consul cluster"
  type        = string
}

variable "cluster_tag_key" {
  description = "The tag EC2 instances will look to auto-discover each other and form cluster"
  type        = string
  default     = "consul-servers"
}

variable "cluster_tag_value" {
  description = "The tag EC2 instances will look to auto-discover each other and form cluster"
  type        = string
  default     = "auto-join"
}

variable "desired_capacity" {
  description = "Number of EC2s that should be running in the group"
  type        = number
}


variable "instance_type" {
  description = "Instance type to use for deployment"
  type        = string
  default     = "t3.micro"
}

variable "max_size" {
  description = "Max size of the ASG"
  type        = number
}

variable "min_size" {
  description = "Minimum size of the ASG"
  type        = number
}

variable "subnet_ids" {
  description = "A list of SubnetIDs to launch resources in, this will automatically determine which AZ's to use."
  type        = list(string)
}

variable "user_data" {
  description = "A script to send to each of the EC2 instances in the ASG on launch time"
  type        = string
  default     = null
}

variable "region" {
  description = "Deployment region of the cluster"
  type        = string
}

variable "vpc_id" {
  description = "VPC id to deploy resources to"
  type        = string
}