Set-Location $PSScriptRoot
git.exe config --local core.autocrlf input
git.exe config --get-regexp user
Read-Host 'Exit'
