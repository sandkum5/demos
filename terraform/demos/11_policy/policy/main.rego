package main

planned_resources = [res |
    res := input.planned_values.root_module.resources[_]
    res.type == "intersight_ntp_policy"
]

num_planned_resources := count(planned_resources)

deny[msg] {
    not num_planned_resources == 1
    msg := "there should be 2 total intersight_ntp_policy"
}
