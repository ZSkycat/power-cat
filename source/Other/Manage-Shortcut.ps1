param (
    [string]$MenuPath = "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Link",
    [string[]]$LinkPath
)

Write-Host $PSCommandPath
Write-Host '
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
        Write-Host "Sync $($linkItem.Length) item"
    }
    '2' {
        Remove-Item $MenuPath -Recurse
    }
    Default { throw 'Error' }
}
Read-Host 'Exit'
