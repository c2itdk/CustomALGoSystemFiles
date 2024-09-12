# install-module navcontainerhelper -force
# Login to Azure
# az login

# set accept_eula to $true to accept the eula found here: https://go.microsoft.com/fwlink/?linkid=861843
$accept_eula = $true

$containername = 'bcserver'
$artifactUrl = Get-BCArtifactUrl -type Sandbox -country dk -select Latest

$secpasswd = ConvertTo-SecureString "password" -AsPlainText -Force
$credential = New-Object System.Management.Automation.PSCredential ("admin", $secpasswd)
New-BcContainer -accept_eula:$true `
  -accept_outdated:$true `
  -containername $containername `
  -auth "NavUserPassword" `
  -Credential $credential `
  -alwaysPull `
  -doNotExportObjectsToText `
  -usessl:$false `
  -updateHosts `
  -assignPremiumPlan `
  -includePerformanceToolkit `
  -includeTestToolkit `
  -artifactUrl $artifactUrl `
  -shortcuts None `
  -includeAL 

# Prevent container from starting after reboot
docker update $containername --restart unless-stopped

Setup-NavContainerTestUsers -containerName $containername -credential $credential -password $credential.Password
