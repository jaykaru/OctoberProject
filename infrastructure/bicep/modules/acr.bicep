param location string = resourceGroup().location
@minLength(5)
@maxLength(50)
@description('Globally unique, alphanumeric only.')
param acrName string = 'acraks${uniqueString(resourceGroup().id)}'
@allowed([
  'Basic'
  'Standard'
  'Premium'
])
param sku string = 'Premium'
param tags object = {}

resource acr 'Microsoft.ContainerRegistry/registries@2023-07-01' = {
  name: acrName
  location: location
  tags: tags
  sku: {
    name: sku
  }
  properties: {
    adminUserEnabled: false
    // Switch to Disabled once the private endpoint is in place.
    publicNetworkAccess: 'Enabled'
  }
}

output acrId string = acr.id
output acrName string = acr.name
output acrLoginServer string = acr.properties.loginServer
