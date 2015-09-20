@echo off
echo.
echo ====================================================================
echo X-TorM PING under MSDOS a %1
echo Numero de pings: %2 
echo                         (c) MaTyAs666                              
echo ====================================================================
echo.
echo.
ping -a -n %2 %1
echo.
echo Operacion finalizada
pause
exit
