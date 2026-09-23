@echo off
link @main_ds.lnk
if errorlevel 1 goto l_err
cd flight
chksum desert.exe
cd ..
goto l_done
:l_err
echo Link failed!
:l_done
