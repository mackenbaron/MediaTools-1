@echo off
rem 切換工作目錄至批次檔所在目錄
cd /d "%~dp0"

REM Copy /y COMDLG32.OCX %windir%\system32\
REM regsvr32/s %windir%\system32\COMDLG32.OCX
start regsvr32 /u %cd%\COMDLG32.OCX
