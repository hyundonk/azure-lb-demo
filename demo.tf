
module "externalLB" {
  source                = "./ext_lb"
  
  lb                    = var.ext_lb 
  location              = var.location
  resource_group_name   = var.resource_group_name
}

module "internalLB" {
  source                = "./int_lb"
  
  lb                    = var.int_lb 
  location              = var.location
  resource_group_name   = var.resource_group_name
}
