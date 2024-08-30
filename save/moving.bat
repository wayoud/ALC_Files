REM @echo off
setlocal EnableDelayedExpansion

REM Change to the directory containing the ZIP files
cd /d D:\Cassiopae\Archive

REM Get the date 10 days ago using PowerShell
for /f "tokens=*" %%a in ('powershell -NoProfile -Command "((Get-Date).AddDays(-10)).ToString('yyyyMMdd')"') do set Last10DaysDate=%%a

REM Loop through each .zip file in the directory
for %%i in (*.zip) do (
    REM Extract the file name without extension
    set "fileName=%%~ni"
    REM Extract the date part from the file name (first 8 characters)
    set "fileDate=!fileName:~0,8!"

    REM Compare the file date with the date 10 days ago
    if !Last10DaysDate! GTR !fileDate! (
        REM Move the file if the date is within the last 10 days
        move "%%i" "\\alc-sb003\Backups BDD\Cassiopae\2024"
    )
)

endlocal
