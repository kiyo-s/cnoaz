variable "service" {
  type        = string
  description = "Specify the service name."
}

variable "env" {
  type        = string
  description = "Specify the environment."
}

variable "region" {
  type        = string
  description = "Specify Azure region."
  default     = "japaneast"
}
