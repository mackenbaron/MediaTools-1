@echo off
REM Ū�]�w��
call %~dp0setup.bat
REM �[logo��
if %WMA% GTR 0 (
cd /d %~dp0
copy %logo% %WP%
)
REM �M���L�h�O��
if exist %WP%worklist.txt (del %WP%worklist.txt)
if exist %WP%error.log (del %WP%error.log)
if exist %WP%ok.log (del %WP%ok.log)

for %%I in (%*) do (
	REM �[�ɦW/���w��r
	cd /d %WP%
	if %ST% GTR 0 (
	copy %~dp0filename0.ass filename.ass 
		if %STA% EQU 0 (
		echo Dialogue: 0,0:0:0.0,1:0:0.0,Default,,0,0,0,,%%~t%I >> filename.ass
		)
		if %STB% EQU 0 (
		echo Dialogue: 0,0:0:0.0,1:0:0.0,Default,,0,0,0,,%%~n%I >> filename.ass
		)
	%~dp0win_iconv.exe -f big5 -t utf-8 filename.ass > %~dp0filenameu.ass
	)
	REM �HFFmpeg����
	cd /d %%~dp%I
	%FF% -i %%I %WMS% -crf %VQ% -vcodec libx264 %VC% -acodec %CA% -threads 0 -vf "copy%VR%%VS%%ASS%" -y %TP%videotmp.mp4
	if %ST% GTR 0 (
	del %~dp0filenameu.ass
	del %WP%filename.ass
	)
	REM �ˬd�ɮצp�G�j�p��0��ܥ���
		for %%S in (%TP%videotmp.mp4) do if %%~zS EQU 0 (
		echo '%date:~0,10% %time:~0,8% ���ɥ��ѡA���ˬd%%I�ؤo�O�_��2������' >> %WP%error.log
		del %TP%videotmp.mp4
		)
	REM �N�ͦ�\���ɮק�W�A�Y�ت��P�ӷ��ۦP�h�b�ɦW��[�W_1
		if exist %TP%videotmp.mp4 (
			if %CV% EQU 1 (echo �^���ɶ����q%CV% >> %WP%ok.log)
			if %CR% EQU 1 (echo �^�������ϰ�ۮy��%RXY%���e��%RWH% >> %WP%ok.log)
			if %RS% EQU 1 (echo �վ�v���ؤo%WH% >> %WP%ok.log)
			if %DP% EQU 0 (
			cd /d %WP%
			echo '%date:~0,10% %time:~0,8% %%~dpn%I_1.mp4����' >> ok.log
			cd /d %%~dp%I
			if exist "%%~n%I_1.mp4" (
			del "%%~n%I_1.mp4"
			)
			ren videotmp.mp4 "%%~n%I_1.mp4"
			) else (
			cd /d %WP%
			echo '%date:~0,10% %time:~0,8% %TP%%%~n%I.mp4����' >> ok.log
			cd %TP%
			if exist "%%~n%I.mp4" (
			del "%%~n%I.mp4"
			)
			ren videotmp.mp4 "%%~n%I.mp4"
			)
		)
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