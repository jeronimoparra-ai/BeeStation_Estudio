# 🐝 BeeStation Estudio

Plan de estudio corto e intensivo para que tu grupo conozca y se apropie de las
tecnologías de **BeeStation_Sena**, usando **PlatformIO + Wokwi** (simulación,
sin hardware) y **NotebookLM** para el material de refuerzo.

> **Duración: 2 h 30 min · 3 ejercicios · sin Arduino IDE, sin MySQL, sin sudo.**

---

## 🎯 Lo que consigue el grupo al terminar

1. Compila firmware para ESP32 con PlatformIO.
2. Simula el circuito en Wokwi y lee un sensor en vivo.
3. Manda datos por WiFi a un servidor y los ve en un dashboard.

Eso es el **pipeline completo**: sensor → microcontrolador → red → servidor → pantalla.

---

## ⏱️ Agenda

| Min | Bloque | Qué hacen | Entregable |
|----:|---|---|---|
| 0–20 | **Instalar y verificar** | Sigen la guía de más abajo | Las 3 verificaciones en verde |
| 20–45 | **e01 — Hola, LED** | Compilan y simulan | LED parpadea, botón lo apaga |
| 45–50 | Pausa | | |
| 50–85 | **e02 — Un sensor** | Leen temperatura y humedad | Mueven el slider y cambia el °C |
| 85–90 | Pausa | | |
| 90–140 | **e03 — Enviar datos** | Levantan el backend y conectan | Dashboard con la gráfica moviéndose |
| 140–150 | **Cierre** | Abren el cuaderno de NotebookLM | Hacen el quiz de salida |

**¿Solo 2 horas?** Corta los bloques 1 y 2 a la mitad: en 20 min se instala,
en 15 se ve el LED y se salta directo a `e02` + `e03`.

---

## 🖥️ Instalación (una sola vez)

### Todos

1. **Visual Studio Code** → <https://code.visualstudio.com>
2. **PlatformIO IDE** — en VS Code: `Ctrl+Shift+X` → busca `PlatformIO IDE` → *Install*.
3. **Wokwi Simulator** — en VS Code: `Ctrl+Shift+X` → busca `Wokwi Simulator` → *Install*.
4. **Git** — <https://git-scm.com/downloads>

### Extras para el bloque `e03`

El backend es PHP. Necesitas **una** de estas dos:

| Sistema | Opción |
|---|---|
| Windows | Instala **XAMPP** → <https://www.apachefriends.org> (no hace falta encender Apache) |
| Linux | `sudo apt install php-cli` |
| macOS | `brew install php` |

### Clonar

```bash
git clone https://github.com/jeronimoparra-ai/BeeStation_Estudio.git
cd BeeStation_Estudio
```

### Verificar que todo está bien

```bash
# PlatformIO
pio --version          # debe decir PlatformIO Core, version 6.x

# PHP (solo para e03)
php -v                 # 8.x   — en Windows puede ser C:\xampp\php\php.exe -v
```

> Si `pio` no se reconoce, cierra y abre VS Code de nuevo (se agrega al PATH al instalar la extensión).

---

## 🚀 Cómo arrancar cada ejercicio

Cada ejercicio es un proyecto de PlatformIO completo. Abré **la carpeta del ejercicio** en VS Code
(`Archivo → Abrir carpeta`) — no la raíz del repo.

```bash
cd ejercicios/e01-led
pio run                     # compila
```

Luego `Ctrl+Shift+P` → **Wokwi: Start Simulator**.

### Plan alternativo: wokwi.com (navegador, sin instalar nada)

Si la extensión de VS Code no te deja usarla (licencia), usa el editor online:

1. Abre <https://wokwi.com/new/esp32>
2. Pega el contenido de `src/main.cpp` en el editor de código.
3. Pega el contenido de `diagram.json` en el editor de diagrama (`F1` → *Edit diagram.json*).
4. Compila igual con `pio run` y sube `.pio/build/esp32dev/firmware.bin`.

