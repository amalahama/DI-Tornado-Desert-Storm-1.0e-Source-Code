@echo off
echo ========================================================
echo   DI TORNADO - BUILD DESERT.EXE (DESERT STORM EXPANSION)
echo ========================================================

cd \lib8086
call pal.bat
if errorlevel 1 goto build_err

cd \visual
call pal_ds.bat
if errorlevel 1 goto build_err

cd \tornado
call pal_ds.bat
if errorlevel 1 goto build_err

call l_ds.bat
if errorlevel 1 goto build_err

echo.
echo ========================================================
echo   DESERT.EXE BUILD AND LINK SUCCESSFUL!
echo ========================================================
goto done

:build_err
echo.
echo ********************************************************
echo   BUILD FAILED! Check assembler/linker errors above.
echo ********************************************************

:done
cd \
