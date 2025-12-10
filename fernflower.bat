@echo off
setlocal enabledelayedexpansion

rem Check if two arguments (input and output folder) are provided
if "%~1"=="" (
    echo Fehler: Kein Eingabeordner angegeben!
    exit /b
)

if "%~2"=="" (
    echo Fehler: Kein Ausgabeordner angegeben!
    exit /b
)

rem Set input and output folders (always as absolute paths)
set "inputFolder=%~f1"
set "outputFolder=%~f2"

rem Define path to Fernflower jar
set "fernflowerPath=fernflower.jar"

rem Check if Fernflower jar exists
if not exist "%fernflowerPath%" (
    echo Fehler: Fernflower wurde nicht gefunden! Erwartet unter:
    echo   %fernflowerPath%
    exit /b
)

rem Define working folder for unpacked content inside output folder
set "unpackedFolder=%outputFolder%\unpacked"

rem If unpacked folder does not exist, run unzip_jars.bat once
if not exist "%unpackedFolder%" (
    echo Erstelle Arbeitsordner "%unpackedFolder%" und entpacke JAR-Dateien...
    mkdir "%unpackedFolder%"
    echo Entpacke JAR-Dateien mit unzip_jars.bat...
    call unzip_jars.bat "%inputFolder%" "%unpackedFolder%"
) else (
    echo Arbeitsordner "%unpackedFolder%" existiert bereits, ueberspringe Entpacken...
)

rem Call Fernflower to decompile the unpacked classes
echo Starte Fernflower...
echo   Input:  %unpackedFolder%
echo   Output: %outputFolder%
java -jar "%fernflowerPath%" "%unpackedFolder%" "%outputFolder%"

echo.
echo Fertig. Inhalte aus "%inputFolder%" wurden (falls noetig) entpackt und nach "%outputFolder%" dekompiliert.
endlocal
