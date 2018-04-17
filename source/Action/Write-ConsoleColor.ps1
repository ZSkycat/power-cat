$e = [char]0x1b
$text = 'cat'
$FGs = @(
    @{ Name='Default'; Value='39' },
    @{ Name='Bold'; Value='1' },
    @{ Name='Underline'; Value='4' },
    @{ Name='Black'; Value='30' },
    @{ Name='DarkGray'; Value='1;30' },
    @{ Name='DarkRed'; Value='31' },
    @{ Name='Red'; Value='1;31' },
    @{ Name='DarkGreen'; Value='32' },
    @{ Name='Green'; Value='1;32' },
    @{ Name='DarkYellow'; Value='33' },
    @{ Name='Yellow'; Value='1;33' },
    @{ Name='DarkBlue'; Value='34' },
    @{ Name='Blue'; Value='1;34' },
    @{ Name='DarkMagenta'; Value='35' },
    @{ Name='Magenta'; Value='1;35' },
    @{ Name='DarkCyan'; Value='36' },
    @{ Name='Cyan'; Value='1;36' },
    @{ Name='Gray'; Value='37' },
    @{ Name='White'; Value='1;37' }
)
$BGs = @(
    @{ Name='Default'; Value='49' },
    @{ Name='Black'; Value='40' },
    @{ Name='DarkRed'; Value='41' },
    @{ Name='DarkGreen'; Value='42' },
    @{ Name='DarkYellow'; Value='43' },
    @{ Name='DarkBlue'; Value='44' },
    @{ Name='DarkMagenta'; Value='45' },
    @{ Name='DarkCyan'; Value='46' },
    @{ Name='Gray'; Value='47' },
    @{ Name='DarkGray'; Value='100' },
    @{ Name='Red'; Value='101' },
    @{ Name='Green'; Value='102' },
    @{ Name='Yellow'; Value='103' },
    @{ Name='Blue'; Value='104' },
    @{ Name='Magenta'; Value='105' },
    @{ Name='Cyan'; Value='106' },
    @{ Name='White'; Value='107' }
)

# Color Table
Write-Host -NoNewline (' ' * 6)
foreach ($bg in $BGs) {
    Write-Host -NoNewline " $($bg.Value.PadRight($text.Length + 1)) "
}
Write-Host
foreach ($fg in $FGs) {
    Write-Host -NoNewline "$($fg.Value.PadLeft(5)) "
    foreach ($bg in $BGs) {
        Write-Host -NoNewline "$e[$($fg.Value);$($bg.Value)m $text $e[0m "
    }
    Write-Host
}

# Color Enum
Write-Host "`n[ForegroundColor]"
foreach ($fg in $FGs) {
    $t1 = "ESC[$($fg.Value)m".PadRight(9)
    $t2 = $fg.Name.PadRight(11)
    Write-Host "$t1 = $t2 = $e[$($fg.Value)m$text$e[0m"
}

Write-Host "`n[BackgroundColor]"
foreach ($bg in $BGs) {
    $t1 = "ESC[$($bg.Value)m".PadRight(9)
    $t2 = $bg.Name.PadRight(11)
    Write-Host "$t1 = $t2 = $e[$($bg.Value)m$text$e[0m"
}

Read-Host 'Exit'
