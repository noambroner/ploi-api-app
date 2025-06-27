@echo off
echo ================================================
echo        PLOI API APP - UNIFIED CLEAN & RUN
echo ================================================
echo 🕒 Starting unified process at %date% %time%
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
echo 🛑 Step 2: Killing any running ploi_api_app processes...
tasklist /FI "IMAGENAME eq ploi_api_app.exe" 2>nul | findstr /I "ploi_api_app.exe" >nul
if %errorlevel% equ 0 (
    echo 🔄 Found running application, stopping it...
    taskkill /F /IM ploi_api_app.exe 2>nul
    if %errorlevel% equ 0 (
        echo ✅ Successfully stopped running application
    ) else (
        echo ⚠️ Warning: Could not stop application (may already be closed)
    )
    ping 127.0.0.1 -n 3 >nul
) else (
    echo ℹ️ No running application found
)

echo.
echo 🧹 Step 3: Running flutter clean...
flutter clean
if %errorlevel% neq 0 (
    echo ❌ Error: Flutter clean failed
    pause
    exit /b 1
)
echo ✅ Flutter clean completed successfully

echo.
echo 🗑️ Step 4: Manually removing build directory...
if exist "build" (
    echo 📁 Found build directory, removing...
    rmdir /s /q "build" 2>nul
    if exist "build" (
        echo ⚠️ Warning: Could not remove build directory completely (files may be in use)
        echo 💡 Tip: Some files might still be locked, continuing anyway...
    ) else (
        echo ✅ Build directory removed successfully
    )
) else (
    echo ℹ️ No build directory found (already clean)
)

echo.
echo 📦 Step 5: Getting dependencies...
flutter pub get
if %errorlevel% neq 0 (
    echo ❌ Error: Flutter pub get failed
    pause
    exit /b 1
)
echo ✅ Dependencies updated successfully

echo.
echo 🚀 Step 6: Running application with flutter run...
echo 💡 Starting PLOI API App in Windows mode...
echo 📱 Application will open in a new window
echo ⚠️ Note: Application will run in this window - do NOT close!
echo 🔧 Use Ctrl+C to stop the application when done
echo.
flutter run -d windows
if %errorlevel% neq 0 (
    echo ❌ Error: Failed to start application
    echo 💡 Try running flutter doctor to check your setup
) else (
    echo 💡 Application stopped normally
)

echo.
echo 🎉 ================================================
echo       PLOI API APP SESSION COMPLETED
echo ================================================
echo 💡 The application session has ended
echo 🔄 If you need to restart, run this script again
echo.
echo Press any key to close this window...
pause >nul 