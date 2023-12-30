variable "region" {
    type = string
    default = "us-east-1"
    description = "The Region where the terraform code will be performed"
}

variable "cidr" {
    type = string
    default = "10.0.0.0/16"
    description = "IP range which will be used in virtual private network"
}

variable "azs" {
    type = list(string)
    default = [ "us-east-1a", "us-east-1b" ]
    description = "Avaliability zones"
}

variable "instance-ami" {
    type = string
    default = "ami-0c7217cdde317cfec"
    description = "The OS that will be used in instance"
}

variable "instance-type" {
    type = string
    default = "t2.micro"
    description = "The resources that will be used in instance"
}

variable "key-pair" {
    type = string
    description = "The priavte key that will be used to connect to instance"
}
