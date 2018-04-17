<#
.SYNOPSIS
Run powershell as Administrator

.FORWARDHELPCATEGORY Alias
runas
#>
function Use-RunAs {
    [Alias("runas")]
    param (
        [Parameter(Position=0)]
        [Switch]$NoExit
    )

    $principal = [System.Security.Principal.WindowsPrincipal][System.Security.Principal.WindowsIdentity]::GetCurrent()
    $isAdministrator = $principal.IsInRole([System.Security.Principal.WindowsBuiltInRole]::Administrator)
    if (!$isAdministrator) {
        $cmd = [System.Environment]::GetCommandLineArgs()
        $location = (Get-Location).Path
        Start-Process -Verb 'runas' -FilePath ($cmd[0] -replace '.dll$', '.exe') -ArgumentList "-NoExit -Command Set-Location '$location'"
        if (!$NoExit) { exit }
    }
}

<#
.SYNOPSIS
Restart powershell

.FORWARDHELPCATEGORY restart
runas
#>
function Restart-Powershell () {
    [Alias("restart")]
    param ()
    $cmd = [System.Environment]::GetCommandLineArgs()
    $location = (Get-Location).Path
    Start-Process -FilePath ($cmd[0] -replace '.dll$', '.exe') -ArgumentList "-NoExit -Command Set-Location '$location'"
    exit
}

<#
.SYNOPSIS
Batch invoke command in multiple directories

.FORWARDHELPCATEGORY Alias
batch
#>
function Invoke-Batch {
    [Alias("batch")]
    param (
        [Parameter(Position=0)]
        [string[]]$Path,
        [string[]]$Exclude,

        [Parameter(ParameterSetName='Command', Mandatory=$true, Position=1)]
        [string]$Command,
        [Parameter(ParameterSetName='Command', ValueFromRemainingArguments=$true)]
        [string[]]$ArgumentList,
        [Parameter(ParameterSetName='Script')]
        [ScriptBlock]$Script
    )
    $location = Get-Location
    Get-ChildItem -Directory -Path $Path -Exclude $Exclude | ForEach-Object {
        Write-Host -NoNewline -ForegroundColor Cyan "`n========== "
        Write-Host -ForegroundColor Yellow $_
        Set-Location $_
        switch ($PSCmdlet.ParameterSetName) {
            'Command' {
                Invoke-Expression "& '$Command' $($ArgumentList -join ' ')"
            }
            'Script' {
                $Script.Invoke()
            }
        }
    }
    Set-Location $location
}

<#
.SYNOPSIS
Invoke git pull all and track all remote branch
#>
function Invoke-GitPullAll {
    param (
        [Switch]$TrackAll,
        [string]$RemoteName = 'origin'
    )
    if((git.exe status) -contains 'nothing to commit, working tree clean') {
        git.exe pull --all
        if ($TrackAll) {
            git.exe fetch --prune $RemoteName
            $loacl = git.exe branch | ForEach-Object { $_.Trim(' *') }
            $remote = git.exe branch --remote | Where-Object { $_ -match '->' -eq $false } | ForEach-Object { $_.Trim().TrimStart("$RemoteName/") }
            $remote | ForEach-Object {
                if ($loacl -contains $_ -eq $false) {
                    git.exe branch --track $_ "$RemoteName/$_"
                }
            }
        }
    }
    else {
        git.exe status
    }
}
