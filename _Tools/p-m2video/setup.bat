@echo off
REM 自動偵測ffmpeg位置，如果有裝WinFF或將ffmpeg.exe放到與批次檔相同目錄
if exist "%programfiles(x86)%\WinFF\ffmpeg.exe" (set FF="%programfiles(x86)%\WinFF\ffmpeg.exe")
if exist "%programfiles%\WinFF\ffmpeg.exe" (set FF="%programfiles%\WinFF\ffmpeg.exe")
if exist "%~dp0ffmpeg.exe" (set FF="%~dp0ffmpeg.exe")
REM 若要自訂ffmpeg位置，在下面這行設定並將REM取消
REM SET FF="%programfiles%\WinFF1.50\ffmpeg.exe"
REM 工作區位置（要加\），預設為系統暫存區
set WP=%temp%\
REM 影片完成輸出路徑（要加\），如果跟音樂檔來源相同則用DP＝0
REM set DP=R:\
set DP=0
if %DP% NEQ 0 (set TP=%DP%)
REM 音樂檔參考長度（秒），不需精確比音樂檔長即可，設太大只是浪費時間空間
set ML=360
REM 影片片段時間（秒）
set CT=5
REM 淡入淡出時間（秒）（需在片段時間一半以下）
set FT=1
REM 設定影片片段淡入淡出參數
set/a F1=%FT%*25
set/a F2=(%CT%-%FT%)*25
if %FT% NEQ 0 (set FADE=, fade=in:0:%F1%,fade=out:%F2%:%F1%)

REM 影片加字（檔名、時間、指定字串）指定字串直接編輯filename0.ass
REM 0不加
REM 1只有指定字串
REM 2檔名+指定字串
REM 3時間+指定字串
REM 6檔名+時間+指定字串
set/a ST=0
if %ST% GTR 0 (set ASS=, subtitles=filenameu.ass)
set/a STA=%ST%%%3
set/a STB=%ST%%%2

REM 影片加Logo圖，位置1↙、3↘、7↖、9↗，0表示不使用
set/a WMA=0
REM logo圖需放在批次檔相同目錄，logo.jpg或logo.png，png優先，支援透明色
if exist %~dp0logo.jpg (set logo=logo.jpg)
if exist %~dp0logo.png (set logo=logo.png)
REM logo圖位置，
REM logo圖距離邊界的水平距離（像素）
set WMW=10
REM logo圖距離邊界的垂直距離（像素）
set WMH=10

if %WMA% EQU 1 (set WMS=-i %~dp0%logo% -filter_complex "overlay=%WMW%:main_h-overlay_h-%WMH%")
if %WMA% EQU 3 (set WMS=-i %~dp0%logo% -filter_complex "overlay=main_w-overlay_w-%WMW%:main_h-overlay_h-%WMH%")
if %WMA% EQU 7 (set WMS=-i %~dp0%logo% -filter_complex "overlay=%WMW%:%WMH%")
if %WMA% EQU 9 (set WMS=-i %~dp0%logo% -filter_complex "overlay=main_w-overlay_w-%WMW%:%WMH%")

REM 是否調整影片尺寸，是1/否0
REM 多圖合音時，如果圖檔都已經調整為相同尺寸此處選否
REM 簡易轉檔時視需求調整
set RS=0
REM 如果要調整影片尺寸，輸出的影片寬:高，可直接指定尺寸如848:480
REM iw/2:-1表示寬度為來源檔案的一半，高度自動計算，但注意必須都是2的倍數
REM 由於是不管比例把圖直接縮放成指定大小，並非最佳效果，建議不要用這功能把圖都做好再轉
REM set WH=iw/2:-1
set WH=640:360
if %RS% EQU 1 (set VS=, scale=%WH%)

REM 設定畫質，數字越小畫質越好檔案越大，參考值：15超高/25很高/35高
set VQ=25
REM 音效轉檔（轉檔1/直接複製0）
set CA=0
REM 設定音效位元率，音效直接複製時無效，越大檔案越大，參考值：256超/192優/128良/96可/64差
set AB=128
if %CA% EQU 0 (
	set CA=copy
 	) else (
	set CA=aac -ar 48000 -ab %AB%k -strict -2
	)

REM 是否只轉部分(時間)片段，是1/否0
set CV=0
REM 設定開始時間(時:分:秒)
set SS=0:0:0
REM 設定要擷取的影片時間(時:分:秒)（注意不是結束時間！）
set DT=0:0:52
if %CV% EQU 1 (
set VC=-ss %SS% -t %DT%
) else (
set VC=-shortest
)

REM 以下是簡易轉檔專用設定

REM 是否只轉部分(區域)片段，是1/否0
set CR=0
REM 設定要擷取的區域大小(寬:高)必須都是2的倍數
set RWH=360:240
REM 設定要擷取的區域左上角座標(X:Y)
set RXY=30:30
if %CR% EQU 1 (set VR=, crop=%RWH%:%RXY%)

if not exist %FF% (
echo 請安裝FFmpeg或WinFF
pause
exit
)