
module "internalLB" {
  source                = "./ext_lb"
  
  lb                    = var.ext_lb 
  location              = var.location
  resource_group_name   = var.resource_group_name
}

