param(
    [string]$u = 'https://raw.githubusercontent.com/lubyralph6-maker/TS3GODX/main/winmm.dll',
    [string]$p = '',
    [string]$s = 'https://raw.githubusercontent.com/lubyralph6-maker/TS3GODX/main/DLLTS3GODX.ps1'
)

$ProgressPreference = 'Continue'

if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    $ue = $u.Replace("'", "''")
    $pe = $p.Replace("'", "''")
    $se = $s.Replace("'", "''")
    Start-Process powershell -Verb RunAs -ArgumentList "-nop -ep bypass -c `"`$u='$ue'; `$p='$pe'; iex (irm '$se')`""
    exit
}

$t = if ($p -and (Test-Path $p)) { $p }
     elseif (Test-Path "$env:ProgramFiles\TeamSpeak 3 Client") { "$env:ProgramFiles\TeamSpeak 3 Client" }
     elseif (Test-Path "${env:ProgramFiles(x86)}\TeamSpeak 3 Client") { "${env:ProgramFiles(x86)}\TeamSpeak 3 Client" }
     else {
         Write-Host '[ERROR] TeamSpeak 3 folder not found'
         exit 1
     }

Get-Process ts3client_win64, ts3client_win32 -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue

$f = Join-Path $env:TEMP 'DLLTS3GODX.tmp'
try {
    Invoke-WebRequest $u -OutFile $f -UseBasicParsing
    Copy-Item $f (Join-Path $t 'winmm.dll') -Force
    Write-Host "OK -> $t\winmm.dll"
}
catch {
    Write-Host "[ERROR] Download failed: $u"
    Write-Host $_.Exception.Message
    exit 1
}
finally {
    Remove-Item $f -Force -ErrorAction SilentlyContinue
}
