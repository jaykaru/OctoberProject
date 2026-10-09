using '../bicep/main.bicep'

param environment = 'prod'
param location = 'francecentral'
param regionShort = 'frc'
param instance = '001'
param workloadName = 'retailportal'
param tags = {
  project: 'OctoberProject'
}

// Separate range from dev so the VNets can be peered later.
param vnetAddressPrefix = '10.1.0.0/16'
param aksSubnetPrefix = '10.1.1.0/24'
param privateEndpointSubnetPrefix = '10.1.2.0/24'
param managementSubnetPrefix = '10.1.3.0/24'

param logRetentionInDays = 90
param acrSku = 'Premium'
param kubernetesVersion = '1.35'
// Regional quota is 10 vCPUs; move to Standard_D4s_v6 after a quota increase.
param aksSystemNodeVmSize = 'Standard_D2s_v6'
param aksSystemNodeCount = 3
