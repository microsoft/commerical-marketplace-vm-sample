. "$env:SystemRoot\System32\Sysprep\Sysprep.exe" /oobe /generalize /quiet /quit
$startTime=(Get-Date).ToUniversalTime()
$now=(Get-Date).ToUniversalTime()

while(($now - $startTime).TotalMinutes -lt 30) { 
    $imageState = Get-ItemProperty HKLM:\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Setup\\State | Select ImageState; 
    if($imageState.ImageState -ne 'IMAGE_STATE_GENERALIZE_RESEAL_TO_OOBE') { 
        Write-Output $imageState.ImageState; Start-Sleep -s 10  
    } else { 
        break 
    } 
    $now=(Get-Date).ToUniversalTime()
}