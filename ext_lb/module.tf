
locals {
  frontend_ipconfig_name   = "frontend-ipconfig"
}
 
resource "azurerm_public_ip" "public_ip" {
  for_each              = var.lb

  name                  = "${each.value.name}-pip"
  location              = var.location
  resource_group_name   = var.resource_group_name

	allocation_method     = "Static"
  sku                   = "Standard"
}

resource "azurerm_lb" "lb" {
  for_each              = var.lb

  name                  = each.value.name
  location              = var.location
  resource_group_name   = var.resource_group_name

  sku = "Standard"

  frontend_ip_configuration  {
    name                  = local.frontend_ipconfig_name
    public_ip_address_id  = azurerm_public_ip.public_ip[each.key].id
  }
}

resource "azurerm_lb_probe" "http" {
  for_each              = var.lb
  
  resource_group_name   = var.resource_group_name

  loadbalancer_id       = azurerm_lb.lb[each.key].id
  name                  = "${azurerm_lb.lb[each.key].name}-probe-http"
  
  protocol              = "Http"
  port                  = 80
  request_path          ="/"

  interval_in_seconds   = 5
  number_of_probes      = 2
}

resource "azurerm_lb_probe" "https" {
  for_each              = var.lb
  
  resource_group_name   = var.resource_group_name

  loadbalancer_id       = azurerm_lb.lb[each.key].id
  name                  = "${azurerm_lb.lb[each.key].name}-probe-https"
  
  protocol              = "Https"
  port                  = 443
  request_path          ="/"

  interval_in_seconds   = 5
  number_of_probes      = 2
}

resource "azurerm_lb_backend_address_pool" "lb" {
  for_each              = var.lb
  
  resource_group_name   = var.resource_group_name
  loadbalancer_id       = azurerm_lb.lb[each.key].id
  name                  = "${azurerm_lb.lb[each.key].name}-backendpool"
}

resource "azurerm_lb_rule" "https" {
  for_each              = var.lb

  resource_group_name   = var.resource_group_name
  loadbalancer_id       = azurerm_lb.lb[each.key].id
 
  name                  = "https"

  protocol                        = "Tcp"
  frontend_port                   = 443
  backend_port                    = 443

  frontend_ip_configuration_name  = local.frontend_ipconfig_name

  backend_address_pool_id         = azurerm_lb_backend_address_pool.lb[each.key].id
  probe_id                        = azurerm_lb_probe.http[each.key].id

  enable_floating_ip              = true
  idle_timeout_in_minutes         = 4
  load_distribution               = "Default" 

  disable_outbound_snat           = true
}


resource "azurerm_lb_rule" "http" {
  for_each              = var.lb

  resource_group_name   = var.resource_group_name
  loadbalancer_id       = azurerm_lb.lb[each.key].id
  
  name                  = "http"
 
  protocol                        = "Tcp"
  frontend_port                   = 80
  backend_port                    = 80

  frontend_ip_configuration_name  = local.frontend_ipconfig_name

  backend_address_pool_id         = azurerm_lb_backend_address_pool.lb[each.key].id
  probe_id                        = azurerm_lb_probe.http[each.key].id

  enable_floating_ip              = true
  idle_timeout_in_minutes         = 4
  load_distribution               = "Default"

  disable_outbound_snat           = true
}

locals {
  backend_address_pool_associations_map = flatten([
    for lb_key, lb in var.lb : [
      for association_key, association in lb.backend_address_pool_associations : {
        "${lb.name}-${association_key}" = {
          network_interface_id    = association.network_interface_id
          ip_configuration_name   = association.ip_configuration_name
          backend_address_pool_id = azurerm_lb_backend_address_pool.lb[lb_key].id
        }
      }
    ]
  ])

  associations_map = {
    for item in local.backend_address_pool_associations_map:
      keys(item)[0] => values(item)[0]
  }
}

resource "azurerm_network_interface_backend_address_pool_association" "lb" {
  for_each                = local.associations_map

  network_interface_id    = each.value.network_interface_id
  ip_configuration_name   = each.value.ip_configuration_name
  backend_address_pool_id = each.value.backend_address_pool_id
}

