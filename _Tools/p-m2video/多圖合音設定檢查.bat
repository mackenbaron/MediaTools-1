@echo off
REM Ū�]�w��
ECHO �h�ϦX���]�w
ECHO ;
call %~dp0setup.bat
set FFP=%FF:ffmpeg.exe"=%
if exist %FFP%\fonts\fonts.conf" (
echo �r���]�wOK�A�i�v���[�r
) else (
echo �ϥμv���[�r�\��ݭn�N%~dp0fonts��Ƨ��ƻs��ffmpeg�Ҧb�B�A
echo �αNffmpeg�ƻs��%~dp0
)
echo ffmpeg��m %FF:"=%
echo �u�@�Ϧ�m %WP%
if %DP% NEQ 0 (
	echo �v��������X���|%DP%
	) else (
	echo �v��������X���|�򭵼��ɨӷ��ۦP
)
echo ;
echo �����ɰѦҪ���%ML%�]��^�]���ƭȤ��ݺ�T�A�񭵼��ɪ��Y�i�^
echo �v�����q�ɶ�%CT%�]��^
echo �H�J�H�X�ɶ�%FT%�]��^�]�ݦb���q�ɶ��@�b�H�U�^
echo ;
if %ST% EQU 1 (echo �v���[�r�]���w�r��^)
if %ST% EQU 2 (echo �v���[�r�]�ɦW+���w�r��^)
if %ST% EQU 3 (echo �v���[�r�]�ɶ�+���w�r��^)
if %ST% EQU 6 (echo �v���[�r�]�ɦW+�ɶ�+���w�r��^)
if %ST% EQU 0 (
echo �v�����[�r
) else (
echo �ϥμv���[�r�\��ݭn�N%~dp0fonts��Ƨ��ƻs��ffmpeg�Ҧb�B�A
echo �αNffmpeg�ƻs��%~dp0
)

echo ;
if %WMA% GTR 0 (
echo �v���[Logo�ϡA���ɬ�%~dp0%logo%
) else (
echo �v�����[Logo��
)
if %WMA% EQU 1 (echo Logo�Ϧ�m�b���U���A�Z����ɪ�����/�������Z��%WMW%/%WMH%)
if %WMA% EQU 3 (echo Logo�Ϧ�m�b�k�U���A�Z����ɪ�����/�������Z��%WMW%/%WMH%)
if %WMA% EQU 7 (echo Logo�Ϧ�m�b���W���A�Z����ɪ�����/�������Z��%WMW%/%WMH%)
if %WMA% EQU 9 (echo Logo�Ϧ�m�b�k�W���A�Z����ɪ�����/�������Z��%WMW%/%WMH%)

echo ;
if %RS% EQU 1 (
echo �վ�v���ؤo�A�e����%WH%�A�Ъ`�N�e���������O2������
ECHO �]���O���ޤ�Ҫ����Y�񦨫��w�j�p�A�D�̨ήĪG�A��ĳ���n�γo�\���ϳ����n�A��
)

echo ;
ECHO �e��%VQ%�]�Ʀr�V�p�e��V�n�ɮ׶V�j�A�ѦҭȡG15�W��/25�ܰ�/35���^

echo ;
if "%CA%"=="copy" (
	ECHO ���Ī����ƻs
 	) else (
	ECHO �������ɦ줸�v%AB%K�]�V�j�ɮ׶V�j�A�ѦҭȡG256�W/192�u/128�}/96�i/64�t�^
	)
echo ;
if %CV% EQU 1 (echo �u�ೡ�����q�A%SS%�}�l�A�ɶ�����%DT%�]�ɤ���^)

if not exist %FF% (
echo �Цw��FFmpeg��WinFF
pause
exit
)
echo ;
pause