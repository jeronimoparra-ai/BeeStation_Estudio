# e03 — Enviar los datos a un servidor

**Objetivo:** ver el ciclo completo **sensor → WiFi → HTTP → servidor → dashboard**.

## Qué hace

1. Lee temperatura y humedad del DHT22.
2. Arma un JSON a mano y lo imprime por el monitor serie.
3. Si hay WiFi, lo manda por `POST` a `backend/recibir.php`.
4. `backend/dashboard.php` lo pinta en una gráfica.

## Cómo ejecutarlo (3 pasos)

**Paso 1 — levanta el backend** (en una terminal, antes que Wokwi):

```bash
cd backend
./iniciar.sh        # Linux/macOS
# o en Windows:
powershell -ExecutionPolicy Bypass -File iniciar.ps1
```

Debes ver `Listening on http://localhost:8080`.

**Paso 2 — compila y simula:**

```bash
cd ejercicios/e03-datos
pio run
```

`Ctrl+Shift+P` → **Wokwi: Start Simulator**.

**Paso 3 — mira el resultado:**

- Monitor serie: `HTTP 201 {"ok":true,...}`
- Navegador: `http://localhost:8080/dashboard.php`

## Plan B (si el gateway no conecta)

Wokwi para VS Code usa un gateway privado que llega a tu PC mediante
`host.wokwi.internal`. Si no conecta (o si usas **wokwi.com**, cuyo gateway
es en la nube y no llega a `localhost`):

1. Copia la línea `JSON -> {...}` del monitor serie.
2. Pégala en `backend/datos/lecturas.json` dentro del arreglo `[]`.
3. Recarga el dashboard.

Los datos **siempre** salen por serie, así que nunca te quedas sin ver nada.

## Qué tocar

1. Cambia `3000` (ms) por `1000` → llegan más datos por minuto.
2. Agrega un campo: `"sensor":"dht22","temperatura":..,"humedad":..,"peso":12.5`
   y recibe `peso` en `backend/recibir.php` (ya está en la lista de campos permitidos).
3. Pon `WIFI_SSID` a un nombre inventado → verás el mensaje `SIN WiFi`.

## Errores típicos

| Mensaje | Causa | Solución |
|---|---|---|
| `No se pudo leer el DHT22.` | Cable o librería | Revisa `dht:SDA` → `esp:D4` |
| `Fallo la peticion: connection refused` | El backend no está corriendo | Ejecuta `iniciar.sh` primero |
| `Fallo la peticion: ... host.wokwi.internal` | Gateway no disponible | Usa el **Plan B** de arriba |
| `SIN WiFi` | SSID mal escrito | Debe ser exactamente `Wokwi-GUEST` |
