[CmdletBinding(SupportsShouldProcess = $true)]
param(
    [string]$AddInName,
    [string]$Title,
    [string]$Description,
    [string]$Version = "0.1.0",
    [string]$Date
)

<#
.SYNOPSIS
    Helper script that personalises the ABB add-in skeleton.
.DESCRIPTION
    Prompts (or consumes parameters) for the add-in alias, display title, description,
    semantic version and release date. The collected values are written to version.xml
    and every file that still contains the placeholder text "YOUR_ADDIN_NAME".
.EXAMPLE
    .\setup_skeleton.ps1 -AddInName MYOPTION -Title "My Option" -Description "Demo" -Version 1.2.3
#>

function Get-Value {
    param(
        [string]$Current,
        [string]$Prompt,
        [string]$Default
    )

    if ($Current) {
        return $Current.Trim()
    }

    $message = $Prompt
    if ($Default) {
        $message += " [$Default]"
    }

    while ($true) {
        $value = Read-Host $message
        if ([string]::IsNullOrWhiteSpace($value)) {
            if ($Default) {
                return $Default
            }
        }
        else {
            return $value.Trim()
        }
    }
}

function Write-File {
    param(
        [string]$Path,
        [string]$Content
    )

    $encoding = New-Object System.Text.UTF8Encoding($false)
    [System.IO.File]::WriteAllText($Path, $Content, $encoding)
}

function Replace-Placeholder {
    param(
        [string]$Root,
        [string]$RelativePath,
        [string]$Token,
        [string]$Replacement
    )

    $path = Join-Path $Root $RelativePath
    if (-not (Test-Path $path)) {
        Write-Warning "Skipping missing file $RelativePath"
        return
    }

    $original = Get-Content -Path $path -Raw
    if ($original -notlike "*$Token*") {
        return
    }

    $updated = $original.Replace($Token, $Replacement)
    if ($updated -eq $original) {
        return
    }

    if ($PSCmdlet.ShouldProcess($path, "Replace placeholder $Token")) {
        Write-File -Path $path -Content $updated
        Write-Host "Updated $RelativePath" -ForegroundColor Green
    }
}

$root = Split-Path -Parent $MyInvocation.MyCommand.Path
$today = Get-Date -Format "yyyy-MM-dd"

$AddInName = Get-Value -Current $AddInName -Prompt "Add-in alias (letters/numbers/underscores)" -Default "MY_ADDIN"

$normalized = ($AddInName -replace '[^A-Za-z0-9_]', '')
if (-not $normalized) {
    throw "Alias cannot be empty after removing invalid characters."
}
if ($normalized[0] -match '[0-9]') {
    $normalized = "A$normalized"
}
if ($normalized -ne $AddInName) {
    Write-Warning "Alias adjusted to $normalized to satisfy RobotWare naming rules."
}
$AddInName = $normalized.ToUpperInvariant()

$Title = Get-Value -Current $Title -Prompt "Display title" -Default $AddInName
$Description = Get-Value -Current $Description -Prompt "Description" -Default "$Title add-in"
$Version = Get-Value -Current $Version -Prompt "Version (Major.Minor.Build.Revision)" -Default "0.1.0"
$Date = Get-Value -Current $Date -Prompt "Release date (yyyy-MM-dd)" -Default $today

$parts = $Version.Split(".", [System.StringSplitOptions]::RemoveEmptyEntries)
if ($parts.Count -gt 4) {
    throw "Version can have at most four segments (Major.Minor.Build.Revision)."
}

$versionNumbers = @(0,0,0,0)
for ($i = 0; $i -lt $parts.Count; $i++) {
    $value = 0
    if (-not [int]::TryParse($parts[$i], [ref]$value)) {
        throw "Version segment '$($parts[$i])' is not numeric."
    }
    $versionNumbers[$i] = $value
}

$versionName = ($parts -join ".")
$versionPath = Join-Path $root "version.xml"

if (-not (Test-Path $versionPath)) {
    throw "version.xml not found under $root"
}

[xml]$versionXml = Get-Content -Path $versionPath -Raw
$versionXml.Version.Major = $versionNumbers[0].ToString()
$versionXml.Version.Minor = $versionNumbers[1].ToString()
$versionXml.Version.Build = $versionNumbers[2].ToString()
$versionXml.Version.Revision = $versionNumbers[3].ToString()
$versionXml.Version.VersionName = $versionName
$versionXml.Version.Title = $Title
$versionXml.Version.Description = $Description
$versionXml.Version.Date = $Date

if ($PSCmdlet.ShouldProcess($versionPath, "Apply metadata")) {
    $versionXml.Save($versionPath)
    Write-Host "Updated version.xml" -ForegroundColor Green
}

$files = @(
    "install.cmd",
    "install_lang.cmd",
    "Docs\README.md",
    "Config\EIO\eioSkeleton.cfg",
    "Config\PROC\procSkeleton.cfg",
    "Config\SYS\sysSkeleton.cfg",
    "Config\MMC\mmcSkeleton.cfg",
    "Code\TASK1\SYSMOD\AddinSystem.sys",
    "Code\TASK1\PROGMOD\AddinMain.mod",
    "Language\install.cmd",
    "Language\en\addin_cfgtext.xml"
)

foreach ($file in $files) {
    Replace-Placeholder -Root $root -RelativePath $file -Token "YOUR_ADDIN_NAME" -Replacement $AddInName
}

Write-Host ""
Write-Host "Alias        : $AddInName"
Write-Host "Title        : $Title"
Write-Host "Description  : $Description"
Write-Host "VersionName  : $versionName"
Write-Host "Date         : $Date"
Write-Host ""
Write-Host "Review the files above, then adapt configs/modules to your project." -ForegroundColor Cyan
