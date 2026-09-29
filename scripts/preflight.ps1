# BeeStation_Estudio · preflight de instalacion en equipo institucional (Windows).
# Detecta que hay instalado y que falta, SOLO en espacio de usuario.
# No eleva, no pide contrasenas, no modifica nada del sistema.

$ErrorActionPreference = 'SilentlyContinue'
$missing = 0
$actions = @()

function Row($name, $state, $note) {
    Write-Host ("  {0,-24} {1,-8} {2}" -f $name, $state, $note)
}
function Ok($name, $note)   { Row $name 'OK' $note; }
function Miss($name, $note, $fix) {
    Row $name 'FALTA' $note
    $script:missing++
    $script:actions += $fix
}
function Skip($name, $note) { Row $name 'SALTA' $note; }

Write-Host '============================================================'
Write-Host ' BeeStation · PREFLIGHT  (sin permisos de administrador)'
Write-Host '============================================================'
Write-Host (" Fecha    : " + (Get-Date -Format 'yyyy-MM-dd HH:mm:ss'))
Write-Host (" Usuario  : " + $env:USERNAME + ' en ' + $env:COMPUTERNAME)
Write-Host (" Sistema  : " + [System.Environment]::OSVersion.VersionString + ' ' + $env:PROCESSOR_ARCHITECTURE)
Write-Host (" Home     : " + $env:USERPROFILE)
Write-Host '------------------------------------------------------------'

$principal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
$elevated = $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if ($elevated) {
    Write-Host ' ACCESO ADMIN   : SI (estas elevado: trabaja sin elevar en este equipo)'
} else {
    Write-Host ' ACCESO ADMIN   : NO (correcto: no pidas la contrasena de Windows)'
}

$free = (Get-PSDrive -Name $env:USERPROFILE.Substring(0,1)).Free
Write-Host (" ESPACIO EN HOME: {0:N1} GB" -f ($free / 1GB))
Write-Host '------------------------------------------------------------'
Write-Host ("  {0,-24} {1,-8} {2}" -f 'HERRAMIENTA', 'ESTADO', 'RUTA / NOTA')
Write-Host '------------------------------------------------------------'

# basicos
if (Get-Command git -ErrorAction SilentlyContinue) {
    Ok 'git' ((git --version) -replace 'git version ', '')
} else {
    Miss 'git' '' 'Edicion Portable de Git for Windows (zip) en %USERPROFILE%\tools\git'
}

$py = $null
foreach ($c in @('python3', 'python', 'py')) {
    if (Get-Command $c -ErrorAction SilentlyContinue) { $py = $c; break }
}
if ($py) { Ok 'python' (& $py -c 'import sys;print(sys.version.split()[0])' 2>$null) }
else { Miss 'python' '' "instalador de python.org con 'Install for current user'" }

if ($py -and (& $py -m pip --version 2>$null)) { Ok 'pip' 'user-scope' }
else { Miss 'pip' '' "$py -m ensurepip --user" }

if (Get-Command php -ErrorAction SilentlyContinue) {
    Ok 'php' ((php -v) -split "`n")[0]
} elseif (Test-Path 'C:\xampp\php\php.exe') {
    Ok 'php (fuera del PATH)' 'C:\xampp\php\php.exe · invocar por ruta absoluta'
    $script:actions += 'agregar C:\xampp\php\php.exe al PATH de USUARIO (no al del sistema)'
} else {
    Miss 'php' '' 'ZIP NTS de windows.php.net en %USERPROFILE%\tools\php (agregar al PATH de USUARIO, no al del sistema)'
}

if (Get-Command curl -ErrorAction SilentlyContinue) { Ok 'curl' 'incluido en Windows 10+' }
else { Miss 'curl' '' 'incluido en Windows 10+; si falta, usa Invoke-WebRequest' }

