@echo off
REM Ū�]�w��
call %~dp0setup.bat
if %DP% NEQ 0 (
	copy %WP%*.avi %DP%
	) else (
	copy %WP%*.avi %~dp0
	)

pause