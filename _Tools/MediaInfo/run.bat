@echo off
rem �P�_OS��64��32�줸�M��������������
if %PROCESSOR_ARCHITECTURE%==AMD64 start 64bit\MediaInfo.exe
if %PROCESSOR_ARCHITECTURE%==x86 start 32bit\MediaInfo.exe