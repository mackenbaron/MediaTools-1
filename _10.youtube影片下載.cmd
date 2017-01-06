::: ��� Youtube �v���ɤu�� by Peter JU
:::		2015/03/22 Last Modify
::: �`�N�ƶ�
::: 	1.�|�Q�Ψ� .\Tools\youtube-dl\youtube-dl �u��{��
::: 	2.�|�Q�Ψ� .\Tools\ffmpeg\ffmpeg �u��{��
::: 	3.�|�Q�Ψ� .\Tools\wbin\date �u��{��
:::	http://rg3.github.io/youtube-dl/

@echo off
cd /d "%~dp0"
::::::::::::::::: �ѼƳ]�m :::::::::::::::::
if exist _Tools\ffmpeg\ffmpeg.exe (set FF=_Tools\ffmpeg)
if exist _Tools\youtube-dl\youtube-dl.exe (set YU=_Tools\youtube-dl\youtube-dl.exe)
if exist _Tools\wbin\date.exe (set DT=_Tools\wbin\date.exe)
::���Ѥ�����ܼ�today
set today=%date:~0,4%%date:~5,2%%date:~8,2%
for /f %%h in ('%DT% "+%%H%%M%%S"') do set runtime=%%h
if not exist _Log\nul md _Log
set logfile=_Log\%today%-%runtime%-youtubeDL.log
::�إ��ɮפU�����x�s�ؿ�
if not exist #Output\nul md #Output
set out=#Output
::Ū���Ѽƪ��ɮ�
set cfgFile=%~n0.txt

rem �R��7�ѫe�� log
forfiles /p %log% /m *.log /d -7 /c "cmd /c del @path" 2> nul
forfiles /m *.log /d -7 /c "cmd /c del @path" 2> nul

SETLOCAL ENABLEDELAYEDEXPANSION
rem %YU% -a %cfgFile% -k -F
echo Downloading from youtube, Please wait...
%YU% -a %cfgFile% -o "%out%\%%(title)s.%%(ext)s"> %logfile%
rem %YU% -a %cfgFile% -o "%out%\%%(title)s.mp4" --ffmpeg-location %FF%> %logfile%
rem %YU% -a %cfgFile% --extract-audio --audio-format mp3 --audio-quality 0 --ffmpeg-location %FF%> %logfile%
rem %YU% -a %cfgFile% -o "%out%\%%(title)s.mp4" FORMAT --ffmpeg-location %FF% --no-playlist
timeout 6