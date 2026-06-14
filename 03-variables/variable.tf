variable "instance_type" {
  description = "Main server instance type"
  type        = string
  default     = "t3.micro"
}

variable "instance_count" {
  description = "Number of main server instances"
  type        = number
  default     = 2
}

variable "user_names" {
  description = "IAM usernames"
  type        = list(string)
  default     = ["Alice", "Isaac", "Steve"]
}