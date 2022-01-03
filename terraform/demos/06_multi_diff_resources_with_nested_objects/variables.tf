variable "ntp" {
  type = list(object({
    Name        = string
    Description = string
    Enabled     = bool
    NtpServers  = list(string)
    Timezone    = string
    Organization = object({
      Name = string
    })
    Tags = list(object({ Key = string, Value = string }))
  }))
  default = [{
    Name         = "demo-ntp1"
    Description  = "DEMO NTP1 for SJ location from variables.tf file"
    Enabled      = true
    NtpServers   = ["1.1.1.1", "2.2.2.2"]
    Timezone     = "America/Los_Angeles"
    Organization = { Name = "default" }
    Tags         = []
  }]
  description = <<EOT
    Name              : Name of NTP policy
    Description       : Description of the NTP Policy
    Enabled           : If NTP Policy is enabled
    NtpServers        : List of NTP servers
    Timezone          : Timezone of the NTP policy
    Organization.Name : Organization Name
    Tags              : Tags
    EOT
}