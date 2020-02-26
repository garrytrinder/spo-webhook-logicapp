[CmdletBinding()]
param (
    [Parameter(Mandatory = $true)]
    [string]
    $resourcegroupname,
    [Parameter(Mandatory = $true)]
    [string]
    $location,
    [Parameter(Mandatory = $true)]
    [string]
    $storageaccountname,
    [Parameter(Mandatory = $true)]
    [string]
    $logicappname,
    [Parameter(Mandatory = $true)]
    [string]
    $o365tenantdomain
)

Write-Host @"
________  ________  ________  _________  _________  ___  ________  ___  ___     
|\   ____\|\   ____\|\   __  \|\___   ___\\___   ___\\  \|\   ____\|\  \|\  \    
\ \  \___|\ \  \___|\ \  \|\  \|___ \  \_\|___ \  \_\ \  \ \  \___|\ \  \\\  \   
 \ \_____  \ \  \    \ \  \\\  \   \ \  \     \ \  \ \ \  \ \_____  \ \   __  \  
  \|____|\  \ \  \____\ \  \\\  \   \ \  \     \ \  \ \ \  \|____|\  \ \  \ \  \ 
    ____\_\  \ \_______\ \_______\   \ \__\     \ \__\ \ \__\____\_\  \ \__\ \__\
   |\_________\|_______|\|_______|    \|__|      \|__|  \|__|\_________\|__|\|__|
   \|_________|                                             \|_________|         
                                                                                 
                                                                                 
        ________  ___  ___  _____ ______   _____ ______   ___  _________         
       |\   ____\|\  \|\  \|\   _ \  _   \|\   _ \  _   \|\  \|\___   ___\       
       \ \  \___|\ \  \\\  \ \  \\\__\ \  \ \  \\\__\ \  \ \  \|___ \  \_|       
        \ \_____  \ \  \\\  \ \  \\|__| \  \ \  \\|__| \  \ \  \   \ \  \        
         \|____|\  \ \  \\\  \ \  \    \ \  \ \  \    \ \  \ \  \   \ \  \       
           ____\_\  \ \_______\ \__\    \ \__\ \__\    \ \__\ \__\   \ \__\      
          |\_________\|_______|\|__|     \|__|\|__|     \|__|\|__|    \|__|      
          \|_________|                                                           
                                                                                 
                                                                                 
                     _______  ________    _______  ________                      
                    /  ___  \|\   __  \  /  ___  \|\   __  \                     
                   /__/|_/  /\ \  \|\  \/__/|_/  /\ \  \|\  \                    
                   |__|//  / /\ \  \\\  \__|//  / /\ \  \\\  \                   
                       /  /_/__\ \  \\\  \  /  /_/__\ \  \\\  \                  
                      |\________\ \_______\|\________\ \_______\                 
                       \|_______|\|_______| \|_______|\|_______|                 
                                                                                                                                                                                                                                                                                                         
"@ -ForegroundColor Magenta

Write-Host "Creating resource group... " -ForegroundColor DarkMagenta
$resourcegroup = @{
    name     = $resourcegroupname
    location = $location
}
./scripts/add-resourcegroup.ps1 @resourcegroup

Write-Host "Creating storage account... " -ForegroundColor Magenta
$storageaccount = @{
    storageaccountname = $storageaccountname;
    resourcegroupname  = $resourcegroupname;
    location           = $location
}
./scripts/add-storageaccount.ps1 @storageaccount

Write-Host "Creating table storage... " -ForegroundColor DarkMagenta
$tablestorage = @{
    storageaccountname = $storageaccountname;
    tablename          = "changeToken"
}
./scripts/add-tablestorage.ps1 @tablestorage 

Write-Host "Creating logic app and connections... " -ForegroundColor Magenta
az group deployment create -g $resourcegroupname -o none --template-file ./templates/azuredeploy.json  --parameters storageAccountName=$storageaccountname logicAppName=$logicappname

#Sleep a little whilst the managed identity gets created
Start-Sleep -Seconds 5

Write-Host "Assigning 'Sites.ReadWrite.All' application role to Managed Identity... " -ForegroundColor DarkMagenta
$approleassignment = @{
    tenantdomain         = $o365tenantdomain;
    managedidentityname  = $logicappname;
    serviceprincipalname = "Office 365 SharePoint Online";
    approlename          = "Sites.ReadWrite.All"
} 
./scripts/add-approleassignment.ps1 @approleassignment

Write-Host "Done ✅" -ForegroundColor Green