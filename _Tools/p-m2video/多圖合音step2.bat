@echo
REM Ū�]�w��
call %~dp0setup.bat
if exist %WP%worklist.txt (del %WP%worklist.txt)
if exist %WP%error.log (del %WP%error.log)
if exist %WP%ok.log (del %WP%ok.log)
REM Ū�����ɨæX��
for %%M in (%*) do  (
	cd /d %%~dp%M
	%FF% -i %WP%output.avi %WMS% -i %%M -crf %VQ% -vcodec libx264 -acodec %CA% %VC% -y %TP%videotmp.mp4
		REM �ˬd�ɮצp�G�j�p��0��ܥ���
		for %%S in (%TP%videotmp.mp4) do if %%~zS EQU 0 (
		echo '%date:~0,10% %time:~0,8% �X�����ѡA���ˬd�ؤo�O�_��2������' >> %WP%error.log
		del %TP%videotmp.mp4
		)
	REM �N�ͦ�\���ɮק�W
		if exist %TP%videotmp.mp4 (
			if %DP% EQU 0 (
			cd /d %WP%
			echo '%date:~0,10% %time:~0,8% %%~dpn%M.mp4����' >> ok.log
			cd /d %%~dp%M
			) else (
			cd /d %WP%
			echo '%date:~0,10% %time:~0,8% %TP%%%~n%M.mp4����' >> ok.log
			cd %TP%
			)
		if exist "%%~n%M.mp4" (
		del "%%~n%M.mp4"
		)
		ren videotmp.mp4 "%%~n%M.mp4"
		)
	)
REM �q�u�@�O��
if exist %WP%error.log (
echo ���~�O�� > %WP%worklist.txt
type %WP%error.log >> %WP%worklist.txt
)
if exist %WP%ok.log (
echo �����O�� >> %WP%worklist.txt
type %WP%ok.log >> %WP%worklist.txt
)
if exist %WP%worklist.txt (notepad %WP%worklist.txt)
pause