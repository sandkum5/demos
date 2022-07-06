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
  #Create x(ntp_count) similar NTP policies when add_ntp variable is true.
  count     = var.add_ntp == true ? var.ntp_count : 0
  # count       = var.ntp_count
  name        = "${count.index}_${var.prefix}_ntp_policy"
  description = var.ntp_description
  enabled     = var.ntp_policy_enabled
  ntp_servers = var.ntp_servers
  timezone    = var.ntp_policy_timezone
  organization {
    object_type = "organization.Organization"
    selector    = "Name eq 'default'"
  }
  tags {
    key   = var.tags.key1
    value = var.tags.value1
  }
  tags {
    key   = var.tags.key2
    value = var.tags.value2
  }
}
