
## Getting start

### Prepare to Terraform

Create Resource Group and Azure Blob Storage to store terraform remote state.

```zsh
REGION="japaneast"
ENV="demo"
az deployment sub create --template-file ./tfstate/main.bicep --parameters @./tfstate/${ENV}/parameters.json --location $REGION
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 3.42 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 3.42.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_resource_group.aks](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_env"></a> [env](#input\_env) | Specify the environment. | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | Specify Azure region. | `string` | `"japaneast"` | no |
| <a name="input_service"></a> [service](#input\_service) | Specify the service name. | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->