@echo off
REM Ū�]�w��
call %~dp0setup.bat
REM �M���L�h�O��
if exist %WP%worklist.txt (del %WP%worklist.txt)
if exist %WP%cliplist.txt (del %WP%cliplist.txt)
if exist %WP%cliplist1.txt (del %WP%cliplist1.txt)
if exist %WP%error.log (del %WP%error.log)
if exist %WP%ok.log (del %WP%ok.log)
del %WP%*.avi
echo �M���Ȧs�v��
pause