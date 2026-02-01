@echo off
title Jarvis - Seu Assistente
color 0B

:: Se estiver usando Node portatil
if exist "%CD%\bin\node-v20.11.0-win-x64" (
    set PATH=%CD%\bin\node-v20.11.0-win-x64;%PATH%
)

echo Iniciando o Jarvis...
echo Pressione Ctrl+C para parar.
echo.

:: Comando de inicio (ajuste conforme o entry point do OpenClaw/Jarvis)
:: Assumindo que o OpenClaw inicia via 'openclaw gateway' ou script node
:: Se for um fork do OpenClaw, provavelmente é:
node packages/cli/dist/index.js gateway start

pause
