param(
    [switch]$Activate
)

$ErrorActionPreference = "Stop"

$ThemeId = "rex"
$RawUrl = "https://raw.githubusercontent.com/KevinXC5/t3code-rex-theme/main/$ThemeId.json"
$UserDataDir = if ($env:T3_USERDATA_DIR) { $env:T3_USERDATA_DIR } else { Join-Path $env:USERPROFILE ".t3\userdata" }
$ThemesDir = Join-Path $UserDataDir "themes"
$TargetFile = Join-Path $ThemesDir "$ThemeId.json"
$SettingsFile = Join-Path $UserDataDir "settings.json"

New-Item -ItemType Directory -Force -Path $ThemesDir | Out-Null

$LocalTheme = if ($PSScriptRoot) { Join-Path $PSScriptRoot "$ThemeId.json" } else { "" }
if ($LocalTheme -and (Test-Path $LocalTheme)) {
    Copy-Item -Path $LocalTheme -Destination $TargetFile -Force
    Write-Host "Installed from local file -> $TargetFile"
} else {
    Invoke-WebRequest -Uri $RawUrl -OutFile $TargetFile -UseBasicParsing
    Write-Host "Downloaded and installed -> $TargetFile"
}

if ($Activate) {
    $Settings = @{}
    if (Test-Path $SettingsFile) {
        Copy-Item -Path $SettingsFile -Destination "$SettingsFile.bak-theme" -Force
        $Settings = Get-Content -Path $SettingsFile -Raw | ConvertFrom-Json -AsHashtable
    }
    $Settings["defaultTheme"] = $ThemeId
    $Settings["defaultThemeSetAt"] = [DateTime]::UtcNow.ToString("yyyy-MM-ddTHH:mm:ss.000Z")
    $Settings | ConvertTo-Json -Depth 10 | Set-Content -Path $SettingsFile -Encoding UTF8
    Write-Host "Activated defaultTheme=$ThemeId in $SettingsFile"
} else {
    Write-Host "Done! Open T3 Code -> Settings -> Appearance and select 'Rex' (or pass -Activate)."
}
