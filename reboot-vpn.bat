@echo off
echo "VPN�Զ���������������ڽ�����......."
echo "ֹͣ�����밴 Ctrl+C"

:begin
echo %date% %time% "ping......" >>c:\ping.txt
ping 10.52.0.140 >>c:\ping.txt
rem echo %errorlevel%
if %ERRORLEVEL% == 1 goto reboot
goto loop

:reboot
echo %date% %time% "VPN����������" >>c:\errlog.log
echo %date% %time% "VPNͣ����...."
taskkill /f /im SecUI.exe /t
echo %date% %time% "VPN������...."
rem start "" "C:\Program Files (x86)\V5VPN\SecUI.exe"
"C:\Program Files (x86)\V5VPN\SecUI.exe"
echo %date% %time% "VPN����������...."

:loop
ping 127.0.0.1 -n 300 > nul
goto begin