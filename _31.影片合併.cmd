::: 將影片合併之後儲存為 mp4 工具 by Peter JU
:::		2015/03/29 Last Modify
::: 注意事項
::: 	1.會利用到 .\Tools\ffmpeg\ffmpeg 工具程式
::: 	2.會利用到 .\Tools\wbin\date 工具程式
::: https://trac.ffmpeg.org/wiki/Concatenate

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
	set mainName=%%I
)

::若找不到任何符合副檔名的檔案，則離開本程式
for /f %%h in ('%DT% "+%%H%%M%%S"') do set runtime=%%h
for %%i in ("%mainName%*") do set filename=%%i
if "%filename%"=="" (
	echo No match %mainName% file > %log%\\%today%-%runtime%-merge.log
	exit /b
)

::產生要合併的檔案列表檔
echo. > _concateList.txt
for %%i in ("%mainName%*") do echo file '%%i' >> _concateList.txt
type _concateList.txt
timeout 3

::抓取附檔名
for %%i in ("%mainName%*") do set ExtName=%%~xi

::開始轉檔
for /f %%h in ('%DT% "+%%H%%M%%S"') do set runtime=%%h
set FFREPORT=file='%log%\%today%-%runtime%-%mainName%-merge.log':level=32
rem 指定符合以下副檔名的檔案，其影音編碼無須重新編碼
rem 其餘影片一律轉換 video codec=libx264, audio codec=libvo_aacenc
set "quickCut="
if /I %ExtName%==.mp4 set quickCut=1
if /I %ExtName%==.avi set quickCut=1
if /I %ExtName%==.mkv set quickCut=1
if /I %ExtName%==.flv set quickCut=1
if /I %ExtName%==.f4v set quickCut=1
if /I %ExtName%==.3gp set quickCut=1
if /I %ExtName%==.mov set quickCut=1
if /I %ExtName%==.asf set quickCut=1
if /I %ExtName%==.mpg set quickCut=1
if /I %ExtName%==.wmv set quickCut=1
if /I %ExtName%==.rmvb set quickCut=1
if /I %ExtName%==.rm set quickCut=1
if /I %ExtName%==.mp3 set quickCut=1
IF defined quickCut (
	%FF% -y -f concat -i _concateList.txt -c copy -async 1 "%out%\%mainName%-merge%ExtName%" -report
) else (
	%FF% -y -f concat -i _concateList.txt -c:v libx264 -q:v 0 -profile:v baseline -c:a libvo_aacenc -b:a 320k -async 1 "%out%\%mainName%-merge%ExtName%" -report
)

del _concateList.txt > nul
echo Completed.
echo.
pause
exit /b