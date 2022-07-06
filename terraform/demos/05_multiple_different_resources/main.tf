terraform {
  required_providers {
    intersight = {
      source  = "CiscoDevNet/intersight"
    }
  }
}

provider "intersight" {
  apikey    = file("../ApiKey.txt")
  secretkey = "../SecretKey.txt"
  endpoint  = "https://intersight.com"
}

resource "intersight_ntp_policy" "ntp_policy" {
  for_each    = { for ntp in var.ntp : ntp.Name => ntp if ntp.Enable == true}
  name        = each.value.Name
  description = each.value.Description
  organization {
    object_type = "organization.Organization"
    selector    = "Name eq '${each.value.Organization.Name}'"
  }
  ntp_servers = each.value.NtpServers
  timezone    = each.value.Timezone
}
