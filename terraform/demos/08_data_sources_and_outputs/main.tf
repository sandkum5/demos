resource "intersight_ntp_policy" "ntp_policy" {
  name        = "ntp_basic_demo"
  description = "Policy Created using no variables"
  enabled     = true
  ntp_servers = ["1.1.1.1", "2.2.2.2"]
  timezone    = "America/Los_Angeles"
  organization {
    object_type = "organization.Organization"
    selector    = "$filter=Name eq 'default'"
  }
}

output "ntp_policy_name" {
  value = intersight_ntp_policy.ntp_policy.name
}
output "ntp_servers" {
  value = intersight_ntp_policy.ntp_policy.ntp_servers
}

data "intersight_ntp_policy" "data_ntp" {}

output "ntp_data" {
  value = data.intersight_ntp_policy.data_ntp.results[*].name
}