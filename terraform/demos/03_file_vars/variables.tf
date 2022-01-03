variable "org_name" {
  type        = string
  description = "Organization Name"
  default     = "default"

}

variable "prefix" {
  type        = string
  description = "Object Prefix"
  default     = "tf_demo"
}

variable "tags" {
  type        = map(string)
  description = "Tags for objects"
  default = {
    key1   = "DC"
    value1 = "SJ"
    key2   = "ENV"
    value2 = "LAB"
  }
}

variable "ntp_description" {
  type        = string
  description = "Description of the object"
  default     = "NTP Policy from variables.tf file"
}

variable "ntp_policy_enabled" {
  type        = bool
  description = "State of NTP service on the endpoint."
  default     = true
}

variable "ntp_server_1" {
  type        = string
  description = "NTP Server IP"
  default     = "1.1.1.1"
}

variable "ntp_server_2" {
  type        = string
  description = "NTP Server IP"
  default     = "1.1.1.2"
}

variable "ntp_policy_timezone" {
  type        = string
  description = "Timezone of services on the endpoint."
  default     = "America/Los_Angeles"
}