variable "staticepgs" {
    type = map(map(object({
            name = string
            encap = string
            immediacy = string
            mode = string
        })))
    default = {
        defaultepg = {
            port1 = {
                name = "ESXi1_VPC"
                encap = "200"
                immediacy = "immediate"
                mode = "regular"
            }
        }
    }
    validation {
      condition = alltrue([
        for epg_key, epg in var.staticepgs: alltrue([
            for port_key, port in epg: contains(["200", "203", "204"], port.encap)
        ])
      ])
      error_message = "Err: Encap should be set to 200"
    }
}
