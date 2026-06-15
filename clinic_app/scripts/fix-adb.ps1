Param(
    [Parameter(Mandatory=$false)]
    [string]$PairAddress,
    [Parameter(Mandatory=$false)]
    [string]$ConnectAddress,
    [switch]$AddToPath
)

function Show-Usage {
    Write-Host "Usage: powershell -ExecutionPolicy Bypass -File .\scripts\fix-adb.ps1 [-PairAddress <host:port>] [-ConnectAddress <host:port>] [-AddToPath]"
    Write-Host "Examples:"
    Write-Host "  .\scripts\fix-adb.ps1 -PairAddress 192.168.100.213:42361"
    Write-Host "  .\scripts\fix-adb.ps1 -AddToPath"
}

if ($PSBoundParameters.Count -eq 0) {
    Show-Usage
}

$candidates = @(
    "$env:USERPROFILE\AppData\Local\Android\Sdk\platform-tools\adb.exe",
    "$env:LOCALAPPDATA\Android\Sdk\platform-tools\adb.exe",
    "C:\Android\platform-tools\adb.exe",
    "C:\Program Files\Android\platform-tools\adb.exe",
    "$env:ProgramFiles\Android\platform-tools\adb.exe",
    "$env:ProgramFiles(x86)\Android\platform-tools\adb.exe"
)

$adbPath = $null
foreach ($p in $candidates) {
    if (Test-Path $p) { $adbPath = $p; break }
}

if (-not $adbPath) {
    Write-Host "adb.exe not found in common locations." -ForegroundColor Yellow
    Write-Host "If you have Android Studio installed: Open SDK Manager -> SDK Tools -> install 'Android SDK Platform-Tools'."
    Write-Host "Or download platform-tools from: https://developer.android.com/studio/releases/platform-tools"
    exit 2
}

Write-Host "Found adb at: $adbPath" -ForegroundColor Green

if ($AddToPath) {
    $adbDir = Split-Path -Parent $adbPath
    Write-Host "Adding $adbDir to user PATH (uses setx). Open a new shell after this completes." -ForegroundColor Cyan
    $newPath = "$env:Path;$adbDir"
    try {
        setx PATH "$newPath" | Out-Null
        Write-Host "Added to PATH. Close and reopen shells to pick up changes." -ForegroundColor Green
    } catch {
        Write-Host "Failed to update PATH: $_" -ForegroundColor Red
        exit 3
    }
}

if ($PairAddress) {
    Write-Host "Running: adb pair $PairAddress" -ForegroundColor Cyan
    & "$adbPath" pair $PairAddress
    exit $LASTEXITCODE
} elseif ($ConnectAddress) {
    Write-Host "Running: adb connect $ConnectAddress" -ForegroundColor Cyan
    & "$adbPath" connect $ConnectAddress
    exit $LASTEXITCODE
} else {
    Write-Host "No address provided. To pair: -PairAddress <host:port>. To connect: -ConnectAddress <host:port>. Or run adb directly:" -ForegroundColor Cyan
    Write-Host "  & '$adbPath' pair <host:port>"
    Write-Host "  & '$adbPath' connect <host:port>"
}
