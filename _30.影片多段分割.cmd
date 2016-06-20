::: �N�v�������n���^���� mp3 �u�� by Peter JU
:::		2015/03/25 Last Modify
::: �`�N�ƶ�
::: 	1.�|�Q�Ψ� .\Tools\ffmpeg\ffmpeg �u��{��
::: 	2.�|�Q�Ψ� .\Tools\wbin\date �u��{��
::: https://trac.ffmpeg.org/wiki/Encode/MP3
::: http://darkranger.no-ip.org/node/324

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

if not exist "%~1" echo �Щ즲�v���ɦܦ��u�� && GOTO END

set no=1000
::�}�l����
FOR /F "tokens=1,2 delims=," %%I IN ('findstr /V [#\[] %cfgFile%') DO CALL :SubRoutin "%~1" %%I %%J

:END
echo Completed.
echo.
pause
exit /b

::::::::::::::::: �Ƶ{��(�妸�ɪ���ƩI�s) :::::::::::::::::
:SubRoutin
	SET /A no = %no%+1
	for /f %%h in ('%DT% "+%%H%%M%%S"') do set runtime=%%h
	set FFREPORT=file='%log%\%today%-%runtime%-%~n1-%no:~2,2%.log':level=32
	set ExtName=%~x1
	
	%FF% -y -i "%~1" -map 0 -c copy -async 1 -ss %2 -to %3 "%out%\%~n1-%no:~2,2%%ExtName%" -report
	
	timeout 3