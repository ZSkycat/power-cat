using module '.\Cat.PathLikeEnvVar.psm1'

function HasNoExit ([string[]]$cmd) {
    if ($cmd -eq $null) {
        $cmd = [System.Environment]::GetCommandLineArgs()
    }
    $skip = $false;
    foreach ($i in $cmd[1..$cmd.Length]) {
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

function HasExit ([string[]]$cmd) {
    return -not (HasNoExit $cmd)
}

function RunAsForFile ([string]$File) {
    $principal = [System.Security.Principal.WindowsPrincipal][System.Security.Principal.WindowsIdentity]::GetCurrent()
    $isAdministrator = $principal.IsInRole([System.Security.Principal.WindowsBuiltInRole]::Administrator)
    if (!$isAdministrator) {
        $cmd = [System.Environment]::GetCommandLineArgs()
        Start-Process -Verb 'runas' ($cmd[0] -replace '.dll$', '.exe') "-ExecutionPolicy Bypass -File `"$File`""
        if (HasNoExit $cmd) { throw 'Stop invoke' }
        else { exit }
    }
}

function WriteTitle ($path) {
    $title = (Split-Path $path -Leaf) -replace '_', ' ' -replace '.ps1$'
    Write-Host $title -ForegroundColor Green
}

function SetPathEnvVar {
    param (
        [string[]]$Value,
        [validateSet('Machine', 'User')]
        [string]$Target
    )
    $temp = [PathLikeEnvVar]::new([System.EnvironmentVariableTarget]$Target)
    $Value | ForEach-Object { $temp.Set($_) }
    $temp.Save() | Out-Null
}

function RemovePathEnvVar {
    param (
        [string[]]$Value,
        [validateSet('Machine', 'User')]
        [string]$Target = 'All'
    )
    $targets = @($Target)
    if ($Target -eq 'All') {
        $targets = 'Machine', 'User'
    }
    foreach ($i in $targets) {
        $temp = [PathLikeEnvVar]::new([System.EnvironmentVariableTarget]$i)
        $Value | ForEach-Object { $temp.Remove($_) }
        $temp.Save() | Out-Null
    }
}
