
# ---------------------------------------------------------------------------------------------------------------------
# Image datasource
# ---------------------------------------------------------------------------------------------------------------------
# Use Consul Public Ubuntu AMI
data "aws_ami" "consul_ubuntu" {
  most_recent = true

  owners = ["562637147889"]

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "is-public"
    values = ["true"]
  }

  filter {
    name   = "name"
    values = ["consul-ubuntu-*"]
  }

}

# ---------------------------------------------------------------------------------------------------------------------
# Launch profile configuration
# ---------------------------------------------------------------------------------------------------------------------

data "aws_iam_policy_document" "instance_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "instance_role" {

  name_prefix = var.cluster_name

  assume_role_policy = data.aws_iam_policy_document.instance_role.json

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_iam_role_policy_attachment" "this" {
  role       = aws_iam_role.instance_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "this" {
  name_prefix = var.cluster_name
  role        = aws_iam_role.instance_role.name

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_launch_configuration" "launch_configuration" {
  name_prefix   = "${var.cluster_name}-"
  image_id      = data.aws_ami.consul_ubuntu.image_id
  instance_type = var.instance_type
  user_data     = var.user_data

  iam_instance_profile = aws_iam_instance_profile.this.name

  lifecycle {
    create_before_destroy = true
  }
}

module "consul_policies" {
  source = "../consul-iam-policies"

  # Deployment region same as consul cluster
  region = var.region

  # Role to attach the policies to
  iam_role_id = aws_iam_role.instance_role.id
}

# ---------------------------------------------------------------------------------------------------------------------
# AutoScaling group configuration
# ---------------------------------------------------------------------------------------------------------------------
resource "aws_autoscaling_group" "consul_asg" {
  name = var.cluster_name

  launch_configuration = aws_launch_configuration.launch_configuration.name
  vpc_zone_identifier  = var.subnet_ids

  min_size         = var.min_size
  max_size         = var.max_size
  desired_capacity = var.desired_capacity

  service_linked_role_arn = var.service_linked_role

  tag {
    key                 = "Name"
    value               = var.cluster_name
    propagate_at_launch = true
  }

  tag {
    key                 = var.cluster_tag_key
    value               = var.cluster_tag_value
    propagate_at_launch = true
  }


}

# ---------------------------------------------------------------------------------------------------------------------
# SG configuration
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_security_group" "consul_sg" {
  name_prefix = "${var.cluster_name}-"
  description = "Securitu group for the ${var.cluster_name} launch configuration"
  vpc_id      = var.vpc_id
  lifecycle {
    create_before_destroy = true
  }
}
