##############
#variable for main
##############



variable "project" {
  description = "name of project"
  type        = string
  default     = "node"
}



variable "env" {
  description = "project environmnet"
  type        = string
}

variable "region" {
  description = "name of region"
  default     = "ap-south-1"
}

variable "owner" {
  description = "owner person"
  default     = "ranaamiya70@gmail.com"
}

variable "master_tags" {
  description = "common tags"
  type        = map(string)
  default = {
    createdBy  = "ranaamiys70@gmail.com"
    CostCenter = "8723578"
    AlwaysOn   = "Yes"
    platforms  = "Myproject"
    product    = "employee data"
  }
}
