function Invoke-GitPullAll {
    <#
    .SYNOPSIS
    Invoke git pull all and track all remote branch
    #>
    [CmdletBinding()]
    param (
        [Parameter(Position=0)]
        [string]$RemoteName = 'origin',
        [switch]$TrackAll
    )

    if((git.exe status) -contains 'nothing to commit, working tree clean') {
        git.exe pull --all
        if ($TrackAll) {
            git.exe fetch --prune $RemoteName
            $loacl = git.exe branch | ForEach-Object { $_.Trim(' *') }
            $remote = git.exe branch --remote | Where-Object { $_ -match '->' -eq $false } | ForEach-Object { $_.Trim().TrimStart("$RemoteName/") }
            ForEach-Object -InputObject $remote {
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
Export-ModuleMember -Function Invoke-GitPullAll


[string]$script:CurrentNpmPath = ''
function Use-Npm{
    <#
    .SYNOPSIS
    Add npm local bin directory to path
    #>
    [CmdletBinding()]
    param (
        [Parameter(Position=0)]
        [string]$Path,
        [switch]$Clear
    )
    if ($Path.Length -eq 0) { $Path = Get-Location }
    [System.Collections.ArrayList]$pathList = $env:Path.Split(';', [System.StringSplitOptions]::RemoveEmptyEntries)

    if ($script:CurrentNpmPath.Length -gt 0) {
        Write-Output "Remove path: $script:CurrentNpmPath"
        $pathList.Remove($script:CurrentNpmPath) | Out-Null
        $script:CurrentNpmPath = ''
    }

    if (!$Clear) {
        while ($Path.Length -gt 0) {
            $bin = "$Path\node_modules\.bin"
            if (Test-Path $bin) {
                $pathList.Add($bin) | Out-Null
                $script:CurrentNpmPath = $bin
                Write-Output "Add path: $script:CurrentNpmPath"
                break
            }
            $Path = Split-Path -Path $Path
        }
    }

    $env:Path = [string]::Join(';', [string[]]$pathList) + ';'
}
Export-ModuleMember -Function Use-Npm
