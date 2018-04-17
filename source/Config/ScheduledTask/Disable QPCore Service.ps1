# Debug
# $DebugPreference = 'Continue'
Start-Process 'C:\Program Files (x86)\Tencent\TIM\Bin\QQScLauncher.exe'
Start-Sleep 5
while ($true) {
    $process = Get-Process 'tim' | Where-Object { $_.WorkingSet -lt '64mb' }
    if ($process -eq $null) {
        Write-Debug 'Clear'
        taskkill.exe /f /t /im QQProtect.exe
        Set-Service QPCore -StartupType Manual
        break;
    }
    else {
        Write-Debug 'Sleep'
        Start-Sleep 1
    }
}
if ($DebugPreference -eq 'Continue') {
    Read-Host 'Exit'
}
