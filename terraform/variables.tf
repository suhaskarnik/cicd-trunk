# variable "create_oidc_provider" {
#   type    = bool
#   default = false
# }

variable "oidc_audience" {
  type    = string
  default = "sts.amazonaws.com"
}

variable "github_org" {
  type    = string
  default = "suhaskarnik"
}

variable "repository_name" {
  type    = string
  default = "cicd-trunk"
}