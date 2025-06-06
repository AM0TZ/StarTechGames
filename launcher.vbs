Set WshShell = CreateObject("WScript.Shell")
WshShell.Run chr(34) & "run_launcher.bat" & chr(34), 0
Set WshShell = Nothing
' This script runs the "run_launcher.bat" file in a hidden window.
' Make sure to place this script in the same directory as "run_launcher.bat"    