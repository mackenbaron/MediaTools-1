::: ����v����V�u�� by Peter JU
:::		2015/03/29 Last Modify
::: �`�N�ƶ�
::: 	1.�|�Q�Ψ� .\Tools\ffmpeg\ffmpeg �u��{��
::: 	2.�|�Q�Ψ� .\Tools\wbin\date �u��{��
::: http://www.mobile01.com/topicdetail.php?f=510&t=3734550
::: http://lnpcd.blogspot.tw/2012/07/ffmpeg-mp4.html
::: http://lnpcd.blogspot.tw/2012/09/ffmpeg.html
::: https://www.ptt.cc/bbs/EZsoft/M.1372509260.A.7B5.html
::: http://inpega.blogspot.tw/2012/07/cd-dp0.html
::: http://stackoverflow.com/questions/112055/what-does-d0-mean-in-a-windows-batch-file

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

::�� _10.rotateVideo.txt Ū���Ѽ�
FOR /F "tokens=1 delims=," %%I IN ('findstr /V [#\[] %cfgFile%') DO (
	set rotateway=%%I
)

::�}�l����
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

::::::::::::::::: �Ƶ{��(�妸�ɪ���ƩI�s) :::::::::::::::::
:SubRoutin
	for /f %%h in ('%DT% "+%%H%%M%%S"') do set runtime=%%h
	set FFREPORT=file='%log%\!today!-!runtime!-%~n1.log':level=32
	set ExtName=%~x1
	
	%FF% -y -i "%~1" -vf transpose=%rotateway% "%out%\%~n1-rotate%ExtName%" -report

	timeout 3