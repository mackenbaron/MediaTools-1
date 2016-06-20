@echo off
cd /d "%~dp0"

::撥放一次
rem start _Tools\foobar2000\foobar2000.exe PlayMusic
rem start _Tools\smplayer\smplayer PlayMusic -close-at-end
rem start _Tools\VLCPortable\VLCPortable PlayMusic --play-and-exit
rem FOR /R PlayMusic %%F in (*) do start _Tools\foobar2000\foobar2000.exe "%%F"

::循環播放
rem start _Tools\VLCPortable\VLCPortable --loop PlayMusic
rem 下面的 foobar2000 的循環播放參數是失敗的
start _Tools\foobar2000\foobar2000.exe PlayMusic /playlist_command:Playback:Order=1

::強制中止循環撥放
rem _Tools\foobar2000\foobar2000.exe /exit
