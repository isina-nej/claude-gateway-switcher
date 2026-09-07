#Requires -Version 5.1
# Claude Gateway Switcher (cgw) - Windows PowerShell port.
# Same CLI and same profile format as bin/cgw (bash), so .conf files
# created on either side load on the other. Native Windows: no Git Bash/WSL needed.
# Requires PowerShell 5.1+ (ships with Windows 10/11) and Claude Code in PATH.

$ErrorActionPreference = 'Stop'

$Script:ClaudeBin = if ($env:CLAUDE_BIN) { $env:CLAUDE_BIN } else { 'claude' }
if ($env:XDG_CONFIG_HOME) { $Script:ConfigDir = Join-Path $env:XDG_CONFIG_HOME 'claude-gateway-switcher' }
elseif ($env:APPDATA) { $Script:ConfigDir = Join-Path $env:APPDATA 'claude-gateway-switcher' }
else { $Script:ConfigDir = Join-Path $HOME '.config/claude-gateway-switcher' }
$Script:ProfilesDir = Join-Path $Script:ConfigDir 'profiles'
$Script:ActiveFile = Join-Path $Script:ConfigDir 'active'
New-Item -ItemType Directory -Force -Path $Script:ProfilesDir | Out-Null

function Fail([string]$Message, [int]$Code = 1) {
  [Console]::Error.WriteLine("cgw: $Message")
  exit $Code
}

function Mask-Secret([string]$s) {
  if ([string]::IsNullOrEmpty($s) -or $s.Length -le 8) { return '********' }
  return $s.Substring(0, 4) + '...' + $s.Substring($s.Length - 4)
}

function Show-Usage {
  @'
Claude Gateway Switcher (cgw)

Usage:
  cgw                      Run Claude with the active profile
  cgw setup [name]         Create a profile interactively
  cgw edit [name]          Edit a profile interactively
  cgw use <name>           Make a profile active
  cgw list                 List profiles
  cgw show [name]          Show a profile (API key masked)
  cgw models [name]        Ask gateway for /v1/models
  cgw doctor [name]        Check Claude, profile, URL and common conflicts
  cgw run [name] -- [args] Run Claude with a profile and extra Claude args
  cgw delete <name>        Delete a profile
  cgw help                 Show this help

Profiles are stored in:
  %APPDATA%\claude-gateway-switcher\profiles\
Same file format as bin/cgw (bash), so .conf files can be copied between OSes.
  ($env:XDG_CONFIG_HOME wins if set; then $HOME\.config\claude-gateway-switcher\)
'@
}

function Sanitize-Name([string]$n) {
  if ($n -notmatch '^[A-Za-z0-9._-]+$') { Fail 'profile name may contain only letters, numbers, dot, underscore and dash' 2 }
  return $n
}

function Get-ProfilePath([string]$Name) { return Join-Path $Script:ProfilesDir ((Sanitize-Name $Name) + '.conf') }

function Get-ActiveName {
  if (Test-Path $Script:ActiveFile) { return ([System.IO.File]::ReadAllText($Script:ActiveFile).Trim()) }
  return ''
}

# Bash-compatible unquoting: handles %q output (bare, '...', $'...', "...") and
# the single-quote style this script writes. ponytail: no $( ) / backtick
# command substitution support; add when values ever need it (they don't today).
function Unquote-BashValue([string]$v) {
  $v = $v.Trim()
  $SQ = "'"
  $DQ = '"'
  $BS = '\'
  $NUL = [string][char]0
  if ($v.StartsWith('$' + $SQ) -and $v.EndsWith($SQ) -and $v.Length -ge 3) {
    $inner = $v.Substring(2, $v.Length - 3)
    $inner = $inner.Replace($BS + $BS, $NUL)
    $inner = $inner.Replace($BS + 'n', "`n")
    $inner = $inner.Replace($BS + 't', "`t")
    $inner = $inner.Replace($BS + 'r', "`r")
    $inner = $inner.Replace($BS + $SQ, $SQ)
    $inner = $inner.Replace($BS + $DQ, $DQ)
    return $inner.Replace($NUL, $BS)
  }
  if ($v.StartsWith($SQ) -and $v.EndsWith($SQ) -and $v.Length -ge 2) {
    return $v.Substring(1, $v.Length - 2).Replace($SQ + $BS + $SQ + $SQ, $SQ)
  }
  if ($v.StartsWith($DQ) -and $v.EndsWith($DQ) -and $v.Length -ge 2) {
    $inner = $v.Substring(1, $v.Length - 2)
    $inner = $inner.Replace($BS + $BS, $NUL)
    $inner = $inner.Replace($BS + $DQ, $DQ)
    $inner = $inner.Replace($BS + '$', '$')
    return $inner.Replace($NUL, $BS)
  }
  $out = ''
  $i = 0
  while ($i -lt $v.Length) {
    if (($v.Substring($i, 1) -eq $BS) -and (($i + 1) -lt $v.Length)) { $out += $v.Substring($i + 1, 1); $i += 2 }
    else { $out += $v.Substring($i, 1); $i += 1 }
  }
  return $out
}

