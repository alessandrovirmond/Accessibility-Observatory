@echo off
echo Encerrando o terminal associado...

taskkill /IM OpenConsole.exe /F >nul 2>&1


taskkill /IM chrome.exe /F >nul 2>&1


taskkill /IM chromedriver.exe /F >nul 2>&1