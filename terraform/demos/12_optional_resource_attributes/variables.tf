variable "iqn_pool" {
  type = list(object({
    Name             = string
    Description      = string
    Tags             = list(map(string))
    Organization     = map(string)
    Prefix           = string
    IqnSuffixBlocks = list(object({
      Suffix = string
      From = number
      Size = number
    }))
  }))
  default = []
}

variable "lan_conn" {
  type = list(object({
    Name              = string
    Description       = string
    Tags              = list(map(string))
    Organization      = map(string)
    TargetPlatform    = string
    AzureQosEnabled   = bool
    IqnAllocationType = string
    StaticIqnName     = string
    PlacementMode     = string
    IqnPool           = object({ Name = string})
  }))
  default = []
}