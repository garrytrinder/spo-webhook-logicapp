[CmdletBinding()]
param (
    [Parameter(Mandatory = $true)]
    [string]
    $storageaccountname,
    [Parameter(Mandatory = $true)]
    [string]
    $tablename
)

$key = az storage account keys list --account-name $storageaccountname --query "[0].value"

az storage table create --name $tablename --account-name $storageaccountname --account-key $key -o none