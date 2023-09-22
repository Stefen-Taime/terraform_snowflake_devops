variable "snowflake_account" {
  description = "Compte Snowflake"
  type        = string
}

variable "snowflake_username" {
  description = "Nom d'utilisateur Snowflake"
  type        = string
}

variable "snowflake_password" {
  description = "Mot de passe Snowflake"
  type        = string
  sensitive   = true
}

variable "snowflake_role" {
  description = "Rôle Snowflake"
  type        = string
}
