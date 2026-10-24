$ErrorActionPreference = 'Stop'
Set-Location -LiteralPath $PSScriptRoot
Write-Host "VOOT installer for RePlayOS 2.0.52"
foreach ($file in @('naomi.zip', 'vonot.zip')) {
  if (-not (Test-Path -LiteralPath (Join-Path $PSScriptRoot $file))) {
    throw "Missing $file. Copy your own ROM and BIOS into this folder after git clone."
  }
}
$release = 'https://github.com/setsuna362/Naomi-Game-Virtual-On-Oratorio-Tangram-5.66-on-Raspberry-Pi-5-/releases/download/v4.0.0/ReplayOS-VOOT-Installer.tar.gz'
$archive = Join-Path $PSScriptRoot 'ReplayOS-VOOT-Installer.tar.gz'
if (-not (Test-Path -LiteralPath $archive)) {
  Write-Host 'Downloading the project installer package...'
  Invoke-WebRequest -Uri $release -OutFile $archive -UseBasicParsing
}
$ip = Read-Host 'Raspberry Pi IP address'
$address = $null
if (-not [Net.IPAddress]::TryParse($ip, [ref]$address)) { throw 'Invalid IP address.' }
Write-Host '1. NO LINK'
Write-Host '2. MASTER'
Write-Host '3. SLAVE'
Write-Host '4. SATELLITE (experimental)'
$role = switch (Read-Host 'Select mode 1-4') {
 '1' { 'nolink' }
 '2' { 'master' }
 '3' { 'slave' }
 '4' { 'satellite' }
 default { throw 'Unknown mode' }
}
Write-Host "Target: $ip | Mode: $role"
Write-Host 'Enter the RePlayOS SSH password when prompted.'
& scp.exe $archive (Join-Path $PSScriptRoot 'naomi.zip') (Join-Path $PSScriptRoot 'vonot.zip') ('root@' + $ip + ':/root/')
if ($LASTEXITCODE -ne 0) { throw 'SCP transfer failed.' }
$command = 'mkdir -p /root/voot-setup && tar -xzf /root/ReplayOS-VOOT-Installer.tar.gz -C /root/voot-setup && cp /root/naomi.zip /root/vonot.zip /root/voot-setup/ && cd /root/voot-setup && bash install.sh ' + $role
& ssh.exe ('root@' + $ip) $command
if ($LASTEXITCODE -ne 0) { throw 'Installation failed; check output.' }
Write-Host 'Installation completed. Reboot your Raspberry Pi.'
