targetScope = 'subscription'

@description('Name of the resource group')
param resourceGroupName string

@description('Location for the resource group')
param location string

resource rg 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: resourceGroupName
  location: location
}

output resourceGroupId string = rg.id
output resourceGroupName string = rg.name
