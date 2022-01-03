terraform {
    required_version = ">= 0.13.5"
    required_providers {
        intersight = {
            source = "CiscoDevNet/intersight"
            version = "1.0.21"
        }
    }
}

provider "intersight" {
    apikey    = "${file('./ApiKey.txt')}"
    secretkey = "./SecretKey.txt"
    endpoint  = "https://intersight.com"
}


locals "ntp" {}

data "intersight_organization_organization" "org_data" {
    name = "default"
}

resource "intersight_ntp_policy" "ntp_policy" {
    name        = "ntp_basic_demo"
    description = "Policy Created using no variables"
    enabled = true
    ntp_servers = ["1.1.1.1", "2.2.2.2"]
    timezone = "America/Los_Angeles"
    organization {
        object_type = "organization.Organization"
        moid        = data.intersight_organization_organization.org_data.results[0].moid
    }
    tags {
        key   = "Location"
        value = "San Jose"
    }
    tags {
        key   = "DC"
        value = "LAB"
    }
}
