---
marp: false
theme: gaia
paginate: true

color: #000
backgroundColor: #fff
# backgroundImage: url('https://marp.app/assets/hero-background.jpg')


---
# My Take on TERRAFORM
Infrastructure as Code (IaC)


By: Sandeep Kumar
---
# Agenda

- Pre-requisites
- Why Terraform
- What is Terraform
- Terraform Basics
- Config Scenarios or Code Snippets
- Terraform Pitfalls
- Terraform Cloud vs CLI

---

# Prerequisites

- The only requirement is we should be familiar with the Target object parameters.
- We should know the object type i.e if its a string, boolean, list, HashMap, etc.
- E.g.
    - Intersight: The parameters needed by NTP policy are Name(type=string), Description(type=string), Tags(type=map),
        Organization(type=string), NTP Servers(type=list(string)), Timezone(type=string), Enabled(type=boolean)

Desired State - explicitely defined in .tf files.
    Note: The settings which are not part of the tfstate file, terraform won't change them back.

Current State - What's running on infrastructure .tfstate file
---

# Why Terraform?

- Auditable
- Repeatable
    - Follow DRY(Don't repeat yourself) Principle
- Dependable

---

# What is Terraform?

Infrastructure as code
Terraform, AWS CloudFormation are the Infrastructure orchestration tools which basically means they can provision the servers and infrastructure by themselves.

Ansible, Chef, Puppet are configuration management tools, primary to install and manage software on existing servers.


---

# Terraform Basics
- HCL

```terraform

# Intersight Example:
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

- Providers
  Syntax:
```terraform
provider "provider_name" {
    # Configuration Options
}
```

- Resources - represent Infrastructure objects.

Syntax of the Terraform language:
```terraform
<BLOCK TYPE> "<BLOCK LABEL>" "<BLOCK LABEL>" {
  # Block body
  <IDENTIFIER> = <EXPRESSION> # Argument
}

resource "provider_resource_name" "local_reference_name" {
    # Configuration Options
}
```

---

- Variables
    - The variables are generally divided into inputs and outputs.
    - Input variables - to define values that configure your infrastructure.
    - Output variables - to get information about the infrastructure after deployment.
        - These can be useful for passing on information such as IP addresses for connecting to the server.

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
        - list []
            - The keyword list is a shorthand for list(any), which accepts any element type as long as every element is the same type.
            - list(string): list of strings

        - map {}
            - The keyword map is a shorthand for map(any), which accepts any element type as long as every element is the same type.
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

    - local, default, var files

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

    - How to access variable from map/list?
        var.map_name["a"]
        var.list_name[0]

- Output
    - To print values of the created resource e.g. IP, etc.
    - It can also act as an input to other resources being created via terraform.
    - Output values exist in the tfstate file.
    - To get the public IP address, you can use the example command below.
        terraform output <out_variable_name>
    Syntax:
    output "name_x" {
      value = resource_name.user_given_name.parameter_name
    }

    - If the value = resource_name.user_given_name  : will list all the attributes with the resource to value

    - After apply, there would be an output section with output:
        name1 = <value from above>


---

- Data Sources
```terraform
    Syntax:
        data "resource_name" "local_reference_name" {
            # Query parameters
        }
```
        <resource_name>.<local_reference_name> serves as an Identifier and must be unique within a module

---
- Statefile
    - Terraform stores the state of the infrastructure that is being created from the TF files.
    - This state file allows terraform to map real world resource to your exisiting configuration.
    Commands:
        terraform state list
        terraform state show <resource_name>.<instance_name>
        terraform refresh  : fetches current state of your resources
        terraform plan     : will automatically refresh the state for you
        terraform show     : will print the statefile info in a easier to read format

- Backend

---
- Imports *
- Provisioners *
- Meta-Parameters *
    - provider
        - 3rd Party providers - not downloaded by "terraform init"
            Manually copy the provider to ~/.terraform.d/plugins dir on mac/linux

    - depends_on
    - count
    - for_each
    - lifecycle

- Expressions *
- Functions *

---
- Looping:
    - count
    - for_each

        Syntax:
        resource "<PROVIDER>_<TYPE>" "<NAME>" {
            for_each = <COLLECTION>
            [CONFIG ...]
        }
        - PROVIDER is the name of a provider (e.g., aws)
        - TYPE is the type of resource to create in that provider (e.g., instance).
        - NAME is an identifier that you can use throughout the Terraform code to refer to this resource (e.g., my_instance).
        - `COLLECTION is a set or map to loop over` (lists are not supported when using for_each on a resource).
        - CONFIG consists of one or more arguments that are specific to that resource.

    - for Expressions
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

---
- Conditional Expressions:
    - A conditional expression uses the value of a boolean expression to select one of two values.
    - condition ? true_val : false_val

- Dependencies
    - depends_on

---
- terraform Workflow:
    - init
    - fmt
    - validate
    - plan
    - apply
    - destory

---
- Advanced stuff:
    - Workspaces
        - Creates a terraform.tfstate.d dir for each workspace to keep the state file separate for environments.
        - For available options: terraform workspace -h
        - terraform workspace select <name>  - Select a namespace
        - terraform workspace new dev        - Create and move to namespace
    - Modules
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


    - PaC (Policy as Code)
        - Sentinel Policies(TF Cloud)
            - An embedded policy-as-code framework integrated with Hashicorp Enterprise products.
            - Enabled fine-grained, logic-based policy decisions.
            - Terraform Plan --> Sentinel Checks --> terraform apply
            - E.g. Policy(Block EC2 without tags) -> Policy Sets -> Workspace(1 or all)

        - OPA(Open Policy Agent)

    - - Terraform Cloud
        - Cloud Agents
        - Run Types *
    - Importing Infrastructure

---
    - Additional Stuff:
      - Terraform-docs:
         - Create documentation from your terraform code

      - tfvar:
        - Tool to create a variable definition file

      - State Drift Detection

---
      - File Extensions:
        - Resource files:
            - *.tf E.g. main.tf, ntp.tf, etc.
            - variables.tf - define the variables type and optionally set a default value.
              Syntax:
                variable "var_name" {
                    type = string
                    description = "Variable Description"
                    default = "default_value"
                }
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
    - Debugging:
    - Environment variables:
        - Terraform will read environment variables in the form of TF_VAR_name to find the value for a variable.
          E.g. TF_VAR_region variable can be set in the shell to set the region variable in Terraform.

        - You can use multiple -var-file arguments in a single command, with some checked in to version control and others not checked in.
          terraform apply -var-file="secret.tfvars" -var-file="production.tfvars"

        - TF_LOG, TF_LOG_CORE, TF_LOG_PROVIDER
            - values: TRACE, DEBUG, INFO, WARN, ERROR, JSON(TRACE Level or higher with json encoding)
        - TF_LOG_PATH: write to log file
        -

---

# Resources Creation Pre-requisites
- Should know Target API and what parameters are needed to create a target resource
- Use Browser Developer tools to inspect API calls

- E.g. If I don't know what parameters are needed to create a NTP Policy in Intersight, how can I identify what parameters do I need in the resource section.

---

# Code Snippets
    - 01_basic
        - Code with no variables in a single file
    - 02_local_vars
        - Code with with local variables in a single file
    - 03_file_vars
        - Code with variables defined in a separate file
    - 04_multiple_identical_resources
        - Code to create multiple resources with identical properties
    - 05_multiple_different_resources
        - Code to create multiple resources with different properties
    - 06_multi_diff_resources_with_nested_objects
        - Code to create multiple resources with different nested properties.
    - 07_separate_files
        - Code in separate files
    - 08_modules
        - Code with Modules


Demo x: Create multiple resources of same type with similar properties:

terraform.tfvars
istest = true

variable "istest" {}

resource "aws_instance" "dev" {
	instance_type = "t2.micro"
	count = var.istest == true ? 2 : 0   # Create 2 instances when istest variable is true.
}

resource "aws_instance" "prod" {
	instance_type = "t2.large"
	count = var.istest == false ? 2 : 0 # Create 2 instances when istest variable is false.
}


---

# Terraform Pitfalls?
- Import existing resources
- Statefile pitfalls


---
# Terraform Cloud vs Terraform CLI
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

TF Cloud:
- It manages Terraform runs in a consistent and reliable environment
- includes easy access to shared state and secret data
- access controls for approving changes to infrastructure
- a private registry for sharing Terraform modules
- detailed policy controls for governing the contents of Terraform configurations, and more.


- Options to Interact with Terraform Cloud:
    - [GUI](https://app.terraform.io/)
    - [API calls](https://www.terraform.io/cloud-docs/api-docs)
    - [Terraform Cloud/Enterprise Provider](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs)



---
Miscellanious

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


---
# Documentation
[Terraform](https://www.terraform.io)
[Providers](https://registry.terraform.io/browse/providers)