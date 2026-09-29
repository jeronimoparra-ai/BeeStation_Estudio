# Soluciones — ejercicios e01, e02 y e03

Esta rama existe solo para el instructor. En `main` los ejercicios ya
compilan y corren tal cual; aquí están resueltos los retos de la sección
**«Qué tocar»** de cada README.

```bash
git checkout soluciones     # ver esto
git checkout main           # volver al material limpio del grupo
```

---

## e01 — Hola, LED

### Reto 1 · Parpadear más rápido
`src/main.cpp` → cambia ambos `delay(500)` por `delay(100)`:

```cpp
  digitalWrite(PIN_LED, HIGH);
  delay(100);          // era 500
  digitalWrite(PIN_LED, LOW);
  delay(100);          // era 500
```
Resultado: 5 parpadeos por segundo en vez de 1.

### Reto 2 · LED rojo
`diagram.json` → en la parte del LED:

```json
{ "type": "wokwi-led", "id": "led1", "top": -40, "left": 240, "attrs": { "color": "red" } }
```

### Reto 3 · Mover el LED al pin 13
Dos lugares, **ambos** deben coincidir:

```cpp
const int PIN_LED = 13;      // src/main.cpp
```
```json
[ "r1:2", "esp:D13", "green", [ "h20" ] ]   // diagram.json
```

> Error típico: cambiar uno de los dos y olvidar el otro. El LED no se enciende
> porque el código manda señal a un pin que no tiene nada conectado.

---

## e02 — Leer un sensor

### Reto 1 · Mover los sliders
No hay código: haz clic en el **DHT22** dentro del simulador y arrastra
`temperature` / `humidity`. El monitor serie se actualiza cada 2 segundos.

### Reto 2 · Alerta a 36 °C
```cpp
if (temperatura > 36.0) {
  Serial.println("  -> ALERTA: demasiado calor para la colmena.");
}
```

### Reto 3 · Alerta también por frío
```cpp
if (temperatura > 36.0) {
  Serial.println("  -> ALERTA: demasiado calor para la colmena.");
} else if (temperatura < 32.0) {
  Serial.println("  -> ALERTA: demasiado frio para la colmena.");
}
```

### Pregunta de comprensión
*¿Por qué se usa `DHTesp` y no la librería de Adafruit?*
Porque Wokwi solo garantiza lecturas fiables del DHT22 en ESP32 con la
librería `DHT sensor library for ESPx`. Con la de Adafruit puede devolver
`nan` de forma intermitente y el ejercicio parecería "roto".

### Reto extra · Rango seguro de colmena
```cpp
bool enRango = (temperatura >= 34.0 && temperatura <= 36.0);
Serial.println(enRango ? "  -> Colmena en rango optimo." : "  -> Fuera de rango.");
```

---

## e03 — Enviar datos

### Reto 1 · Enviar una lectura por segundo
```cpp
delay(1000);   // era 3000
```

### Reto 2 · Agregar el peso al JSON
El backend ya acepta `peso` (está en su lista de campos permitidos), solo hay
que meterlo al cuerpo del POST:

```cpp
String cuerpo = String("{\"sensor\":\"dht22\",")
              + "\"temperatura\":" + String(temperatura, 1) + ","
              + "\"humedad\":"     + String(humedad, 1)     + ","
              + "\"peso\":12.5}";
```

Resultado esperado en el dashboard: la tarjeta de lecturas sigue contando, y en
`datos/lecturas.json` aparece `"peso": 12.5`.

Para que la gráfica lo dibuje habría que agregarlo a `backend/dashboard.php`
(serie de color ámbar, eje propio). Lo dejamos como reto avanzado.

### Reto 3 · Romper el WiFi a propósito
```cpp
const char* WIFI_SSID = "Wokwi-Inventado";
```
Resultado esperado, en este orden:

1. `Conectando a Wokwi-Inventado ......` (60 intentos ≈ 15 s)
2. `SIN WiFi: el backend no recibira nada.`
3. `  -> Los datos saldran igual por el monitor serie (plan B).`
4. `JSON -> {"sensor":"dht22","temperatura":34.0,"humedad":62.0}`

**La lección:** el sensor sigue midiendo aunque la red falle. Por eso el
firmware imprime el JSON por serie *antes* de intentar enviarlo: nunca se
pierde el dato, solo se pierde el envío.

### Reto 4 · Qué significa cada código de estado

| Código | Significado | Qué hacer |
|---|---|---|
| `201` | Creado: se guardó | Nada, todo bien |
| `400` | La API no entendió el cuerpo | Revisa que sea JSON y que traiga campos conocidos |
| `401` | Credencial inválida | Falta o está mal la API Key |
| `connection refused` | No había servidor | El backend estaba apagado |

### Reto 5 · Plan B a mano

Si `host.wokwi.internal` no resuelve (o usas wokwi.com), copia la línea
`JSON -> {...}` y pégala dentro del arreglo de `backend/datos/lecturas.json`:

```json
[
  { "sensor": "dht22", "temperatura": 34.0, "humedad": 62.0,
    "fecha": "2026-09-29", "hora": "10:15:00" }
]
```

Recarga `dashboard.php` y aparecerá el punto.

---

## Cierre · el quiz

Las respuestas del quiz de salida salen de `notebooklm/fuente-01.md`:

| Tema | Sección de la fuente |
|---|---|
| Recorrido de un dato | § 4 |
| Qué mide cada sensor | § 3 |
| API y códigos de estado | § 4 y § 5 |
| Indicadores (IBB, EV, ΔT, H_miel) | § 7 |
| Limitaciones reales del sistema | § 9 |
| PlatformIO vs Wokwi | § 11 |
