using module ".\Cat.Base.PathVariable.psm1"
Import-Module "$PSScriptRoot\Cat.Base.psm1"

function HasNoExit ([string[]]$Cmd) {
    if ($Cmd -eq $null) { $Cmd = [System.Environment]::GetCommandLineArgs() }
    $skip = $false;
    foreach ($i in $Cmd[1..$Cmd.Length]) {
        if ($skip) {
            $skip = $false
            continue
        }
        switch -Regex ($i) {
            '-NoExit' { return $true }
            '-Command|-EncodedCommand|-File' { return $false }
            '-ExecutionPolicy|-PSConsoleFile|-Version|-WindowStyle|-InputFormat|-OutputFormat' { $skip = $true }
            '-NonInteractive|-NoLogo|-NoProfile|-Mta|-Sta' {}
            Default { return $false }
        }
    }
    return $true
}

function HasExit ([string[]]$Cmd) {
    return -not (HasNoExit $Cmd)
}

function RunAsForFile ([string]$File) {
    if ($File.Length -eq 0) { $File = $MyInvocation.PSCommandPath }
    $principal = [System.Security.Principal.WindowsPrincipal][System.Security.Principal.WindowsIdentity]::GetCurrent()
    $isAdministrator = $principal.IsInRole([System.Security.Principal.WindowsBuiltInRole]::Administrator)
    if (!$isAdministrator) {
        $cmd = [System.Environment]::GetCommandLineArgs()
        Start-Process -Verb 'runas' ($cmd[0] -replace '.dll$', '.exe') "-ExecutionPolicy Bypass -File `"$File`""
        if (HasNoExit $cmd) { throw 'Stop invoke' }
        else { exit }
    }
}


function WriteFileTitle ([string]$File) {
    if ($File.Length -eq 0) { $File = $MyInvocation.PSCommandPath }
    $title = (Get-Item $File).BaseName -replace '_', ' '
    WriteOutput $title -ForegroundColor Green
}


function SetPathVariable {
    param (
        [string[]]$Value,
        [validateSet('Machine', 'User')]
        [string]$Target,
        [string]$Name = 'Path'
    )
    $temp = [PathVariable]::new([System.EnvironmentVariableTarget]$Target, $Name)
    $Value | ForEach-Object { $temp.Set($_) }
    $temp.Save() | Out-Null
}

function RemovePathVariable {
    param (
        [string[]]$Value,
        [validateSet('Machine', 'User')]
        [string]$Target = 'All',
        [string]$Name = 'Path'
    )
    $targets = @($Target)
    if ($Target -eq 'All') {
        $targets = 'Machine', 'User'
    }
    foreach ($i in $targets) {
        $temp = [PathVariable]::new([System.EnvironmentVariableTarget]$i, $Name)
        $Value | ForEach-Object { $temp.Remove($_) }
        $temp.Save() | Out-Null
    }
}
