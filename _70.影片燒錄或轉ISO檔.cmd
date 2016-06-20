::: 影片燒錄或轉ISO檔 工具 by Peter JU
:::		2015/04/12 Last Modify
::: 注意事項
::: 	1.會利用到 .\Tools\ffmpeg\ffmpeg 工具程式
::: 	2.會利用到 .\Tools\dvdauthor\dvdauthor 工具程式
::: 	3.會利用到 .\Tools\ImgBurn\ImgBurn 工具程式
::: 	4.會利用到 .\Tools\wbin\date 工具程式
:::		http://forums.afterdawn.com/threads/batch-file-to-write-dvd-from-command-line-imgburn.666447/

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
::dvdauthor程式路徑
set DA=%thisPath%_Tools\dvdauthor\dvdauthor.exe
::ImgBurn程式路徑
set BN=%thisPath%_Tools\ImgBurn\ImgBurn.exe
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
	set isBurn=%%I
	set rwDriveLetter=%%J
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

::轉換為mpg格式
if exist "%out%\%~n1.mpg" del "%out%\%~n1.mpg"
%FF% -y -i "%~1" -target ntsc-dvd -qscale 0 -async 1 -aspect 16:9 "%out%\%~n1.mpg" -report

::轉換為DVD格式
if exist %out%\DVD\VIDEO_TS\*.vob del /Q /S %out%\DVD\
%DA% -t -o %out%\DVD -f "%out%\%~n1.mpg"
%DA% -T -o %out%\DVD
rem if exist %out%\%~n1.mpg del %out%\%~n1.mpg

::呼叫imgburn產生ISO檔
if exist %out%\DVD\VIDEO_TS\*.vob (
	echo 產生ISO檔中...
	if exist "%out%\%~n1.iso" del "%out%\%~n1.iso" > nul
	if exist "%out%\%~n1.mds" del "%out%\%~n1.mds" > nul
	%BN% /VOLUMELABEL "%~n1" /MODE BUILD /BUILDOUTPUTMODE /NOIMAGEDETAILS /ROOTFOLDER yes /FILESYSTEM "ISO9660 + UDF" /UDFREVISION "1.02" /START /CLOSE /LOG "%log%\[DATETIME]-%~n1-iso.log" /SRC "%out%\DVD\" /DEST "%out%\%~n1.iso"
	if exist "%out%\%~n1.iso" echo 產生ISO檔成功
	rem if exist "%out%\%~n1.iso" if exist %out%\DVD\VIDEO_TS\*.vob del /Q /S %out%\DVD\
) else (
	echo DVD格式產生失敗，無法建立ISO檔
)

if %isBurn%==Y (
	if exist "%out%\%~n1.iso" (
		echo 燒錄光碟中...
		%BN% /MODE WRITE /SPEED 4x /SRC "%out%\%~n1.iso" /DEST %rwDriveLetter% /WAITFORMEDIA /START /COPIES 1 /VERIFY YES /CLOSE /EJECT yes /DELETEIMAGE yes /LOG "%log%\[DATETIME]-%~n1-burn.log"
		echo 請自行確認光碟是否可正常撥放
	) else (
		echo ISO檔建立失敗，無法燒錄光碟
	)
)

timeout 3