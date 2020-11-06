@echo off
echo "网卡自动检查重启服务正在进行中......."
echo "停止服务请按 Ctrl+C"

:begin
echo %date% %time% "ping......" >>d:\ping.txt
ping 192.168.1.1 >>d:\ping.txt
rem echo %errorlevel%
if %ERRORLEVEL% == 1 goto reboot
goto loop

:reboot
echo %date% %time% "网卡已重新启动" >>d:\errlog.log
echo %date% %time% "网卡停用中...."
netsh interface set interface "Ethernet0" disabled
echo %date% %time% "网卡启动中...."
netsh interface set interface "Ethernet0" enabled
echo %date% %time% "网卡已重新启动...."

:loop
ping 127.0.0.1 -n 300 > nul
goto begin