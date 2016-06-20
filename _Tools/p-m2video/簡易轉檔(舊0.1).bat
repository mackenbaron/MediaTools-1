@echo off
REM 自動偵測ffmpeg位置，如果有裝WinFF
if exist "%programfiles%\WinFF\ffmpeg.exe" (set FF="%programfiles%\WinFF\ffmpeg.exe")
if exist "%programfiles(x86)%\WinFF\ffmpeg.exe" (set FF="%programfiles(x86)%\WinFF\ffmpeg.exe")
REM 若要自訂ffmpeg位置，在下面這行設定並將REM取消
REM SET FF=""
REM 工作區位置（要加\），預設為系統暫存區
set WP=%temp%\
REM 影片完成輸出路徑（要加\），如果跟來源相同則用DP＝0
rem set DP=R:\
set DP=0
REM 設定畫質，數字越小畫質越好檔案越大，參考值：15超高/25很高/35高
set VQ=25
REM 設定音效位元率，越大檔案越大，參考值：256超/192優/128良/96可/64差
set AB=128

REM 是否調整影片尺寸，是1/否0
set RS=0
REM 如果要調整影片尺寸，輸出的影片寬:高，可直接指定尺寸如848:480，iw/2:-1表示寬度為來源檔案的一半，高度自動計算，但注意必須都是2的倍數
set WH=iw/2:-1
REM if %RS% EQU 1 (set VS=-s %WH%)
if %RS% EQU 1 (set VS=-vf scale=%WH%)

REM 是否只轉部分(時間)片段，是1/否0
set CV=0
REM 設定開始時間(時:分:秒)
set SS=0:0:5
REM 設定要擷取的影片時間(時:分:秒)
set DT=0:0:30
if %CV% EQU 1 (set VC=-ss %SS% -t %DT%)

REM 是否只轉部分(區域)片段，是1/否0
set CR=0
REM 設定要擷取的區域大小(寬:高)必須都是2的倍數
set RWH=360:240
REM 設定要擷取的區域左上角座標(X:Y)
set RXY=30:30
if %CR% EQU 1 (set VR=-vf crop=%RWH%:%RXY%)

REM 切換到工作目錄
cd /D %WP%
if exist worklist.txt (del worklist.txt)
if exist error.log (del error.log)
if exist ok.log (del ok.log)

for %%I in (%*) do if exist %FF% (
	REM 複製影片檔到工作區
	copy %%I videotmp.avi
	REM 以FFmpeg轉檔
	%FF% -i videotmp.avi -crf %VQ% -vcodec libx264 %VC% -acodec libfaac -ar 48000 -ab %AB%k -flags +loop -cmp +chroma -partitions +parti4x4+partp8x8+partb8x8 -me_method hex -subq 6 -me_range 16 -g 250 -keyint_min 25 -sc_threshold 40 -i_qfactor 0.71 -b_strategy 1 -threads 0 %VS% %VR% videotmp.mp4
	REM 檢查檔案如果大小為0表示失敗
		for %%S in (videotmp.mp4) do if %%~zS EQU 0 (
		echo '%date:~0,10% %time:~0,8% 轉檔失敗，請檢查%%I尺寸是否為2的倍數' >> error.log
		del videotmp.mp4
		)
	REM 將生成\的檔案複製到目的地，若目的與來源相同則在檔名後加上_1
		if exist videotmp.mp4 (
                        if %RS% EQU 1 (
                        	if %CR% EQU 1 (echo 因同時設定擷取部分區域，故無法調整影片尺寸 >> ok.log)
                        	) else (
                        echo 調整影片尺寸 >> ok.log
                        )
                        if %CV% EQU 1 (echo 擷取時間片段 >> ok.log)
                        if %CR% EQU 1 (echo 擷取部分區域 >> ok.log)
			if %DP% EQU 0 (
			copy videotmp.mp4 "%%~dpn%I_1.mp4"
			echo '%date:~0,10% %time:~0,8% %%~n%I_1.mp4完成' >> ok.log
			) else (
			copy videotmp.mp4 "%DP%%%~n%I.mp4"
			echo '%date:~0,10% %time:~0,8% %%~n%I.mp4完成' >> ok.log
			)
		del %WP%videotmp.mp4
		)
	REM 刪除暫存檔
	del %WP%videotmp.avi
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