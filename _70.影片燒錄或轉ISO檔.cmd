::: �v���N������ISO�� �u�� by Peter JU
:::		2015/04/12 Last Modify
::: �`�N�ƶ�
::: 	1.�|�Q�Ψ� .\Tools\ffmpeg\ffmpeg �u��{��
::: 	2.�|�Q�Ψ� .\Tools\dvdauthor\dvdauthor �u��{��
::: 	3.�|�Q�Ψ� .\Tools\ImgBurn\ImgBurn �u��{��
::: 	4.�|�Q�Ψ� .\Tools\wbin\date �u��{��
:::		http://forums.afterdawn.com/threads/batch-file-to-write-dvd-from-command-line-imgburn.666447/

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
::dvdauthor�{�����|
set DA=%thisPath%_Tools\dvdauthor\dvdauthor.exe
::ImgBurn�{�����|
set BN=%thisPath%_Tools\ImgBurn\ImgBurn.exe
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

FOR /F "tokens=1,2 delims=," %%I IN ('findstr /V [#\[] %cfgFile%') DO (
	set isBurn=%%I
	set rwDriveLetter=%%J
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

::�ഫ��mpg�榡
if exist "%out%\%~n1.mpg" del "%out%\%~n1.mpg"
%FF% -y -i "%~1" -target ntsc-dvd -qscale 0 -async 1 -aspect 16:9 "%out%\%~n1.mpg" -report

::�ഫ��DVD�榡
if exist %out%\DVD\VIDEO_TS\*.vob del /Q /S %out%\DVD\
%DA% -t -o %out%\DVD -f "%out%\%~n1.mpg"
%DA% -T -o %out%\DVD
rem if exist %out%\%~n1.mpg del %out%\%~n1.mpg

::�I�simgburn����ISO��
if exist %out%\DVD\VIDEO_TS\*.vob (
	echo ����ISO�ɤ�...
	if exist "%out%\%~n1.iso" del "%out%\%~n1.iso" > nul
	if exist "%out%\%~n1.mds" del "%out%\%~n1.mds" > nul
	%BN% /VOLUMELABEL "%~n1" /MODE BUILD /BUILDOUTPUTMODE /NOIMAGEDETAILS /ROOTFOLDER yes /FILESYSTEM "ISO9660 + UDF" /UDFREVISION "1.02" /START /CLOSE /LOG "%log%\[DATETIME]-%~n1-iso.log" /SRC "%out%\DVD\" /DEST "%out%\%~n1.iso"
	if exist "%out%\%~n1.iso" echo ����ISO�ɦ��\
	rem if exist "%out%\%~n1.iso" if exist %out%\DVD\VIDEO_TS\*.vob del /Q /S %out%\DVD\
) else (
	echo DVD�榡���ͥ��ѡA�L�k�إ�ISO��
)

if %isBurn%==Y (
	if exist "%out%\%~n1.iso" (
		echo �N�����Ф�...
		%BN% /MODE WRITE /SPEED 4x /SRC "%out%\%~n1.iso" /DEST %rwDriveLetter% /WAITFORMEDIA /START /COPIES 1 /VERIFY YES /CLOSE /EJECT yes /DELETEIMAGE yes /LOG "%log%\[DATETIME]-%~n1-burn.log"
		echo �Цۦ�T�{���ЬO�_�i���`����
	) else (
		echo ISO�ɫإߥ��ѡA�L�k�N������
	)
)

timeout 3