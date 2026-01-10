@echo off
setlocal enabledelayedexpansion

:: --- CONFIGURATION ---
set PYTHON_VERSION=3.12.0
set PYTHON_URL=https://www.python.org/ftp/python/%PYTHON_VERSION%/python-%PYTHON_VERSION%-amd64.exe
set INSTALLER_NAME=python_installer.exe

echo =======================================================
echo           ENVIRONMENT SETUP FOR BUILDER
echo =======================================================

:: 1. Check if Python is already installed
python --version >nul 2>&1
if %errorlevel% equ 0 (
    echo [✓] Python is already installed.
    goto :INSTALL_DEPS
)

:: 2. Download Python if missing
echo [!] Python not found. Downloading Python %PYTHON_VERSION%...
powershell -Command "Invoke-WebRequest -Uri '%PYTHON_URL%' -OutFile '%INSTALLER_NAME%'"

if not exist %INSTALLER_NAME% (
    echo [X] Failed to download Python installer. Please check your internet connection.
    pause
    exit /b
)

:: 3. Silent Installation of Python
echo [!] Installing Python... Please wait...
:: /quiet = no UI, InstallAllUsers=0 (Current User), PrependPath=1 (Adds to PATH)
start /wait %INSTALLER_NAME% /quiet InstallAllUsers=0 PrependPath=1 Include_test=0

:: Clean up installer
del %INSTALLER_NAME%

:: 4. Refresh Environment Variables
:: (This allows the current script to recognize the new 'python' command without a restart)
set "PATH=%LOCALAPPDATA%\Programs\Python\Python312\;%LOCALAPPDATA%\Programs\Python\Python312\Scripts\;%PATH%"

:: Verify Install
python --version >nul 2>&1
if %errorlevel% neq 0 (
    echo [X] Python installation failed or PATH not updated. 
    echo Please restart your computer and run this script again.
    pause
    exit /b
)
echo [✓] Python installed successfully.

:INSTALL_DEPS
:: 5. Install Required Dependencies
echo.
echo [!] Upgrading pip and installing build tools...
python -m pip install --upgrade pip --quiet [cite: 1]

echo [!] Installing PyInstaller...
python -m pip install pyinstaller --quiet [cite: 1]

echo [!] Installing pypiwin32...
python -m pip install pypiwin32 --quiet [cite: 1]

echo =======================================================
echo [✓] SETUP COMPLETE! 
echo You can now run the Installer Builder executable.
echo =======================================================
pause [cite: 2]