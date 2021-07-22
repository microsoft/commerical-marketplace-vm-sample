$var_file='demo-linux-variables.json'
$packer_file='demo-linux.pkr.hcl'
$file_data = Get-Content $var_file
$config = $file_data | ConvertFrom-Json 

$account_id=$config.account_id
$azure_subscription_id=$config.azure_subscription_id
$resource_group_name=$config.resource_group_name
$resource_group_location=$config.resource_group_location
$azure_shared_image_gallery=$config.azure_shared_image_gallery
$image_name = $config.image_name
$image_description = $config.image_description

Write-Host "Logging in"

az login --service-principal -u $config.service_principal_app_id_uri -p $config.service_principal_client_secret --tenant $config.service_principal_tenant_id
az account get-access-token
$accountJson = az account get-access-token | ConvertFrom-Json
Write-Host $accountJson.accessToken 
 
Connect-AzAccount -AccessToken $accountJson.accessToken -AccountId $account_id 
Select-AzSubscription $azure_subscription_id

# This is an upsert. All ok.
New-AzResourceGroup -Name $resource_group_name -Location $resource_group_location -Force

Write-Host "Looking for shared image gallery $azure_shared_image_gallery. An error here is OK, we will create the account."
$gallery = Get-AzGallery -ResourceGroupName $resource_group_name -Name $azure_shared_image_gallery

if ($null -eq $gallery){
    Write-Host "Creating shared image gallery $azure_shared_image_gallery in $resource_group_name/$resource_group_location"
    $gallery = New-AzGallery -Location $resource_group_location `
                                        -ResourceGroupName $resource_group_name `
                                        -Name $azure_shared_image_gallery

    
}

$params = @{
    galleryName = $azure_shared_image_gallery
    galleryImageDefinitionName = $image_name
    description = $image_description
    location = $resource_group_location
    publisher = $config.this_publisher
    offer = $config.this_offer
    sku = $config.this_sku
}

Write-Host "Creating the image definition"

New-AzResourceGroupDeployment -ResourceGroupName $resource_group_name `
     -TemplateFile .\image_definition.json `
     -Mode Incremental `
     -TemplateParameterObject $params


$current_directory = Get-Location
$path = $current_directory.Path
Write-Host "Building packer image"
packer build -var-file="$path\$var_file" -force "$path\$packer_file"