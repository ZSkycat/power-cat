$ProcessName = 'tim'
$ProcessPath = 'C:\Program Files (x86)\Tencent\TIM\Bin\QQScLauncher.exe'

function ClearGarbage {
    taskkill.exe /f /t /im QQProtect.exe
    Set-Service QPCore -StartupType Manual
}

[int]$maxCount = 0
[datetime]$timeHasProcess = Get-Date
[int[]]$ids = Get-Process $ProcessName | ForEach-Object { $_.Id }
Start-Process $ProcessPath

while ($true) {
    Write-Output 'Sleep'
    Start-Sleep 1

    $now = Get-Date
    $process = Get-Process 'tim' | ForEach-Object {
        if ($ids -contains $_.Id) { return $null }
        else { return $_ }
    } | Where-Object { $_ -ne $null }

    if ($process) {
        $timeHasProcess = $now

        # 登录完成检测: 当 Tim 进程减少时
        if ($process.Length -gt $maxCount) {
            $maxCount = $process.Length
        }
        elseif ($process.Length -lt $maxCount) {
            ClearGarbage
            Write-Host 'Clear (count)'
            break
        }
    }
    else {
        # 异常检测: 当 Tim 进程不存在超过5秒时
        if (($now - $timeHasProcess).Seconds -gt 5) {
            ClearGarbage
            Write-Output 'Clear (null)'
            break
        }
    }
}
