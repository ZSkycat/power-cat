# power-cat
My PowerShell profile and scripts.

Only supports Windows.

## Use Profile
Windows PowerShell and PowerShell Core:
```PowerShell
$path = 'your directory path'
New-Item -Type Directory (Split-Path $PROFILE.CurrentUserAllHosts)
New-Item -Type SymbolicLink $PROFILE.CurrentUserAllHosts -Value '$path\source\profile.ps1'
```

## License
```
       DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
               Version 2, December 2004

Copyright (C) ZSkycat

Everyone is permitted to copy and distribute verbatim or modified
copies of this license document, and changing it is allowed as long
as the name is changed.

           DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
  TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION

  0. You just DO WHAT THE FUCK YOU WANT TO.
```
