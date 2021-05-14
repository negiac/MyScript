@echo off
echo "VPN自动检查重启服务正在进行中......."
echo "停止服务请按 Ctrl+C"

:begin
echo %date% %time% "ping......" >>c:\ping.txt
ping 10.52.0.140 >>c:\ping.txt
rem echo %errorlevel%
if %ERRORLEVEL% == 1 goto reboot
goto loop

:reboot
echo %date% %time% "VPN已重新启动" >>c:\errlog.log
echo %date% %time% "VPN停用中...."
taskkill /f /im SecUI.exe /t
echo %date% %time% "VPN启动中...."
rem start "" "C:\Program Files (x86)\V5VPN\SecUI.exe"
"C:\Program Files (x86)\V5VPN\SecUI.exe"
echo %date% %time% "VPN已重新启动...."

:loop
ping 127.0.0.1 -n 300 > nul
goto begin