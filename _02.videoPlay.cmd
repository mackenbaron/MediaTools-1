@echo off
cd /d "%~dp0"

::����@��
start _Tools\smplayer\smplayer.exe PlayVideo -close-at-end
rem FOR /R PlayVideo %%F in (*) do _Tools\VLCPortable\VLCPortable.exe "%%F" --play-and-exit

::�`������
rem start _Tools\VLCPortable\VLCPortable.exe --loop PlayVideo