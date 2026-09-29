# e02 — Leer un sensor

**Objetivo:** leer temperatura y humedad reales desde el simulador y reaccionar a ellas.

## Qué hace

Cada 2 segundos imprime por el monitor serie:

```
temperatura = 34.0 C | humedad = 62.0 %
```

Si subes la temperatura por encima de 35 °C aparece `ALERTA: demasiado calor para la colmena.`

## Cómo ejecutarlo

```bash
cd ejercicios/e02-sensor
pio run
pio device monitor      # (opcional) ver la salida sin abrir Wokwi
```

En VS Code: `Ctrl+Shift+P` → **Wokwi: Start Simulator**.

## Qué tocar

1. Haz clic en el **DHT22** y mueve los sliders de temperatura y humedad → los números del monitor serie cambian en vivo.
2. Pon la temperatura en `36` → aparece la alerta.
3. Cambia el umbral `35.0` por `30.0` en `src/main.cpp` y recompila.

## Nota importante

Se usa la librería **`DHT sensor library for ESPx`** (y no la de Adafruit) porque es la que Wokwi recomienda para ESP32; con la otra puede fallar la lectura.

## Errores típicos

| Mensaje | Causa | Solución |
|---|---|---|
| `No se pudo leer el DHT22.` | Cable mal conectado o librería equivocada | Revisa `dht:SDA` → `esp:D4` en `diagram.json` |
| `isnan` / basura | Estás usando la librería de Adafruit | Quita `adafruit/DHT...` y deja la de ESPx |
