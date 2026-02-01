@echo off
title Instalador do Jarvis - Assistente Pessoal
color 0A

echo ===================================================
echo      JARVIS - INSTALADOR AUTOMATICO (v1.0)
echo ===================================================
echo.
echo [1/4] Verificando ambiente...

:: Verifica Node.js
node -v >nul 2>&1
if %errorlevel% neq 0 (
    echo [AVISO] Node.js nao encontrado.
    echo Baixando versao portatil do Node.js (isso pode demorar um pouco)...
    
    :: Baixa Node.js Portátil (Exemplo simplificado, ideal seria usar winget ou curl local)
    powershell -Command "Invoke-WebRequest -Uri 'https://nodejs.org/dist/v20.11.0/node-v20.11.0-win-x64.zip' -OutFile 'node.zip'"
    powershell -Command "Expand-Archive -Path 'node.zip' -DestinationPath 'bin' -Force"
    del node.zip
    
    :: Adiciona ao PATH temporário
    set PATH=%CD%\bin\node-v20.11.0-win-x64;%PATH%
)

echo [2/4] Instalando cerebro (dependencias)...
call npm install --omit=dev --silent
if %errorlevel% neq 0 (
    echo [ERRO] Falha ao instalar dependencias. Verifique sua internet.
    pause
    exit
)

echo [3/4] Configurando atalhos...
powershell -Command "$s=(New-Object -COM WScript.Shell).CreateShortcut('%userprofile%\Desktop\Jarvis.lnk');$s.TargetPath='%CD%\start_jarvis.bat';$s.IconLocation='%CD%\assets\icon.ico';$s.Save()"

echo [4/4] Finalizando...
echo.
echo ===================================================
echo      INSTALACAO CONCLUIDA COM SUCESSO!
echo ===================================================
echo.
echo Um atalho 'Jarvis' foi criado na sua Area de Trabalho.
echo Pressione qualquer tecla para iniciar o Jarvis agora...
pause >nul

call start_jarvis.bat
