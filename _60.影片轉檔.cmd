::: 將各種影片格式統一轉換為 mp4 工具 by Peter JU
:::		2015/03/30 Last Modify
::: 注意事項
::: 	1.會利用到 .\Tools\ffmpeg\ffmpeg 工具程式
::: 	2.會利用到 .\Tools\wbin\date 工具程式
::: http://cation-av-station.blogspot.tw/2008/04/blog-post.html
::: http://www.mobile01.com/topicdetail.php?f=510&t=3734550
::: http://lnpcd.blogspot.tw/2012/07/ffmpeg-mp4.html
::: http://lnpcd.blogspot.tw/2012/09/ffmpeg.html
::: https://www.ptt.cc/bbs/EZsoft/M.1372509260.A.7B5.html
::: http://inpega.blogspot.tw/2012/07/cd-dp0.html
::: https://trac.ffmpeg.org/wiki/Scaling%20%28resizing%29%20with%20ffmpeg

@echo off
rem 切換工作目錄至批次檔所在目錄
cd /d "%~dp0"
::::::::::::::::: 參數設置 :::::::::::::::::
SETLOCAL ENABLEDELAYEDEXPANSION
::目前路徑
set thisPath=%~dp0
::欲處理的影片路徑
if exist %~1 set remotePath=%~d1%~p1
::ffmpeg程式路徑
set FF=%thisPath%_Tools\ffmpeg\ffmpeg.exe
::date程式路徑
set DT=%thisPath%_Tools\wbin\date.exe
::紀錄儲存目錄
set log=%thisPath%_Log
::轉檔輸出目錄
set out=%thisPath%#Output
::今天日期的變數today
set today=%date:~0,4%%date:~5,2%%date:~8,2%
::讀取與本批次檔相同名稱的參數檔(.txt)
set cfgFile=%~n0.txt

rem 刪除7天前的 log
forfiles /p %log% /m *.log /d -7 /c "cmd /c del @path" 2> nul
forfiles /m *.log /d -7 /c "cmd /c del @path" 2> nul

FOR /F "tokens=1 delims=," %%I IN ('findstr /V [#\[] %cfgFile%') DO (
	set ExtName=%%I
)

::開始轉檔
if not exist "%~1" (
	for %%i in (*.mp4 *.avi *.mkv *.flv *.f4v *.3gp *.mov *.asf *.ts *.tp *.mpg *.wmv *.rmvb *.rm *.vob) DO CALL :SubRoutin "%%i"
) else (
	CALL :SubRoutin "%~1"
)

echo Completed.
echo.
pause
exit /b

::::::::::::::::: 副程式(批次檔的函數呼叫) :::::::::::::::::
:SubRoutin
for /f %%h in ('%DT% "+%%H%%M%%S"') do set runtime=%%h
set FFREPORT=file='%log%\%today%-%runtime%-%~n1.log':level=32
if /I %ExtName%==mp4  goto mp4
if /I %ExtName%==avi  goto mp4
if /I %ExtName%==mkv  goto mkv
if /I %ExtName%==flv  goto mp4
if /I %ExtName%==f4v  goto mp4
if /I %ExtName%==3gp  goto mp4
if /I %ExtName%==mov  goto mp4
if /I %ExtName%==asf  goto mp4
if /I %ExtName%==ts   goto mp4
if /I %ExtName%==tp   goto mp4
if /I %ExtName%==wmv  goto wmv
if /I %ExtName%==rmvb goto mp4
if /I %ExtName%==rm   goto mp4
if /I %ExtName%==mpg  goto mpg
if /I %ExtName%==vob  goto mpg

:mp4
rem 此類別影片需轉換 video codec=libx264, audio codec=libvo_aacenc
	%FF% -y -i "%~1" -c:v libx264 -q:v 0 -profile:v baseline -aspect 16:9 -c:a aac -strict experimental -b:a 128k -async 1 -threads 3 "%out%\%~n1-converter.%ExtName%" -report
    rem %FF% -y -i "%~1" -c:v libx264 -q:v 0 -profile:v baseline -c:a aac -strict experimental -b:a 128k -async 1 -threads 3 "%out%\%~n1-converter.%ExtName%" -report
	rem %FF% -y -i "%~1" -c:v libx264 -q:v 0 -profile:v baseline -c:a libvo_aacenc -b:a 128k -async 1 -threads 3 "%out%\%~n1-converter.%ExtName%" -report
	goto subExit

:mpg
	%FF% -y -i "%~1" -q:v 0 -async 1 -acodec mp2 -threads 3 "%out%\%~n1-converter.%ExtName%" -report
	rem	%FF% -y -i "%~1" -target ntsc-dvd -qscale 0 -async 1 -acodec mp2 -threads 3 "%out%\%~n1-converter.%ExtName%" -report
	goto subExit
	
:wmv
rem Powerpoint中預設影片格視為wmv
	%FF% -y -i "%~1" -q:a 2 -q:v 2 -vcodec msmpeg4 -acodec wmav2 "%out%\%~n1-converter.%ExtName%" -report
	goto subExit

:subExit
timeout 3