@echo off
setlocal enabledelayedexpansion

rem Überprüfen, ob zwei Argumente (Input- und Output-Ordner) übergeben wurden
if "%~1"=="" (
    echo Fehler: Kein Eingabeordner angegeben!
    exit /b
)

if "%~2"=="" (
    echo Fehler: Kein Ausgabeordner angegeben!
    exit /b
)

rem Setze die Eingabe- und Ausgabeordner (immer als absolute Pfade)
set "inputFolder=%~f1"
set "outputFolder=%~f2"

rem Definiere den Pfad zu Fernflower
set "fernflowerPath=fernflower.jar"

rem Überprüfe, ob Fernflower existiert
if not exist "%fernflowerPath%" (
    echo Fehler: Fernflower wurde nicht gefunden! Erwartet unter:
    echo   %fernflowerPath%
    exit /b
)

rem Rufe das bestehende unzip_jars.bat Script auf, um die JARs zu entpacken
echo Entpacke JAR-Dateien mit unzip_jars.bat...
call unzip_jars.bat "%inputFolder%" "%outputFolder%"

rem Erstelle einen temporären Ordner für Fernflower
set "tempFolder=%outputFolder%\temp"
if not exist "%tempFolder%" (
    mkdir "%tempFolder%"
)

rem Verschiebe die entpackten Dateien in den temporären Ordner für Fernflower
echo Verschiebe entpackte Dateien nach %tempFolder%...
xcopy /E /H /I "%outputFolder%" "%tempFolder%" >nul

rem Rufe Fernflower auf, um die entpackten Dateien zu dekompilieren
echo Starte Fernflower...
java -jar "%fernflowerPath%" "%tempFolder%" "%outputFolder%"

rem Lösche den temporären Ordner, nachdem Fernflower fertig ist
echo Lösche temporären Ordner...
rmdir /S /Q "%tempFolder%"

echo.
echo Fertig. Alle JARs in "%outputFolder%" sind entpackt und dekompiliert.
endlocal
