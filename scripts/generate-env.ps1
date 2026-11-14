
$ErrorActionPreference = 'Stop'

# Identificar la raiz del proyecto
$projectRoot = Split-Path -Parent $PSScriptRoot
$examplePath = Join-Path $projectRoot '.env.example'
$envPath = Join-Path $projectRoot '.env'

# Evitar sobrescribir una configuracion existente
if (Test-Path $envPath) {
    throw 'Ya existe el archivo .env. No se realizaron cambios.'
}

# Verificar que exista la plantilla
if (-not (Test-Path $examplePath)) {
    throw 'No se encontro .env.example en la raiz del proyecto.'
}

# Generar valores aleatorios criptograficamente seguros
function New-SecureHex {
    param (
        [Parameter(Mandatory = $true)]
        [int]$ByteCount
    )

    $bytes = New-Object byte[] $ByteCount
    $rng = [System.Security.Cryptography.RandomNumberGenerator]::Create()

    try {
        $rng.GetBytes($bytes)
        return [System.BitConverter]::ToString($bytes).Replace('-', '').ToLowerInvariant()
    }
    finally {
        $rng.Dispose()
    }
}

# Leer la plantilla
$content = [System.IO.File]::ReadAllText($examplePath)

# Generar secretos independientes
$dbPassword = New-SecureHex -ByteCount 32
$jwtSecret = New-SecureHex -ByteCount 48
$jwtRefreshSecret = New-SecureHex -ByteCount 48

# Reemplazar los valores de ejemplo
$content = $content.Replace(
    'REEMPLAZAR_CON_PASSWORD_SEGURA',
    $dbPassword
)

$content = $content.Replace(
    'GENERAR_SECRETO_ALEATORIO',
    $jwtSecret
)

$content = $content.Replace(
    'GENERAR_OTRO_SECRETO_ALEATORIO',
    $jwtRefreshSecret
)

# Comprobar que no queden marcadores pendientes
if ($content -match 'REEMPLAZAR_CON_PASSWORD_SEGURA|GENERAR_SECRETO_ALEATORIO') {
    throw 'La plantilla contiene marcadores sin reemplazar. No se creo .env.'
}

# Guardar sin BOM y sin mostrar los secretos
$encoding = [System.Text.UTF8Encoding]::new($false)
[System.IO.File]::WriteAllText($envPath, $content, $encoding)

Write-Host 'Archivo .env generado correctamente.'
Write-Host 'Se crearon secretos aleatorios para PostgreSQL y JWT.'
Write-Host 'Por seguridad, los valores no se muestran en pantalla.'
