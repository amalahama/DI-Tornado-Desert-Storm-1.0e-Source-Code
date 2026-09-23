@echo off
echo ========================================================
echo   DI TORNADO - BUILD FLIGHT.EXE (EUROPEAN THEATER 1.0e)
echo ========================================================

cd \lib8086
call pal.bat
if errorlevel 1 goto build_err

cd \visual
call pal.bat
if errorlevel 1 goto build_err

cd \tornado
call pal.bat
if errorlevel 1 goto build_err

call l.bat
if errorlevel 1 goto build_err

echo.
echo ========================================================
echo   FLIGHT.EXE BUILD AND LINK SUCCESSFUL!
echo ========================================================
goto done

:build_err
echo.
echo ********************************************************
echo   BUILD FAILED! Check assembler/linker errors above.
echo ********************************************************

:done
cd \
