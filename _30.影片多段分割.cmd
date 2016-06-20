::: 將影片中的聲音擷取為 mp3 工具 by Peter JU
:::		2015/03/25 Last Modify
::: 注意事項
::: 	1.會利用到 .\Tools\ffmpeg\ffmpeg 工具程式
::: 	2.會利用到 .\Tools\wbin\date 工具程式
::: https://trac.ffmpeg.org/wiki/Encode/MP3
::: http://darkranger.no-ip.org/node/324

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

if not exist "%~1" echo 請拖曳影片檔至此工具 && GOTO END

set no=1000
::開始轉檔
FOR /F "tokens=1,2 delims=," %%I IN ('findstr /V [#\[] %cfgFile%') DO CALL :SubRoutin "%~1" %%I %%J

:END
echo Completed.
echo.
pause
exit /b

::::::::::::::::: 副程式(批次檔的函數呼叫) :::::::::::::::::
:SubRoutin
	SET /A no = %no%+1
	for /f %%h in ('%DT% "+%%H%%M%%S"') do set runtime=%%h
	set FFREPORT=file='%log%\%today%-%runtime%-%~n1-%no:~2,2%.log':level=32
	set ExtName=%~x1
	
	%FF% -y -i "%~1" -map 0 -c copy -async 1 -ss %2 -to %3 "%out%\%~n1-%no:~2,2%%ExtName%" -report
	
	timeout 3