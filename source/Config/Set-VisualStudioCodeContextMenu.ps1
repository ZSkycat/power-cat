Import-Module "$($PSScriptRoot|Split-Path)\Cat.Base.Script.psm1"
RunAsForFile

$RegDirectory = 'Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Classes\Directory'
$VSCPath = '"C:\Program Files\Microsoft VS Code\Code.exe"'

function Reset {
    Remove-Item "$RegDirectory\shell\VSCode" -Recurse -ErrorAction Ignore
    Remove-Item "$RegDirectory\background\shell\VSCode" -Recurse -ErrorAction Ignore
}

function AddMenu () {
    New-Item         "$RegDirectory\shell\VSCode" -Value 'Open with Code'
    New-ItemProperty "$RegDirectory\shell\VSCode" -Name 'Icon' -Value $VSCPath
    New-Item         "$RegDirectory\shell\VSCode\Command" -Value "$VSCPath `"%V`""

    New-Item         "$RegDirectory\background\shell\VSCode" -Value 'Open with Code'
    New-ItemProperty "$RegDirectory\background\shell\VSCode" -Name 'Icon' -Value $VSCPath
    New-Item         "$RegDirectory\background\shell\VSCode\Command" -Value "$VSCPath `"%V`""
}

function AddExtended {
    New-ItemProperty "$RegDirectory\shell\VSCode" -Name 'Extended'
    New-ItemProperty "$RegDirectory\background\shell\VSCode" -Name 'Extended'
}

WriteFileTitle
Write-Output '
[Open with Code (Directory, Verb=VSCode)]
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
