
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

echo [2/3] Generando secretos JWT...

powershell -NoProfile -ExecutionPolicy Bypass -Command "$ErrorActionPreference='Stop'; $p='.env'; $lines=@(); if(Test-Path $p){$lines=@(Get-Content -LiteralPath $p)}; $rng=New-Object System.Security.Cryptography.RNGCryptoServiceProvider; foreach($name in @('JWT_SECRET','JWT_REFRESH_SECRET')) { $pattern='^'+$name+'=.+$'; $idx=-1; for($i=0;$i -lt $lines.Count;$i++){if($lines[$i] -match ('^'+$name+'=')){$idx=$i;break}}; if($idx -ge 0 -and $lines[$idx] -match $pattern){Write-Host ($name+' ya existe; se conserva.')}else{$bytes=New-Object byte[] 64; $rng.GetBytes($bytes); $secret=([BitConverter]::ToString($bytes)).Replace('-','').ToLowerInvariant(); $entry=$name+'='+$secret; if($idx -ge 0){$lines[$idx]=$entry}else{$lines+= $entry}; Write-Host ($name+' generado correctamente.')}}; $rng.Dispose(); [IO.File]::WriteAllLines((Join-Path (Get-Location) $p),[string[]]$lines,(New-Object System.Text.UTF8Encoding($false)))"

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
