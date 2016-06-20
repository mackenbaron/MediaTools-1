@echo off
REM 讀設定檔
call %~dp0setup.bat
REM 加logo圖
if %WMA% GTR 0 (
cd /d %~dp0
copy %logo% %WP%
)
REM 清除過去記錄
if exist %WP%worklist.txt (del %WP%worklist.txt)
if exist %WP%error.log (del %WP%error.log)
if exist %WP%ok.log (del %WP%ok.log)

for %%I in (%*) do (
	REM 加檔名/指定文字
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
	REM 以FFmpeg轉檔
	cd /d %%~dp%I
	%FF% -i %%I %WMS% -crf %VQ% -vcodec libx264 %VC% -acodec %CA% -threads 0 -vf "copy%VR%%VS%%ASS%" -y %TP%videotmp.mp4
	if %ST% GTR 0 (
	del %~dp0filenameu.ass
	del %WP%filename.ass
	)
	REM 檢查檔案如果大小為0表示失敗
		for %%S in (%TP%videotmp.mp4) do if %%~zS EQU 0 (
		echo '%date:~0,10% %time:~0,8% 轉檔失敗，請檢查%%I尺寸是否為2的倍數' >> %WP%error.log
		del %TP%videotmp.mp4
		)
	REM 將生成\的檔案改名，若目的與來源相同則在檔名後加上_1
		if exist %TP%videotmp.mp4 (
			if %CV% EQU 1 (echo 擷取時間片段%CV% >> %WP%ok.log)
			if %CR% EQU 1 (echo 擷取部分區域自座標%RXY%取寬高%RWH% >> %WP%ok.log)
			if %RS% EQU 1 (echo 調整影片尺寸%WH% >> %WP%ok.log)
			if %DP% EQU 0 (
			cd /d %WP%
			echo '%date:~0,10% %time:~0,8% %%~dpn%I_1.mp4完成' >> ok.log
			cd /d %%~dp%I
			if exist "%%~n%I_1.mp4" (
			del "%%~n%I_1.mp4"
			)
			ren videotmp.mp4 "%%~n%I_1.mp4"
			) else (
			cd /d %WP%
			echo '%date:~0,10% %time:~0,8% %TP%%%~n%I.mp4完成' >> ok.log
			cd %TP%
			if exist "%%~n%I.mp4" (
			del "%%~n%I.mp4"
			)
			ren videotmp.mp4 "%%~n%I.mp4"
			)
		)
) 
REM 秀工作記錄
if exist %WP%error.log (
echo 錯誤記錄 >> %WP%worklist.txt
type %WP%error.log >> %WP%worklist.txt
)
if exist %WP%ok.log (
echo 完成記錄 >> %WP%worklist.txt
type %WP%ok.log >> %WP%worklist.txt
)
if exist %WP%worklist.txt (notepad %WP%worklist.txt)
pause