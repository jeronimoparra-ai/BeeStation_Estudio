# e01 — Hola, LED

**Objetivo:** compilar con PlatformIO y ver correr el firmware en el simulador Wokwi.

## Qué hace

- Un LED verde parpadea una vez por segundo.
- Mientras mantienes pulsado el botón, el LED queda apagado.
- Todo lo que pasa se imprime en el monitor serie.

## Cómo ejecutarlo

```bash
cd ejercicios/e01-led
pio run              # compila
```

Luego, en VS Code: `Ctrl+Shift+P` → **Wokwi: Start Simulator**.

- Si usas **wokwi.com**: copia `src/main.cpp`, `diagram.json` en el editor online y sube el `.bin` de `.pio/build/esp32dev/firmware.bin`.

## Qué tocar para ver qué pasa

1. Cambia `delay(500)` por `delay(100)` → parpadea más rápido.
2. Cambia `"color": "green"` por `"red"` en `diagram.json` → el LED queda rojo.
3. Cambia el pin `PIN_LED` de `2` a `13` y cambia también `esp:D2` por `esp:D13` en `diagram.json`.

## Errores típicos

| Mensaje | Causa | Solución |
|---|---|---|
| `failed to build` | PlatformIO no está instalado | Ver `README.md` raíz |
| El simulador no arranca | Falta `wokwi.toml` o no está en la raíz | Revisa que exista junto a `platformio.ini` |
| No cambia nada al editar | No recompilaste | `pio run` otra vez y reinicia el simulador |
