@echo off
setlocal enabledelayedexpansion

:: Full path to Chrome - update this path if Chrome isn't in the system PATH
set "chromePath=C:\Program Files\Google\Chrome\Application\chrome.exe"

:: Check if Chrome is already running
tasklist /FI "IMAGENAME eq chrome.exe" | find /I "chrome.exe" >nul
if %ERRORLEVEL% equ 0 (
    echo Error: Google Chrome is already running. Please close Chrome and try again.
    pause
    exit /b
)

:: Prompt for day input
set "userDay="
set /p "userDay=Enter day of the month (1-31) or press Enter for today: "

:: Check if input is empty
if "%userDay%"=="" (
    echo Input is empty, defaulting to the current day.
    for /f "tokens=2 delims==" %%i in ('wmic path win32_localtime get day /value') do set "DayOfMonth=%%i"
    goto processDay
)

:: Check if the input is a valid number between 1 and 31
:: First, check if the input is numeric
for /f %%i in ('echo %userDay% 2^>nul') do set "validInput=true"
if not defined validInput (
    echo Invalid input. Exiting.
    pause
    exit /b
)

:: If numeric, check if within range (1-31)
set /a DayOfMonth=%userDay%
if %DayOfMonth% geq 1 if %DayOfMonth% leq 31 (
    goto processDay
)

echo Invalid input. The day must be a number between 1 and 31. Exiting.
pause
exit /b

:processDay
:: If DayOfMonth is set correctly, continue. Otherwise, exit with error.
if not defined DayOfMonth (
    echo Error: Unable to determine the day of the month.
    pause
    exit /b
)

echo Using day: %DayOfMonth%

:: Get the current year and month
for /f "tokens=2 delims==" %%i in ('wmic path win32_localtime get year /value') do set "Year=%%i"
for /f "tokens=2 delims==" %%i in ('wmic path win32_localtime get month /value') do set "Month=%%i"

:: Format the month to ensure two digits (e.g., 01 for January)
if %Month% LSS 10 set Month=0%Month%

:: Specify the text file based on the day of the month
set "inputFile=%DayOfMonth%.txt"

:: Check if the file exists
if not exist "%inputFile%" (
    echo File %inputFile% not found.
    pause
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

    :: Show the URL and output file path being processed
    echo Processing URL: !url!
    echo Saving PDF to: !outputFile!

    :: Check if Chrome executable exists
    if not exist "%chromePath%" (
        echo Chrome executable not found at %chromePath%.
        pause
        exit /b
    )

    :: Use cmd /c to properly handle the Chrome command with arguments and suppress logging
    cmd /c ""%chromePath%" --headless --disable-gpu --no-margins --no-sandbox --log-level=3 --print-to-pdf="!outputFile!" "!url!" >nul 2>&1"

    :: List the saved PDF
    echo Saved: !fileName!.pdf

    endlocal
)

echo All URLs have been saved to PDFs in the %outputDir% folder.
endlocal
pause
