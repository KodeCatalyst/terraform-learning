output "alb_dns_name" {
  value = module.alb.alb_dns_name
}

output "instance_ids" {
  value = module.ec2.instance_ids
}