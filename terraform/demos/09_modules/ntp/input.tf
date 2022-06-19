variable "Name" {
  type        = string
  description = "Name of NTP policy"
  default     = "Demo-ntp-1"
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
  type        = string
  description = "Description of the NTP Policy"
  default     = "DEMO NTP1 for SJ location from variables.tf file"
  validation {
    condition     = length(var.Description) > 0
    error_message = "Please add Description for the variable."
  }
}

variable "Enabled" {
  type        = bool
  description = "If NTP Policy is enabled"
  default     = true
}

variable "NtpServers" {
  type        = list(string)
  description = "List of NTP servers"
  default     = ["1.1.1.1", "2.2.2.2"]
}

variable "Timezone" {
  type        = string
  description = "Timezone of the NTP policy"
  default     = "America/Los_Angeles"
}

variable "Organization" {
  type        = map(string)
  description = "Organization Name"
  default     = { Name = "default" }

}

variable "Tags" {
  type        = list(map(string))
  description = "Tags"
  default     = []
}
