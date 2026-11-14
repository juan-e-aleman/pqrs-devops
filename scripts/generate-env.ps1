$ErrorActionPreference = 'Stop'

$projectRoot = Split-Path -Parent $PSScriptRoot
$examplePath = Join-Path $projectRoot '.env.example'
$envPath = Join-Path $projectRoot '.env'

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

if (Test-Path -LiteralPath $envPath) {
    $script:envLines = [System.Collections.Generic.List[string]]::new()
    foreach ($line in [System.IO.File]::ReadAllLines($envPath)) {
        $script:envLines.Add($line)
    }
}
else {
    if (-not (Test-Path -LiteralPath $examplePath)) {
        throw 'No se encontro .env.example en la raiz del proyecto.'
    }

    $script:envLines = [System.Collections.Generic.List[string]]::new()
    foreach ($line in [System.IO.File]::ReadAllLines($examplePath)) {
        $script:envLines.Add($line)
    }
}

function Ensure-EnvSecret {
    param (
        [Parameter(Mandatory = $true)] [string]$Name,
        [Parameter(Mandatory = $true)] [int]$ByteCount,
        [Parameter(Mandatory = $true)] [string]$Placeholder
    )

    $prefix = $Name + '='
    $index = -1
    for ($i = 0; $i -lt $script:envLines.Count; $i++) {
        if ($script:envLines[$i].StartsWith($prefix, [System.StringComparison]::Ordinal)) {
            $index = $i
            break
        }
    }

    if ($index -ge 0) {
        $currentValue = $script:envLines[$index].Substring($prefix.Length)
        if (-not [string]::IsNullOrWhiteSpace($currentValue) -and $currentValue -ne $Placeholder) {
            Write-Host ($Name + ' ya existe; se conserva.')
            return
        }
    }

    $entry = $prefix + (New-SecureHex -ByteCount $ByteCount)
    if ($index -ge 0) {
        $script:envLines[$index] = $entry
    }
    else {
        $script:envLines.Add($entry)
    }
    Write-Host ($Name + ' generado correctamente.')
}

Ensure-EnvSecret -Name 'DB_PASSWORD' -ByteCount 32 -Placeholder 'REEMPLAZAR_CON_PASSWORD_SEGURA'
Ensure-EnvSecret -Name 'JWT_SECRET' -ByteCount 48 -Placeholder 'GENERAR_SECRETO_ALEATORIO'
Ensure-EnvSecret -Name 'JWT_REFRESH_SECRET' -ByteCount 48 -Placeholder 'GENERAR_OTRO_SECRETO_ALEATORIO'

$content = $script:envLines -join "`n"
if ($content -match 'REEMPLAZAR_CON_PASSWORD_SEGURA|GENERAR_SECRETO_ALEATORIO|GENERAR_OTRO_SECRETO_ALEATORIO') {
    throw 'Quedaron marcadores de secretos sin reemplazar. No se guardaron cambios.'
}

$encoding = [System.Text.UTF8Encoding]::new($false)
[System.IO.File]::WriteAllLines($envPath, [string[]]$script:envLines, $encoding)

Write-Host 'Archivo .env listo. Los valores de los secretos no se muestran.'
