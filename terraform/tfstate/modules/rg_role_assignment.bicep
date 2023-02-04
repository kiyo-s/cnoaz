@description('Specify Principal ID to whom resource group role will be assignment.')
param principalId string

@description('Specify Principal Type of Principal ID.')
param principalType string

@description('Specify the RBAC role definition ID to be assigned to specified principal. Default value is `Storage Blob Data Contributor`.')
param roleDefinitionId string

var roleAssignmentName = guid(resourceGroup().id, principalId, roleDefinitionId)

resource roleDefinition 'Microsoft.Authorization/roleDefinitions@2022-04-01' existing = {
  scope: subscription()
  name: roleDefinitionId
}

resource tfstate_rg_role_assignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: roleAssignmentName
  scope: resourceGroup()
  properties: {
    principalId: principalId
    principalType: principalType
    roleDefinitionId: roleDefinition.id
  }
}

output roleAssignmentNameValue string = roleAssignmentName
output roleDefinitionIdValue string = roleDefinition.id
