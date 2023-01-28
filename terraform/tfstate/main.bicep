// parameters
@description('Specify the service name.')
param service string

@description('Specify the environment.')
param env string

@description('Specify Azure region.')
param region string = 'japaneast'

// variables
var resource_name_prefix = '${toLower(service)}-${toLower(env)}'

// Scope definition
targetScope = 'subscription'

// resource definition
/*
  resource group
*/
resource tfstate_rg 'Microsoft.Resources/resourceGroups@2022-09-01' = {
  name: '${resource_name_prefix}-tfstate'
  location: region
  tags: {
    Service: service
    Env: env
  }
  managedBy: 'string'
  properties: {}
}

/*
  blob storage for terraform state
*/
module tfstate_storage 'modules/storage_account.bicep' = {
  scope: resourceGroup(tfstate_rg.name)
  name: 'tfstate_storage'

  params: {
    service: service
    env: env
    region: region
  }
}
