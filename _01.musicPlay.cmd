@echo off
cd /d "%~dp0"

::����@��
rem start _Tools\foobar2000\foobar2000.exe PlayMusic
rem start _Tools\smplayer\smplayer PlayMusic -close-at-end
rem start _Tools\VLCPortable\VLCPortable PlayMusic --play-and-exit
rem FOR /R PlayMusic %%F in (*) do start _Tools\foobar2000\foobar2000.exe "%%F"

::�`������
rem start _Tools\VLCPortable\VLCPortable --loop PlayMusic
rem �U���� foobar2000 ���`������ѼƬO���Ѫ�
start _Tools\foobar2000\foobar2000.exe PlayMusic /playlist_command:Playback:Order=1

::�j���`������
rem _Tools\foobar2000\foobar2000.exe /exit
