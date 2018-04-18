function NeedCopy ([System.IO.FileInfo]$formFile, [string]$toFilePath) {
    $toFile = Get-Item $toFilePath -ErrorAction Ignore
    if ($toFile) {
        if ($formFile.LastWriteTime -gt $toFile.LastWriteTime) { return $true }
        else { return $false }
    }
    else {
        return $true;
    }
}

Set-Location $PSScriptRoot
Write-Host 'synchronize to directory path:'
$toPath = (Read-Host '>').TrimEnd('\')
$formPath = (Get-Item '..\source\').FullName.TrimEnd('\')
Get-ChildItem -Recurse -File '..\source\' | ForEach-Object {
    $formFile = $_
    $toFilePath = $formFile.FullName.Replace($formPath, $toPath)
    if (NeedCopy $formFile $toFilePath) {
        $flag = New-Item -Type Directory (Split-Path $toFilePath) -ErrorAction Ignore
        Copy-Item $formFile.FullName $toFilePath
        if ($flag) { Write-Host "New: $($flag.FullName)" }
        Write-Host "Copy: $toFilePath"
    }
    # 'C:\Users\Cat\Desktop\test'
}
Read-Host 'Exit'
