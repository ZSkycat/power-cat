Write-Host 'Remove environment variable'
$BandizipPath = 'C:\Program Files\Bandizip\'
$value = [System.Environment]::GetEnvironmentVariable('Path', [System.EnvironmentVariableTarget]::User)
if ($value.IndexOf($BandizipPath) -ge 0) {
    $value = $value.Replace($BandizipPath, '').Replace(';;', ';')
    [System.Environment]::SetEnvironmentVariable('Path', $value, [System.EnvironmentVariableTarget]::User)
    Write-Host 'True'
}

Read-Host 'Exit'
