variable "Name" {
  type = string
  validation {
    condition     = substr(var.Name, 0, 5) == "Demo-"
    error_message = "Name should start with \"Demo-\"."
  }
  validation {
    condition     = length(var.Name) > 1 && length(var.Name) <= 64
    error_message = "The name must be between 1 and 64 characters."
  }
  validation {
    condition = regex("[0-9A-Za-z\\-_\\.]+", var.Name) == var.Name
    error_message = "The number should include alphanumeric characters, allowing special characters '-' '_' '.' ."
  }
}

variable "Description" {
  type = string
  validation {
    condition = length(var.Description) > 20
    error_message = "Please add Description for the variable. The letters should be <= 1024."
  }
}

variable "Enabled" {}

variable "NtpServers" {
  type = list(string)
  validation {
    condition = length(var.NtpServers) > 0 && length(var.NtpServers) <= 4
    error_message = "NTP Servers must be between 1 to 4."
  }
}

variable "Timezone" {
  type = string
  validation {
    condition = var.Timezone == "America/Los_Angeles" || var.Timezone == "America/New_York" || var.Timezone == "America/Denver" || var.Timezone == "America/Phoenix"
    error_message = "Timezone should be one of the following: America/Los_Angeles | America/New_York | America/Denver | America/Phoenix."
  }
}

variable "Organization" {
  type = object({ Name = string })
  # type = map(string)
}

variable "Tags" {
  type = list(object({ Key = string, Value = string }))
  # type = list(map(string))
}
