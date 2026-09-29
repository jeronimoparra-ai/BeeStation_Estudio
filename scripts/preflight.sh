#!/usr/bin/env bash
# BeeStation_Estudio · preflight de instalación en equipo institucional.
# Detecta qué hay instalado y qué falta, SOLO en espacio de usuario.
# No ejecuta sudo, no pide contraseñas, no modifica nada del sistema.

set -u

BOLD=$'\033[1m'; DIM=$'\033[2m'; GRN=$'\033[32m'; RED=$'\033[31m'; YEL=$'\033[33m'; RST=$'\033[0m'
if [ ! -t 1 ]; then BOLD=""; DIM=""; GRN=""; RED=""; YEL=""; RST=""; fi

MISSING=0
ACTIONS=()

have() { command -v "$1" >/dev/null 2>&1; }

row() { printf ' %-24s %-8s %s\n' "$1" "$2" "$3"; }

ok()    { row "$1" "OK" "$2"; }
missing(){ row "$1" "${RED}FALTA${RST}" "$2"; MISSING=$((MISSING+1)); ACTIONS+=("$3"); }
skip()  { row "$1" "${YEL}SALTA${RST}" "$2"; }

home_check() {
  if [ -d "$HOME/.local" ] || [ -w "$HOME" ]; then
    ok "escritura en \$HOME" "$HOME"
  else
    missing "escritura en \$HOME" "sin permiso de escritura" "no puedes instalar nada; pide otra cuenta"
  fi
}

detect_admin() {
  if [ "$(id -u)" = "0" ]; then
    echo "NO (estás como root: no trabajes así en este equipo)"
    return
  fi
  if have sudo; then
    echo "NO usar (sudo existe pero pide contraseña; política del proyecto)"
  else
    echo "NO (sin sudo en el equipo)"
  fi
}

disk_free() {
  if df -Pk "$HOME" >/dev/null 2>&1; then
    df -Pk "$HOME" | awk 'NR==2 {printf "%.1f GB", $4/1048576}'
  else
    echo "?"
  fi
}

echo "============================================================"
echo " BeeStation · PREFLIGHT  (sin permisos de administrador)"
echo "============================================================"
echo " Fecha    : $(date '+%Y-%m-%d %H:%M:%S')"
echo " Usuario  : ${USER:-?} en $(hostname 2>/dev/null || echo '?')"
echo " Sistema  : $(uname -s) $(uname -r) $(uname -m)"
echo " Home     : $HOME"
echo "------------------------------------------------------------"
echo " ACCESO ADMIN   : $(detect_admin)"
FREE=$(disk_free)
echo " ESPACIO EN HOME: $FREE"
echo "------------------------------------------------------------"
printf ' %-24s %-8s %s\n' "HERRAMIENTA" "ESTADO" "RUTA / NOTA"
echo "------------------------------------------------------------"

# --- básicos -----------------------------------------------------------
if have git;  then ok "git" "$(git --version 2>/dev/null | head -1)"; else missing "git" "" "Windows: ZIP portable de Git for Windows en \$USERPROFILE\\tools\\git"; fi
if have python3; then ok "python3" "$(python3 -c 'import sys;print(sys.version.split()[0])' 2>/dev/null)"; elif have python; then ok "python" "$(python -c 'import sys;print(sys.version.split()[0])' 2>/dev/null)"; else missing "python3" "" "instalador de python.org con 'Install for current user' o Miniconda en el home"; fi
if have pip3 || have pip || python3 -m pip --version >/dev/null 2>&1; then ok "pip" "user-scope"; else missing "pip" "" "python -m ensurepip --user"; fi
PHPBIN=$(command -v php 2>/dev/null || true)
if [ -z "$PHPBIN" ] && [ -x /opt/lampp/bin/php ]; then PHPBIN=/opt/lampp/bin/php; fi
if [ -n "$PHPBIN" ]; then
  if have php; then ok "php" "$("$PHPBIN" -v 2>/dev/null | head -1)"
  else ok "php (fuera del PATH)" "$PHPBIN · invocar por ruta absoluta"
        ACTIONS+=("agregar $PHPBIN al PATH de usuario (no al del sistema)"); fi
