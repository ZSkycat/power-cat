param (
    [Switch]$NoClear
)

# Module
Import-Module "$PSScriptRoot\Cat.Cmdlet.psm1"
Import-Module "$PSScriptRoot\Cat.Cmdlet.Tool.psm1"

# Global Object
$P = @{}
$P.Hosts = "$env:windir\System32\Drivers\etc\hosts"
$P.PowerRoot = $PSScriptRoot
$P.PowerAction = "$PSScriptRoot\Action"

# Main
function prompt {
    Write-Host -NoNewline -ForegroundColor Cyan "`n${env:USERNAME}@${env:COMPUTERNAME} "
    Write-Host -NoNewline -ForegroundColor Yellow "$PWD`n"
    Write-Host -NoNewline -ForegroundColor Cyan "$('>' * ($NestedPromptLevel + 1))"
    ' '
}

if (!$NoClear) { Clear-Host }
