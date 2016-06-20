@echo off
REM �۰ʰ���ffmpeg��m�A�p�G����WinFF�αNffmpeg.exe���P�妸�ɬۦP�ؿ�
if exist "%programfiles(x86)%\WinFF\ffmpeg.exe" (set FF="%programfiles(x86)%\WinFF\ffmpeg.exe")
if exist "%programfiles%\WinFF\ffmpeg.exe" (set FF="%programfiles%\WinFF\ffmpeg.exe")
if exist "%~dp0ffmpeg.exe" (set FF="%~dp0ffmpeg.exe")
REM �Y�n�ۭqffmpeg��m�A�b�U���o��]�w�ñNREM����
REM SET FF=""
REM �u�@�Ϧ�m�]�n�[\�^�A�w�]���t�μȦs��
set WP=%temp%\
REM �v��������X���|�]�n�[\�^�A�p�G��ӷ��ۦP�h��DP��0
rem set DP=R:\
set DP=0
REM �]�w�e��A�Ʀr�V�p�e��V�n�ɮ׶V�j�A�ѦҭȡG15�W��/25�ܰ�/35��
set VQ=25
REM �]�w���Ħ줸�v�A�V�j�ɮ׶V�j�A�ѦҭȡG256�W/192�u/128�}/96�i/64�t
set AB=128

REM �O�_�վ�v���ؤo�A�O1/�_0
set RS=0
REM �p�G�n�վ�v���ؤo�A��X���v���e:���A�i�������w�ؤo�p848:480
REM iw/2:-1��ܼe�׬��ӷ��ɮת��@�b�A���צ۰ʭp��A���`�N�������O2������
set WH=iw/2:-1
if %RS% EQU 1 (set VS=-vf scale=%WH%)

REM �O�_�u�ೡ��(�ɶ�)���q�A�O1/�_0
set CV=0
REM �]�w�}�l�ɶ�(��:��:��)
set SS=0:0:5
REM �]�w�n�^�����v���ɶ�(��:��:��)�]�`�N���O�����ɶ��I�^
set DT=0:0:30
if %CV% EQU 1 (set VC=-ss %SS% -t %DT%)

REM �O�_�u�ೡ��(�ϰ�)���q�A�O1/�_0
set CR=0
REM �]�w�n�^�����ϰ�j�p(�e:��)�������O2������
set RWH=360:240
REM �]�w�n�^�����ϰ쥪�W���y��(X:Y)
set RXY=30:30
if %CR% EQU 1 (set VR=-vf crop=%RWH%:%RXY%)

REM �M���L�h�O��
if exist %WP%worklist.txt (del %WP%worklist.txt)
if exist %WP%error.log (del %WP%error.log)
if exist %WP%ok.log (del %WP%ok.log)
if %DP% NEQ 0 (set TP=%DP%)

for %%I in (%*) do if exist %FF% (
	cd /d %%~dp%I
	REM �HFFmpeg����
	%FF% -i %%I -crf %VQ% -vcodec libx264 %VC% -acodec libfaac -ar 48000 -ab %AB%k -flags +loop -cmp +chroma -partitions +parti4x4+partp8x8+partb8x8 -me_method hex -subq 6 -me_range 16 -g 250 -keyint_min 25 -sc_threshold 40 -i_qfactor 0.71 -b_strategy 1 -threads 0 %VS% %VR% %TP%videotmp.mp4
	REM �ˬd�ɮצp�G�j�p��0��ܥ���
		for %%S in (%TP%videotmp.mp4) do if %%~zS EQU 0 (
		echo '%date:~0,10% %time:~0,8% ���ɥ��ѡA���ˬd%%I�ؤo�O�_��2������' >> %WP%error.log
		del %TP%videotmp.mp4
		)
	REM �N�ͦ�\���ɮק�W�A�Y�ت��P�ӷ��ۦP�h�b�ɦW��[�W_1
		if exist %TP%videotmp.mp4 (
                        if %RS% EQU 1 (
                        	if %CR% EQU 1 (echo �]�P�ɳ]�w�^�������ϰ�A�G�L�k�վ�v���ؤo >> %WP%ok.log
                        	) else (
                        echo �վ�v���ؤo%WH% >> %WP%ok.log
                        )
                        )
                        if %CV% EQU 1 (echo �^���ɶ����q%CV% >> %WP%ok.log)
                        if %CR% EQU 1 (echo �^�������ϰ�ۮy��%RXY%���e��%RWH% >> %WP%ok.log)
			if %DP% EQU 0 (
			cd /d %WP%
			echo '%date:~0,10% %time:~0,8% %%~dpn%I_1.mp4����' >> ok.log
			cd /d %%~dp%I
			ren videotmp.mp4 "%%~n%I_1.mp4"
			) else (
			cd /d %WP%
			echo '%date:~0,10% %time:~0,8% %TP%%%~n%I.mp4����' >> ok.log
			cd %TP%
			ren videotmp.mp4 "%%~n%I.mp4"
			)
		)
) else (
echo '�Цw��FFmpeg��WinFF'
)
REM �q�u�@�O��
if exist %WP%error.log (
echo ���~�O�� >> %WP%worklist.txt
type %WP%error.log >> %WP%worklist.txt
)
if exist %WP%ok.log (
echo �����O�� >> %WP%worklist.txt
type %WP%ok.log >> %WP%worklist.txt
)
if exist %WP%worklist.txt (notepad %WP%worklist.txt)
pause