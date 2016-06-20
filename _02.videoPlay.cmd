@echo off
cd /d "%~dp0"

::撥放一次
start _Tools\smplayer\smplayer.exe PlayVideo -close-at-end
rem FOR /R PlayVideo %%F in (*) do _Tools\VLCPortable\VLCPortable.exe "%%F" --play-and-exit

::循環播放
rem start _Tools\VLCPortable\VLCPortable.exe --loop PlayVideo