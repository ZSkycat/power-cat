Import-Module "$($PSScriptRoot|Split-Path)\Cat.Base.Script.psm1"
RunAsForFile

function ParseInput ($path) {
    if ($path -match '^[A-Z]$') {
        $path = "${path}:"
    }
    if (!(Test-Path $path)) {
        throw 'Error'
    }
    $pathPlus = Join-Path $path '\sources\sxs'
    if (Test-Path $pathPlus) {
        return $pathPlus
    }
    else {
        return $path
    }
}

WriteFileTitle
Write-Output '
Image path: {?:}\sources\sxs
Package path: {?:\sources\sxs}\microsoft-windows-netfx3-ondemand-package.cab
'

$read = Read-Host ">"
Dism.exe /Online /Enable-Feature /FeatureName:NetFX3 "/Source:$(ParseInput $read)"

if (HasExit) { Read-Host 'Exit' }
