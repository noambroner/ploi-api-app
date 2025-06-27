@echo off
echo ================================================
echo           PLOI API APP - QUICK RUN
echo ================================================
echo 🕒 Quick start at %date% %time%
echo 📍 Location: %cd%
echo.

echo 🔄 Step 1: Navigating to project directory...
cd /d "C:\NoamDrive\DataFlow\cursor\Projects\ploi_api_app"
if %errorlevel% neq 0 (
    echo ❌ Error: Could not navigate to project directory
    pause
    exit /b 1
)
echo ✅ Successfully navigated to project directory

echo.
echo 🛑 Step 2: Killing any running processes...
tasklist /FI "IMAGENAME eq ploi_api_app.exe" 2>nul | findstr /I "ploi_api_app.exe" >nul
if %errorlevel% equ 0 (
    echo 🔄 Stopping running application...
    taskkill /F /IM ploi_api_app.exe 2>nul
    ping 127.0.0.1 -n 2 >nul
    echo ✅ Application stopped
) else (
    echo ℹ️ No running application found
)

echo.
echo 🚀 Step 3: Starting application...
echo 💡 Launching PLOI API App...
flutter run -d windows

pause 