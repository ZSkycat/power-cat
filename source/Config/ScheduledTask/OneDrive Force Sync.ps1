$FileName = "$env:OneDrive\__sync";
New-Item -Force $FileName
Remove-Item -Force $FileName
