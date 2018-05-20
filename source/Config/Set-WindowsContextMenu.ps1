Import-Module "$($PSScriptRoot|Split-Path)\Cat.Base.Script.psm1"
RunAsForFile

# Shell handler
$RegShellPath = @(
    'Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Classes\SystemFileAssociations\.*\Shell\3D Edit'
    'Registry::HKEY_CURRENT_USER\Software\Classes\AppX43hnxtbyyps62jhe9sqpdzxn1790zetc\Shell\ShellEdit'
    'Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Classes\SystemFileAssociations\.*\Shell\setdesktopwallpaper'
)

function ShellReset ([string]$path) {
    Remove-ItemProperty $path -Name 'Extended' -ErrorAction Ignore
    Remove-ItemProperty $path -Name 'ProgrammaticAccessOnly' -ErrorAction Ignore
}

function ShellExtended ([string]$path) {
    New-ItemProperty $path -Name 'Extended'
}

function ShellHide ([string]$path) {
    New-ItemProperty $path -Name 'ProgrammaticAccessOnly'
}

# Block handler
$RegBlock = 'Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Shell Extensions\Blocked'
$RegBlockName = @(
    '{1d27f844-3a1f-4410-85ac-14651078412d}'  # Troubleshoot Compatibility
    '{596AB062-B4D2-4215-9F74-E9109B0A8153}'  # Restore Previous Versions
)

function BlockEnable ([string]$name) {
    Remove-ItemProperty $RegBlock -Name $name
}

function BlockDisable ([string]$name) {
    New-Item $RegBlock -ErrorAction Ignore
    New-ItemProperty $RegBlock -Name $name
}

# ShellEx handler
$RegShellEx = @(
    # Rotate right / Rotate left
    @{ Path = 'Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Classes\SystemFileAssociations\.*\ShellEx\ContextMenuHandlers\ShellImagePreview'; Value = '{FFE2A43C-56B9-4bf5-9A79-CC6D4285608A}'}
    # Include in Library
    @{ Path = 'Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Classes\Folder\shellex\ContextMenuHandlers\Library Location'; Value = '{3dad6c5d-2167-4cae-9914-f99e41c12cfa}'}
)

function ShellExEnable ([string]$path, [string]$value) {
    New-Item $path -Value $value
}

function ShellExDisable ([string]$path) {
    Remove-Item $path
}

WriteFileTitle
Write-Output '
[Shell]
A: Enable
B: Enable (Shift)
C: Hide

0: Edit with Paint 3D (Image file)
1: Edit with Photos (Image file)
2: Set as desktop background (Image file)

[Block] Need to restart explorer
D: Block Enable
E: Block Disable

0: Troubleshoot Compatibility (Execute file)
1: Restore Previous Versions

[ShellEx]
F: ShellEx Enable
G: ShellEx Disable

0: Rotate right / Rotate left (Image file)
1: Include in Library (Directory)

Example: B012, E01, G01
'

switch -Regex (Read-Host '>') {
    '[A-C]\d{1,3}' {
        $action = $_[0]
        $_.ToCharArray()[1..9] | ForEach-Object {
            $index = [int][string]$_
            switch ($action) {
                'A' { ShellReset $RegShellPath[$index] }
                'B' { ShellReset $RegShellPath[$index]; ShellExtended $RegShellPath[$index] }
                'C' { ShellReset $RegShellPath[$index]; ShellHide $RegShellPath[$index] }
            }
        }
    }
    '[DE]\d{1,2}' {
        $action = $_[0]
        $_.ToCharArray()[1..9] | ForEach-Object {
            $index = [int][string]$_
            switch ($action) {
                'D' { BlockEnable $RegBlockName[$index] }
                'E' { BlockDisable $RegBlockName[$index] }
            }
        }
    }
    '[FG]\d{1,2}' {
        $action = $_[0]
        $_.ToCharArray()[1..9] | ForEach-Object {
            $index = [int][string]$_
            switch ($action) {
                'F' { ShellExEnable $RegShellEx[$index].Path $RegShellEx[$index].Value }
                'G' { ShellExDisable $RegShellEx[$index].Path }
            }
        }
    }
    Default {
        throw 'Error'
    }
}

if (HasExit) { Read-Host 'Exit' }
