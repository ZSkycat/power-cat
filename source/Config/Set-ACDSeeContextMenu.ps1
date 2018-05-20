Import-Module "$($PSScriptRoot|Split-Path)\Cat.Base.Script.psm1"
RunAsForFile

$Name = 'ACDSee Professional 2018'
$NewName = 'ACDSee'
$RegACDSeeType = "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Classes\${Name}.*\shell"
$RegACDSeeManage = "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Classes\Directory\shell\${Name}.Manage"
$ShellList = 'Open', '2ACDDevelop', '3ACDEdit', '4ACDPrint'

function Reset ([string]$path) {
    Remove-ItemProperty $path -Name 'Extended' -ErrorAction Ignore
    Remove-ItemProperty $path -Name 'ProgrammaticAccessOnly' -ErrorAction Ignore
}

function AddExtended ([string]$path) {
    New-ItemProperty $path -Name 'Extended'
}

function AddHide ([string]$path) {
    New-ItemProperty $path -Name 'ProgrammaticAccessOnly'
}

function Rename ([string]$path) {
    if ($path -match 'Open$') {
        Get-Item $path | ForEach-Object { $_.OpenSubKey('', $true).DeleteValue('', $false) }
    }
    else {
        Get-Item $path | ForEach-Object {
            $value = $_.GetValue('')
            $_.OpenSubKey('', $true).SetValue('', ($value -replace $Name, $NewName))
        }
    }
}

function GetPath ([int]$index) {
    if ($index -ge 0 -and $index -le 3) {
        return "$RegACDSeeType\$($ShellList[$index])"
    }
    elseif ($index -eq 4) {
        return $RegACDSeeManage
    }
}

WriteFileTitle
Write-Output '
A: Enable
B: Enable (Shift)
C: Hide
D: Rename (Irreversible)

0: View with ACDSee
1: Develop with ACDSee
2: Edit with ACDSee
3: Print with ACDSee
4: Manage with ACDSee (Directory)

Example: B1234, D01234
'

switch -Regex (Read-Host '>') {
    'A\d{1,5}' {
        $_.ToCharArray()[1..9] | ForEach-Object {
            Reset (GetPath ([int][string]$_))
        }
    }
    'B\d{1,5}' {
        $_.ToCharArray()[1..9] | ForEach-Object {
            $path = GetPath ([int][string]$_)
            Reset $path
            AddExtended $path
        }
    }
    'C\d{1,5}' {
        $_.ToCharArray()[1..9] | ForEach-Object {
            $path = GetPath ([int][string]$_)
            Reset $path
            AddHide $path
        }
    }
    'D\d{1,5}' {
        $_.ToCharArray()[1..9] | ForEach-Object {
            Rename (GetPath ([int][string]$_))
        }
    }
    Default {
        throw 'Error'
    }
}

if (HasExit) { Read-Host 'Exit' }
