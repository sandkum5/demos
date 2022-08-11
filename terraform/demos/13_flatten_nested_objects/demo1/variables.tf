variable "staticepgs" {
    type = map(object({
        portvlans = map(object({
            name = string
            encap = string
            immediacy = string
            mode = string
        }))}))
    default = {
        defaultepg = {
            portvlans = {
                esxi1vpc = {
                    name = "ESXi1_VPC"
                    encap = "200"
                    immediacy = "immediate"
                    mode = "regular"
                }
            }
        }
    }
}
