@echo off
REM �۰ʰ���ffmpeg��m�A�p�G����WinFF�αNffmpeg.exe���P�妸�ɬۦP�ؿ�
if exist "%programfiles(x86)%\WinFF\ffmpeg.exe" (set FF="%programfiles(x86)%\WinFF\ffmpeg.exe")
if exist "%programfiles%\WinFF\ffmpeg.exe" (set FF="%programfiles%\WinFF\ffmpeg.exe")
if exist "%~dp0ffmpeg.exe" (set FF="%~dp0ffmpeg.exe")
REM �Y�n�ۭqffmpeg��m�A�b�U���o��]�w�ñNREM����
REM SET FF=""
REM �u�@�Ϧ�m�]�n�[\�^�A�w�]���t�μȦs��
set WP=%temp%\
REM �Ϥ��ӷ����|�]�n�[\�^�A�p�G�򭵼��ɨӷ��ۦP�h��PS��0
REM set PS=C:\vocaloid\picture\
set PS=0
REM �v��������X���|�]�n�[\�^�A�p�G�򭵼��ɨӷ��ۦP�h��DP��0
REM set DP=R:\
set DP=0
REM ������u�@�ؿ�
cd /D %WP%
if exist worklist.txt (del worklist.txt)
if exist error.log (del error.log)
if exist ok.log (del ok.log)
for %%I in (%*) do if exist %FF% (
REM �N���ɽƻs��u�@��
	if %PS% EQU 0 (
		copy "%%~dpn%I.jpg" videotmp.jpg
	) else (
		copy "%PS%%%~n%I.jpg" videotmp.jpg
	)
REM �ˬd���ɦs�b�~�~��
if exist videotmp.jpg (
	REM �ƻs�����ɨ�u�@��
	copy %%I videotmp%%~x%I
	REM �HFFmpeg���ɡA-crf�᪺�Ʀr�O�e��]�w�A�Ʀr�V�p�e��V�n�ɮ׶V�j�A�ѦҭȡA15�W���A25�ܰ��A35��
	%FF% -loop 1 -i videotmp.jpg -i videotmp%%~x%I -shortest -crf 25 -vcodec libx264 -acodec copy videotmp.mp4
	REM �ˬd�ɮצp�G�j�p��0��ܥ���
		for %%S in (videotmp.mp4) do if %%~zS EQU 0 (
		echo '%date:~0,10% %time:~0,8% �X�����ѡA���ˬd%%~n%I.jpg�ؤo�O�_��2������' >> error.log
		del videotmp.mp4
		)
	REM �N�ͦ�\���ɮ׽ƻs��ت��a
		if exist videotmp.mp4 (
			if %DP% EQU 0 (
			copy videotmp.mp4 "%%~dpn%I.mp4"
			) else (
			copy videotmp.mp4 "%DP%%%~n%I.mp4"
			)
		echo '%date:~0,10% %time:~0,8% %%~n%I.mp4����' >> ok.log
		)
	REM �R���Ȧs��
	del %WP%videotmp.*
	) else (
	echo '%date:~0,10% %time:~0,8% �X�����ѡA�ʤ�%%~n%I.jpg�C' >> error.log
	)
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