function Quote-BashValue([string]$s) {
  if ($null -eq $s) { $s = '' }
  $SQ = "'"
  $BS = '\'
  return $SQ + $s.Replace($SQ, $SQ + $BS + $SQ + $SQ) + $SQ
}

function Read-Profile([string]$Name) {
  $path = Get-ProfilePath $Name
  if (-not (Test-Path $path)) { Fail "profile '$Name' not found" 3 }
  $p = @{}
  foreach ($line in [System.IO.File]::ReadAllLines($path)) {
    if ($line -match '^([A-Za-z_][A-Za-z0-9_]*)=(.*)$') { $p[$Matches[1]] = Unquote-BashValue $Matches[2] }
  }
  foreach ($k in @('BASE_URL', 'MODEL_ID', 'AUTH_TYPE', 'API_KEY')) {
    if ([string]::IsNullOrEmpty($p[$k])) { Fail "profile '$Name' is missing $k" 3 }
  }
  if ($null -eq $p['DISCOVERY']) { $p['DISCOVERY'] = '0' }
  return $p
}

function Write-Profile([string]$Name, [string]$BaseUrl, [string]$AuthType, [string]$ApiKey, [string]$ModelId, [string]$Discovery) {
  # LF-only + no BOM: bash must be able to source this file as-is.
  $utf8 = New-Object System.Text.UTF8Encoding $false
  $text = @(
    'BASE_URL=' + (Quote-BashValue $BaseUrl)
    'AUTH_TYPE=' + (Quote-BashValue $AuthType)
    'API_KEY=' + (Quote-BashValue $ApiKey)
    'MODEL_ID=' + (Quote-BashValue $ModelId)
    'DISCOVERY=' + (Quote-BashValue $Discovery)
  ) -join "`n"
  [System.IO.File]::WriteAllText((Get-ProfilePath $Name), $text + "`n", $utf8)
}

function Set-Active([string]$Name) {
  $utf8 = New-Object System.Text.UTF8Encoding $false
  [System.IO.File]::WriteAllText($Script:ActiveFile, "$Name`n", $utf8)
}

function Select-Profile([string]$Requested) {
  if ($Requested) { return $Requested }
  $a = Get-ActiveName
  if (-not $a) { Fail 'no active profile. Run: cgw setup default' 3 }
  return $a
}

function Prompt-Default([string]$Label, [string]$Default) {
  if ($Default) {
    $r = Read-Host -Prompt "$Label [$Default]"
    if ([string]::IsNullOrWhiteSpace($r)) { return $Default }
    return $r.Trim()
  }
  return (Read-Host -Prompt $Label).Trim()
}

function Read-ApiKey([string]$Prompt, [string]$Keep) {
  $sec = Read-Host -Prompt $Prompt -AsSecureString
  if ($sec.Length -eq 0) { return $Keep }
  $ptr = [Runtime.InteropServices.Marshal]::SecureStringToBSTR($sec)
  try { return [Runtime.InteropServices.Marshal]::PtrToStringBSTR($ptr) }
  finally { [Runtime.InteropServices.Marshal]::ZeroFreeBSTR($ptr) }
}

