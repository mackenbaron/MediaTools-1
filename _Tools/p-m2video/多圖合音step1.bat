@echo off
REM Ū�]�w��
call %~dp0setup.bat
REM �M���L�h�O��
if exist %WP%videotemp.jpg  (del %WP%videotemp.jpg)
if exist %WP%filenameu.ass  (del %WP%filenameu.ass)
if exist %WP%filename.ass   (del %WP%filename.ass)
if exist %WP%worklist.txt (del %WP%worklist.txt)
if exist %WP%cliplist.txt (del %WP%cliplist.txt)
if exist %WP%cliplist1.txt (del %WP%cliplist1.txt)
if exist %WP%error.log (del %WP%error.log)
if exist %WP%ok.log (del %WP%ok.log)
for %%I in (%*) do  (
	copy %%I %WP%videotemp.jpg
	cd /d %WP%
	REM �[�ɦW/���w��r
	if %ST% GTR 0 (
	copy %~dp0filename0.ass filename.ass 
		if %STA% EQU 0 (
		echo Dialogue: 0,0:0:0.0,1:0:0.0,Default,,0,0,0,,%%~t%I >> filename.ass
		)
		if %STB% EQU 0 (
		echo Dialogue: 0,0:0:0.0,1:0:0.0,Default,,0,0,0,,%%~n%I >> filename.ass
		)
	%~dp0win_iconv.exe -f big5 -t utf-8 filename.ass > filenameu.ass
	)
	REM �HFFmpeg����
	%FF% -loop 1 -i videotemp.jpg -vcodec msmpeg4 -b:v 12000k -t %CT% -vf "copy%VS%%ASS%%FADE%" -y -an videotmp.avi
	del %WP%videotemp.jpg
	del %WP%filenameu.ass
	del %WP%filename.ass
	REM �ˬd�ɮצp�G�j�p��0��ܥ���
		for %%S in (%WP%videotmp.avi) do if %%~zS EQU 0 (
		echo '%date:~0,10% %time:~0,8% %%I���ɥ���' >> %WP%error.log
		del %WP%videotmp.avi
		)
	REM �N�ͦ�\���ɮק�W
		if exist "%%~n%I.avi" (
		del "%%~n%I.avi"
		)
		if exist %WP%videotmp.avi (
			cd /d %WP%
			ren videotmp.avi "%%~n%I.avi"
			echo %%~n%I.avi >> cliplist.txt
			)
	) 
if exist %WP%error.log (notepad %WP%error.log)
echo MsgBox("�v�����q���ɧ����A���ˬd���ǬO�_���T�A�վ��s�ɨ������O�ƥ�") > %WP%message.vbs
%WP%message.vbs
notepad %WP%cliplist.txt
REM �p��Ȧs���v���ƶq�B���Ʀ���
for /f "tokens=1 delims=][" %%K in ('find /n /v "" cliplist.txt') do (set /a A=%%K)
set /a TI=%ML%/(%CT%*%A%)
set /a TR=%ML%%%(%CT%*%A%)
if %TR% GTR 0 (set /a TI=%TI%+1)
for /l %%L in (1,1,%TI%) do (type cliplist.txt >> cliplist1.txt)
REM �N�Ȧs�v���X��
set var=
for /f "delims=" %%J in (cliplist1.txt) do call set "var=%%var%%'%%J'"
set CONCAT="%var: ''='|'%"
%FF% -i concat:%CONCAT:'=% -c copy -y output.avi

echo MsgBox("%date:~0,10% %time:~0,8%�v���s�@����") > %WP%message.vbs
echo MsgBox("�бN�����ɩ즲��u�h�ϦX��step2.bat�v") >> %WP%message.vbs
%WP%message.vbs