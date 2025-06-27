@echo off
echo ================================================
echo           PLOI API APP - CLEAN & BUILD
echo ================================================
echo 🕒 Starting clean process at %date% %time%
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
echo 🧹 Step 2: Running flutter clean...
flutter clean
if %errorlevel% neq 0 (
    echo ❌ Error: Flutter clean failed
    pause
    exit /b 1
)
echo ✅ Flutter clean completed successfully

echo.
echo 🗑️ Step 3: Manually removing build directory...
if exist "build" (
    echo 📁 Found build directory, removing...
    REM Kill any running instances first (Windows compatible)
    tasklist /FI "IMAGENAME eq ploi_api_app.exe" 2>nul | findstr /I "ploi_api_app.exe" >nul
    if %errorlevel% equ 0 (
        echo 🔄 Stopping running application...
        taskkill /F /IM ploi_api_app.exe 2>nul
        ping 127.0.0.1 -n 2 >nul
    )
    rmdir /s /q "build" 2>nul
    if exist "build" (
        echo ⚠️ Warning: Could not remove build directory completely (files may be in use)
        echo 💡 Tip: Close all editors and browsers, then try again
    ) else (
        echo ✅ Build directory removed successfully
    )
) else (
    echo ℹ️ No build directory found (already clean)
)

echo.
echo 📦 Step 4: Getting dependencies...
flutter pub get
if %errorlevel% neq 0 (
    echo ❌ Error: Flutter pub get failed
    pause
    exit /b 1
)
echo ✅ Dependencies updated successfully

echo.
echo 🔨 Step 5: Building Windows application...
flutter build windows --debug
if %errorlevel% neq 0 (
    echo ❌ Error: Build failed
    pause
    exit /b 1
)
echo ✅ Build completed successfully

echo.
echo 🎉 ================================================
echo     CLEAN & BUILD PROCESS COMPLETED SUCCESSFULLY!
echo ================================================
echo 💡 Your ploi_api_app is now clean and rebuilt
echo 🚀 You can now run the app using: run_ploi.bat
echo.
pause 