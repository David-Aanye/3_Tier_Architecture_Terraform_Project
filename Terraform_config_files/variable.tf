
#VPC and Subnet variables
variable "vpc_name" {
  type        = string
  default     = "server_vpc"
  description = "Vpc name"

}

variable "vpc_cidr" {
  type        = string
  default     = "10.0.0.0/16"
  description = "Cidr block for the vpc"

}

variable "webtier_subnets_names" {
  type        = list(string)
  default     = ["webtier_subnet1", "webtier_subnet2"]
  description = "Names of webtier subnets"

}

variable "webtier_subnets_cidr" {
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
  description = "Cidr blocks for public subnets"

}

variable "apptier_subnets_names" {
  type        = list(string)
  default     = ["apptier_subnet1", "apptier_subnet2"]
  description = "Names of private subnets"

}

variable "apptier_subnets_cidr" {
  type        = list(string)
  default     = ["10.0.3.0/24", "10.0.4.0/24"]
  description = "Cidr blocks for private subnets"

}


variable "dbtier_subnets_names" {
  type        = list(string)
  default     = ["dbtier_subnet1", "dbtier_subnet2"]
  description = "Names of Database subnets"

}

variable "dbtier_subnets_cidr" {
  type        = list(string)
  default     = ["10.0.5.0/24", "10.0.6.0/24"]
  description = "Cidr blocks for Database subnets"
}
variable "availability_zone" {
  type    = list(string)
  default = ["ca-central-1a", "ca-central-1b"]

}

variable "db_subnet_grp_name" {
  type        = string
  default     = "my_db_subnet_gp"
  description = "Name of subnet group"

}


variable "internet_gateway" {
  type        = string
  default     = "internet_gw"
  description = "Internet gateway"
}


variable "elastic_ip" {
  type        = list(string)
  default     = ["webtier_elastic-ip1", "webtier_elastic-ip2"]
  description = "Elastic ip addresses"

}

variable "nat_gw" {
  type        = list(string)
  default     = ["webtier-nat-gw1", "webtier-nat-gw1"]
  description = "Nat-gateways"

}
variable "route_table_names" {
  type    = list(string)
  default = ["webtier_route_table", "apptier_route_table1", "apptier_route_table1"]

  #Security group variables
}
variable "security_groups_names" {
  type    = list(string)
  default = ["external_alb_sg", "webtier_sg", "internal_alb_sg", "apptier_sg", "dbtier_sg"]

}

#Launch templates names
variable "launch_template_names" {
  type        = list(string)
  default     = ["apptier_launch_template", "webtier_launch_template"]
  description = "Names of Launch templates for apptier and webtier"

}

variable "instance_type" {
  type        = string
  default     = "t2.micro"
  description = "Instance type"

}

variable "image_ids" {
  type        = list(string)
  default     = ["ami-042c6aafb59f8d4f9", "ami-046727379ee0504a1"]
  description = "AMI for launch templates"

}

variable "asg_name" {
  type    = list(string)
  default = ["apptier_asg", "webtier_asg"]

}
variable "alb-names" {
  type        = list(string)
  default     = ["backend-alb", "external-alb"]
  description = "Names of load balancers"

}
variable "alb-tg" {
  type        = list(string)
  default     = ["backend-alb-tg", "external-alb-tg"]
  description = "ASG names"

}

variable "sns_name" {
  type        = list(string)
  default     = ["apptier_sns", "webtier_sns"]
  description = "SNS notification"

}
variable "sns_protocol" {
  type        = string
  default     = "email"
  description = "SNS protocol"

}
variable "sns_endpoint" {
  type        = string
  default     = "dmaanye@gmail.com"
  description = "SNS endpoint"

}
variable "region" {
  type        = string
  default     = "ca-central-1"
  description = "AWS Region"

}

variable "account-id" {
  type        = string
  default     = "65643592427"
  description = "AWS Account ID"

}

variable "environment" {
  type        = string
  default     = "test"
  description = "The test environment"

}

variable "db-username" {
  type        = string
  default     = "adminuser"
  description = "Database username"

}

 