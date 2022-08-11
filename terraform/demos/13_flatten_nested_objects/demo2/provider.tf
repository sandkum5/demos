terraform {
  required_providers {
    aci = {
      source = "CiscoDevNet/aci"
      version = "2.5.2"
    }
  }
}

provider "aci" {
  username = "admin"
  password = "password"
  url      = "https://my-cisco-aci.com"
  insecure = true
}
