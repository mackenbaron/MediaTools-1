@echo off
call setup.bat
cd /d %~dp0
if exist ffmpeg.exe (
	echo ffmpeg.exe已存在
	pause
	exit
	) else (
	copy %FF%
	if exist ffmpeg.exe (
	echo ffmpeg.exe已複製
	)
)
pause