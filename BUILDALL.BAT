@echo off
echo ========================================================
echo   DI TORNADO - DUAL TARGET BUILD (FLIGHT.EXE + DESERT.EXE)
echo ========================================================

echo.
echo [1/2] Building European Theater (FLIGHT.EXE)...
call build_fl.bat
if errorlevel 1 goto build_err

echo.
echo [2/2] Building Desert Storm Expansion (DESERT.EXE)...
call build_ds.bat
if errorlevel 1 goto build_err

echo.
echo ========================================================
echo   BOTH EXECUTABLES BUILT AND VERIFIED SUCCESSFULLY!
echo ========================================================
goto done

:build_err
echo.
echo ********************************************************
echo   BUILD FAILED! Check errors above.
echo ********************************************************

:done
cd \
