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

Write-Output 'synchronize to directory path:'
$toPath = (Read-Host '>').TrimEnd('\')
$formPath = (Get-Item "$($PSScriptRoot|Split-Path)\source\").FullName.TrimEnd('\')
Get-ChildItem -Recurse -File $formPath | ForEach-Object {
    $formFile = $_
    $toFilePath = $formFile.FullName.Replace($formPath, $toPath)
    if (NeedCopy $formFile $toFilePath) {
        $flag = New-Item -Type Directory (Split-Path $toFilePath) -ErrorAction Ignore
        Copy-Item $formFile.FullName $toFilePath
        if ($flag) { Write-Output "New: $($flag.FullName)" }
        Write-Output "Copy: $toFilePath"
    }
}
Read-Host 'Exit'
