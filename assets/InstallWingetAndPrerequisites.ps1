# ----------------------------------------------------------------------
# This script contains portions of code from "winutil" by ChrisTitusTech
# Copyright (c) 2022 Chris Titus
# https://github.com/ChrisTitusTech/winutil
# 
# Licensed under the MIT License
# https://opensource.org/license/mit
# ----------------------------------------------------------------------

New-Item -Name "temp-install" -ItemType "directory"

Set-Location temp-install
$WorkingDirName = Split-Path -Path $PWD -Leaf -Resolve
if ($WorkingDirName -eq 'temp-install') {
    Remove-Item * -Recurse -Force
}
else {
	Write-Host ''
    Write-Host "!!!!!   ERROR   !!!!!" -ForegroundColor Red
    Write-Host "Something broke... This might not be an issue, but it PROBABLY is."
	Write-Host ''
	Start-Sleep -Seconds 5
	pause
	exit
}
Set-Location ..\


# ~ ~ ~ Get Winget Prerequisites ~ ~ ~

Write-Host "Downloading Winget Prerequsites`n"

# I don't know of a way to detect the prereqs automatically, so if someone has a better way of defining these, that would be great.
# Microsoft.VCLibs version rarely changes, but for future compatibility I made it a variable.
$versionVCLibs = "14.00"
$fileVCLibs = "https://aka.ms/Microsoft.VCLibs.x64.${versionVCLibs}.Desktop.appx"
# Write-Host "$fileVCLibs"
# Microsoft.UI.Xaml version changed recently, so I made the version numbers variables.
$versionUIXamlMinor = "2.8"
$versionUIXamlPatch = "2.8.6"
$fileUIXaml = "https://github.com/microsoft/microsoft-ui-xaml/releases/download/v${versionUIXamlPatch}/Microsoft.UI.Xaml.${versionUIXamlMinor}.x64.appx"
# Write-Host "$fileUIXaml"

Write-Host "Downloading Microsoft.VCLibs Dependency..."
Invoke-WebRequest -Uri $fileVCLibs -OutFile .\temp-install\Microsoft.VCLibs.x64.Desktop.appx
Write-Host "Downloading Microsoft.UI.Xaml Dependency...`n"
Invoke-WebRequest -Uri $fileUIXaml -OutFile .\temp-install\Microsoft.UI.Xaml.x64.appx



# ~ ~ ~ Get Winget Latest ~ ~ ~

Write-Host "Downloading Winget and License File`r"

# Invoke-WebRequest is notoriously slow when the byte progress is displayed. The following lines disable the progress bar and reset them at the end of the function  
$PreviousProgressPreference = $ProgressPreference 
$ProgressPreference = "silentlyContinue"

# Grabs the latest release of Winget from the Github API for the install process.
$response = Invoke-RestMethod -Uri "https://api.github.com/repos/microsoft/Winget-cli/releases/latest" -Method Get -ErrorAction Stop
$latestVersion = $response.tag_name #Stores version number of latest release.
$licenseWingetUrl = $response.assets.browser_download_url | Where-Object {$_ -like "*License1.xml"} #Index value for License file.
Write-Host "Latest Version:`t$($latestVersion)`n"
Write-Host "Downloading..."
$assetUrl = $response.assets.browser_download_url | Where-Object {$_ -like "*Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle"}
Invoke-WebRequest -Uri $licenseWingetUrl -OutFile .\temp-install\License1.xml
# The only pain is that the msixbundle for winget-cli is 246MB. In some situations this can take a bit, with slower connections.
Invoke-WebRequest -Uri $assetUrl -OutFile .\temp-install\Microsoft.DesktopAppInstaller.msixbundle

$ProgressPreference = $PreviousProgressPreference



# ~ ~ ~ Install Winget via GitHub method ~ ~ ~

# Used part of my own script with some modification: ruxunderscore/windows-initialization
Write-Host "Installing Winget w/ Prerequsites`r"
Add-AppxProvisionedPackage -Online -PackagePath .\temp-install\Microsoft.DesktopAppInstaller.msixbundle -DependencyPackagePath .\temp-install\Microsoft.VCLibs.x64.Desktop.appx, .\temp-install\Microsoft.UI.Xaml.x64.appx -LicensePath .\temp-install\License1.xml
Write-Host "Manually adding Winget Sources, from Winget CDN."
Add-AppxPackage -Path https://cdn.winget.microsoft.com/cache/source.msix #Seems some installs of Winget don't add the repo source, this should makes sure that it's installed every time. 
Write-Host ''
Write-Host "Winget Installed" -ForegroundColor Green
Write-Host ''



# ~ ~ ~ DONE ~ ~ ~

Start-Sleep -Seconds 1
Set-Location temp-install
$WorkingDirName = Split-Path -Path $PWD -Leaf -Resolve
if ($WorkingDirName -eq 'temp-install') {
    Set-Location ..\
    Remove-Item 'temp-install' -Recurse -Force
	winget install --id Microsoft.Powershell --source winget --accept-package-agreements --accept-source-agreements
}
else {
	Write-Host ''
    Write-Host "!!!!!   MAJOR FAILURE   !!!!!" -ForegroundColor Red
    Write-Host "Something broke... This might not be an issue, but it PROBABLY is."
	Write-Host ''
	Start-Sleep -Seconds 5
	pause
	exit
}
exit