@echo off
REM Main Execution Script for Cybersecurity Capstone Project (Windows)
REM This script orchestrates the entire penetration testing process

echo ==========================================
echo Cybersecurity Capstone Project - Main Script
echo ==========================================
echo.

REM Check if we're in the right directory
if not exist "scripts\setup.sh" (
    echo Error: Please run this script from the project root directory
    pause
    exit /b 1
)

:menu
echo Select an option:
echo 1. Setup Environment
echo 2. Run Reconnaissance
echo 3. Run Vulnerability Assessment
echo 4. Run Ethical Exploitation
echo 5. Generate Documentation
echo 6. Run Complete Assessment (All Steps)
echo 7. View Project Information
echo 8. Exit
echo.

set /p choice="Enter your choice (1-8): "

if "%choice%"=="1" goto setup
if "%choice%"=="2" goto reconnaissance
if "%choice%"=="3" goto vulnerability
if "%choice%"=="4" goto exploitation
if "%choice%"=="5" goto documentation
if "%choice%"=="6" goto complete
if "%choice%"=="7" goto info
if "%choice%"=="8" goto exit
echo Invalid option. Please choose 1-8.
goto menu

:setup
echo Running environment setup...
cd scripts
bash setup.sh
cd ..
echo Setup completed!
pause
goto menu

:reconnaissance
echo Running reconnaissance...
cd scripts
bash reconnaissance.sh
cd ..
echo Reconnaissance completed!
pause
goto menu

:vulnerability
echo Running vulnerability assessment...
cd scripts
bash vulnerability_assessment.sh
cd ..
echo Vulnerability assessment completed!
pause
goto menu

:exploitation
echo Running ethical exploitation...
cd scripts
bash exploitation.sh
cd ..
echo Exploitation completed!
pause
goto menu

:documentation
echo Generating documentation...
cd scripts
bash documentation.sh
cd ..
echo Documentation completed!
pause
goto menu

:complete
echo Running complete penetration testing assessment...
echo This will run all phases in sequence.
echo.
call :setup
echo.
call :reconnaissance
echo.
call :vulnerability
echo.
call :exploitation
echo.
call :documentation
echo.
echo Complete assessment finished!
echo Check the reports\ directory for all generated reports.
pause
goto menu

:info
echo Project Information:
echo ===================
echo.
echo Project Name: Cybersecurity Capstone Project
echo Description: Ethical Hacking of E-commerce Website
echo Target: E-commerce website (configure in target_info.txt)
echo.
echo Project Structure:
echo - scripts\: Penetration testing scripts
echo - reports\: Generated reports and documentation
echo - logs\: Log files from testing sessions
echo - wordlists\: Wordlists for brute force attacks
echo.
echo Files:
echo - README.md: Project overview and instructions
echo - target_info.txt: Target configuration (create this)
echo - wordlist.txt: Provided wordlist for testing
echo - filelist.txt: Provided file list for testing
echo - js_6rk_wd58kli.ova: Target virtual machine
echo.
echo Scripts:
echo - setup.sh: Environment setup and tool verification
echo - reconnaissance.sh: Initial reconnaissance phase
echo - vulnerability_assessment.sh: Vulnerability scanning
echo - exploitation.sh: Ethical exploitation of vulnerabilities
echo - documentation.sh: Report generation and documentation
echo.
pause
goto menu

:exit
echo Exiting...
exit /b 0
