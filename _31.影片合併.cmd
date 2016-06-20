::: �N�v���X�֤����x�s�� mp4 �u�� by Peter JU
:::		2015/03/29 Last Modify
::: �`�N�ƶ�
::: 	1.�|�Q�Ψ� .\Tools\ffmpeg\ffmpeg �u��{��
::: 	2.�|�Q�Ψ� .\Tools\wbin\date �u��{��
::: https://trac.ffmpeg.org/wiki/Concatenate

@echo off
rem �����u�@�ؿ��ܧ妸�ɩҦb�ؿ�
cd /d "%~dp0"

::::::::::::::::: �ѼƳ]�m :::::::::::::::::
SETLOCAL ENABLEDELAYEDEXPANSION
::�ثe���|
set thisPath=%~dp0
::���B�z���v�����|
if exist %~1 set remotePath=%~d1%~p1
::ffmpeg�{�����|
set FF=%thisPath%_Tools\ffmpeg\ffmpeg.exe
::date�{�����|
set DT=%thisPath%_Tools\wbin\date.exe
::�����x�s�ؿ�
set log=%thisPath%_Log
::���ɿ�X�ؿ�
set out=%thisPath%#Output
::���Ѥ�����ܼ�today
set today=%date:~0,4%%date:~5,2%%date:~8,2%
::Ū���P���妸�ɬۦP�W�٪��Ѽ���(.txt)
set cfgFile=%~n0.txt

rem �R��7�ѫe�� log
forfiles /p %log% /m *.log /d -7 /c "cmd /c del @path" 2> nul
forfiles /m *.log /d -7 /c "cmd /c del @path" 2> nul

FOR /F "tokens=1 delims=," %%I IN ('findstr /V [#\[] %cfgFile%') DO (
	set mainName=%%I
)

::�Y�䤣�����ŦX���ɦW���ɮסA�h���}���{��
for /f %%h in ('%DT% "+%%H%%M%%S"') do set runtime=%%h
for %%i in ("%mainName%*") do set filename=%%i
if "%filename%"=="" (
	echo No match %mainName% file > %log%\\%today%-%runtime%-merge.log
	exit /b
)

::���ͭn�X�֪��ɮצC����
echo. > _concateList.txt
for %%i in ("%mainName%*") do echo file '%%i' >> _concateList.txt
type _concateList.txt
timeout 3

::������ɦW
for %%i in ("%mainName%*") do set ExtName=%%~xi

::�}�l����
for /f %%h in ('%DT% "+%%H%%M%%S"') do set runtime=%%h
set FFREPORT=file='%log%\%today%-%runtime%-%mainName%-merge.log':level=32
rem ���w�ŦX�H�U���ɦW���ɮסA��v���s�X�L�����s�s�X
rem ��l�v���@���ഫ video codec=libx264, audio codec=libvo_aacenc
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