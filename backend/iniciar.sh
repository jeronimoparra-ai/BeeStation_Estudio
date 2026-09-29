#!/usr/bin/env bash
# BeeStation Estudio — levanta el backend con el servidor embebido de PHP.
# No necesita Apache, sudo ni MySQL: solo `php -S`.
set -euo pipefail
cd "$(dirname "$0")"

PHP=""
for candidato in php /opt/lampp/bin/php /usr/bin/php /usr/local/bin/php; do
  if command -v "$candidato" >/dev/null 2>&1; then
    PHP="$(command -v "$candidato")"
    break
  elif [ -x "$candidato" ]; then
    PHP="$candidato"
    break
  fi
done

if [ -z "$PHP" ]; then
  echo "ERROR: no encontre PHP."
  echo "  Linux : sudo apt install php-cli"
  echo "  macOS : brew install php"
  echo "  XAMPP : /opt/lampp/bin/php"
  exit 1
fi

mkdir -p datos
[ -f datos/lecturas.json ] || echo "[]" > datos/lecturas.json

PUERTO="${1:-8080}"
echo "----------------------------------------------"
echo " PHP     : $("$PHP" -r 'echo PHP_VERSION;')"
echo " Carpeta : $(pwd)"
echo " URL     : http://localhost:$PUERTO/dashboard.php"
echo " API     : http://localhost:$PUERTO/recibir.php"
echo " Detener : Ctrl+C"
echo "----------------------------------------------"
echo "Escuchando en http://localhost:$PUERTO  (0.0.0.0:$PUERTO)"

# 0.0.0.0 para que el gateway de Wokwi (host.wokwi.internal) tambien llegue.
exec "$PHP" -S "0.0.0.0:$PUERTO" -t .
