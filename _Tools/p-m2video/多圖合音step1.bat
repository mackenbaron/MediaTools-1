@echo off
REM 讀設定檔
call %~dp0setup.bat
REM 清除過去記錄
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
	REM 加檔名/指定文字
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
	REM 以FFmpeg轉檔
	%FF% -loop 1 -i videotemp.jpg -vcodec msmpeg4 -b:v 12000k -t %CT% -vf "copy%VS%%ASS%%FADE%" -y -an videotmp.avi
	del %WP%videotemp.jpg
	del %WP%filenameu.ass
	del %WP%filename.ass
	REM 檢查檔案如果大小為0表示失敗
		for %%S in (%WP%videotmp.avi) do if %%~zS EQU 0 (
		echo '%date:~0,10% %time:~0,8% %%I轉檔失敗' >> %WP%error.log
		del %WP%videotmp.avi
		)
	REM 將生成\的檔案改名
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
echo MsgBox("影片片段轉檔完成，請檢查順序是否正確，調整後存檔並關閉記事本") > %WP%message.vbs
%WP%message.vbs
notepad %WP%cliplist.txt
REM 計算暫存的影片數量、重複次數
for /f "tokens=1 delims=][" %%K in ('find /n /v "" cliplist.txt') do (set /a A=%%K)
set /a TI=%ML%/(%CT%*%A%)
set /a TR=%ML%%%(%CT%*%A%)
if %TR% GTR 0 (set /a TI=%TI%+1)
for /l %%L in (1,1,%TI%) do (type cliplist.txt >> cliplist1.txt)
REM 將暫存影片合併
set var=
for /f "delims=" %%J in (cliplist1.txt) do call set "var=%%var%%'%%J'"
set CONCAT="%var: ''='|'%"
%FF% -i concat:%CONCAT:'=% -c copy -y output.avi

echo MsgBox("%date:~0,10% %time:~0,8%影片製作完成") > %WP%message.vbs
echo MsgBox("請將音效檔拖曳到「多圖合音step2.bat」") >> %WP%message.vbs
%WP%message.vbs