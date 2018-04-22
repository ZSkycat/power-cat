Import-Module "$($PSScriptRoot|Split-Path)\Cat.Base.Script.psm1"
RunAsForFile

$RegDirectory = 'Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Classes\Directory'
$VSPath = '"C:\Program Files (x86)\Common Files\Microsoft Shared\MSEnv\VSLauncher.exe"'

function Reset {
    Remove-Item "$RegDirectory\shell\AnyCode" -Recurse -ErrorAction Ignore
    Remove-Item "$RegDirectory\background\shell\AnyCode" -Recurse -ErrorAction Ignore
}

function AddMenu () {
    New-Item         "$RegDirectory\shell\AnyCode" -Value 'Open with Visual Studio'
    New-ItemProperty "$RegDirectory\shell\AnyCode" -Name 'Icon' -Value $VSPath
    New-Item         "$RegDirectory\shell\AnyCode\Command" -Value "$VSPath `"%1`" source:Explorer"

    New-Item         "$RegDirectory\background\shell\AnyCode" -Value 'Open with Visual Studio'
    New-ItemProperty "$RegDirectory\background\shell\AnyCode" -Name 'Icon' -Value $VSPath
    New-Item         "$RegDirectory\background\shell\AnyCode\Command" -Value "$VSPath `"%V`" source:ExplorerBackground"
}

function AddExtended {
    New-ItemProperty "$RegDirectory\shell\AnyCode" -Name 'Extended'
    New-ItemProperty "$RegDirectory\background\shell\AnyCode" -Name 'Extended'
}

WriteFileTitle
Write-Output '
[Open with Visual Studio (Directory, Verb=AnyCode)]
1: Enable
2: Enable (Shift)
3: Disable
'

switch (Read-Host '>') {
    '1' {
        Reset
        AddMenu
    }
    '2' {
        Reset
        AddMenu
        AddExtended
    }
    '3' {
        Reset
    }
    Default {
        throw 'Error'
    }
}

if (HasExit) { Read-Host 'Exit' }
