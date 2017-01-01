::: 抓取 Youtube 影片檔工具 by Peter JU
:::		2015/03/22 Last Modify
::: 注意事項
::: 	1.會利用到 .\Tools\youtube-dl\youtube-dl 工具程式
::: 	2.會利用到 .\Tools\ffmpeg\ffmpeg 工具程式
::: 	3.會利用到 .\Tools\wbin\date 工具程式
:::	http://rg3.github.io/youtube-dl/

@echo off
cd /d "%~dp0"
::::::::::::::::: 參數設置 :::::::::::::::::
if exist _Tools\ffmpeg\ffmpeg.exe (set FF=_Tools\ffmpeg\ffmpeg.exe)
if exist _Tools\youtube-dl\youtube-dl.exe (set YU=_Tools\youtube-dl\youtube-dl.exe)
if exist _Tools\wbin\date.exe (set DT=_Tools\wbin\date.exe)
::今天日期的變數today
set today=%date:~0,4%%date:~5,2%%date:~8,2%
for /f %%h in ('%DT% "+%%H%%M%%S"') do set runtime=%%h
if not exist _Log\nul md _Log
set logfile=_Log\%today%-%runtime%-youtubeDL.log
::建立檔案下載後儲存目錄
if not exist #Output\nul md #Output
set out=#Output
::讀取參數的檔案
set cfgFile=%~n0.txt

rem 刪除7天前的 log
forfiles /p %log% /m *.log /d -7 /c "cmd /c del @path" 2> nul
forfiles /m *.log /d -7 /c "cmd /c del @path" 2> nul

SETLOCAL ENABLEDELAYEDEXPANSION
rem %YU% -a %cfgFile% -k -F
echo Downloading from youtube, Please wait...
%YU% -a %cfgFile% --output "%out%\%%(title)s.mp4" --ffmpeg-location %FF%> %logfile%
rem %YU% -a %cfgFile% -o "%out%\%%(title)s.mp4" FORMAT --ffmpeg-location %FF% --no-playlist

timeout 6