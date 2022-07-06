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


locals {
  name        = "ntp_basic_demo_02"
  description = "Policy Created using local variables"
  enabled     = true
  ntp_servers = ["1.1.1.1", "2.2.2.2"]
  timezone    = "America/Los_Angeles"
  org_name    = "default"
  tag_key1    = "Location"
  tag_value1  = "San Jose"
  tag_key2    = "DC"
  tag_value2  = "LAB"
}


resource "intersight_ntp_policy" "ntp_policy" {
  name        = local.name
  description = local.description
  enabled     = local.enabled
  ntp_servers = local.ntp_servers
  timezone    = local.timezone
  organization {
    object_type = "organization.Organization"
    selector    = "Name eq 'default'"
  }
  tags {
    key   = local.tag_key1
    value = local.tag_value1
  }
  tags {
    key   = local.tag_key2
    value = local.tag_value2
  }
}
