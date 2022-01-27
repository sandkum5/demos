# Terraform Intersight Demos

`01_basic` : Demo Code with no variables

`02_local_vars` : Code with with local variables in a single file

`03_file_vars` : Code with variables defined in a separate file

`04_multiple_identical_resources` : Code to create multiple resources with identical properties

`05_multiple_different_resources` : Code to create multiple resources with different properties

`06_multi_diff_resources_with_nested_objects` : Code to create multiple resources with multi-level/nested properties.

`07_separate_files` : Code to showcase how to keep code in separate files

`08_data_sources_and_outputs` : Code to showcase how to use data sources and outputs.

`09_modules` : Code to showcase how to create and use modules.

`10_validation` : Code to showcase variable input validation

`11_policy` : Code to showcase policy check using conftest.

`12_optional_resource_attributes` : Code to showcase how to make an attribute optional in resource configuration


## How to Demo
- **Update** `ApiKey.txt` file with the Intersight ApiKey.
- **Update** `SecretKey.txt` file with the Intersight SecretKey.
- Change to each directory using "cd <dir_name>" and run the terraform commands.

E.g.
```terraform
cd 01_basic
terraform init
terraform fmt
terraform validate
terraform plan                  : review the output
terraform apply -auto-approve   : verify resource creation in intersight with all the properties defined in variables file.
terraform destory -auto-approve : Destory created resources
rm -rf .terraform .terraform.lock.hcl terraform.tfstate terraform.tfstate.backup  : Remove provider, state files once done.
```
