variable "INSTANCE_TYPE" {
    default = ""
}

variable "AWS_REGION" {}

variable "VPC_CIDR" {
    default = "10.0.0.0/16" 
}
variable "PUB_SUB_CIDR" {
    default = "10.0.0.0/24"
}
variable "PRI_SUB_CIDR" {
    default = "10.0.1.0/24"
}