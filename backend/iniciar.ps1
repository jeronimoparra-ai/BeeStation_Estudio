# BeeStation Estudio - levanta el backend en Windows.
# Uso: powershell -ExecutionPolicy Bypass -File iniciar.ps1
$ErrorActionPreference = "Stop"
Set-Location $PSScriptRoot

$candidatos = @(
    "php",
    "C:\xampp\php\php.exe",
    "C:\laragon\bin\php\php.exe",
    "C:\php\php.exe"
)

$php = $null
foreach ($c in $candidatos) {
    if (Get-Command $c -ErrorAction SilentlyContinue) {
        $php = (Get-Command $c).Source
        break
    }
}

if (-not $php) {
    Write-Host "ERROR: no encontre PHP en este equipo." -ForegroundColor Red
    Write-Host "  Opcion A (recomendada): instala XAMPP -> https://www.apachefriends.org"
    Write-Host "  Opcion B: instala PHP y agregalo al PATH -> https://windows.php.net"
    exit 1
}

if (-not (Test-Path "datos")) { New-Item -ItemType Directory -Path "datos" | Out-Null }
if (-not (Test-Path "datos\lecturas.json")) { Set-Content -Path "datos\lecturas.json" -Value "[]" -Encoding UTF8 }

$puerto = if ($args.Count -gt 0) { $args[0] } else { "8080" }

Write-Host "----------------------------------------------"
Write-Host " PHP     : $(& $php -r 'echo PHP_VERSION;')"
Write-Host " Carpeta : $PSScriptRoot"
Write-Host " URL     : http://localhost:$puerto/dashboard.php"
Write-Host " API     : http://localhost:$puerto/recibir.php"
Write-Host " Detener : Ctrl+C"
Write-Host "----------------------------------------------"
Write-Host "Escuchando en http://localhost:$puerto"

& $php -S "0.0.0.0:$puerto" -t $PSScriptRoot
