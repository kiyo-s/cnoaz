// parameters
@description('Specify the service name.')
param service string

@description('Specify the environment.')
param env string

@description('Specify Azure region.')
param region string = 'japaneast'

// variables
var resource_name_prefix = '${toLower(service)}${toLower(env)}'

// resources
resource tfstate_storage_account 'Microsoft.Storage/storageAccounts@2022-09-01' = {
  name: '${resource_name_prefix}tfstate'
  location: region
  tags: {
    Service: service
    Env: env
  }
  sku: {
    name: 'Standard_GRS'
  }
  kind: 'BlobStorage'
  identity: {
    type: 'None'
  }
  properties: {
    accessTier: 'Hot'

    /*
    // Security Settings
    /// authentication
    allowSharedKeyAccess: false
    defaultToOAuthAuthentication: true

    /// storage encryption
    encryption: {
      keySource: 'Microsoft.Keyvault'
      keyvaultproperties: {
        keyname: ''
        keyvaulturi: ''
        keyversion: ''
      }
    }
    /// traffic encryption
    supportsHttpsTrafficOnly: true
    minimumTlsVersion: 'TLS1_2'
    /// network security
    allowBlobPublicAccess: true
    publicNetworkAccess: 'Enabled'
    networkAcls: {
      bypass: 'None'
      defaultAction: 'Deny'
      ipRules: []
    }

    // Availability Settings
    allowCrossTenantReplication: true
    */
  }
}
