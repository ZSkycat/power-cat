Import-Module "$($PSScriptRoot|Split-Path)\Cat.Script.psm1"
RunAsForFile $PSCommandPath

WriteTitle $PSCommandPath
Write-Host 'Need to restart explorer'

Read-Host '>'
Remove-ItemProperty 'Registry::HKEY_CLASSES_ROOT\Local Settings\Software\Microsoft\Windows\CurrentVersion\TrayNotify' 'IconStreams', 'PromotedIconCache'
taskkill.exe /F /IM explorer.exe
Start-Process explorer.exe

if (HasExit) { Read-Host 'Exit' }
