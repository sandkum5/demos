---
# My Terraform Learnings
Infrastructure as Code (IaC)


By: Sandeep Kumar
---
# Agenda

Session-1
- What is Infrastructure as Code(IaC)
- Benefits of IaC
- What is Terraform
- Core Terraform Workflow
- HCL(HashiCorp Configuration Language)
- Install Terraform

Session-2:
- Terraform Basics
    - Variables, Providers, Resources, Data Sources, Output, Statefile,   
    
    - Session-3 Meta-Parameters - for_each, count, depends_on, lifecycle
    
    - Session-4 Expressions, Environment variables, Debugging
    
Session-5
- Terraform Advanced
    - Modules, Backend, Workspaces, 
    
    - Session-6 TF Cloud, PaC(Policy as Code), 
    
    - Session-7 Importing Infrastructure, Provisioners, 
    
    - Session-8 CICD Workflow, miscellaneious. 
    
- Demos
- Additional Info
  - terraform-docs, tfvar, File Extensions
- Miscellaneous
- Documentation

---
# What is Infrastructure as Code?

- You write and execute code to define, deploy, and update your Infrastructure.
- You treat all aspects of operations as software include hardware(e.g. setting up physical servers)

There are four broad categories of IAC tools:
- Ad hoc scripts - Bash Scripts
- Configuration management tools - Ansible, Chef, Puppet are primarily to install and manage software on existing servers.
- Server templating tools - Packer, Vagrant, Docker
- Server provisioning tools - Terraform, Pulumi

---
# Benefits of Infrastructure as Code?

