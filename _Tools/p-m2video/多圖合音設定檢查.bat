@echo off
REM 讀設定檔
ECHO 多圖合音設定
ECHO ;
call %~dp0setup.bat
set FFP=%FF:ffmpeg.exe"=%
if exist %FFP%\fonts\fonts.conf" (
echo 字型設定OK，可影片加字
) else (
echo 使用影片加字功能需要將%~dp0fonts資料夾複製到ffmpeg所在處，
echo 或將ffmpeg複製到%~dp0
)
echo ffmpeg位置 %FF:"=%
echo 工作區位置 %WP%
if %DP% NEQ 0 (
	echo 影片完成輸出路徑%DP%
	) else (
	echo 影片完成輸出路徑跟音樂檔來源相同
)
echo ;
echo 音樂檔參考長度%ML%（秒）（此數值不需精確，比音樂檔長即可）
echo 影片片段時間%CT%（秒）
echo 淡入淡出時間%FT%（秒）（需在片段時間一半以下）
echo ;
if %ST% EQU 1 (echo 影片加字（指定字串）)
if %ST% EQU 2 (echo 影片加字（檔名+指定字串）)
if %ST% EQU 3 (echo 影片加字（時間+指定字串）)
if %ST% EQU 6 (echo 影片加字（檔名+時間+指定字串）)
if %ST% EQU 0 (
echo 影片不加字
) else (
echo 使用影片加字功能需要將%~dp0fonts資料夾複製到ffmpeg所在處，
echo 或將ffmpeg複製到%~dp0
)

echo ;
if %WMA% GTR 0 (
echo 影片加Logo圖，圖檔為%~dp0%logo%
) else (
echo 影片不加Logo圖
)
if %WMA% EQU 1 (echo Logo圖位置在左下角，距離邊界的水平/垂直為距離%WMW%/%WMH%)
if %WMA% EQU 3 (echo Logo圖位置在右下角，距離邊界的水平/垂直為距離%WMW%/%WMH%)
if %WMA% EQU 7 (echo Logo圖位置在左上角，距離邊界的水平/垂直為距離%WMW%/%WMH%)
if %WMA% EQU 9 (echo Logo圖位置在右上角，距離邊界的水平/垂直為距離%WMW%/%WMH%)

echo ;
if %RS% EQU 1 (
echo 調整影片尺寸，寬高為%WH%，請注意寬高必須都是2的倍數
ECHO 因為是不管比例直接縮放成指定大小，非最佳效果，建議不要用這功能把圖都做好再轉
)

echo ;
ECHO 畫質%VQ%（數字越小畫質越好檔案越大，參考值：15超高/25很高/35高）

echo ;
if "%CA%"=="copy" (
	ECHO 音效直接複製
 	) else (
	ECHO 音效轉檔位元率%AB%K（越大檔案越大，參考值：256超/192優/128良/96可/64差）
	)
echo ;
if %CV% EQU 1 (echo 只轉部份片段，%SS%開始，時間長度%DT%（時分秒）)

if not exist %FF% (
echo 請安裝FFmpeg或WinFF
pause
exit
)
echo ;
pause