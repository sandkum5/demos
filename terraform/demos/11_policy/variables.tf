variable "Name" {}

variable "Description" {}

variable "Enabled" {}

variable "NtpServers" {
  type = list(string)
}

variable "Timezone" {}

variable "Organization" {
  type = map(string)
}

variable "Tags" {
  type = list(map(string))
}