⚠️ En **wokwi.com** no llegas a `localhost`, así que en `e03` usa el **Plan B**
(descrito en `ejercicios/e03-datos/README.md`): copiar la línea `JSON -> {...}`
del monitor serie dentro de `backend/datos/lecturas.json`.

---

## 📁 Qué hay en este repo

```
BeeStation_Estudio/
├── README.md                  ← este archivo
├── ejercicios/
│   ├── e01-led/               LED + botón                          (0 librerías)
│   ├── e02-sensor/            DHT22 → monitor serie                (1 librería)
│   └── e03-datos/             DHT22 → WiFi → servidor → dashboard  (1 librería)
├── backend/
│   ├── recibir.php            recibe JSON y lo guarda en un archivo
│   ├── dashboard.php          gráfica en vivo (sin internet)
│   ├── iniciar.sh             Linux/macOS
│   └── iniciar.ps1            Windows
└── notebooklm/
    ├── COMO-USAR.md           cómo generar el material y con qué límites
    ├── prompts.md             4 prompts listos para pegar
    └── fuente-01.md           fuente base para el cuaderno
```

Cada ejercicio trae `platformio.ini`, `src/main.cpp`, `diagram.json`, `wokwi.toml` y su `README.md`.

---

## 🔧 El backend en 30 segundos

```bash
cd backend
./iniciar.sh                      # Linux/macOS
powershell -ExecutionPolicy Bypass -File iniciar.ps1    # Windows
```

| URL | Qué muestra |
|---|---|
| <http://localhost:8080/dashboard.php> | La gráfica |
| <http://localhost:8080/recibir.php> | El endpoint (responde 400 si le llega basura) |

Detener: `Ctrl+C`. Prueba rápida sin Wokwi:

```bash
curl -X POST http://localhost:8080/recibir.php \
  -H "Content-Type: application/json" \
  -d '{"sensor":"dht22","temperatura":34.5,"humedad":62.1}'
```

---

## 🧠 NotebookLM (material de refuerzo)

Todo el material para generar guías, quizzes y videos está en
[`notebooklm/`](notebooklm/COMO-USAR.md).

Resumen rápido:

1. Crea un cuaderno en <https://notebooklm.google.com>.
2. Sube `notebooklm/fuente-01.md`.
3. Usa los prompts de [`notebooklm/prompts.md`](notebooklm/prompts.md).

La cuenta gratuita da **3 videos y 3 audios al día**, así que reparte la
generación en 2 días.

---

## ⚠️ Problemas frecuentes

| Síntoma | Causa | Solución |
|---|---|---|
| `pio: command not found` | VS Code recién instalado | Reinicia VS Code |
| El simulador no arranca | Faltan `wokwi.toml` o `diagram.json` | Deben estar junto a `platformio.ini` |
| `No se pudo leer el DHT22` | Librería equivocada o cable | Usa `DHTesp.h` y `dht:SDA → esp:D4` |
| `no encontre PHP` | No está en el PATH | XAMPP o `apt install php-cli` |
| `Fallo la peticion: connection refused` | Backend apagado | Corre `iniciar.sh` antes de simular |
| `host.wokwi.internal` no resuelve | Gateway no disponible o wokwi.com | **Plan B** de `e03` |
| Extensión Wokwi pide licencia | Plan gratuito caducado | Activa en <https://wokwi.com/license> (30 días) o usa wokwi.com |

---

## 📚 Qué es BeeStation (para contextualizar)

BeeStation_Sena monitorea colmenas con un ESP32 y 6 sensores (temperatura,
humedad, peso, sonido, luz, presión). El equipo mide, envía por WiFi, el backend
valida y guarda en MySQL, y un dashboard calcula el **Índice de Bienestar
Bioclimático** de la colmena.

Este repo **no** instala ese sistema: es el entrenamiento previo, en versión
mínima y simulada, para que el grupo llegue sabiendo moverse.

Repo principal: [`jeronimoparra-ai/BeeStation_Sena`](https://github.com/jeronimoparra-ai/BeeStation_Sena)

---

## 📄 Licencia

MIT © 2026 𝕵𝖊𝖗𝖔_𝕯𝖊𝕧
