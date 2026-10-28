# Downloads, builds and installs the latest BrandonWherry fork of ONI Together.
# No admin rights needed: .NET is downloaded into a private folder, not installed system-wide.
# Optional overrides (used for testing): ONI_FORK_ROOT, ONI_FORK_MODS_DIR, ONI_FORK_GAME_DIR

$ErrorActionPreference = 'Stop'
$ProgressPreference = 'SilentlyContinue'
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$Repo   = 'BrandonWherry/Oxygen_Not_Included_Together'
$Branch = 'brandon-fork'

function Step($msg) { Write-Host "`n==> $msg" -ForegroundColor Cyan }
function Fail($msg) { Write-Host "`nERROR: $msg" -ForegroundColor Red; exit 1 }

$Root = if ($env:ONI_FORK_ROOT) { $env:ONI_FORK_ROOT } else { Join-Path $env:LOCALAPPDATA 'ONITogetherFork' }
$DotnetDir = Join-Path $Root 'dotnet'
$SrcDir    = Join-Path $Root 'src'
New-Item -ItemType Directory -Force -Path $Root | Out-Null

if (Get-Process -Name 'OxygenNotIncluded' -ErrorAction SilentlyContinue) {
    Fail 'Oxygen Not Included is running. Close the game and run this again.'
}

Step 'Finding Oxygen Not Included'
function Find-GameDir {
    if ($env:ONI_FORK_GAME_DIR) { return $env:ONI_FORK_GAME_DIR }
    $steam = (Get-ItemProperty -Path 'HKCU:\Software\Valve\Steam' -ErrorAction SilentlyContinue).SteamPath
    $libraries = @()
    if ($steam) {
        $libraries += $steam
        $vdf = Join-Path $steam 'steamapps\libraryfolders.vdf'
        if (Test-Path $vdf) {
            foreach ($m in [regex]::Matches((Get-Content $vdf -Raw), '"path"\s+"([^"]+)"')) {
                $libraries += $m.Groups[1].Value -replace '\\\\', '\'
            }
        }
    }
    $libraries += "${env:ProgramFiles(x86)}\Steam"
    foreach ($lib in $libraries | Select-Object -Unique) {
        $dir = Join-Path $lib 'steamapps\common\OxygenNotIncluded'
        if (Test-Path (Join-Path $dir 'OxygenNotIncluded_Data\Managed\Assembly-CSharp.dll')) { return $dir }
    }
    return $null
}
$GameDir = Find-GameDir
if (-not $GameDir) { Fail 'Could not find the game. Is Oxygen Not Included installed through Steam?' }
$Managed = Join-Path $GameDir 'OxygenNotIncluded_Data\Managed'
Write-Host "Game: $GameDir"

$ModsDir = if ($env:ONI_FORK_MODS_DIR) { $env:ONI_FORK_MODS_DIR } else {
    Join-Path ([Environment]::GetFolderPath('MyDocuments')) 'Klei\OxygenNotIncluded\mods\Local'
}
New-Item -ItemType Directory -Force -Path $ModsDir | Out-Null

Step 'Checking .NET (first run downloads ~250 MB, later runs skip this)'
$Dotnet = Join-Path $DotnetDir 'dotnet.exe'
$haveSdk = (Test-Path $Dotnet) -and ((& $Dotnet --list-sdks) -match '^8\.')
$haveRt6 = (Test-Path $Dotnet) -and ((& $Dotnet --list-runtimes) -match 'Microsoft\.NETCore\.App 6\.')
if (-not ($haveSdk -and $haveRt6)) {
    $installer = Join-Path $Root 'dotnet-install.ps1'
    Invoke-WebRequest -UseBasicParsing 'https://dot.net/v1/dotnet-install.ps1' -OutFile $installer
    if (-not $haveSdk) { & $installer -Channel 8.0 -InstallDir $DotnetDir -NoPath }
    if (-not $haveRt6) { & $installer -Channel 6.0 -Runtime dotnet -InstallDir $DotnetDir -NoPath }
}
$env:DOTNET_ROOT = $DotnetDir
$env:PATH = "$DotnetDir;$env:PATH"
$env:DOTNET_CLI_TELEMETRY_OPTOUT = '1'
$env:DOTNET_NOLOGO = '1'
$env:DOTNET_MULTILEVEL_LOOKUP = '0'

Step 'Downloading the latest mod source'
$commit = (Invoke-RestMethod -UseBasicParsing "https://api.github.com/repos/$Repo/commits/$Branch").sha
$zip = Join-Path $Root 'src.zip'
Invoke-WebRequest -UseBasicParsing "https://github.com/$Repo/archive/$commit.zip" -OutFile $zip
if (Test-Path $SrcDir) { Remove-Item -Recurse -Force $SrcDir }
$extract = Join-Path $Root 'extract'
if (Test-Path $extract) { Remove-Item -Recurse -Force $extract }
Expand-Archive -Path $zip -DestinationPath $extract
Move-Item (Get-ChildItem $extract | Select-Object -First 1).FullName $SrcDir
Remove-Item -Recurse -Force $extract, $zip

@"
<?xml version="1.0" encoding="utf-8"?>
<Project>
	<PropertyGroup>
		<GameLibsFolder>$Managed</GameLibsFolder>
		<ModFolder>$ModsDir</ModFolder>
	</PropertyGroup>
</Project>
"@ | Set-Content -Encoding UTF8 (Join-Path $SrcDir 'Directory.Build.props.user')

Step 'Building the mod (about a minute)'
Push-Location $SrcDir
try {
    & dotnet tool restore
    if ($LASTEXITCODE -ne 0) { Fail 'dotnet tool restore failed (see messages above).' }
    & dotnet build 'ONI_Together\ONI_Together.csproj' -c Release -v minimal -clp:ErrorsOnly
    if ($LASTEXITCODE -ne 0) { Fail 'Build failed (see messages above). Send a screenshot to Brandon.' }
} finally { Pop-Location }

Write-Host "`nDone! Installed build $($commit.Substring(0,7)) to $ModsDir\ONI_Together_dev" -ForegroundColor Green
Write-Host 'Start the game, open Mods, and make sure "ONI Together (Brandon fork)" is enabled.'
Write-Host 'Do NOT also enable the Steam Workshop version of ONI Together.'
