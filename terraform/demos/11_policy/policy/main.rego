package main

# Rego Comprehensions
planned_resources_comprehension = [ policies |
    policies := input.planned_values.root_module.resources[_]
    policies.type == "intersight_ntp_policy"
]

# or we can use Rego Rule
# Rego Rule
planned_resources_rule[policies] {
    policies := input.planned_values.root_module.resources[_]
    policies.type == "intersight_ntp_policy"
}

# Scalar value
num_planned_resources := count(planned_resources_rule)

# Rego Rule
deny[msg] {
    not num_planned_resources == 1
    msg := "there should be 2 total intersight_ntp_policy"
}
