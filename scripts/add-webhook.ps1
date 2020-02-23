[CmdletBinding()]
param (
    [Parameter(Mandatory = $true)]
    [string]
    $weburl,
    [Parameter(Mandatory = $true)]
    [string]
    $notificationurl,
    [Parameter(Mandatory = $true)]
    [string]
    $listtitle,
    [Parameter(Mandatory = $true)]
    [string]
    $clientstate
)

o365 spo list webhook add --webUrl $weburl --notificationUrl $notificationurl --listTitle $listtitle --clientState $clientstate