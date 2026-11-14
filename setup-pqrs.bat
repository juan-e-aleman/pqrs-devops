
@echo off
setlocal
title Configuracion y despliegue PQRS

cd /d "%~dp0"

echo.
echo ==========================================
echo       CONFIGURACION DEL PROYECTO PQRS
echo ==========================================
echo.

echo [1/3] Comprobando PowerShell...
where powershell >nul 2>&1
if errorlevel 1 (
    echo ERROR: PowerShell no esta disponible.
    exit /b 1
)

echo [2/3] Preparando archivo .env y secretos...

powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0scripts\generate-env.ps1"

if errorlevel 1 (
    echo ERROR: No se pudieron generar los secretos.
    exit /b 1
)

echo.
echo [3/3] Comprobando Docker...

where docker >nul 2>&1
if errorlevel 1 (
    echo ERROR: Docker no esta instalado o no esta en PATH.
    exit /b 1
)

docker info >nul 2>&1
if errorlevel 1 (
    echo ERROR: Docker Desktop no esta iniciado.
    exit /b 1
)

echo.
echo Desplegando servicios Docker Compose...
docker compose config --quiet
if errorlevel 1 (
    echo ERROR: Configuracion de Docker Compose invalida.
    exit /b 1
)

docker compose up -d
if errorlevel 1 (
    echo ERROR: No se pudieron iniciar los servicios.
    exit /b 1
)

echo.
echo ==========================================
echo       DESPLIEGUE FINALIZADO
echo ==========================================
docker compose ps

echo.
pause
