@echo off
echo ================================================
echo         PLOI API APP - SIMPLE LAUNCHER
echo ================================================
echo 🕒 Starting at %date% %time%
echo.

echo 🔄 Navigating to project directory...
cd /d "C:\NoamDrive\DataFlow\cursor\Projects\ploi_api_app"

echo 🛑 Stopping any running instances...
taskkill /F /IM ploi_api_app.exe 2>nul >nul

echo 🚀 Launching PLOI API App...
if exist "build\windows\x64\runner\Debug\ploi_api_app.exe" (
    echo ✅ Found application executable
    echo 📱 Starting application...
    start "" "build\windows\x64\runner\Debug\ploi_api_app.exe"
    ping 127.0.0.1 -n 3 >nul
    echo ✅ Application launched!
    echo 💡 Check your screen for the application window
) else (
    echo ❌ Application not found! Please build first with:
    echo    run_ploi_unified.bat
)

echo.
echo Press any key to close this launcher...
pause >nul 