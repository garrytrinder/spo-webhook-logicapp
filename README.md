# SharePoint Online Webhook Logic App

TODO: Add description

## Pre-requisities

- Azure CLI
- PowerShell

## Setup

- Update `<values>` in `deploy.ps1`
- Run `az login`
  - Log in with admin account
- Run `deploy.ps1`
- Go to Azure Portal
  - Navigate to Azure Logic App and copy the request url from the trigger
- Run `add-webhook.ps1` to create webhook
