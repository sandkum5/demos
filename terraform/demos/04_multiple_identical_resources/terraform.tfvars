org_name = "default"
prefix   = "tf_demo"

add_ntp   = true
ntp_count = 2

ntp_description     = "NTP Policy from terraform.tfvars file"
ntp_policy_enabled  = true
ntp_servers         = ["3.3.3.3", "4.4.4.4"]
ntp_policy_timezone = "America/Los_Angeles"

tags = {
  key1   = "DC"
  value1 = "San Jose"
  key2   = "ENV"
  value2 = "LAB"
}
