param (
    [string]$BackupPath = "$PSScriptRoot\Library Backup"
)
[string]$LibraryPath = "$env:APPDATA\Microsoft\Windows\Libraries"
[string[]]$LibraryDefault = 'CameraRoll.library-ms', 'Documents.library-ms', 'Music.library-ms', 'Pictures.library-ms', 'SavedPictures.library-ms', 'Videos.library-ms'

Write-Output $PSCommandPath
Write-Output '
1: Open directory
2: Import
3: Backup
'

switch (Read-Host '>') {
    '1' {
        explorer.exe $LibraryPath
        exit
    }
    '2' {
        Get-ChildItem $BackupPath *.library-ms | ForEach-Object {
            Copy-Item $_.FullName $LibraryPath
            Write-Output $_.Name
        }
    }
    '3' {
        Get-ChildItem $LibraryPath\* *.library-ms -Exclude $LibraryDefault | ForEach-Object {
            Copy-Item $_.FullName $BackupPath
            Write-Output $_.Name
        }
    }
    Default { throw 'Error' }
}
Read-Host 'Exit'
