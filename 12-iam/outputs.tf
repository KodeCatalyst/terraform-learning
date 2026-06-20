# outputs.tf

output "instance_id" {
  value = module.ec2.instance_id
}

output "public_ip" {
  value = module.ec2.public_ip
}

output "role_arn" {
  value = module.iam.role_arn
}