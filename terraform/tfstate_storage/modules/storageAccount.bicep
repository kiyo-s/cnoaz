// parameters
@description('Specify the service name.')
param service string

@description('Specify the environment.')
param env string

@description('Specify Azure region.')
param region string = 'japaneast'

@description('')
param tagUsage string

@description('Specify IP Address or CIDR list.')
param allowIplist array

// variables
var resourceNamePrefix = '${toLower(service)}${toLower(env)}'
var networkAclsIpRules = [for allowIp in allowIplist: {
  value: allowIp
}]

// resources
resource tfstateStorageAccount 'Microsoft.Storage/storageAccounts@2022-05-01' = {
  name: '${resourceNamePrefix}tfstate'
  location: region
  tags: {
    Service: service
    Env: env
    Usage: tagUsage
  }
  sku: {
    name: 'Standard_GRS'
  }
  kind: 'StorageV2'
  identity: {
    type: 'None'
  }
  properties: {
    accessTier: 'Hot'

    // Security Settings
    /// authentication
    allowSharedKeyAccess: false
    defaultToOAuthAuthentication: true

    /// storage encryption
    /*
    encryption: {
      keySource: 'Microsoft.Keyvault'
      keyvaultproperties: {
        keyname: ''
        keyvaulturi: ''
        keyversion: ''
      }
    }
    */

    /// traffic encryption
    supportsHttpsTrafficOnly: true
    minimumTlsVersion: 'TLS1_2'

    /// network security
    allowBlobPublicAccess: true
    publicNetworkAccess: 'Enabled'
    networkAcls: {
      bypass: 'None'
      defaultAction: 'Deny'
      ipRules: networkAclsIpRules
    }
  }
}

resource tfstateBlob 'Microsoft.Storage/storageAccounts/blobServices@2022-05-01' = {
  name: 'default'
  parent: tfstateStorageAccount
  properties: {
    isVersioningEnabled: true
  }
}

resource tfstateBlobContainer 'Microsoft.Storage/storageAccounts/blobServices/containers@2022-05-01' = {
  name: 'tfstate'
  parent: tfstateBlob
  properties: {
    metadata: {
      Service: service
      Env: env
      Usage: tagUsage
    }
    publicAccess: 'None'
  }
}
