output "consul_ami" {
  value = data.aws_ami.consul_ubuntu
}

output "aws_autoscaling_group_arn" {
  value = aws_autoscaling_group.consul_asg.arn
}