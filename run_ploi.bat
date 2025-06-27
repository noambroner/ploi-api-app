@echo off
echo ================================================
echo           PLOI API APP - WINDOWS RUNNER
echo ================================================
echo 🕒 Starting app at %date% %time%
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
echo 🔍 Step 2: Checking if app is built...
if not exist "build\windows\x64\runner\Debug\ploi_api_app.exe" (
    echo ⚠️ Warning: App executable not found!
    echo 💡 Building the app first...
    flutter build windows --debug
    if %errorlevel% neq 0 (
        echo ❌ Error: Build failed
        echo 🔧 Try running clean_ploi.bat first
        pause
        exit /b 1
    )
    echo ✅ Build completed
)

echo.
echo 🚀 Step 3: Launching PLOI API App...
echo 📱 Opening Windows application...

REM Try to launch the app and show any errors
echo 🔍 Attempting to start application...
start "" "build\windows\x64\runner\Debug\ploi_api_app.exe"

REM Wait a moment for the process to start
ping 127.0.0.1 -n 3 >nul

REM Check if the application is running (Windows compatible)
tasklist /FI "IMAGENAME eq ploi_api_app.exe" 2>nul | findstr /I "ploi_api_app.exe" >nul
if %errorlevel% equ 0 (
    echo ✅ Application started successfully!
    echo 💡 PLOI API App is now running
) else (
    echo ⚠️ Warning: Application may not have started properly
    echo 🔧 Trying alternative launch method...
    
    REM Try alternative method
    "build\windows\x64\runner\Debug\ploi_api_app.exe"
    
    REM Check again (Windows compatible)
    tasklist /FI "IMAGENAME eq ploi_api_app.exe" 2>nul | findstr /I "ploi_api_app.exe" >nul
    if %errorlevel% equ 0 (
        echo ✅ Application started with alternative method!
    ) else (
        echo ❌ Error: Could not start application
        echo 🔧 Troubleshooting steps:
        echo    1. Make sure all programs/browsers are closed
        echo    2. Run clean_ploi.bat first
        echo    3. Try running as Administrator
        echo    4. Check if antivirus is blocking the app
    )
)

echo.
echo 🎉 ================================================
echo         PLOI API APP LAUNCH ATTEMPT COMPLETED
echo ================================================
echo 📝 Check task manager if the app doesn't appear
echo 🔄 If issues persist, try clean_ploi.bat first
echo.
echo Press any key to close this window...
pause >nul 