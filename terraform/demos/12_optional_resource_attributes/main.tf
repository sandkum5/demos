resource "intersight_iqnpool_pool" "iqn_pool" {
  for_each    = { for entry in var.iqn_pool : entry.Name => entry }
  name        = each.value.Name
  description = each.value.Description
  organization {
    object_type = "organization.Organization"
    moid        = data.intersight_organization_organization.data_org_default.results[0].moid
    # selector    = "$filter=Name eq '${each.value.Organization.Name}'"
  }
  dynamic "tags" {
    for_each = each.value.Tags
    content {
      key   = tags.value.Key
      value = tags.value.Value
    }
  }
  prefix = each.value.Prefix
  dynamic "iqn_suffix_blocks" {
    for_each = each.value.IqnSuffixBlocks
    content {
        suffix = iqn_suffix_blocks.value.Suffix
        from   = iqn_suffix_blocks.value.From
        size   = iqn_suffix_blocks.value.Size
    }
  }
}

resource "intersight_vnic_lan_connectivity_policy" "lan_conn" {
  depends_on = [intersight_iqnpool_pool.iqn_pool]
  for_each    = { for entry in var.lan_conn : entry.Name => entry }
  name        = each.value.Name
  description = each.value.Description
  organization {
    object_type = "organization.Organization"
    moid = data.intersight_organization_organization.data_org_default.results[0].moid
    # selector    = "$filter=Name eq '${each.value.Organization.Name}'"
  }
  dynamic "tags" {
    for_each = each.value.Tags
    content {
      key   = tags.value.Key
      value = tags.value.Value
    }
  }
  target_platform     = each.value.TargetPlatform
  azure_qos_enabled   = each.value.AzureQosEnabled
  iqn_allocation_type = each.value.IqnAllocationType
  static_iqn_name     = each.value.StaticIqnName
  placement_mode      = each.value.PlacementMode
  # Below dynamic block will add iqn_pool only if IqnPool value is not equal to null(when the value is empty).
  # If IqnPool is set to null, don't add this.
  dynamic "iqn_pool" {
    # for_each = each.value.IqnPool != null ? toset([1]) : toset([])
    for_each = each.value.IqnPool != null ? [1] : []
    content {
      object_type = "iqnpool.Pool"
      selector    = "$filter=Name eq '${each.value.IqnPool.Name}'"
    }
  }
}
