Import-Module "$($PSScriptRoot|Split-Path)\Cat.Script.psm1"
RunAsForFile $PSCommandPath

WriteTitle $PSCommandPath
Write-Host '
Need to restart computer
1: Enable Hyper-V
2: Disable Hyper-V
'

switch (Read-Host '>') {
    '1' { bcdedit.exe /deletevalue hypervisorlaunchtype }
    '2' { bcdedit.exe /set hypervisorlaunchtype off }
    Default { throw 'Error' }
}

if (HasExit) { Read-Host 'Exit' }
