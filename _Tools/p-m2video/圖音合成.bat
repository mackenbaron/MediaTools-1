@echo off
REM 自動偵測ffmpeg位置，如果有裝WinFF或將ffmpeg.exe放到與批次檔相同目錄
if exist "%programfiles(x86)%\WinFF\ffmpeg.exe" (set FF="%programfiles(x86)%\WinFF\ffmpeg.exe")
if exist "%programfiles%\WinFF\ffmpeg.exe" (set FF="%programfiles%\WinFF\ffmpeg.exe")
if exist "%~dp0ffmpeg.exe" (set FF="%~dp0ffmpeg.exe")
REM 若要自訂ffmpeg位置，在下面這行設定並將REM取消
REM SET FF=""
REM 工作區位置（要加\），預設為系統暫存區
set WP=%temp%\
REM 圖片來源路徑（要加\），如果跟音樂檔來源相同則用PS＝0
REM set PS=C:\vocaloid\picture\
set PS=0
REM 影片完成輸出路徑（要加\），如果跟音樂檔來源相同則用DP＝0
REM set DP=R:\
set DP=0
REM 切換到工作目錄
cd /D %WP%
if exist worklist.txt (del worklist.txt)
if exist error.log (del error.log)
if exist ok.log (del ok.log)
for %%I in (%*) do if exist %FF% (
REM 將圖檔複製到工作區
	if %PS% EQU 0 (
		copy "%%~dpn%I.jpg" videotmp.jpg
	) else (
		copy "%PS%%%~n%I.jpg" videotmp.jpg
	)
REM 檢查圖檔存在才繼續
if exist videotmp.jpg (
	REM 複製音樂檔到工作區
	copy %%I videotmp%%~x%I
	REM 以FFmpeg轉檔，-crf後的數字是畫質設定，數字越小畫質越好檔案越大，參考值，15超高，25很高，35高
	%FF% -loop 1 -i videotmp.jpg -i videotmp%%~x%I -shortest -crf 25 -vcodec libx264 -acodec copy videotmp.mp4
	REM 檢查檔案如果大小為0表示失敗
		for %%S in (videotmp.mp4) do if %%~zS EQU 0 (
		echo '%date:~0,10% %time:~0,8% 合成失敗，請檢查%%~n%I.jpg尺寸是否為2的倍數' >> error.log
		del videotmp.mp4
		)
	REM 將生成\的檔案複製到目的地
		if exist videotmp.mp4 (
			if %DP% EQU 0 (
			copy videotmp.mp4 "%%~dpn%I.mp4"
			) else (
			copy videotmp.mp4 "%DP%%%~n%I.mp4"
			)
		echo '%date:~0,10% %time:~0,8% %%~n%I.mp4完成' >> ok.log
		)
	REM 刪除暫存檔
	del %WP%videotmp.*
	) else (
	echo '%date:~0,10% %time:~0,8% 合成失敗，缺少%%~n%I.jpg。' >> error.log
	)
) else (
echo '請安裝FFmpeg或WinFF'
)
REM 秀工作記錄
if exist error.log (
echo 錯誤記錄 >> worklist.txt
type error.log >> worklist.txt
)
if exist ok.log (
echo 完成記錄 >> worklist.txt
type ok.log >> worklist.txt
)
if exist worklist.txt (notepad worklist.txt)
pause