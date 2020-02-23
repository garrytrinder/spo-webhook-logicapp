[CmdletBinding()]
param (
    [Parameter(Mandatory = $true)]
    [string]
    $name,
    [Parameter(Mandatory = $true)]
    [string]
    $location
)

az group create --name $name --location $location -o none