variable "project_name" {

  description = "project name"
  type        = string
  default     = "zomato"

}

variable "project_enivornment" {
  description = " project environment"
  type        = string
  default     = "prod"

}
variable "vpc_cidr" {
  description = "VPC CIDR block"
  type        = string
  default     = "10.1.0.0/16"

}


variable "create_nat" {
type = bool
default = true
}
