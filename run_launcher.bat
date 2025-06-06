@echo off
setlocal
set PDIR=%~dp0
"%PDIR%processing\processing-java.exe" --sketch="%PDIR%launcher" --run
