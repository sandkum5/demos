terraform {
  required_version = ">= 0.13.5"
  required_providers {
    intersight = {
      source  = "CiscoDevNet/intersight"
      # version = "1.0.21"
    }
  }
}

provider "intersight" {
  apikey    = file("../ApiKey.txt")
  secretkey = "../SecretKey.txt"
  endpoint  = "https://intersight.com"
}

data "intersight_organization_organization" "org_data" {
  name = var.org_name
}

resource "intersight_ntp_policy" "ntp_policy" {
  name        = "${var.prefix}_ntp_policy"
  description = var.ntp_description
  enabled     = var.ntp_policy_enabled
  ntp_servers = [
    var.ntp_server_1,
    var.ntp_server_2
  ]
  timezone = var.ntp_policy_timezone
  organization {
    object_type = "organization.Organization"
    moid        = data.intersight_organization_organization.org_data.results[0].moid
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
