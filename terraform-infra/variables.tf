variable "env" {
  type = string
}
variable "vpc_config" {
  type = any

}

variable "cluster_config" {
  type = any
}
variable "ui_conf" {
  type = any
}
## ECR
variable "ecr_names" {
  type = any
}