::: 指定影片擷取片段並儲存成(1.有聲影片2.無聲影片3.純聲音)之工具 by Peter JU
:::		2015/03/30 Last Modify
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

FOR /F "tokens=1,2,3,4 delims=," %%I IN ('findstr /V [#\[] %cfgFile%') DO (
	set isSplitter=%%I
	set grepType=%%J
	set Begin=%%K
	set End=%%L
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
	set FFREPORT=file='%log%\!today!-!runtime!-%~n1.log':level=32
	set ExtName=%~x1
	
	if /I %isSplitter%==Y (
		if /I %grepType%==both (
			%FF% -y -i "%~1" -map 0 -c copy -async 1 -ss %Begin% -to %End% "%out%\%~n1-splitter%ExtName%" -report
		)
		if /I %grepType%==video (
			%FF% -y -i "%~1" -an -vcodec copy -ss %Begin% -to %End% "%out%\%~n1-splitterMute%ExtName%" -report
		)
	) else (
		if /I %grepType%==both (
			%FF% -y -i "%~1" -map 0 -c copy -async 1 "%out%\%~n1-converter%ExtName%" -report
		)
		if /I %grepType%==video (
			%FF% -y -i "%~1" -an -vcodec copy "%out%\%~n1-allMute%ExtName%" -report
		)
	)

	timeout 3