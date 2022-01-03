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

variable "ntp_count" {
  type        = number
  description = "Create ntp_count number of policies"
  default     = 1
}

variable "add_ntp" {
  type        = bool
  description = "Add NTP Policy"
  default     = false
}

variable "ntp_description" {
  type        = string
  description = "Description of the object"
  default     = "Default Description of NTP Policy from variables.tf file"
}

variable "ntp_policy_enabled" {
  type        = bool
  description = "State of NTP service on the endpoint."
  default     = true
}

variable "ntp_servers" {
  type        = list(string)
  description = "NTP Server IP"
  default     = ["1.1.1.1", "1.1.1.2"]
}

variable "ntp_policy_timezone" {
  type        = string
  description = "Timezone of services on the endpoint."
  default     = "America/Los_Angeles"
}