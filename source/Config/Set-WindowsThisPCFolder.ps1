Import-Module "$($PSScriptRoot|Split-Path)/Power.Script.psm1"
RunAsForFile $PSCommandPath

$RegFolder = 'Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace'
$FolderList = @(
    ('{0DB7E03F-FC29-4DC6-9020-FF41B59E513A}'),  # 3D Object
    ('{B4BFCC3A-DB2C-424C-B029-7FE99A87C641}'),  # Desktop
    ('{A8CDFF1C-4878-43be-B5FD-F8091C1C60D0}', '{d3162b92-9365-467a-956b-92703aca08af}'),  # Local Document
    ('{374DE290-123F-4565-9164-39C4925E467B}', '{088e3905-0323-4b02-9826-5d99428e115f}'),  # Local Download
    ('{1CF1260C-4DD0-4ebb-811F-33C572699FDE}', '{3dfdf296-dbec-4fb4-81d1-6a3438bcf4de}'),  # Local Musci
    ('{3ADD1653-EB32-4cb0-BBD7-DFA0ABB5ACCA}', '{24ad3ad4-a569-4530-98e1-ab02f9417aa8}'),  # Local Picture
    ('{A0953C92-50DC-43bf-BE83-3742FED03C9C}', '{f86fa3ab-70d2-4fc7-9c99-fcbf05467f3a}'))  # Local Video

function IsShowFolder ([bool]$isShow, [int]$index) {
    foreach ($name in $FolderList[$index]) {
        $path = "$RegFolder\$name"
        if ($isShow) {
            New-Item $path -Force -ErrorAction Ignore
        }
        else {
            Remove-Item $path -ErrorAction Ignore
        }
    }
}

WriteTitle $PSCommandPath
Write-Host '
+: Show
-: Hide

0: 3D Object
1: Desktop
2: Local Document
3: Local Download
4: Local Musci
5: Local Picture
6: Local Video

Example: -0123456
'

switch -Regex (Read-Host '>') {
    '\+\d{1,7}' {
        $_.ToCharArray()[1..9] | ForEach-Object { IsShowFolder $true ([int][string]$_) }
    }
    '\-\d{1,7}' {
        $_.ToCharArray()[1..9] | ForEach-Object { IsShowFolder $false ([int][string]$_) }
    }
    Default {
        throw 'Error'
    }
}

if (HasExit) { Read-Host 'Exit' }
