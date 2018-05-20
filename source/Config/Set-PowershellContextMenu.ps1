Import-Module "$($PSScriptRoot|Split-Path)\Cat.Base.Script.psm1"
RunAsForFile

$RegShell = 'Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Classes\Microsoft.PowerShellScript.1\Shell'
$RegDirectory = 'Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Classes\Directory'
$ShellPath = '"powershell.exe"'

# Open and Runas
function ResetOpen {
    Remove-Item "$RegShell\0" -Recurse -ErrorAction Ignore
    Remove-Item "$RegShell\Open" -Recurse -ErrorAction Ignore
    Remove-Item "$RegShell\Runas" -Recurse -ErrorAction Ignore
}

function PlusOpen {
    New-Item -Force  "$RegShell\Open\Command" -Value "$ShellPath -Command `"& '%1'`""
    New-Item -Force  "$RegShell\Runas\Command" -Value "$ShellPath -Command `"& '%1'`""
    New-ItemProperty "$RegShell\Runas" -Name 'Icon' -Value '%systemroot%\system32\imageres.dll,73' -PropertyType ExpandString
}

function DefalutOpen {
    New-Item -Force  "$RegShell\Open\Command" -Value '"C:\Windows\System32\notepad.exe" "%1"'
    New-Item -Force  "$RegShell\0\Command" -Value '"C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe" "-Command" "if(Get-ExecutionPolicy -ne ''AllSigned'') { Set-ExecutionPolicy -Scope Process Bypass }; & ''%1''"'
    New-ItemProperty "$RegShell\0" -Name 'MUIVerb' -Value '@"%systemroot%\system32\windowspowershell\v1.0\powershell.exe",-108' -PropertyType ExpandString
}

# Open with Powershell
function PlusDirectory {
    Set-ItemProperty    "$RegDirectory\shell\Powershell" -Name '(Default)' -Value 'Open with Powershell (&I)'
    New-ItemProperty    "$RegDirectory\shell\Powershell" -Name 'Icon' -Value $ShellPath
    Remove-ItemProperty "$RegDirectory\shell\Powershell" -Name 'Extended' -ErrorAction Ignore

    Set-ItemProperty    "$RegDirectory\background\shell\Powershell" -Name '(Default)' -Value 'Open with Powershell (&I)'
    New-ItemProperty    "$RegDirectory\background\shell\Powershell" -Name 'Icon' -Value $ShellPath
    Remove-ItemProperty "$RegDirectory\background\shell\Powershell" -Name 'Extended' -ErrorAction Ignore
}

function DefaultDirectory {
    Set-ItemProperty    "$RegDirectory\shell\Powershell" -Name '(Default)' -Value '@shell32.dll,-8508'
    Remove-ItemProperty "$RegDirectory\shell\Powershell" -Name 'Icon' -ErrorAction Ignore
    New-ItemProperty    "$RegDirectory\shell\Powershell" -Name 'Extended'

    Set-ItemProperty    "$RegDirectory\background\shell\Powershell" -Name '(Default)' -Value '@shell32.dll,-8508'
    Remove-ItemProperty "$RegDirectory\background\shell\Powershell" -Name 'Icon' -ErrorAction Ignore
    New-ItemProperty    "$RegDirectory\background\shell\Powershell" -Name 'Extended'
}

WriteFileTitle
Write-Output '
[Open and Runas]
11: Enable Plus
12: Default

[Open with Powershell (Directory, Verb=Powershell)]
21: Enable Plus
22: Default
'

switch (Read-Host '>') {
    '11' {
        ResetOpen
        PlusOpen
    }
    '12' {
        ResetOpen
        DefalutOpen
    }
    '21' {
        PlusDirectory
    }
    '22' {
        DefaultDirectory
    }
    Default {
        throw 'Error'
    }
}

if (HasExit) { Read-Host 'Exit' }
