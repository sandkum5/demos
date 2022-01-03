resource "intersight_ntp_policy" "ntp_policy" {
    name        = "ntp_basic_demo"
    description = "Policy Created using no variables"
    enabled = true
    ntp_servers = ["1.1.1.1", "2.2.2.2"]
    timezone = "America/Los_Angeles"
    organization {
        object_type = "organization.Organization"
        moid        = data.intersight_organization_organization.org_data.results[0].moid
    }
    tags {
        key   = "Location"
        value = "San Jose"
    }
    tags {
        key   = "DC"
        value = "LAB"
    }
}
