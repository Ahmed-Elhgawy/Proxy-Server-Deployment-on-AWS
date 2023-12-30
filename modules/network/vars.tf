variable "cidr" {
    type = string
    description = "IP range which will be used in virtual private network"
}

variable "azs" {
    type = list(string)
    description = "Avaliability zones"
}