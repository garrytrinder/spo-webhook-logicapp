$params = Get-Content -Path ./deploy.json | ConvertFrom-Json -AsHashtable

./deploy-azure.ps1 @params