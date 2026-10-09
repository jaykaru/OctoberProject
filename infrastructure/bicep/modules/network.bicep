targetScope = 'resourceGroup'

param location string = resourceGroup().location
param vnetName string = 'vnet-aks'
param vnetAddressPrefix string = '10.0.0.0/16'
param aksSubnetPrefix string = '10.0.1.0/24'
param privateEndpointSubnetPrefix string = '10.0.2.0/24'
param managementSubnetPrefix string = '10.0.3.0/24'
param tags object = {}

resource vnet 'Microsoft.Network/virtualNetworks@2023-11-01' = {
  name: vnetName
  location: location
  tags: tags
  properties: {
    addressSpace: {
      addressPrefixes: [
        vnetAddressPrefix
      ]
    }
    subnets: [
      {
        name: 'snet-aks'
        properties: {
          addressPrefix: aksSubnetPrefix
        }
      }
      {
        name: 'snet-private-endpoints'
        properties: {
          addressPrefix: privateEndpointSubnetPrefix
          privateEndpointNetworkPolicies: 'Enabled'
        }
      }
      {
        name: 'snet-management'
        properties: {
          addressPrefix: managementSubnetPrefix
        }
      }
    ]
  }
}

output vnetId string = vnet.id
output vnetName string = vnet.name
output aksSubnetId string = resourceId('Microsoft.Network/virtualNetworks/subnets', vnet.name, 'snet-aks')
output privateEndpointSubnetId string = resourceId('Microsoft.Network/virtualNetworks/subnets', vnet.name, 'snet-private-endpoints')
output managementSubnetId string = resourceId('Microsoft.Network/virtualNetworks/subnets', vnet.name, 'snet-management')
