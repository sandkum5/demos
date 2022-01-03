terraform {
  required_version = ">= 0.13.5"
  required_providers {
    intersight = {
      source  = "CiscoDevNet/intersight"
      version = "1.0.21"
    }
  }
}

provider "intersight" {
  apikey    = file("../ApiKey.txt")
  secretkey = "../SecretKey.txt"
  endpoint  = "https://intersight.com"
}

resource "intersight_ntp_policy" "ntp_policy" {
  for_each    = { for ntp in var.ntp : ntp.Name => ntp }
  name        = each.value.Name
  description = each.value.Description
  organization {
    object_type = "organization.Organization"
    selector    = "$filter=Name eq '${each.value.Organization.Name}'"
  }
  enabled     = each.value.Enabled
  ntp_servers = each.value.NtpServers
  timezone    = each.value.Timezone
}
