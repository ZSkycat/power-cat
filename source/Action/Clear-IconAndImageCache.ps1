Write-Host $PSCommandPath
Write-Host 'Need to restart explorer'

Read-Host '>'
taskkill.exe /F /IM explorer.exe
Start-Sleep 5
Remove-Item "$env:LOCALAPPDATA\IconCache.db"
Remove-Item "$env:LOCALAPPDATA\Microsoft\Windows\Explorer\iconcache_*.db"
Remove-Item "$env:LOCALAPPDATA\Microsoft\Windows\Explorer\thumbcache_*.db"
Start-Sleep 1
Start-Process explorer.exe
Read-Host 'Exit'
