$variables = @{}

foreach($line in Get-Content .\variables.conf ){
    if ($line.StartsWith('#')){
        continue
    }

    $eqIndex = $line.IndexOf('=')
    if ($eqIndex -lt 1){
        continue
    }
    $key = $line.Substring(0, $eqIndex)
    $value = $line.Substring($eqIndex + 1)
    
    $variables[$key] = $value
}

$resource_group_name=$variables.base_name + "rg"
$vm_name=$variables.base_name + "vm"
$os_disk_name = $vm_name + "-osdisk1"

az login
$accountJson = az account get-access-token | ConvertFrom-Json

Connect-AzAccount -AccessToken $accountJson.accessToken -AccountId $variables.account_id 
Select-AzSubscription $variables.azure_subscription_id

$vm = (Get-AzVM -ResourceGroupName $resource_group_name -Name $vm_name)

if (-not($null -eq $vm)){
    Remove-AzVM -ResourceGroupName $resource_group_name -Name $vm_name
    Remove-AzDisk -ResourceGroupName $resource_group_name -DiskName $os_disk_name
}

$subId = $variables.azure_subscription_id
$baseName = $variables.base_name
$location = $variables.resource_group_location
$image_uri = $variables.image_uri
$admin_username=$variables.admin_username
$admin_password=$variables.admin_password
$vm_sku=$variables.vm_sku

if ($False -eq (Test-Path .\.terraform)) {
    terraform init
}

terraform apply -auto-approve -var="azure_subscription_id=$subId" `
                              -var="base_name=$baseName" `
                              -var="location=$location" `
                              -var="image_uri=$image_uri" `
                              -var="admin_username=$admin_username" `
                              -var="admin_password=$admin_password" `
                              -var="vm_sku=$vm_sku"

