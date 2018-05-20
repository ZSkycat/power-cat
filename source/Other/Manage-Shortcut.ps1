param (
    [string]$MenuPath = "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Link",
    [string[]]$LinkPath
)

Write-Output $PSCommandPath
Write-Output '
1: Sync link to start menu
2: Remove link for start menu
'

switch (Read-Host '>') {
    '1' {
        if ($LinkPath.Length -eq 0) { throw 'Error: LinkPath is empty' }
        Remove-Item $MenuPath -Recurse -ErrorAction Ignore
        New-Item $MenuPath -ItemType Directory
        $linkItem = Get-ChildItem $LinkPath *.lnk
        $linkItem | ForEach-Object { Copy-Item $_.FullName $MenuPath }
        Write-Output "Sync $($linkItem.Length) item"
    }
    '2' {
        Remove-Item $MenuPath -Recurse
    }
    Default { throw 'Error' }
}
Read-Host 'Exit'
