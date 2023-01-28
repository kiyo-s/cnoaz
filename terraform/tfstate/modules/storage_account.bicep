// parameters
@description('Specify the service name.')
param service string

@description('Specify the environment.')
param env string

@description('Specify Azure region.')
param region string = 'japaneast'

@description('Specify IP Address or CIDR list.')
param allow_ip_list array

// variables
var resource_name_prefix = '${toLower(service)}${toLower(env)}'
var network_acls_ip_rules = [for allow_ip in allow_ip_list: {
  value: allow_ip
}]

// resources
resource tfstate_storage_account 'Microsoft.Storage/storageAccounts@2022-05-01' = {
  name: '${resource_name_prefix}tfstate'
  location: region
  tags: {
    Service: service
    Env: env
    Usage: 'terraform_remote_state'
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
      ipRules: network_acls_ip_rules
    }
  }
}

resource tfstate_blob 'Microsoft.Storage/storageAccounts/blobServices@2022-05-01' = {
  name: 'default'
  parent: tfstate_storage_account
  properties: {
    isVersioningEnabled: true
  }
}

resource tfstate_blob_container 'Microsoft.Storage/storageAccounts/blobServices/containers@2022-05-01' = {
  name: 'tfstate'
  parent: tfstate_blob
  properties: {
    metadata: {
      Service: service
      Env: env
      Usage: 'terraform_remote_state'
    }
    publicAccess: 'None'
  }
}
