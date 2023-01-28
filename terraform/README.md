
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

No requirements.

## Providers

No providers.

## Modules

No modules.

## Resources

No resources.

## Inputs

No inputs.

## Outputs

No outputs.
<!-- END_TF_DOCS -->