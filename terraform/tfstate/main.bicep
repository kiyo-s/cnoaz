/* parameters */
// common parameters
@description('Specify the service name.')
param service string

@description('Specify the environment.')
param env string

@description('Specify Azure region.')
param region string = 'japaneast'

@description('Specify suffix the deployed name of the module. Default value is UTC time at the time the deployment is executed.')
param deploymentSuffix string = utcNow()

// resource group parameters
@description('Specify Principal ID to whom resource group role will be assignment.')
param principalId string

@description('Specify Principal Type of Principal ID.')
@allowed([
  'Device'
  'ForeignGroup'
  'Group'
  'ServicePrincipal'
  'User'
])
param principalType string

@description('Specify the RBAC role definition ID to be assigned to specified principal. Default value is `Storage Blob Data Contributor`.')
param roleDefinitionId string = 'ba92f5b4-2d11-453d-a403-e96b0029c9fe'

// storage parameters
@description('Specify IP Address or CIDR list')
param allowIplist array

/* variables */
var resourceNamePrefix = '${toLower(service)}-${toLower(env)}'
var tagUsage = 'terraform_remote_state'

/* resource definitions */
targetScope = 'subscription'

//  resource group
resource tfstate_rg 'Microsoft.Resources/resourceGroups@2022-09-01' = {
  name: '${resourceNamePrefix}-tfstate'
  location: region
  tags: {
    Service: service
    Env: env
    Usage: tagUsage
  }
  managedBy: 'string'
  properties: {}
}

module tfstate_rg_role_assignment 'modules/rgRoleAssignment.bicep' = {
  scope: resourceGroup(tfstate_rg.name)
  name: 'tfstate-rg-role-assignment-${deploymentSuffix}'

  params: {
    principalId: principalId
    principalType: principalType
    roleDefinitionId: roleDefinitionId
  }
}

// storage for terraform remote state
module tfstate_storage 'modules/storageAccount.bicep' = {
  scope: resourceGroup(tfstate_rg.name)
  name: 'tfstate-storage-${deploymentSuffix}'

  params: {
    service: service
    env: env
    region: region
    tagUsage: tagUsage
    allowIplist: allowIplist
  }
}
