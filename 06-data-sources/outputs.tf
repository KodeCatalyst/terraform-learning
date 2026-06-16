output "vpc_id"{
    value = data.aws_vpc.default.id
}

output "vpc_cidr" {
    value = data.aws_vpc.default.cidr_block
}

output "subnet_ids" {
    value = data.aws_subnets.default.ids
}

# outputs.tf (add this)

output "latest_ami_id" {
  value = data.aws_ami.amazon_linux.id
}

output "latest_ami_name" {
  value = data.aws_ami.amazon_linux.name
}