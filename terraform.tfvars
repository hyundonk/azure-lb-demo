# input variables 

resource_group_name   = "rg-demo"
location              = "koreacentral"

ext_lb  = {
  0         = {
    name = "lb-prd-web-pp-app1"
    backend_address_pool_associations = [
      {
        network_interface_id  = "/subscriptions/aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee/resourceGroups/myresourcegroup/providers/Microsoft.Network/networkInterfaces/app1vm001-nic"
        ip_configuration_name = "ipconfig0"   
      }, 
      {
        network_interface_id  = "/subscriptions/aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee/resourceGroups/myresourcegroup/providers/Microsoft.Network/networkInterfaces/app1vm002-nic"
        ip_configuration_name = "ipconfig0"   
      } 
    ]
  }
  1         = {
    name = "lb-prd-web-pp-app2"
    backend_address_pool_associations = [
      {
        network_interface_id  = "/subscriptions/aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee/resourceGroups/myresourcegroup/providers/Microsoft.Network/networkInterfaces/app2vm001-nic"
        ip_configuration_name = "ipconfig0"   
      }, 
      {
        network_interface_id  = "/subscriptions/aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee/resourceGroups/myresourcegroup/providers/Microsoft.Network/networkInterfaces/app2vm002-nic"
        ip_configuration_name = "ipconfig0"   
      } 
    ]
  }
}

int_lb  = {
  0         = {
    name        = "lb-prd-web-pp-app1-int"
    subnet_id   = "/subscriptions/aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee/resourceGroups/myresourcegroup/providers/Microsoft.Network/virtualNetworks/myvnet/subnets/frontend"
    ip_address = "10.10.0.10"

    backend_address_pool_associations = [
      {
        network_interface_id  = "/subscriptions/aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee/resourceGroups/myresourcegroup/providers/Microsoft.Network/networkInterfaces/app1vm001-nic"
        ip_configuration_name = "ipconfig1"   
      }, 
      {
        network_interface_id  = "/subscriptions/aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee/resourceGroups/myresourcegroup/providers/Microsoft.Network/networkInterfaces/app1vm002-nic"
        ip_configuration_name = "ipconfig1"   
      } 
    ]
  }
}


