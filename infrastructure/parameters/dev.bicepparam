using '../bicep/main.bicep'

param environment = 'dev'
param location = 'francecentral'
param regionShort = 'frc'
param instance = '001'
param workloadName = 'retailportal'
param tags = {
  project: 'OctoberProject'
}

param vnetAddressPrefix = '10.0.0.0/16'
param aksSubnetPrefix = '10.0.1.0/24'
param privateEndpointSubnetPrefix = '10.0.2.0/24'
param managementSubnetPrefix = '10.0.3.0/24'

param logRetentionInDays = 30
param acrSku = 'Premium'
param kubernetesVersion = '1.35'
param aksSystemNodeVmSize = 'Standard_D2s_v6'
param aksSystemNodeCount = 3