- Define Infrastructure in config/code
- Auditable
- Repeatable
    - Follow DRY(Don't repeat yourself) Principle
- Version Control
- Documentation

---

# What is Terraform?

- Tool for building, changing, and versioning infrastructure safely and efficiently.
- Its a Infrastructure as code solution.
- Platform agnostic
- Open source tool created by HashiCorp
- Written in Go Programming Language
- It uses Declarative style where you write code that specifies your desired end state, and terraform will figure out how to acheive that state.
- The terraform binary makes API calls on your behalf to one or more providers.

Some other IaC options:
- AWS has CloudFormation
- Azure has Azure Resource Manager Templates
- GCP has Deployment Manager
- Openstack has Heat
- Pulumi(Open Source, uses programming languages)

---
# Core Terraform Workflow

The core Terraform workflow has three steps:

1. Write - Author infrastructure as code.
2. Plan  - Preview changes before applying.
3. Apply - Provision reproducible infrastructure.

---
# HCL(HashiCorp Configuration Language)

- Primary user interface
- Tells Terraform what plugins to install, what infrastructure to create, what data to fetch.
- Define dependencies between resources and create multiple similar resources

Language Syntax consists of only a few basic elements:
```
<BLOCK TYPE> "<BLOCK LABEL>" "<BLOCK LABEL>" {
  # Block body
  <IDENTIFIER> = <EXPRESSION> # Argument
}

E.g.
terraform {
  required_providers {}
  backend "<backend_name>" {}
}
provider "<provider_name>" {}
variable "<variable_name>" {}
resource "<resource_name>" "<resource_local_identifier>" {}
locals {}
data "<resource_name>" "<local_identifier>" {}
output "<local_identifier>" {}
module "<mod_local_name> {}
```
---
# Terraform Basics

## Variables
    - The variables are generally divided into inputs and outputs.
    - Input variables - to define values that configure your infrastructure.
    - Output variables - to get information about the infrastructure after deployment.
        - Useful for passing on information such as IP addresses for connecting to the server.

```
    - Types:
        - string
        - number
        - bool : true or false
        - list []
        - map {}
        - null
```
---

    - Complex Types:
        - list or list(any) : []
            - Accepts any element type as long as every element is the same type.
            - E.g.
              - list(string): list of strings
              - list(number): list of numbers

        - map or map(any): {}
            - Accepts any element type as long as every element is the same type.
            - Maps can be made with braces ({}) and colons (:) or equals signs (=): { "foo": "bar", "bar": "baz" } OR { foo = "bar", bar = "baz" }.
            - Quotes may be omitted on keys, unless the key starts with a number, in which case quotes are required.
            - Commas are required between key/value pairs for single line maps.
            - A newline between key/value pairs is sufficient in multi-line maps.

        - set(...):
            - Collection of unique values

    - Structural Types:
        - object(...):
            - Collection of named attributes that each have their own type.
            - object({ name=string, age=number })

        - tuple(...):
            - Each element has its own type.
            - tuple([string, number, bool])

    - Optional Object Type attributes(Experimental)
        - optional(string)

---
    - Variable Declaration:
        - type
        - description
        - default
        - validation
        - sensitive
        - nullable:
            - Specify if the variable can be null within the module.
        - Ref: https://www.terraform.io/language/values/variables

```
variable "<var_name>" {
  type = bool
  description = "Bool variable"
  default = true
  sensitive = false
  nullable = false
  validation {
    condition = length(var.<var_name>) > 4
    error_message = "Error message if condition is false"
  }
  validation {}
}
```
    - How to access variable from map/list?
        var.map_name["a"]
        var.list_name[0]


## Providers

- Intersight Example:

```
terraform {
  required_providers {
    intersight = {
      source = "CiscoDevNet/intersight"
      version = "1.0.21"
    },
    aci = {
      source = "CiscoDevNet/aci"
      version = "1.2.0"
    }
  }
}

provider "intersight" {
  # Configuration options
}

provider "aci" {
  # Configuration options
}
```

## Backend


## Resources

```
resource "<resource_name>" "<local_resource_identifier>" {}
```

---
## Data Sources
```terraform
    Syntax:
        data "resource_name" "local_reference_name" {
            # Query parameters
        }
```
        <resource_name>.<local_reference_name> serves as an Identifier and must be unique within a module

---
## Output
    - To print values of the created resource e.g. IP, etc.
    - It can also act as an input to other resources being created via terraform.
    - Output values exist in the tfstate file.
    - To get the public IP address, you can use the example command below.
        terraform output <out_variable_name>
```
    Syntax:
    output "name_x" {
      value = resource_name.user_given_name.parameter_name
    }
```
    - If the value = resource_name.user_given_name  : will list all the attributes with the resource to value

    - After apply, there would be an output section with output:
        name1 = <value from above>

---
## Statefile
    - Terraform stores the state of the infrastructure that is being created from the TF files.
    - This state file allows terraform to map real world resource to your exisiting configuration.
    Commands:
```
        terraform state list
        terraform state show <resource_name>.<instance_name>
        terraform refresh  : fetches current state of your resources
        terraform plan     : will automatically refresh the state for you
        terraform show     : will print the statefile info in a easier to read format
```
    - Desired State - explicitely defined in .tf files.
      Note: The settings which are not part of the tfstate file, terraform won't change them back.

    - Current State - What's running on infrastructure .tfstate file

## Meta-Parameters

- provider
    - 3rd Party providers - not downloaded by "terraform init"
        Manually copy the provider to ~/.terraform.d/plugins dir on mac/linux

- depends_on
- count
- for_each
- lifecycle

## Expressions
- Conditional Expressions:
  - A conditional expression uses the value of a boolean expression to select one of two values.
  - condition ? true_val : false_val

- Dynamic Blocks:
  - Dynamically construct repeatable nested blocks
  - Supported inside resource, data, provider, and provisioner blocks.
  - It iterates over a given complex value, and generates a nested block for each element of that complex value.
```terraform
resource "aws_elastic_beanstalk_environment" "tfenvtest" {
  name                = "tf-test-name"
  application         = "${aws_elastic_beanstalk_application.tftest.name}"
  solution_stack_name = "64bit Amazon Linux 2018.03 v2.11.4 running Go 1.12.6"

  dynamic "setting" {
    for_each = var.settings
    content {
      namespace = setting.value["namespace"]
      name = setting.value["name"]
      value = setting.value["value"]
    }
  }
}
Src: https://www.terraform.io/language/expressions/dynamic-blocks
```

## Environment variables:
- Terraform will read environment variables in the form of TF_VAR_name to find the value for a variable.
  E.g. TF_VAR_region variable can be set in the shell to set the region variable in Terraform.

- You can use multiple -var-file arguments in a single command, with some checked in to version control and others not checked in.
  terraform apply -var-file="secret.tfvars" -var-file="production.tfvars"

- TF_LOG, TF_LOG_CORE, TF_LOG_PROVIDER
    - values: TRACE, DEBUG, INFO, WARN, ERROR, JSON(TRACE Level or higher with json encoding)
- TF_LOG_PATH: write to log file

- The automation tool can set TF_WORKSPACE to an existing workspace name, which overrides any selection made with the terraform workspace select command.
  Using this environment variable is recommended only for non-interactive usage.
  https://learn.hashicorp.com/tutorials/terraform/automate-terraform?in=terraform/automation

- Controlling Terraform Output in Automation
  When the TF_IN_AUTOMATION is set to any non-empty value, Terraform makes some minor adjustments to its output to de-emphasize specific commands to run.


## Debugging


# Terraform Advanced

## Modules
- Modules are containers for multiple resources that are used together.
- A module consists of a collection of .tf and/or .tf.json files kept together in a directory.
- Terraform can load modules from a public or private registry.
    https://registry.terraform.io/browse/modules
- A sub-directory in Terraform is a module.
- Terraform will only process *.tf files in the folder where you run terraform plan.
- To include configuration in sub-folders you use the module syntax.
- When calling a module, the source argument is required.
- The version will let you define what version or versions of the module will be loaded.
- Other arguments to module blocks are treated as input variables to the modules.
E.g.
```
terraform.tf
module "my_network" {
  source = "./network"
}

module "module_name" {
  source = "../../modules/ec2"
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "2.21.0"
  name = var.vpc_name
  cidr = var.vpc_cidr
  azs             = var.vpc_azs
  private_subnets = var.vpc_private_subnets
}
```

## Workspaces
- Creates a terraform.tfstate.d dir for each workspace to keep the state file separate for environments.
- For available options: terraform workspace -h
- terraform workspace select <name>  - Select a namespace
- terraform workspace new dev        - Create and move to namespace


## TF Cloud
- It manages Terraform runs in a consistent and reliable environment
- includes easy access to shared state and secret data
- access controls for approving changes to infrastructure
- a private registry for sharing Terraform modules
- detailed policy controls for governing the contents of Terraform configurations, and more.

- Options to Interact with Terraform Cloud:
  - [GUI](https://app.terraform.io/)
  - [API calls](https://www.terraform.io/cloud-docs/api-docs)
  - [Terraform Cloud/Enterprise Provider](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs)

- Cloud Agents
- Run Types *

- Terraform Cloud vs Terraform CLI
GUI/API
Stores State Data
SSO
Agents
Sentinel Policies
VCS Integration
Cost Estimation
Team Management
Tagging, Organization, Workspaces, Notifications
3rd Party Tools and services integration to manage cost, security, compliance and more.


## PaC(Policy as Code)
- Sentinel Policies(TF Cloud)
    - An embedded policy-as-code framework integrated with Hashicorp Enterprise products.
    - Enabled fine-grained, logic-based policy decisions.
    - Terraform Plan --> Sentinel Checks --> terraform apply
    - E.g. Policy(Block EC2 without tags) -> Policy Sets -> Workspace(1 or all)

- OPA(Open Policy Agent)

## Importing Infrastructure
https://www.terraform.io/cli/import

## Provisioners
https://www.terraform.io/language/resources/provisioners

## CICD Workflow
- Add/Update Terraform code in a new Git branch
- CI kicks off a new build based off the Git commit that outputs a Terraform plan binary
- Conftest binary runs against this Terraform plan. If it fails, the entire build fails and developer is notified. Build ends.
- If Conftest passes successfully, code is merged into main/master branch
- Terraform is applied and new infrastructure deployed

Workflow Commands:
- terraform init
- terraform fmt
- terraform validate
- terraform plan
  - Policy Check
- terraform apply
- terraform destory

---
# Demos

```
01_basic                                    : Demo Code with no variables
02_local_vars                               : Code with with local variables in a single file
03_file_vars                                : Code with variables defined in a separate file
04_multiple_identical_resources             : Code to create multiple resources with identical properties
05_multiple_different_resources             : Code to create multiple resources with different properties
06_multi_diff_resources_with_nested_objects : Code to create multiple resources with different nested properties.
07_separate_files                           : Code to showcase how to keep code in separate files
08_data_sources_and_outputs                 : Code to showcase how to use data sources and outputs.
09_modules                                  : Code to showcase how to create and use modules.
10_validation                               : Code to showcase variable input validation
11_policy                                   : Code to showcase policy check using conftest.
12_import * NA
13_cicd_workflow * NA
```
---
# Additional Stuff:

## Terraform-docs:
- Create documentation from your terraform code

## tfvar:
  - Tool to create a variable definition file

---
## File Extensions:
- Resource files:
    - *.tf E.g. main.tf, ntp.tf, etc.
    - variables.tf - define the variables type and optionally set a default value.
      Syntax:
```
        variable "var_name" {
            type = string
            description = "Variable Description"
            default = "default_value"
        }
```
---
- Variable Definitions (.tfvars) Files:
    - terraform.tfvars - used to set the actual values of the variables
        -  If this is present in your root directory than terraform will load this file and apply the values.
    - terraform.tfvars.json
    - *.auto.tfvars
    - *.auto.tfvars.json
    - If variable "var_name" {} is empty, then it will prompt during "terraform plan"

- State file:
    - terraform.tfstate
    - terraform.tfstate.backup

---
# Miscellaneous

- Terraform console to test functions:
```terraform
$ terraform console
Out: max(10,20,30)
```

- Use file function to pull data from files such as passwords
```terraform
password = "${file("../my_pass.txt")}"  # interpolation function
```

- Local-exec provisioner usage e.g.
```terraform
resource "resource_name" "local_name" {
	ami = "xxxxx"
	instance_type = "t2.micro"
	provisioner "local-exec" {
	    command = "echo ${resource_name.local_name.ip} >> private_ips.txt"
	}
}
```

```
terraform show -json tfplan > tfplan-1.json
terraform show -json tfplan | jq > tfplan-2.json

% terraform plan -json
{"@level":"info","@message":"Terraform 1.1.3","@module":"terraform.ui","@timestamp":"2022-01-06T17:30:09.379537-08:00","terraform":"1.1.3","type":"version","ui":"1.0"}

{"@level":"error","@message":"Error: Invalid value for variable","@module":"terraform.ui","@timestamp":"2022-01-06T17:30:15.107233-08:00","diagnostic":{"severity":"error","summary":"Invalid value for variable","detail":"Organization Name should be one of the following: default, Prod.\n\nThis was checked by the validation rule at variables.tf:52,3-13.","range":{"filename":"variables.tf","start":{"line":49,"column":1,"byte":1431},"end":{"line":49,"column":24,"byte":1454}},"snippet":{"context":null,"code":"variable \"Organization\" {","start_line":49,"highlight_start_offset":0,"highlight_end_offset":23,"values":[]}},"type":"diagnostic"}



% terraform plan -json
{"@level":"info","@message":"Terraform 1.1.3","@module":"terraform.ui","@timestamp":"2022-01-06T17:31:15.793598-08:00","terraform":"1.1.3","type":"version","ui":"1.0"}

{"@level":"info","@message":"intersight_ntp_policy.ntp_policy: Plan to create","@module":"terraform.ui","@timestamp":"2022-01-06T17:31:21.854262-08:00","change":{"resource":{"addr":"intersight_ntp_policy.ntp_policy","module":"","resource":"intersight_ntp_policy.ntp_policy","implied_provider":"intersight","resource_type":"intersight_ntp_policy","resource_name":"ntp_policy","resource_key":null},"action":"create"},"type":"planned_change"}
{"@level":"info","@message":"Plan: 1 to add, 0 to change, 0 to destroy.","@module":"terraform.ui","@timestamp":"2022-01-06T17:31:21.855172-08:00","changes":{"add":1,"change":0,"remove":0,"operation":"plan"},"type":"change_summary"}
{"@level":"info","@message":"Outputs: 1","@module":"terraform.ui","@timestamp":"2022-01-06T17:31:21.855259-08:00","outputs":{"ntp_data":{"sensitive":false,"action":"create"}},"type":"outputs"}
```

```
Single line comments start with #
Multi-line comments are wrapped with /* and */
Multiline strings can use shell-style "here doc" syntax, with the string starting with a marker like <<EOF and then the string ending with EOF on a line of its own. The lines of the string and the end marker must not be indented.
```

```
tflint — https://github.com/terraform-linters/
terrafirma — https://github.com/wayfair/terrafirma
tfsec — https://github.com/liamg/tfsec
terrascan — https://github.com/cesar-rodriguez/terrascan (no TF 0.13 support at this time)
checkov — https://github.com/bridgecrewio/checkov/
conftest — https://github.com/instrumenta/conftest
```

- Conftest is a command line tool for testing configuration files and uses Open Policy Agent (OPA) under the hood.
- Conftest uses the Rego language from Open Policy Agent for writing the assertions.
- Conftest will look in the directory ./policy for Rego policies.
- If you do not have it in that directory, this also works:
- conftest test --policy [location_here] tfplan-2.json

```
docker run --rm -v $(pwd):/project openpolicyagent/conftest test deployment.yaml
```

---
# Documentation
[Terraform](https://www.terraform.io)

[Providers](https://registry.terraform.io/browse/providers)
