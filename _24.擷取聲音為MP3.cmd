::: �N�v�������n���^���� mp3 �u�� by Peter JU
:::		2015/03/29 Last Modify
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

FOR /F "tokens=1,2,3,4,5 delims=," %%I IN ('findstr /V [#\[] %cfgFile%') DO (
	set isSplitter=%%I
	set sampleRate=%%J
	set volumeFactor=%%K
	set Begin=%%L
	set End=%%M
)

::�}�l����
if not exist "%~1" (
	for %%i in (*.mp3 *.wav *.wma *.ogg *.aif *.aiff *.aac *.flac *.ape *.mp4 *.avi *.mkv *.flv *.f4v *.3gp *.mov *.asf *.ts *.tp *.mpg *.wmv *.rmvb *.rm *.vob) DO CALL :SubRoutin "%%i"
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
	if /I %isSplitter%==Y (
		%FF% -y -i "%~1" -vn -acodec libmp3lame -b:a %sampleRate% -af volume=%volumeFactor% -ss %Begin% -to %End% "%out%\%~n1-splitter.mp3" -report
	) else (
		%FF% -y -i "%~1" -vn -acodec libmp3lame -b:a %sampleRate% -af volume=%volumeFactor% "%out%\%~n1-converter.mp3" -report
	)
	
	timeout 3