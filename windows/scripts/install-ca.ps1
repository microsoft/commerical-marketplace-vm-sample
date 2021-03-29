# see https://docs.microsoft.com/en-us/powershell/module/adcsdeployment/install-adcscertificationauthority?view=win10-ps
# for information on other options for installing a CA on Windows.

Install-WindowsFeature Adcs-Cert-Authority
Install-AdcsCertificationAuthority -CAType StandaloneRootCa -Force
Add-WindowsFeature Adcs-Web-Enrollment
Install-AdcsWebEnrollment -Force
