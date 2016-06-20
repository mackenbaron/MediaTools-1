::: 將影片的畫面擷取為 jpg 工具 by Peter JU
:::		2015/03/29 Last Modify
::: 注意事項
::: 	1.會利用到 .\Tools\ffmpeg\ffmpeg 工具程式
::: 	2.會利用到 .\Tools\wbin\date 工具程式
::: http://lnpcd.blogspot.tw/2012/07/ffmpeg-mp4.html
::: http://lnpcd.blogspot.tw/2012/09/ffmpeg.html
::: https://www.ptt.cc/bbs/EZsoft/M.1372509260.A.7B5.html
::: http://inpega.blogspot.tw/2012/07/cd-dp0.html
::: http://goo.gl/fi1guC

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

FOR /F "tokens=1,2,3 delims=," %%I IN ('findstr /V [#\[] %cfgFile%') DO (
	set Begin=%%I
	set End=%%J
	set Page=%%K
)

::開始轉檔
if not exist "%~1" (
	for %%i in (*.mp4 *.avi *.mkv *.flv *.f4v *.3gp *.mov *.asf *.ts *.tp *.mpg *.wmv *.rmvb *.rm *.vob) DO CALL :SubRoutin "%%i"
) else (
	CALL :SubRoutin "%~1"
)

:END
echo Completed.
echo.
pause
exit /b

::::::::::::::::: 副程式(批次檔的函數呼叫) :::::::::::::::::
:SubRoutin
	for /f %%h in ('%DT% "+%%H%%M%%S"') do set runtime=%%h
	set FFREPORT=file='%log%\!today!-!runtime!-%~n1.log':level=32
	
	%FF% -y -i "%~1" -an -ss %Begin% -to %End% -r %Page% "%out%\%~n1-cut%%d.jpg" -report

	timeout 3