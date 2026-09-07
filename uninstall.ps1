#Requires -Version 5.1
# Uninstaller for cgw on native Windows. Keeps profiles by design.
$ErrorActionPreference = 'Stop'

$InstallDir = Join-Path $HOME '.local\bin'
Remove-Item -Force (Join-Path $InstallDir 'cgw.cmd') -ErrorAction SilentlyContinue
Remove-Item -Force (Join-Path $InstallDir 'cgw.ps1') -ErrorAction SilentlyContinue

Write-Host "Removed cgw from $InstallDir"
Write-Host "Profiles were kept in $env:APPDATA\claude-gateway-switcher\"
Write-Host 'To remove them too, delete that directory manually.'
