@echo
REM 讀設定檔
call %~dp0setup.bat
if exist %WP%worklist.txt (del %WP%worklist.txt)
if exist %WP%error.log (del %WP%error.log)
if exist %WP%ok.log (del %WP%ok.log)
REM 讀音效檔並合成
for %%M in (%*) do  (
	cd /d %%~dp%M
	%FF% -i %WP%output.avi %WMS% -i %%M -crf %VQ% -vcodec libx264 -acodec %CA% %VC% -y %TP%videotmp.mp4
		REM 檢查檔案如果大小為0表示失敗
		for %%S in (%TP%videotmp.mp4) do if %%~zS EQU 0 (
		echo '%date:~0,10% %time:~0,8% 合成失敗，請檢查尺寸是否為2的倍數' >> %WP%error.log
		del %TP%videotmp.mp4
		)
	REM 將生成\的檔案改名
		if exist %TP%videotmp.mp4 (
			if %DP% EQU 0 (
			cd /d %WP%
			echo '%date:~0,10% %time:~0,8% %%~dpn%M.mp4完成' >> ok.log
			cd /d %%~dp%M
			) else (
			cd /d %WP%
			echo '%date:~0,10% %time:~0,8% %TP%%%~n%M.mp4完成' >> ok.log
			cd %TP%
			)
		if exist "%%~n%M.mp4" (
		del "%%~n%M.mp4"
		)
		ren videotmp.mp4 "%%~n%M.mp4"
		)
	)
REM 秀工作記錄
if exist %WP%error.log (
echo 錯誤記錄 > %WP%worklist.txt
type %WP%error.log >> %WP%worklist.txt
)
if exist %WP%ok.log (
echo 完成記錄 >> %WP%worklist.txt
type %WP%ok.log >> %WP%worklist.txt
)
if exist %WP%worklist.txt (notepad %WP%worklist.txt)
pause