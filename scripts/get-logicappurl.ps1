[CmdletBinding()]
param (
    [Parameter(Mandatory = $true)]
    [string]
    $resourcegroupname,
    [Parameter(Mandatory = $true)]
    [string]
    $logicappname
)

$subscriptionId = az account list --query '[?isDefault==`true`] | [0] .id'

$requestUrl = az rest -m post -u "https://management.azure.com/subscriptions/$subscriptionId/resourceGroups/$resourcegroupname/providers/Microsoft.Logic/workflows/$logicappname/triggers/manual/listCallbackUrl?api-version=2016-10-01" --query value

$requestUrl