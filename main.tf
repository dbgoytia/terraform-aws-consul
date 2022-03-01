# ---------------------------------------------------------------------------------------------------------------------
# Create a custom role for consul
# ---------------------------------------------------------------------------------------------------------------------
resource "aws_iam_service_linked_role" "consul_asg_role" {
  aws_service_name = "autoscaling.amazonaws.com"
  custom_suffix    = "${var.cluster_name}-linked-role"
  description      = "Service-Linked Role enables access to AWS Services and Resources used or managed by Auto Scaling"
}

module "consul_cluster" {
  source = "./modules/consul-cluster"

  region              = var.region
  cluster_name        = var.cluster_name
  cluster_tag_key     = var.cluster_tag_key
  cluster_tag_value   = var.cluster_tag_value
  desired_capacity    = var.desired_capacity
  instance_type       = var.instance_type
  min_size            = var.min_size
  max_size            = var.max_size
  service_linked_role = aws_iam_service_linked_role.consul_asg_role.arn
  subnet_ids          = var.subnet_ids
  user_data = templatefile("${path.module}/templates/user-data-server.sh", {
    cluster_tag_key   = var.cluster_tag_key
    cluster_tag_value = var.cluster_name
  })
  vpc_id = var.vpc_id
}