locals {
    staticepgs = flatten([
        for epgkey, epgvalue in var.staticepgs : [
            for portkey, portvalue in epgvalue: {
                ekey  = epgkey
                key   = portkey
                # value = portvalue
                encap     = portvalue.encap
                immediacy = portvalue.immediacy
                mode      = portvalue.mode
                name      = portvalue.name
            }
        ]
    ])
}

output "localdata" {
    value = local.staticepgs
}

resource "aci_epg_to_static_path" "epg_bindings" {
  for_each = { for k,v in local.staticepgs: k => v }
  application_epg_dn = "uni/tn-Prod/ap-AP1/epg-${each.value.ekey}"
  tdn                = "topology/pod-1/protpaths-201-202/pathep-[${each.value.name}]"
  encap              = "vlan-${each.value.encap}"
  instr_imedcy       = each.value.immediacy /*deployment immediacy*/
  mode               = each.value.mode   /*regular =  trunk */
}
