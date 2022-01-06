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
    condition = length(var.Description) > 20
    error_message = "Please add Description for the variable."
  }
}

variable "Enabled" {}

variable "NtpServers" {
  type = list(string)
  validation {
    condition = length(var.NtpServers) > 0 && length(var.NtpServers) <= 4
    error_message = "NTP Servers must be between 1 to 4.
  }
}

variable "Timezone" {}

variable "Organization" {
  type = object({ Name = string })
  # type = map(string)
}

variable "Tags" {
  type = list(object({ Key = string, Value = string }))
  # type = list(map(string))
  }
