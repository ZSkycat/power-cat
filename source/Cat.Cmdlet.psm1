Import-Module "$PSScriptRoot\Cat.Base.psm1"


function Restart-Powershell () {
    <#
    .SYNOPSIS
    Restart powershell
    #>
    [Alias('restart')]
    [CmdletBinding()]
    param (
        [Switch]$NoResetPath
    )

    if (!$NoResetPath) {
        [System.Collections.ArrayList]$pathList = [System.Environment]::GetEnvironmentVariable('Path', [System.EnvironmentVariableTarget]::Machine).Split(';', [System.StringSplitOptions]::RemoveEmptyEntries)
        $pathList.AddRange([System.Environment]::GetEnvironmentVariable('Path', [System.EnvironmentVariableTarget]::User).Split(';', [System.StringSplitOptions]::RemoveEmptyEntries))
        $env:Path = [string]::Join(';', [string[]]$pathList) + ';'
    }

    $cmd = [System.Environment]::GetCommandLineArgs()
    $location = (Get-Location).Path
    Start-Process -FilePath ($cmd[0] -replace '.dll$', '.exe') -ArgumentList "-NoExit -Command Set-Location '$location'"
    exit
}
Export-ModuleMember -Function Restart-Powershell -Alias restart


function Use-RunAs {
    <#
    .SYNOPSIS
    Run powershell as Administrator
    #>
    [Alias('runas')]
    [CmdletBinding()]
    param (
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
Export-ModuleMember -Function Use-RunAs -Alias runas


function Invoke-Batch {
    <#
    .SYNOPSIS
    Batch invoke command in multiple directories
    #>
    [Alias('batch')]
    [CmdletBinding(DefaultParameterSetName='Command')]
    param (
        [Parameter(Position=0)]
        [string[]]$Path,
        [string[]]$Exclude,
        [string[]]$Include,
        [uint32]$Depth,
        [switch]$Recurse,
        [switch]$Force,

        [Parameter(ParameterSetName='Command', Mandatory=$true, Position=1)]
        [string]$Command,
        [Parameter(ParameterSetName='Command', ValueFromRemainingArguments=$true)]
        [string[]]$ArgumentList,
        [Parameter(ParameterSetName='Script')]
        [ScriptBlock]$Script
    )
    $location = Get-Location
    'Command', 'ArgumentList', 'Script' | ForEach-Object { $PSBoundParameters.Remove($_) } | Out-Null
    Get-ChildItem -Directory @PSBoundParameters | ForEach-Object {
        WriteOutput -ForegroundColor Green "`n========== $($_.FullName)"
        Set-Location $_.FullName
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
Export-ModuleMember -Function Invoke-Batch -Alias batch
