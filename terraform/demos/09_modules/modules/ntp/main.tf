resource "intersight_ntp_policy" "ntp_policy" {
  name        = var.Name
  description = var.Description
  organization {
    object_type = "organization.Organization"
    selector    = "Name eq '${var.Organization.Name}'"
  }
  enabled     = var.Enabled
  ntp_servers = var.NtpServers
  timezone    = var.Timezone
  dynamic "tags" {
    for_each = var.Tags
    content {
      key   = tags.value.Key
      value = tags.value.Value
    }
  }
}
