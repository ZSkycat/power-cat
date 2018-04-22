Import-Module "$($PSScriptRoot|Split-Path)\Cat.Base.Script.psm1"
RunAsForFile

WriteFileTitle
Write-Output 'Need to restart explorer'

Read-Host '>'
Remove-ItemProperty 'Registry::HKEY_CLASSES_ROOT\Local Settings\Software\Microsoft\Windows\CurrentVersion\TrayNotify' 'IconStreams', 'PromotedIconCache'
taskkill.exe /f /im explorer.exe
Start-Process explorer.exe

if (HasExit) { Read-Host 'Exit' }
