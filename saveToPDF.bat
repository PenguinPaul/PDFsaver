@echo off
setlocal

:: Full path to Chrome - update this path if Chrome isn't in the system PATH
set "chromePath=C:\Program Files\Google\Chrome\Application\chrome.exe"

:: Check if Chrome is already running
tasklist /FI "IMAGENAME eq chrome.exe" | find /I "chrome.exe" >nul
if %ERRORLEVEL% equ 0 (
    echo Error: Google Chrome is already running. Please close Chrome and try again.
    pause
    exit /b
)

:: Get the current year and month
for /f "tokens=2 delims==" %%i in ('wmic path win32_localtime get year /value') do set Year=%%i
for /f "tokens=2 delims==" %%i in ('wmic path win32_localtime get month /value') do set Month=%%i

:: Format the month to ensure two digits (e.g., 01 for January)
if %Month% LSS 10 set Month=0%Month%

:: Get the current day of the month
for /f "tokens=2 delims==" %%i in ('wmic path win32_localtime get day /value') do set DayOfMonth=%%i

:: Format the day to avoid leading zero issues
set DayOfMonth=%DayOfMonth: =%

:: Specify the text file based on the day of the month
set "inputFile=%DayOfMonth%.txt"

:: Check if the file exists
if not exist "%inputFile%" (
    echo File %inputFile% not found.
    exit /b
)

:: Create a directory structure PDFs\YYYY\MM
set "outputDir=%~dp0PDFs\%Year%\%Month%"
if not exist "%outputDir%" mkdir "%outputDir%"

:: Read each line (PDF name and URL) from the input file
for /f "usebackq tokens=1,* delims= " %%a in ("%inputFile%") do (
    set "fileName=%%a"
    set "url=%%b"
    setlocal enabledelayedexpansion

    :: Define the output path for the PDF file
    set "outputFile=!outputDir!\!fileName!.pdf"

    :: Check if Chrome executable exists
    if not exist "%chromePath%" (
        echo Chrome executable not found at %chromePath%.
        exit /b
    )

    echo Saving !url! to !outputFile!
    
    :: Use cmd /c to properly handle the Chrome command with arguments and suppress logging
    cmd /c ""%chromePath%" --headless --disable-gpu --no-margins --no-sandbox --log-level=3 --print-to-pdf="!outputFile!" "!url!" >nul 2>&1"

    endlocal
)

echo All URLs have been saved to PDFs in the %outputDir% folder.
endlocal
pause
