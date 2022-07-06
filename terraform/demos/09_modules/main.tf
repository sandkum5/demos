module "ntp" {
  source = "./modules/ntp"
  Name         = "Demo-NTP-Module"
  Description  = "NTP Policy using Modules"
  Enabled      = true
  NtpServers   = ["1.1.1.1", "2.2.2.2"]
  Timezone     = "America/Los_Angeles"
  Organization = { Name = "default" }
  Tags         = []
}
