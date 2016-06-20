@echo off
REM 自動偵測ffmpeg位置，如果有裝WinFF或將ffmpeg.exe放到與批次檔相同目錄
if exist "%programfiles(x86)%\WinFF\ffmpeg.exe" (set FF="%programfiles(x86)%\WinFF\ffmpeg.exe")
if exist "%programfiles%\WinFF\ffmpeg.exe" (set FF="%programfiles%\WinFF\ffmpeg.exe")
if exist "%~dp0ffmpeg.exe" (set FF="%~dp0ffmpeg.exe")
REM 若要自訂ffmpeg位置，在下面這行設定並將REM取消
REM SET FF="%programfiles%\WinFF1.40\ffmpeg.exe"
REM 工作區位置（要加\），預設為系統暫存區
set WP=%temp%\
REM 設定開始時間(時:分:秒)
set SS=0:0:40
REM 設定要擷取的影片時間(時:分:秒)（注意不是結束時間！）
set DT=0:5:0
REM 砍掉後的檔案檔名前綴，如12.mp3處理後會變成cut_12.mp3
set PW=cut_
REM 切換到暫存目錄
cd /D %WP%
if exist worklist.txt (del worklist.txt)
if exist error.log (del error.log)
if exist ok.log (del ok.log)
for %%I in (%*) do if exist %FF% (
cd /D %%~dp%I
	REM 以FFmpeg轉檔
	%FF% -i %%I -shortest -acodec copy -ss %SS% -t %DT% mp3temp%%~x%I
	REM 將生成\的檔案複製到目的地
	rename mp3temp.* "%PW%%%~n%I.*"
cd /D %WP%
		echo '%date:~0,10% %time:~0,8% %%I完成聲音檔剪輯' >> ok.log
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