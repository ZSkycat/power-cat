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

Write-Host 'Remove startup'
Remove-ItemProperty 'Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Run' -Name 'ACPW11EN'
Remove-ItemProperty 'Registry::HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run' -Name 'ACDSeeCommanderPro11'

Write-Host 'Disable ACDSeeCommanderPro11.exe'
Get-Item 'C:\Program Files\ACD Systems\ACDSee Pro\11.0\ACDSeeCommanderPro11.exe' | Rename-Item -NewName 'ACDSeeCommanderPro11.exe.disable'

Read-Host 'Exit'
