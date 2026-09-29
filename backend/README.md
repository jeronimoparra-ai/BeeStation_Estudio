# backend — servidor mínimo (PHP + archivo JSON)

No usa Apache, ni MySQL, ni sudo. Un solo comando.

## Arrancar

**Linux / macOS**

```bash
./iniciar.sh
```

**Windows**

```powershell
powershell -ExecutionPolicy Bypass -File iniciar.ps1
```

Debes ver:

```
URL     : http://localhost:8080/dashboard.php
Escuchando en http://localhost:8080
```

Déjalo abierto. Detenlo con `Ctrl+C`.

## Qué hay aquí

| Archivo | Qué hace |
|---|---|
| `recibir.php` | Recibe un `POST` con JSON, valida campos y lo guarda en `datos/lecturas.json` (últimas 200 lecturas) |
| `dashboard.php` | Gráfica en vivo que refresca cada 2 s. **Sin CDN, funciona sin internet** |
| `datos/lecturas.json` | El almacén. Es solo un arreglo JSON editable a mano |
| `iniciar.sh` / `iniciar.ps1` | Arrancan `php -S` en el puerto 8080 |

## Probarlo a mano (sin Wokwi)

Con el servidor corriendo, en **otra** terminal:

```bash
curl -X POST http://localhost:8080/recibir.php \
  -H "Content-Type: application/json" \
  -d '{"sensor":"dht22","temperatura":34.5,"humedad":62.1}'
```

Esperado: `HTTP 201` con `"ok":true`.

Abre <http://localhost:8080/dashboard.php> → debe aparecer un punto.

## Campos aceptados

`sensor`, `temperatura`, `humedad`, `peso`, `presion`, `co2`, `luz`, `sonido`, `nota`

Cualquier otro campo se ignora (no se rechaza el resto). Siempre se agregan `fecha` y `hora`.

## Plan B — pegar datos a mano

Si el gateway de Wokwi no llega a tu PC, copia la línea `JSON -> {...}` del
monitor serie y pégala **dentro** de `datos/lecturas.json`:

```json
[
  { "sensor": "dht22", "temperatura": 34.0, "humedad": 62.0, "fecha": "2026-09-29", "hora": "10:15:00" }
]
```

Recarga el dashboard y aparecerá.

## Problemas frecuentes

| Síntoma | Causa | Solución |
|---|---|---|
| `no encontre PHP` | PHP no está en el PATH | Instala XAMPP o `sudo apt install php-cli` |
| `Address already in use` | Ya hay algo en el 8080 | `./iniciar.sh 8081` y cambia el puerto en `e03-datos` |
| `400 Ningun campo reconocido` | Enviaste otra clave | Usa los nombres de la tabla de arriba |
| Dashboard dice "Sin lecturas" | Todavía no llegó ningún POST | Ejecuta `e03-datos` o usa el Plan B |
