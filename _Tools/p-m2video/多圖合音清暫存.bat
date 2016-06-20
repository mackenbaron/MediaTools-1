@echo off
REM 讀設定檔
call %~dp0setup.bat
REM 清除過去記錄
if exist %WP%worklist.txt (del %WP%worklist.txt)
if exist %WP%cliplist.txt (del %WP%cliplist.txt)
if exist %WP%cliplist1.txt (del %WP%cliplist1.txt)
if exist %WP%error.log (del %WP%error.log)
if exist %WP%ok.log (del %WP%ok.log)
del %WP%*.avi
echo 清除暫存影片
pause