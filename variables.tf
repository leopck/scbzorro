variable "dbusername" {
  type        = string
  description = "Enter your username"
}
variable dbpassword {
  type        = string
  description = "Enter your password"
  sensitive = true
}
