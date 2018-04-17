function RunFileAsAdministrator {
    $principal = [System.Security.Principal.WindowsPrincipal][System.Security.Principal.WindowsIdentity]::GetCurrent()
    $isAdministrator = $principal.IsInRole([System.Security.Principal.WindowsBuiltInRole]::Administrator)
    if (!$isAdministrator) {
        $cmd = [System.Environment]::GetCommandLineArgs()
        Start-Process -Verb 'runas' ($cmd[0] -replace '.dll$', '.exe') "-File `"$PSCommandPath`""
        if (($cmd.Length -gt 1) -and (($cmd[1..$cmd.Length] | Where-Object { $_ -match '-NoExit' }) -eq $null)) {
            exit
        }
        else {
            throw 'Stop invoke'
        }
    }
}
RunFileAsAdministrator

Write-Host 'Disable service'
Set-Service 'TeamViewer' -StartupType Manual

Read-Host 'Exit'