else
  missing "php" "" "Windows: ZIP NTS de windows.php.net en %USERPROFILE%\\tools\\php | Linux: marcar REQUIERE TI y usar Plan B (monitor serie)"
fi
if have curl; then ok "curl" "$(command -v curl)"; else missing "curl" "" "ya suele venir; si falta usa wget"; fi

# --- PlatformIO --------------------------------------------------------
PIO=""
if have pio; then PIO=$(command -v pio)
elif [ -x "$HOME/.platformio/penv/bin/pio" ]; then PIO="$HOME/.platformio/penv/bin/pio"
fi
if [ -n "$PIO" ]; then ok "PlatformIO Core" "$PIO · $($PIO --version 2>/dev/null)"
else missing "PlatformIO Core" "" "python3 -m pip install --user platformio  (o instalador oficial -> \$HOME/.platformio)"; fi

if [ -d "$HOME/.platformio/platforms/espressif32" ]; then ok "plataforma espressif32" "$HOME/.platformio/platforms/espressif32"
else missing "plataforma espressif32" "" "pio pkg install --global --platform espressif32 (baja a \$HOME, sin admin)"; fi

if [ -d "$HOME/.platformio/packages/framework-arduinoespressif32" ] || [ -d "$HOME/.platformio/packages/toolchain-xtensa-esp32" ]; then
  ok "toolchain ESP32" "\$HOME/.platformio/packages"
else missing "toolchain ESP32" "" "pio run en cualquier ejercicio la descarga a \$HOME/.platformio"; fi

# --- dependencias por ejercicio ---------------------------------------
if [ -d ejercicios ]; then
  DEPS=$(find ejercicios -maxdepth 4 -type d -name 'libdeps' 2>/dev/null | head -1)
  if [ -n "$DEPS" ] && find "$DEPS" -maxdepth 2 -iname '*DHT*' 2>/dev/null | grep -q .; then
    ok "librerías de ejercicio" "DHTesp descargado en $DEPS"
  else
    missing "librerías de ejercicio" "" "cd ejercicios/e02-sensor && pio run  (baja a .pio/libdeps, sin admin)"
  fi
else
  skip "librerías de ejercicio" "no se ejecutó desde la raíz del repo"
fi

# --- VS Code y extensiones --------------------------------------------
CODE=""
if have code; then CODE=$(command -v code)
elif [ -x "$HOME/.local/vscode/bin/code" ]; then CODE="$HOME/.local/vscode/bin/code"
fi
if [ -n "$CODE" ]; then ok "VS Code" "$($CODE --version 2>/dev/null | head -1) · $CODE"
else missing "VS Code" "" "tarball oficial extraido a \$HOME/.local/vscode (NO usar apt)"; fi

if [ -n "$CODE" ]; then
  EXTS=$("$CODE" --list-extensions 2>/dev/null | tr '[:upper:]' '[:lower:]')
  echo "$EXTS" | grep -q '^platformio\.platformio-ide$' && ok "ext: PlatformIO IDE" "instalada por usuario" || missing "ext: PlatformIO IDE" "" "code --install-extension platformio.platformio-ide"
  echo "$EXTS" | grep -q '^wokwi\.wokwi-vscode$'    && ok "ext: Wokwi" "instalada por usuario"          || missing "ext: Wokwi" "" "code --install-extension wokwi.wokwi-vscode"
else
  skip "ext: PlatformIO IDE" "falta VS Code"
  skip "ext: Wokwi" "falta VS Code"
fi

echo "------------------------------------------------------------"
if [ "${#ACTIONS[@]}" -eq 0 ]; then
  echo " ${GRN}RESULTADO: todo listo. No hace falta instalar nada.${RST}"
else
  echo " ${YEL}RESULTADO: ${#ACTIONS[@]} accion(es) pendiente(s). Todas son aplicables SIN administrador:${RST}"
  i=1
  for a in "${ACTIONS[@]}"; do echo "   $i. $a"; i=$((i+1)); done
fi
echo "============================================================"
echo " Regla: si algo solo se puede instalar con contraseña de admin,"
echo "        márcalo REQUIERE TI y sigue con el resto."
echo "============================================================"

[ "${#ACTIONS[@]}" -eq 0 ]
