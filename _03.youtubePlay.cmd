@echo off
cd /d "%~dp0"

::::::::::::::::: °Ñ¼Æ³]¸m :::::::::::::::::
if exist _Tools\smplayer\smplayer.exe (set MP=_Tools\smplayer\smplayer.exe)
setlocal enabledelayedexpansion

for /f "tokens=1,* delims=\=" %%x in ('find "URL=" PlayYoutube\*') do (
  set url=%%y
  if "!url:~0,4!"=="http" echo !url!
  if "!url:~0,4!"=="http" %MP% "!url!" -close-at-end
  rem if "!url:~0,4!"=="http" %MP% "!url!" -close-at-end -fullscreen
  timeout 1 > nul
)
