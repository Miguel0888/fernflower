@echo off
setlocal enabledelayedexpansion

rem Überprüfen, ob zwei Argumente (Input- und Output-Ordner) übergeben wurden
if "%~1"=="" (
    echo Fehler: Kein Eingabeordner angegeben!
rem    echo Syntax: unzip_jars.bat <Input-Ordner> <Output-Ordner>
    exit /b
)

if "%~2"=="" (
    echo Fehler: Kein Ausgabeordner angegeben!
rem    echo Syntax: unzip_jars.bat <Input-Ordner> <Output-Ordner>
    exit /b
)

rem Setze die Eingabe- und Ausgabeordner (immer als absolute Pfade)
set "inputFolder=%~f1"
set "outputFolder=%~f2"

rem Definiere den Pfad zu 7-Zip
set "sevenZipPath=C:\Program Files\7-Zip\7z.exe"

rem Überprüfe, ob 7-Zip existiert
if not exist "%sevenZipPath%" (
    echo Fehler: 7-Zip wurde nicht gefunden! Erwartet unter:
    echo   %sevenZipPath%
    exit /b
)

rem Überprüfe, ob der Eingabeordner existiert
if not exist "%inputFolder%" (
    echo Fehler: Der Eingabeordner "%inputFolder%" existiert nicht!
    exit /b
)

rem Wenn der Ausgabeordner nicht existiert, erstelle ihn
if not exist "%outputFolder%" (
    echo Ausgabeordner "%outputFolder%" existiert nicht. Erstelle den Ordner.
    mkdir "%outputFolder%"
)

rem Kopiere den Inhalt des Eingabeordners in den Ausgabeordner
robocopy "%inputFolder%" "%outputFolder%" /E >nul

rem Rekursiv alle .jar-Dateien im Ausgabeordner entpacken
:unpack_loop
set "foundJar="

for /r "%outputFolder%" %%f in (*.jar) do (
    set "foundJar=1"

    rem Erstelle einen Ordner mit demselben Namen wie die JAR-Datei (ohne .jar)
    set "jarName=%%~nf"
    set "jarDir=%%~dpf!jarName!"

    rem Entpacke die JAR in diesen Ordner
    if not exist "!jarDir!" (
        mkdir "!jarDir!"
    )

    "%sevenZipPath%" x "%%f" -o"!jarDir!" -y

    rem Lösche die JAR-Datei nach dem Entpacken
    del "%%f"
)

rem Wenn in diesem Durchlauf JARs gefunden wurden, nochmal laufen
if defined foundJar goto unpack_loop

echo.
echo Fertig. Alle JARs in "%outputFolder%" sind entpackt.
endlocal
