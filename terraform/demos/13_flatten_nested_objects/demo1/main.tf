
locals {
    staticepgs = flatten([
        for epgkey, epgvalue in var.staticepgs : [
            for vlankey, vlanvalue in epgvalue: [
                for portkey, portvalue in vlanvalue: {
                    ekey = epgkey
                    key = portkey
                    value = portvalue
                }
            ]
        ]
    ])
}

output "localdata" {
    value = local.staticepgs
}

resource "aci_epg_to_static_path" "epg_bindings" {
  for_each = { for k,v in local.staticepgs: k => v }
  application_epg_dn  = "uni/tn-Prod/ap-AP1/epg-${each.value.ekey}"
  tdn  = "topology/pod-1/protpaths-201-202/pathep-[${each.value.value.name}]"
  encap  = "vlan-${each.value.value.encap}"
  instr_imedcy = "immediate" /*deployment immediacy*/
  mode  = "regular"   /*regular =  trunk */
}
