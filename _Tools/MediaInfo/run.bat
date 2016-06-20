@echo off
rem 判斷OS為64或32位元然後執行對應的版本
if %PROCESSOR_ARCHITECTURE%==AMD64 start 64bit\MediaInfo.exe
if %PROCESSOR_ARCHITECTURE%==x86 start 32bit\MediaInfo.exe