::: 影音合併工具 by Peter JU
:::		2015/05/15 Last Modify
::: 注意事項
::: 	1.會利用到 .\Tools\ffmpeg\ffmpeg 工具程式
::: 	2.會利用到 .\Tools\wbin\date 工具程式
::: http://lnpcd.blogspot.tw/2012/07/ffmpeg-mp4.html
::: http://lnpcd.blogspot.tw/2012/09/ffmpeg.html
::: https://www.ptt.cc/bbs/EZsoft/M.1372509260.A.7B5.html
::: http://inpega.blogspot.tw/2012/07/cd-dp0.html

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

FOR /F "tokens=1,2 delims=," %%I IN ('findstr /V [#\[] %cfgFile%') DO (
	set video=%%I
	set audio=%%J
)

rem for %%i in ("%video%") DO set ExtName=%%~xi

::開始轉檔

for /f %%h in ('%DT% "+%%H%%M%%S"') do set runtime=%%h
set FFREPORT=file='%log%\!today!-!runtime!-%~n1.log':level=32
%FF% -y -i "%video%" -i "%audio%" -c:v copy -c:a aac -strict experimental "%out%\%video%" -report

rem %FF% -y -i "%video%" -i "%audio%" -c:v copy -c:a aac -strict experimental -map 0:v:0 -map 1:a:0 "%out%\%video%" -report

echo Completed.
echo.
pause
exit /b