# You can list all available features by calling Get-WindowsFeature
$featuresToInstall = @(
    "Web-Server",
    "Web-Default-Doc",
    "Web-Http-Errors",
    "Web-Static-Content",
    "Web-Http-Redirect",
    "Web-Http-Logging",
    "Web-Stat-Compression",
    "Web-Dyn-Compression",
    "Web-Filtering",
    "Web-Basic-Auth",
    "Web-CertProvider",
    "Web-Client-Auth",
    "Web-Digest-Auth",
    "Web-Cert-Auth",
    "Web-IP-Security",
    "Web-Url-Auth",
    "Web-Net-Ext45",
    "Web-AppInit",
    "Web-Asp-Net45",
    "Web-WebSockets",
    "Web-Mgmt-Console"
)

foreach ($feature in $featuresToInstall) {
    Write-Host "Installing " + $feature
    Install-WindowsFeature $feature
}
