# azure-lb-demo

This is sample terraform project for azure load balancer creation and backend VM association to the LB pool.
This can be used for scenarios that backend VMs have already been created and load balancers are needed for providing internal and external endpoints. 

You can add lb list with name and list of VM network interface with ip configuration name as below. For internal lb, you need to enter subnet ID and private IP address for the load balancer frontend as well.

```
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
```

This terraform demo uses "for expression" syntax and "flatten" funciton. Refer below: 
1. "for expression" reference: https://www.terraform.io/docs/configuration/expressions.html#for-expressions
"The source value can also be an object or map value, in which case two temporary variable names can be provided to access the keys and values respectively"

2. "flatten" function: https://www.terraform.io/docs/configuration/functions/flatten.html




