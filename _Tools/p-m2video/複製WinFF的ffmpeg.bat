@echo off
call setup.bat
cd /d %~dp0
if exist ffmpeg.exe (
	echo ffmpeg.exe�w�s�b
	pause
	exit
	) else (
	copy %FF%
	if exist ffmpeg.exe (
	echo ffmpeg.exe�w�ƻs
	)
)
pause