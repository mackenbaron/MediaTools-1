@echo off
REM �۰ʰ���ffmpeg��m�A�p�G����WinFF
if exist "%programfiles%\WinFF\ffmpeg.exe" (set FF="%programfiles%\WinFF\ffmpeg.exe")
if exist "%programfiles(x86)%\WinFF\ffmpeg.exe" (set FF="%programfiles(x86)%\WinFF\ffmpeg.exe")
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
REM �p�G�n�վ�v���ؤo�A��X���v���e:���A�i�������w�ؤo�p848:480�Aiw/2:-1��ܼe�׬��ӷ��ɮת��@�b�A���צ۰ʭp��A���`�N�������O2������
set WH=iw/2:-1
REM if %RS% EQU 1 (set VS=-s %WH%)
if %RS% EQU 1 (set VS=-vf scale=%WH%)

REM �O�_�u�ೡ��(�ɶ�)���q�A�O1/�_0
set CV=0
REM �]�w�}�l�ɶ�(��:��:��)
set SS=0:0:5
REM �]�w�n�^�����v���ɶ�(��:��:��)
set DT=0:0:30
if %CV% EQU 1 (set VC=-ss %SS% -t %DT%)

REM �O�_�u�ೡ��(�ϰ�)���q�A�O1/�_0
set CR=0
REM �]�w�n�^�����ϰ�j�p(�e:��)�������O2������
set RWH=360:240
REM �]�w�n�^�����ϰ쥪�W���y��(X:Y)
set RXY=30:30
if %CR% EQU 1 (set VR=-vf crop=%RWH%:%RXY%)

REM ������u�@�ؿ�
cd /D %WP%
if exist worklist.txt (del worklist.txt)
if exist error.log (del error.log)
if exist ok.log (del ok.log)

for %%I in (%*) do if exist %FF% (
	REM �ƻs�v���ɨ�u�@��
	copy %%I videotmp.avi
	REM �HFFmpeg����
	%FF% -i videotmp.avi -crf %VQ% -vcodec libx264 %VC% -acodec libfaac -ar 48000 -ab %AB%k -flags +loop -cmp +chroma -partitions +parti4x4+partp8x8+partb8x8 -me_method hex -subq 6 -me_range 16 -g 250 -keyint_min 25 -sc_threshold 40 -i_qfactor 0.71 -b_strategy 1 -threads 0 %VS% %VR% videotmp.mp4
	REM �ˬd�ɮצp�G�j�p��0��ܥ���
		for %%S in (videotmp.mp4) do if %%~zS EQU 0 (
		echo '%date:~0,10% %time:~0,8% ���ɥ��ѡA���ˬd%%I�ؤo�O�_��2������' >> error.log
		del videotmp.mp4
		)
	REM �N�ͦ�\���ɮ׽ƻs��ت��a�A�Y�ت��P�ӷ��ۦP�h�b�ɦW��[�W_1
		if exist videotmp.mp4 (
                        if %RS% EQU 1 (
                        	if %CR% EQU 1 (echo �]�P�ɳ]�w�^�������ϰ�A�G�L�k�վ�v���ؤo >> ok.log)
                        	) else (
                        echo �վ�v���ؤo >> ok.log
                        )
                        if %CV% EQU 1 (echo �^���ɶ����q >> ok.log)
                        if %CR% EQU 1 (echo �^�������ϰ� >> ok.log)
			if %DP% EQU 0 (
			copy videotmp.mp4 "%%~dpn%I_1.mp4"
			echo '%date:~0,10% %time:~0,8% %%~n%I_1.mp4����' >> ok.log
			) else (
			copy videotmp.mp4 "%DP%%%~n%I.mp4"
			echo '%date:~0,10% %time:~0,8% %%~n%I.mp4����' >> ok.log
			)
		del %WP%videotmp.mp4
		)
	REM �R���Ȧs��
	del %WP%videotmp.avi
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