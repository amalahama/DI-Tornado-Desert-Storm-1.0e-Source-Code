@echo off
link @main.lnk
if errorlevel 1 goto l_err
cd flight
chksum flight.exe
cd ..
goto l_done
:l_err
echo Link failed!
:l_done