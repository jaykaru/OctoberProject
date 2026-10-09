targetScope = 'subscription'

@allowed([
  'dev'
  'prod'
])
param environment string
param location string
param workloadName string
@description('Short region code used in resource names, e.g. frc for francecentral.')
param regionShort string
param instance string = '001'
param tags object = {}

param vnetAddressPrefix string
param aksSubnetPrefix string
param privateEndpointSubnetPrefix string
param managementSubnetPrefix string

param logRetentionInDays int
param acrSku string
param kubernetesVersion string
param aksSystemNodeVmSize string
param aksSystemNodeCount int

var baseName = '${workloadName}-${environment}-${regionShort}'
var resourceGroupName = 'rg-${baseName}-${instance}'
var allTags = union(tags, { environment: environment, workload: workloadName })

resource rg 'Microsoft.Resources/resourceGroups@2024-03-01' = {
  name: resourceGroupName
  location: location
  tags: allTags
}

module network 'modules/network.bicep' = {
  name: 'deploy-network-${environment}'
  scope: rg
  params: {
    location: location
    vnetName: 'vnet-${baseName}-${instance}'
    vnetAddressPrefix: vnetAddressPrefix
    aksSubnetPrefix: aksSubnetPrefix
    privateEndpointSubnetPrefix: privateEndpointSubnetPrefix
    managementSubnetPrefix: managementSubnetPrefix
    tags: allTags
  }
}

module monitoring 'modules/monitoring.bicep' = {
  name: 'deploy-monitoring-${environment}'
  scope: rg
  params: {
    location: location
    logAnalyticsName: 'log-${baseName}-${instance}'
    retentionInDays: logRetentionInDays
    tags: allTags
  }
}

module acr 'modules/acr.bicep' = {
  name: 'deploy-acr-${environment}'
  scope: rg
  params: {
    location: location
    acrName: 'acr${workloadName}${environment}${regionShort}${take(uniqueString(rg.id), 5)}'
    sku: acrSku
    tags: allTags
  }
}

module keyVault 'modules/keyvault.bicep' = {
  name: 'deploy-keyvault-${environment}'
  scope: rg
  params: {
    location: location
    keyVaultName: 'kv-${baseName}'
    tags: allTags
  }
}

module aks 'modules/aks.bicep' = {
  name: 'deploy-aks-${environment}'
  scope: rg
  params: {
    location: location
    aksName: 'aks-${baseName}-${instance}'
    kubernetesVersion: kubernetesVersion
    aksSubnetId: network.outputs.aksSubnetId
    logAnalyticsId: monitoring.outputs.logAnalyticsId
    acrName: acr.outputs.acrName
    systemNodeVmSize: aksSystemNodeVmSize
    systemNodeCount: aksSystemNodeCount
    tags: allTags
  }
}

output resourceGroupName string = rg.name
output aksName string = aks.outputs.aksName
output acrLoginServer string = acr.outputs.acrLoginServer
output keyVaultUri string = keyVault.outputs.keyVaultUri
