@echo off
REM �۰ʰ���ffmpeg��m�A�p�G����WinFF�αNffmpeg.exe���P�妸�ɬۦP�ؿ�
if exist "%programfiles(x86)%\WinFF\ffmpeg.exe" (set FF="%programfiles(x86)%\WinFF\ffmpeg.exe")
if exist "%programfiles%\WinFF\ffmpeg.exe" (set FF="%programfiles%\WinFF\ffmpeg.exe")
if exist "%~dp0ffmpeg.exe" (set FF="%~dp0ffmpeg.exe")
REM �Y�n�ۭqffmpeg��m�A�b�U���o��]�w�ñNREM����
REM SET FF="%programfiles%\WinFF1.50\ffmpeg.exe"
REM �u�@�Ϧ�m�]�n�[\�^�A�w�]���t�μȦs��
set WP=%temp%\
REM �v��������X���|�]�n�[\�^�A�p�G�򭵼��ɨӷ��ۦP�h��DP��0
REM set DP=R:\
set DP=0
if %DP% NEQ 0 (set TP=%DP%)
REM �����ɰѦҪ��ס]��^�A���ݺ�T�񭵼��ɪ��Y�i�A�]�Ӥj�u�O���O�ɶ��Ŷ�
set ML=360
REM �v�����q�ɶ��]��^
set CT=5
REM �H�J�H�X�ɶ��]��^�]�ݦb���q�ɶ��@�b�H�U�^
set FT=1
REM �]�w�v�����q�H�J�H�X�Ѽ�
set/a F1=%FT%*25
set/a F2=(%CT%-%FT%)*25
if %FT% NEQ 0 (set FADE=, fade=in:0:%F1%,fade=out:%F2%:%F1%)

REM �v���[�r�]�ɦW�B�ɶ��B���w�r��^���w�r�ꪽ���s��filename0.ass
REM 0���[
REM 1�u�����w�r��
REM 2�ɦW+���w�r��
REM 3�ɶ�+���w�r��
REM 6�ɦW+�ɶ�+���w�r��
set/a ST=0
if %ST% GTR 0 (set ASS=, subtitles=filenameu.ass)
set/a STA=%ST%%%3
set/a STB=%ST%%%2

REM �v���[Logo�ϡA��m1���B3���B7���B9���A0��ܤ��ϥ�
set/a WMA=0
REM logo�ϻݩ�b�妸�ɬۦP�ؿ��Alogo.jpg��logo.png�Apng�u���A�䴩�z����
if exist %~dp0logo.jpg (set logo=logo.jpg)
if exist %~dp0logo.png (set logo=logo.png)
REM logo�Ϧ�m�A
REM logo�϶Z����ɪ������Z���]�����^
set WMW=10
REM logo�϶Z����ɪ������Z���]�����^
set WMH=10

if %WMA% EQU 1 (set WMS=-i %~dp0%logo% -filter_complex "overlay=%WMW%:main_h-overlay_h-%WMH%")
if %WMA% EQU 3 (set WMS=-i %~dp0%logo% -filter_complex "overlay=main_w-overlay_w-%WMW%:main_h-overlay_h-%WMH%")
if %WMA% EQU 7 (set WMS=-i %~dp0%logo% -filter_complex "overlay=%WMW%:%WMH%")
if %WMA% EQU 9 (set WMS=-i %~dp0%logo% -filter_complex "overlay=main_w-overlay_w-%WMW%:%WMH%")

REM �O�_�վ�v���ؤo�A�O1/�_0
REM �h�ϦX���ɡA�p�G���ɳ��w�g�վ㬰�ۦP�ؤo���B��_
REM ²�����ɮɵ��ݨD�վ�
set RS=0
REM �p�G�n�վ�v���ؤo�A��X���v���e:���A�i�������w�ؤo�p848:480
REM iw/2:-1��ܼe�׬��ӷ��ɮת��@�b�A���צ۰ʭp��A���`�N�������O2������
REM �ѩ�O���ޤ�ҧ�Ϫ����Y�񦨫��w�j�p�A�ëD�̨ήĪG�A��ĳ���n�γo�\���ϳ����n�A��
REM set WH=iw/2:-1
set WH=640:360
if %RS% EQU 1 (set VS=, scale=%WH%)

REM �]�w�e��A�Ʀr�V�p�e��V�n�ɮ׶V�j�A�ѦҭȡG15�W��/25�ܰ�/35��
set VQ=25
REM �������ɡ]����1/�����ƻs0�^
set CA=0
REM �]�w���Ħ줸�v�A���Ī����ƻs�ɵL�ġA�V�j�ɮ׶V�j�A�ѦҭȡG256�W/192�u/128�}/96�i/64�t
set AB=128
if %CA% EQU 0 (
	set CA=copy
 	) else (
	set CA=aac -ar 48000 -ab %AB%k -strict -2
	)

REM �O�_�u�ೡ��(�ɶ�)���q�A�O1/�_0
set CV=0
REM �]�w�}�l�ɶ�(��:��:��)
set SS=0:0:0
REM �]�w�n�^�����v���ɶ�(��:��:��)�]�`�N���O�����ɶ��I�^
set DT=0:0:52
if %CV% EQU 1 (
set VC=-ss %SS% -t %DT%
) else (
set VC=-shortest
)

REM �H�U�O²�����ɱM�γ]�w

REM �O�_�u�ೡ��(�ϰ�)���q�A�O1/�_0
set CR=0
REM �]�w�n�^�����ϰ�j�p(�e:��)�������O2������
set RWH=360:240
REM �]�w�n�^�����ϰ쥪�W���y��(X:Y)
set RXY=30:30
if %CR% EQU 1 (set VR=, crop=%RWH%:%RXY%)

if not exist %FF% (
echo �Цw��FFmpeg��WinFF
pause
exit
)