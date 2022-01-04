variable "Name" {
  type = string
  validation {
    condition     = substr(var.Name, 0, 5) == "Demo-"
    error_message = "Name should start with \"Demo-\"."
  }
  validation {
    condition     = length(var.Name) > 8
    error_message = "Minimum length should be > 8."
  }
}

variable "Description" {
  type = string
  validation {
    condition = length(var.Description) > 0
    error_message = "Please add Description for the variable."
  }
}

variable "Enabled" {}

variable "NtpServers" {}

variable "Timezone" {}

variable "Organization" {
  type = object({ Name = string })
  # type = map(string)
}

variable "Tags" {
  type = list(object({ Key = string, Value = string }))
  # type = list(map(string))
  }

# Default values
# Name         = "demo-ntp1"
# Description  = "DEMO NTP1 for SJ location from variables.tf file"
# Enabled      = true
# NtpServers   = ["1.1.1.1", "2.2.2.2"]
# Timezone     = "America/Los_Angeles"
# Organization = { Name = "default" }
# Tags         = []
#
# Description
# Name              : Name of NTP policy
# Description       : Description of the NTP Policy
# Enabled           : If NTP Policy is enabled
# NtpServers        : List of NTP servers
# Timezone          : Timezone of the NTP policy
# Organization.Name : Organization Name
# Tags              : Tags
