$params = @{
    resourcegroupname  = "<rg-ss2020-webhook-dev>";
    location           = "<uksouth>";
    storageaccountname = "<stss2020webhookdata001>";
    logicappname       = "<la-ss2020-webhook-dev>";
    o365tenantdomain   = "<contoso.com>"
}

./deploy-azure.ps1 @params