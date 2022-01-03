ntp = [{
  Name         = "demo-ntp1"
  Description  = "DEMO NTP1 for SJ location  different resources from terraform.tfvars file"
  Enabled      = true
  NtpServers   = ["1.1.1.1", "2.2.2.2"]
  Timezone     = "America/Los_Angeles"
  Organization = { Name = "default" }
  Tags         = []
  },
  {
    Name         = "demo-ntp2"
    Description  = "DEMO NTP2 for SJ location different resources from terraform.tfvars file"
    Enabled      = true
    NtpServers   = ["3.3.3.3", "4.4.4.4"]
    Timezone     = "Africa/Accra"
    Organization = { Name = "default" }
    Tags = [{
      Key   = "Location"
      Value = "SJ"
      },
      {
        Key   = "ENV"
        Value = "PROD"
    }]
}]