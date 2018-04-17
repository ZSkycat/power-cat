Import-Module "$($PSScriptRoot|Split-Path)\Cat.Script.psm1"
RunAsForFile $PSCommandPath

$ValueList = 'Undefined', 'Restricted', 'AllSigned', 'RemoteSigned', 'Unrestricted', 'Bypass'

WriteTitle $PSCommandPath
Write-Host '
0: Undefined
1: Restricted (Default)
2: AllSigned
3：RemoteSigned (*)
4: Unrestricted
5：Bypass
'

[int]$read= Read-Host '>'
Set-ExecutionPolicy -Scope LocalMachine -Force $ValueList[$read]

if (HasExit) { Read-Host 'Exit' }
