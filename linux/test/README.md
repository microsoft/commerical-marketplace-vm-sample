# Checking Azure Instance Management Service

PowerShell:

``` PowerShell
Invoke-RestMethod -Headers @{"Metadata"="true"} -Method GET -Uri http://169.254.169.254/metadata/instance?api-version=2020-06-01 -OutFile .\data.json

Get-Content .\data.json | ConvertFrom-Json | ConvertTo-Json -Depth 100
```

Bash:

``` bash
# Make sure jq is installed
# Yum:
# sudo yum install jq

# Apt:
# sudo apt install jq

curl -H Metadata:true --noproxy "*" "http://169.254.169.254/metadata/instance?api-version=2020-09-01" | jq
```

# Running self test

Make sure you have the GUID for a App Registration (aka Service Principal) and the associated secret.

First, acquire an access_token:

``` bash
curl --location --request POST 'https://login.microsoftonline.com/{TENANT_ID}/oauth2/token' \
--header 'Content-Type: application/x-www-form-urlencoded' \
--data-urlencode 'grant_type=client_credentials' \
--data-urlencode 'client_id={CLIENT_ID} ' \
--data-urlencode 'client_secret={CLIENT_SECRET}' \
--data-urlencode 'resource=https://management.core.windows.net'
```

Then, copy the access_token element from the JWT and use it here:

``` bash
curl --location --request POST 'https://isvapp.azurewebsites.net/selftest-vm' \
--header 'Content-Type: application/json' \
--header 'Authorization: Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJS…' \
--data-raw '{
    "DNSName": "avvm1.eastus.cloudapp.azure.com",
    "UserName": "azureuser",
    "Password": "SECURE_PASSWORD_FOR_THE_SSH_INTO_VM",
    "OS": "Linux",
    "PortNo": "22",
    "CompanyName": "COMPANY_NAME",
    "AppId": "CLIENT_ID_SAME_AS_USED_FOR_AAD_TOKEN ",
    "TenantId": "TENANT_ID_SAME_AS_USED_FOR_AAD_TOKEN"
}'
```