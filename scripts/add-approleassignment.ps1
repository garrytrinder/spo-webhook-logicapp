[CmdletBinding()]
param (
    [Parameter(Mandatory = $true)]
    [string]
    $tenantdomain,
    [Parameter(Mandatory = $true)]
    [string]
    $managedidentityname,
    [Parameter(Mandatory = $true)]
    [string]
    $serviceprincipalname,
    [Parameter(Mandatory = $true)]
    [string]
    $approlename
)

$spo = az ad sp list --display-name $serviceprincipalname --query "{ AppRoleId: [0] .appRoles [?value=='$approlename'].id | [0], ObjectId:[0] .objectId }" -o json | ConvertFrom-Json

$msi = az ad sp list --display-name $managedidentityname --query "{ ObjectId: [0] .objectId }" -o json | ConvertFrom-Json

$assignments = az rest -m get -u "https://graph.windows.net/$tenantdomain/servicePrincipals/$($msi.ObjectId)/appRoleAssignedTo?api-version=1.6" -o json | ConvertFrom-Json

$hasAssignment = $false
$assignments | ForEach-Object {
    if($_.value.id -eq $spo.AppRoleId) { $hasAssignment = $true }
}

if($hasAssignment -ne $true){    
    $body = @{ 
        "id"          = $spo.AppRoleId; 
        "principalId" = $msi.ObjectId; 
        "resourceId"  = $spo.ObjectId 
    } | ConvertTo-Json -Compress
    
    $body = $body.Replace('"', '\"')
    
    # create role assignment
    az rest -m post -u "https://graph.windows.net/$tenantdomain/servicePrincipals/$($msi.ObjectId)/appRoleAssignments?api-version=1.6" -b "$body" -o none
}