function Invoke-Wizard([string]$Name, [string]$Mode) {
  $path = Get-ProfilePath $Name
  $oldBase = ''; $oldAuth = 'bearer'; $oldKey = ''; $oldModel = ''; $oldDisc = '0'
  if ($Mode -eq 'edit') {
    $p = Read-Profile $Name
    $oldBase = $p['BASE_URL']; $oldAuth = $p['AUTH_TYPE']; $oldKey = $p['API_KEY']
    $oldModel = $p['MODEL_ID']; $oldDisc = $p['DISCOVERY']
  } elseif (Test-Path $path) {
    Fail "profile '$Name' already exists; use: cgw edit $Name" 4
  }
  Write-Host ''
  Write-Host "Configuring profile: $Name"
  $baseUrl = (Prompt-Default 'Gateway base URL (no trailing /v1)' $oldBase).TrimEnd('/')
  $authDefault = if ($oldAuth -eq 'x-api-key') { '2' } else { '1' }
  $authChoice = Read-Host -Prompt "Auth type: 1) Bearer token  2) x-api-key [$authDefault]"
  if ([string]::IsNullOrWhiteSpace($authChoice)) { $authChoice = $authDefault }
  switch ($authChoice.Trim()) {
    '1' { $authType = 'bearer' }
    '2' { $authType = 'x-api-key' }
    default { Fail 'invalid auth type' 2 }
  }
  if ($oldKey) { $apiKey = Read-ApiKey 'API key [press Enter to keep current]' $oldKey }
  else { $apiKey = Read-ApiKey 'API key' '' }
  if ([string]::IsNullOrEmpty($apiKey)) { Fail 'API key cannot be empty' 2 }
  $modelId = Prompt-Default 'Model ID' $oldModel
  if ([string]::IsNullOrEmpty($modelId)) { Fail 'Model ID cannot be empty' 2 }
  $discDefault = if ($oldDisc -eq '1') { 'y' } else { 'n' }
  $disc = Read-Host -Prompt "Enable gateway model discovery for /model? [y/N] [$discDefault]"
  if ([string]::IsNullOrWhiteSpace($disc)) { $disc = $discDefault }
  $discovery = if ($disc.Trim() -match '^(?i)y(es)?$') { '1' } else { '0' }
  Write-Profile $Name $baseUrl $authType $apiKey $modelId $discovery
  if (-not (Test-Path $Script:ActiveFile)) { Set-Active $Name }
  Write-Host "Saved profile '$Name'."
  Write-Host "Use it with: cgw use $Name"
  Write-Host 'Run Claude with: cgw'
}

function Invoke-Claude([string]$Name, [string[]]$ExtraArgs) {
  $p = Read-Profile $Name
  if (-not (Get-Command $Script:ClaudeBin -ErrorAction SilentlyContinue)) {
    Fail 'Claude Code not found in PATH. Install Claude Code first or set CLAUDE_BIN.' 127
  }
  $env:ANTHROPIC_BASE_URL = $p['BASE_URL']
  $env:ANTHROPIC_MODEL = $p['MODEL_ID']
  Remove-Item Env:\ANTHROPIC_AUTH_TOKEN -ErrorAction SilentlyContinue
  Remove-Item Env:\ANTHROPIC_API_KEY -ErrorAction SilentlyContinue
  if ($p['AUTH_TYPE'] -eq 'bearer') { $env:ANTHROPIC_AUTH_TOKEN = $p['API_KEY'] }
  else { $env:ANTHROPIC_API_KEY = $p['API_KEY'] }
  if ($p['DISCOVERY'] -eq '1') {
    $env:CLAUDE_CODE_USE_GATEWAY = '1'
    $env:CLAUDE_CODE_ENABLE_GATEWAY_MODEL_DISCOVERY = '1'
  } else {
    Remove-Item Env:\CLAUDE_CODE_USE_GATEWAY -ErrorAction SilentlyContinue
    Remove-Item Env:\CLAUDE_CODE_ENABLE_GATEWAY_MODEL_DISCOVERY -ErrorAction SilentlyContinue
  }
  & $Script:ClaudeBin --model $p['MODEL_ID'] @ExtraArgs
  exit $LASTEXITCODE
}

$cmd = if ($args.Count -eq 0) { 'run-active' } else { $args[0] }
$rest = if ($args.Count -gt 1) { @($args[1..($args.Count - 1)]) } else { @() }

