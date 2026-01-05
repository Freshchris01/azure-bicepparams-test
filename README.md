# Azure Bicep Parameters Test with GitHub Actions

This repository demonstrates how to deploy Azure resources using Bicep with `.bicepparam` files via GitHub Actions using OIDC authentication.

## Files

- `main.bicep` - Bicep template that creates a resource group at subscription scope
- `main.bicepparam` - Parameter file containing resource group name and location
- `.github/workflows/deploy.yml` - GitHub Actions workflow for deployment

## Setup

### 1. Configure Azure OIDC

Set up OIDC authentication for your GitHub repository. You'll need:

```bash
az ad app create --display-name "github-oidc-bicepparam-test"
# Note the Application (client) ID

az ad app federated-credential create \
  --id <APP_ID> \
  --parameters '{
    "name": "github-federated",
    "issuer": "https://token.actions.githubusercontent.com",
    "subject": "repo:<YOUR_ORG>/<YOUR_REPO>:ref:refs/heads/main",
    "audiences": ["api://AzureADTokenExchange"]
  }'

# Create service principal and assign subscription contributor role
az ad sp create --id <APP_ID>
az role assignment create --assignee <APP_ID> --role Contributor --scope /subscriptions/<SUBSCRIPTION_ID>
```

### 2. Configure GitHub Secrets

Add these secrets to your repository (Settings > Secrets and variables > Actions):

- `AZURE_CLIENT_ID` - Application (client) ID
- `AZURE_TENANT_ID` - Your Azure tenant ID
- `AZURE_SUBSCRIPTION_ID` - Your Azure subscription ID

### 3. Run the Workflow

1. Go to Actions tab in GitHub
2. Select "Deploy Bicep with BicepParam" workflow
3. Click "Run workflow"

## What Gets Deployed

The workflow deploys a resource group named `rg-bicepparam-test` in `eastus` region using the parameters from `main.bicepparam`.

## Verify Parameter Usage

Check the deployment in Azure Portal or via CLI:

```bash
az deployment sub show --name bicepparam-test-<RUN_NUMBER> --query properties.parameters
```

This shows how parameters were passed from the `.bicepparam` file to the deployment.
