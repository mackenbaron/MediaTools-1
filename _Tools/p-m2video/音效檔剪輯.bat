@echo off
REM �۰ʰ���ffmpeg��m�A�p�G����WinFF�αNffmpeg.exe���P�妸�ɬۦP�ؿ�
if exist "%programfiles(x86)%\WinFF\ffmpeg.exe" (set FF="%programfiles(x86)%\WinFF\ffmpeg.exe")
if exist "%programfiles%\WinFF\ffmpeg.exe" (set FF="%programfiles%\WinFF\ffmpeg.exe")
if exist "%~dp0ffmpeg.exe" (set FF="%~dp0ffmpeg.exe")
REM �Y�n�ۭqffmpeg��m�A�b�U���o��]�w�ñNREM����
REM SET FF="%programfiles%\WinFF1.40\ffmpeg.exe"
REM �u�@�Ϧ�m�]�n�[\�^�A�w�]���t�μȦs��
set WP=%temp%\
REM �]�w�}�l�ɶ�(��:��:��)
set SS=0:0:40
REM �]�w�n�^�����v���ɶ�(��:��:��)�]�`�N���O�����ɶ��I�^
set DT=0:5:0
REM �屼�᪺�ɮ��ɦW�e��A�p12.mp3�B�z��|�ܦ�cut_12.mp3
set PW=cut_
REM ������Ȧs�ؿ�
cd /D %WP%
if exist worklist.txt (del worklist.txt)
if exist error.log (del error.log)
if exist ok.log (del ok.log)
for %%I in (%*) do if exist %FF% (
cd /D %%~dp%I
	REM �HFFmpeg����
	%FF% -i %%I -shortest -acodec copy -ss %SS% -t %DT% mp3temp%%~x%I
	REM �N�ͦ�\���ɮ׽ƻs��ت��a
	rename mp3temp.* "%PW%%%~n%I.*"
cd /D %WP%
		echo '%date:~0,10% %time:~0,8% %%I�����n���ɰſ�' >> ok.log
) else (
echo '�Цw��FFmpeg��WinFF'
)
REM �q�u�@�O��
if exist error.log (
echo ���~�O�� >> worklist.txt
type error.log >> worklist.txt
)
if exist ok.log (
echo �����O�� >> worklist.txt
type ok.log >> worklist.txt
)
if exist worklist.txt (notepad worklist.txt)
pause