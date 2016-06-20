::: �v���X�֤u�� by Peter JU
:::		2015/05/15 Last Modify
::: �`�N�ƶ�
::: 	1.�|�Q�Ψ� .\Tools\ffmpeg\ffmpeg �u��{��
::: 	2.�|�Q�Ψ� .\Tools\wbin\date �u��{��
::: http://lnpcd.blogspot.tw/2012/07/ffmpeg-mp4.html
::: http://lnpcd.blogspot.tw/2012/09/ffmpeg.html
::: https://www.ptt.cc/bbs/EZsoft/M.1372509260.A.7B5.html
::: http://inpega.blogspot.tw/2012/07/cd-dp0.html

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

FOR /F "tokens=1,2 delims=," %%I IN ('findstr /V [#\[] %cfgFile%') DO (
	set video=%%I
	set audio=%%J
)

rem for %%i in ("%video%") DO set ExtName=%%~xi

::�}�l����

for /f %%h in ('%DT% "+%%H%%M%%S"') do set runtime=%%h
set FFREPORT=file='%log%\!today!-!runtime!-%~n1.log':level=32
%FF% -y -i "%video%" -i "%audio%" -c:v copy -c:a aac -strict experimental "%out%\%video%" -report

rem %FF% -y -i "%video%" -i "%audio%" -c:v copy -c:a aac -strict experimental -map 0:v:0 -map 1:a:0 "%out%\%video%" -report

echo Completed.
echo.
pause
exit /b