switch ($cmd) {
  'setup' {
    $n = if ($rest.Count -ge 1) { $rest[0] } else { 'default' }
    Invoke-Wizard (Sanitize-Name $n) 'setup'
  }
  'edit' {
    $n = if ($rest.Count -ge 1) { $rest[0] } else { Select-Profile '' }
    Invoke-Wizard (Sanitize-Name $n) 'edit'
  }
  'use' {
    if ($rest.Count -lt 1) { Fail 'usage: cgw use <name>' 2 }
    $n = Sanitize-Name $rest[0]
    if (-not (Test-Path (Get-ProfilePath $n))) { Fail "profile '$n' not found" 3 }
    Set-Active $n
    Write-Host "Active profile: $n"
  }
  'list' {
    $active = Get-ActiveName
    $files = @(Get-ChildItem -Path $Script:ProfilesDir -Filter *.conf -ErrorAction SilentlyContinue)
    if ($files.Count -eq 0) { Write-Host 'No profiles. Run: cgw setup default' }
    foreach ($f in $files) {
      $n = [System.IO.Path]::GetFileNameWithoutExtension($f.Name)
      if ($n -eq $active) { Write-Host "* $n" } else { Write-Host "  $n" }
    }
  }
  'show' {
    $n = Select-Profile $(if ($rest.Count -ge 1) { $rest[0] } else { '' })
    $p = Read-Profile $n
    Write-Host "Profile:   $n"
    Write-Host "Base URL:  $($p['BASE_URL'])"
    Write-Host "Auth:      $($p['AUTH_TYPE'])"
    Write-Host "API key:   $(Mask-Secret $p['API_KEY'])"
    Write-Host "Model:     $($p['MODEL_ID'])"
    Write-Host "Discovery: $($p['DISCOVERY'])"
  }
  'models' {
    $n = Select-Profile $(if ($rest.Count -ge 1) { $rest[0] } else { '' })
    $p = Read-Profile $n
    $headers = @{ accept = 'application/json' }
    if ($p['AUTH_TYPE'] -eq 'bearer') { $headers['Authorization'] = "Bearer $($p['API_KEY'])" }
    else { $headers['x-api-key'] = $p['API_KEY'] }
    try {
      Invoke-RestMethod -Uri "$($p['BASE_URL'].TrimEnd('/'))/v1/models" -Headers $headers |
        ConvertTo-Json -Depth 10
    } catch { Fail $_.Exception.Message }
  }
  'doctor' {
    $n = Select-Profile $(if ($rest.Count -ge 1) { $rest[0] } else { '' })
    Write-Host "Profile: $n"
    $ok = $true
    $found = Get-Command $Script:ClaudeBin -ErrorAction SilentlyContinue
    if ($found) { Write-Host "[ok] Claude Code: $($found.Source)" }
    else { Write-Host '[!!] Claude Code not found'; $ok = $false }
    $p = Read-Profile $n
    if ($p['BASE_URL'] -match '^https?://') { Write-Host '[ok] Base URL format' }
    else { Write-Host '[!!] Base URL should start with http:// or https://'; $ok = $false }
    if ($p['MODEL_ID']) { Write-Host "[ok] Model ID: $($p['MODEL_ID'])" }
    else { Write-Host '[!!] Model ID empty'; $ok = $false }
    if ($p['API_KEY']) { Write-Host "[ok] API key present ($(Mask-Secret $p['API_KEY']))" }
    else { Write-Host '[!!] API key missing'; $ok = $false }
    $homeDir = if ($HOME) { $HOME } else { $env:USERPROFILE }
    $settings = Join-Path (Join-Path $homeDir '.claude') 'settings.json'
    if ((Test-Path $settings) -and (Select-String -Path $settings -Pattern '"model"\s*:' -Quiet)) {
      Write-Host '[warn] settings.json contains a top-level model setting; some Claude Code versions have had precedence bugs.'
    }
    if (-not $ok) { exit 1 }
  }
  'delete' {
    if ($rest.Count -lt 1) { Fail 'usage: cgw delete <name>' 2 }
    $n = Sanitize-Name $rest[0]
    Remove-Item -Force (Get-ProfilePath $n) -ErrorAction SilentlyContinue
    if ((Get-ActiveName) -eq $n) { Remove-Item -Force $Script:ActiveFile -ErrorAction SilentlyContinue }
    Write-Host "Deleted profile '$n'."
  }
  'run' {
    $extra = @($rest); $name = ''
    if ($extra.Count -ge 1 -and $extra[0] -ne '--') { $name = $extra[0]; $extra = @(if ($extra.Count -gt 1) { $extra[1..($extra.Count - 1)] } else { @() }) }
    if ($extra.Count -ge 1 -and $extra[0] -eq '--') { $extra = @(if ($extra.Count -gt 1) { $extra[1..($extra.Count - 1)] } else { @() }) }
    Invoke-Claude (Select-Profile $name) $extra
  }
  { $_ -in 'help', '-h', '--help' } { Show-Usage }
  'run-active' { Invoke-Claude (Select-Profile '') @() }
  default {
    # Unknown first args are Claude args when a profile is active, e.g. cgw -p "hello"
    Invoke-Claude (Select-Profile '') @($args)
  }
}
