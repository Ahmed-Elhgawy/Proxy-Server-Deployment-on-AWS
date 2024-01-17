# Security Group ==========================================
variable "alb-sg" {
    type = list(string)
    description = "List of security groups id that alb will use"
}

variable "nlb-sg" {
    type = list(string)
    description = "List of security groups id that nlb will use"
}

# Subnets =================================================
variable "alb-subnets" {
    type = list(string)
    description = "List of subnets id that will be attached to alb"
}

variable "nlb-subnets" {
    type = list(string)
    description = "List of subnets id that will be attached to nlb"
}

# VPC =====================================================
variable "vpc-id" {
    type = string
    description = "The ID of VPC that wiil connect to ALB target group"
}

# Availbility Zones =======================================
variable "azs" {
    type = list(string)
    description = "Avaliability Zones"
}

# Instances ===============================================
variable "frontend-instaces-id" {
    type = list(string)
    description = "The IDs of frontend-instances"
}

variable "backend-instaces-id" {
    type = list(string)
    description = "The IDs of backend-instances"
}
