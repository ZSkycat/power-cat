Set list = CreateObject("System.Collections.ArrayList")
For Each arg In Wscript.Arguments
    list.Add(arg)
Next
command = Replace(Join(list.ToArray, " "), "'", chr(34))
Set shell = CreateObject("WScript.Shell")
result = shell.Run(command, 0, true)
WScript.Quit result
