@echo off
REM 讀設定檔
ECHO 簡易轉檔設定
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
	echo 影片完成輸出路徑跟影片檔來源相同
)

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
echo 因影片加Logo圖，調整大小、淡入淡出、加字等所有影像濾鏡的設定都會失效
)
if %WMA% EQU 1 (echo Logo圖位置在左下角，距離邊界的水平/垂直為距離%WMW%/%WMH%)
if %WMA% EQU 3 (echo Logo圖位置在右下角，距離邊界的水平/垂直為距離%WMW%/%WMH%)
if %WMA% EQU 7 (echo Logo圖位置在左上角，距離邊界的水平/垂直為距離%WMW%/%WMH%)
if %WMA% EQU 9 (echo Logo圖位置在右上角，距離邊界的水平/垂直為距離%WMW%/%WMH%)

echo ;
if %RS% EQU 1 (
echo 調整影片尺寸，寬高為%WH%，請注意寬高必須都是2的倍數
ECHO 由於是不管比例把圖直接縮放成指定大小，並非最佳效果，建議不要用這功能把圖都做好再轉
)

echo ;
if %CV% EQU 1 (echo 只轉部份片段，%SS%開始，時間%DT%（時分秒）)
echo ;
if %CR% EQU 1 (echo 只轉部分（區域）片段，區域大小%RWH%，擷取區域左上角座標%RXY%)

echo ;
ECHO 畫質%VQ%（數字越小畫質越好檔案越大，參考值：15超高/25很高/35高）

echo ;
if "%CA%"=="copy" (
	ECHO 音效直接複製
 	) else (
	ECHO 音效轉檔位元率%AB%K（越大檔案越大，參考值：256超/192優/128良/96可/64差）
	)
if not exist %FF% (
echo 請安裝FFmpeg或WinFF
pause
exit
)
echo ;
pause