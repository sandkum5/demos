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
  dynamic "tags" {
    for_each = length(each.value.Tags) != [] ? each.value.Tags : []
    content {
      key   = tags.value.Key
      value = tags.value.Value
    }
  }
}