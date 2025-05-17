' create_launcher.vbs - One file that creates and runs the batch launcher

Set fso = CreateObject("Scripting.FileSystemObject")
Set shell = CreateObject("WScript.Shell")

' Get the folder of this .vbs file
baseDir = fso.GetParentFolderName(WScript.ScriptFullName)

' Path to temp batch file
batFile = baseDir & "\_temp_launcher.bat"

' Create batch file
Set bat = fso.CreateTextFile(batFile, True)
bat.WriteLine "setlocal"
bat.WriteLine "set PDIR=%~dp0"
bat.WriteLine """%PDIR%processing\processing-java.exe"" --sketch=""%PDIR%launcher"" --run"
bat.Close

' Run batch silently (0 = hidden window)
shell.Run """" & batFile & """", 0, True

' Clean up
fso.DeleteFile batFile