# PlatformIO
$pio = $null
if (Get-Command pio -ErrorAction SilentlyContinue) { $pio = 'pio' }
elseif (Test-Path "$env:USERPROFILE\.platformio\penv\Scripts\pio.exe") { $pio = "$env:USERPROFILE\.platformio\penv\Scripts\pio.exe" }
if ($pio) { Ok 'PlatformIO Core' ("$pio · " + (& $pio --version 2>$null)) }
else { Miss 'PlatformIO Core' '' 'py -m pip install --user platformio  (o instalador oficial -> %USERPROFILE%\.platformio)' }

if (Test-Path "$env:USERPROFILE\.platformio\platforms\espressif32") {
    Ok 'plataforma espressif32' "$env:USERPROFILE\.platformio\platforms\espressif32"
} else {
    Miss 'plataforma espressif32' '' 'pio pkg install --global --platform espressif32 (baja a %USERPROFILE%, sin admin)'
}

if ((Test-Path "$env:USERPROFILE\.platformio\packages\framework-arduinoespressif32") -or
    (Test-Path "$env:USERPROFILE\.platformio\packages\toolchain-xtensa-esp32")) {
    Ok 'toolchain ESP32' '%USERPROFILE%\.platformio\packages'
} else {
    Miss 'toolchain ESP32' '' 'pio run en cualquier ejercicio la descarga a %USERPROFILE%\.platformio'
}

# dependencias por ejercicio
$root = Split-Path -Parent $PSScriptRoot
$deps = Get-ChildItem -Path (Join-Path $root 'ejercicios') -Recurse -Directory -Filter 'libdeps' -ErrorAction SilentlyContinue | Select-Object -First 1
if ($deps -and (Get-ChildItem $deps.FullName -Recurse -Directory -ErrorAction SilentlyContinue | Where-Object { $_.Name -like '*DHT*' })) {
    Ok 'librerias de ejercicio' "DHTesp descargado en $($deps.FullName)"
} elseif ($deps) {
    Miss 'librerias de ejercicio' '' 'cd ejercicios\e02-sensor && pio run  (baja a .pio\libdeps, sin admin)'
} else {
    Skip 'librerias de ejercicio' 'aun no se compilo ningun ejercicio'
}

# VS Code y extensiones
$code = $null
if (Get-Command code -ErrorAction SilentlyContinue) { $code = 'code' }
elseif (Test-Path "$env:LOCALAPPDATA\Programs\Microsoft VS Code\bin\code.cmd") {
    $code = "$env:LOCALAPPDATA\Programs\Microsoft VS Code\bin\code.cmd"
}
if ($code) {
    Ok 'VS Code' ((& $code --version 2>$null) -join ' · ')
} else {
    Miss 'VS Code' '' 'ZIP oficial extraido a %USERPROFILE%\tools\VSCode (NO usar winget ni instalador para todos)'
}

if ($code) {
    $exts = (& $code --list-extensions 2>$null | ForEach-Object { $_.ToLower() })
    if ($exts -contains 'platformio.platformio-ide') { Ok 'ext: PlatformIO IDE' 'instalada por usuario' }
    else { Miss 'ext: PlatformIO IDE' '' 'code --install-extension platformio.platformio-ide' }
    if ($exts -contains 'wokwi.wokwi-vscode') { Ok 'ext: Wokwi' 'instalada por usuario' }
    else { Miss 'ext: Wokwi' '' 'code --install-extension wokwi.wokwi-vscode' }
} else {
    Skip 'ext: PlatformIO IDE' 'falta VS Code'
    Skip 'ext: Wokwi' 'falta VS Code'
}

Write-Host '------------------------------------------------------------'
if ($missing -eq 0) {
    Write-Host ' RESULTADO: todo listo. No hace falta instalar nada.' -ForegroundColor Green
} else {
    Write-Host " RESULTADO: $missing elemento(s) faltante(s). Todo es instalable SIN administrador:" -ForegroundColor Yellow
    $i = 1
    foreach ($a in $actions) { Write-Host "   $i. $a"; $i++ }
}
Write-Host '============================================================'
Write-Host ' Regla: si algo solo se puede instalar con contrasena de admin,'
Write-Host '        marcalo REQUIERE TI y sigue con el resto.'
Write-Host '============================================================'

if ($missing -eq 0) { exit 0 } else { exit 1 }
