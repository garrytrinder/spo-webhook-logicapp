[CmdletBinding()]
param (
    [Parameter(Mandatory = $true)]
    [string]
    $storageaccountname,
    [Parameter(Mandatory = $true)]
    [string]
    $resourcegroupname,
    [Parameter(Mandatory = $true)]
    [string]
    $location
)

az storage account create --name $storageaccountname --resource-group $resourcegroupname --location $location --sku Standard_LRS -o none