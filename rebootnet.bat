@echo off
echo "�����Զ���������������ڽ�����......."
echo "ֹͣ�����밴 Ctrl+C"

:begin
echo %date% %time% "ping......" >>d:\ping.txt
ping 192.168.1.1 >>d:\ping.txt
rem echo %errorlevel%
if %ERRORLEVEL% == 1 goto reboot
goto loop

:reboot
echo %date% %time% "��������������" >>d:\errlog.log
echo %date% %time% "����ͣ����...."
netsh interface set interface "Ethernet0" disabled
echo %date% %time% "����������...."
netsh interface set interface "Ethernet0" enabled
echo %date% %time% "��������������...."

:loop
ping 127.0.0.1 -n 300 > nul
goto begin