resource "aws_ssm_parameter" "vpc_id" {
  name  = "/${var.environment}/${var.region}/${var.vpc_name}"
  type  = "String"
  value = aws_vpc.terra.id

}


resource "aws_ssm_parameter" "image-ids" {
  name  = "/${var.environment}/${var.region}/image_ids"
  type  = "String"
  value = join(",", [var.image_ids[0], var.image_ids[1]])

}


resource "aws_ssm_parameter" "webtier_subnets_ids" {
  name  = "/${var.environment}/${var.region}/webtier_subnets"
  type  = "String"
  value = join(",", [aws_subnet.webtier1.id, aws_subnet.webtier2.id])

}


resource "aws_ssm_parameter" "apptier_subnets_ids" {
  name  = "/${var.environment}/${var.region}/apptier_subnets"
  type  = "String"
  value = join(",", [aws_subnet.apptier1.id, aws_subnet.apptier2.id])

}

# data "aws_ssm_parameter" "webtier_subnets"{
#     name = "/${var.environment}/${var.region}/webtier_subnets"
# }

# data.aws_ssm_parameter.webtier_subnets.value [0]
