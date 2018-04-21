function ClearGarbage {
    taskkill.exe /f /t /im QQProtect.exe
    Set-Service QPCore -StartupType Manual
}

[double]$maxWs = 100
[datetime]$beginTimeWs = Get-Date
[datetime]$beginTimeNull = Get-Date
Start-Process 'C:\Program Files (x86)\Tencent\TIM\Bin\QQScLauncher.exe'

while ($true) {
    Write-Output 'Sleep'
    Start-Sleep 1

    $now = Get-Date
    $process = Get-Process 'tim'

    if ($process) {
        $beginTimeNull = $now

        # 登录完成检测: 当 Tim 内存保持稳定时
        $currentMax = ($process | Measure-Object -Property WS -Maximum).Maximum / 1mb

        if ([System.Math]::Abs($currentMax - $maxWs) -lt 5) {
            if (($now - $beginTimeWs).Seconds -gt 5) {
                ClearGarbage
                Write-Output 'Clear (ws)'
                break
            }
        }
        else {
            $beginTimeWs = $now
        }

        if ($currentMax -gt $maxWs) { $maxWs = $currentMax }
    }
    else {
        # 异常检测: 当 Tim 进程不存在时
        if (($now - $beginTimeNull).Seconds -gt 5) {
            ClearGarbage
            Write-Output 'Clear (null)'
            break
        }
    }
}
