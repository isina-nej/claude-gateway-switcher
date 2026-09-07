#Requires -Version 5.1
# Installer for cgw on native Windows (PowerShell 5.1+, no Git Bash/WSL needed).
# Run:  powershell -ExecutionPolicy Bypass -File install.ps1
$ErrorActionPreference = 'Stop'

$RootDir = $PSScriptRoot
if (-not $RootDir) { $RootDir = (Get-Location).Path }
$BinDir = Join-Path $RootDir 'bin'
$InstallDir = Join-Path $HOME '.local\bin'

foreach ($f in @('cgw.ps1', 'cgw.cmd')) {
  if (-not (Test-Path (Join-Path $BinDir $f))) {
    [Console]::Error.WriteLine("cgw: missing $BinDir\$f")
    exit 1
  }
}

New-Item -ItemType Directory -Force -Path $InstallDir | Out-Null
Copy-Item -Force (Join-Path $BinDir 'cgw.ps1') (Join-Path $InstallDir 'cgw.ps1')
Copy-Item -Force (Join-Path $BinDir 'cgw.cmd') (Join-Path $InstallDir 'cgw.cmd')
Write-Host "Installed cgw -> $InstallDir\cgw.cmd"

$UserPath = [Environment]::GetEnvironmentVariable('Path', 'User')
if ([string]::IsNullOrEmpty($UserPath)) {
  [Environment]::SetEnvironmentVariable('Path', $InstallDir, 'User')
  $env:Path = "$env:Path;$InstallDir"
  Write-Host ''
  Write-Host "Added $InstallDir to your user PATH."
  Write-Host 'Close and reopen the terminal, then run: cgw'
} elseif ($UserPath -notlike "*$InstallDir*") {
  [Environment]::SetEnvironmentVariable('Path', "$UserPath;$InstallDir", 'User')
  $env:Path = "$env:Path;$InstallDir"
  Write-Host ''
  Write-Host "Added $InstallDir to your user PATH."
  Write-Host 'Close and reopen the terminal, then run: cgw'
} else {
  Write-Host 'PATH already contains install dir.'
}

if (-not (Get-Command claude -ErrorAction SilentlyContinue)) {
  Write-Host 'Warning: Claude Code was not found in PATH. You can configure cgw now and install Claude Code separately.'
}

$ans = Read-Host -Prompt 'Create the default gateway profile now? [Y/n]'
if ([string]::IsNullOrWhiteSpace($ans) -or $ans.Trim() -match '^(?i)y(es)?$') {
  & (Join-Path $InstallDir 'cgw.cmd') setup default
  $start = Read-Host -Prompt 'Start Claude with this profile now? [y/N]'
  if ($start.Trim() -match '^(?i)y(es)?$') { & (Join-Path $InstallDir 'cgw.cmd') }
}
