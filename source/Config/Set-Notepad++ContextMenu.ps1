param (
    [string]$NotepadPath = '"E:\Program\Notepad++\notepad++.exe"'
)

Import-Module "$($PSScriptRoot|Split-Path)\Cat.Base.Script.psm1"
RunAsForFile

$RegNotepad = 'Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Classes\*\shell\Notepad'

function Reset {
    Remove-Item -LiteralPath $RegNotepad -Recurse -ErrorAction Ignore
}

function AddMenu {
    New-Item                      $RegNotepad -Value 'Open with Notepad++'
    New-ItemProperty -LiteralPath $RegNotepad -Name 'Icon' -Value $NotepadPath
    New-Item                      $RegNotepad\Command -Value "$NotepadPath `"%1`""
}

WriteFileTitle
Write-Output '
[Open with Notepad++ (Verb=Notepad)]
1: Enable
2: Disable
'

switch (Read-Host '>') {
    '1' {
        Reset
        AddMenu
    }
    '2' {
        Reset
    }
    Default {
        throw 'Error'
    }
}

if (HasExit) { Read-Host 'Exit' }
