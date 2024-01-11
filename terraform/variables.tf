variable "tenancy_ocid" {
  type        = string
  description = "Your tenancy OCID."
}

variable "root_compartment_ocid" {
  type        = string
  description = "Root compartment OCID."
}

variable "user_ocid" {
  type        = string
  description = "OCID of the user thar calls the API."
}

variable "fingerprint" {
  type        = string
  description = "SSH Keys fingerprint."
}

variable "private_key_path" {
  type        = string
  description = "SSH Private key file path."
}

variable "ssh_public_key_path" {
  type        = string
  description = "SSH Public key file path."
}

variable "region" {
  type        = string
  description = "The OCI region."
}

