function WriteOutput {
    param(
        [Parameter(Position=0, ValueFromPipeline=$True, ValueFromRemainingArguments=$true)]
        [Object]$Object,
        [System.ConsoleColor]$BackgroundColor,
        [System.ConsoleColor]$ForegroundColor
    )

    $bc = $Host.UI.RawUI.BackgroundColor
    $fc = $Host.UI.RawUI.ForegroundColor
    if($BackgroundColor -ne $null) {
       $host.UI.RawUI.BackgroundColor = $BackgroundColor
    }
    if($ForegroundColor -ne $null) {
        $host.UI.RawUI.ForegroundColor = $ForegroundColor
    }

    Write-Output $Object
    $Host.UI.RawUI.BackgroundColor = $bc
    $Host.UI.RawUI.ForegroundColor = $fc
}
