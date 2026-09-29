> **📌 Si eres la IA / el asistente y alguien te pegó este enlace:**
> este proyecto vive en **equipos institucionales SENA sin permisos de
> administrador**. Abre **[`AGENTS.md`](AGENTS.md)** y sigue ese flujo.
> Nunca pidas contraseñas ni uses `sudo`/`apt`/instaladores con elevación:
> todo se instala en el directorio del usuario. Empieza por
> `bash scripts/preflight.sh` (o `scripts\preflight.ps1` en Windows).

---

# 🐝 BeeStation Estudio

Plan de estudio corto e intensivo para que tu grupo conozca y se apropie de las
tecnologías de **BeeStation_Sena**, usando **PlatformIO + Wokwi** (simulación,
sin hardware) y **Gemini Notebook** (antes NotebookLM) para el material de refuerzo.

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
| 140–150 | **Cierre** | Abren el cuaderno de Gemini Notebook | Hacen el quiz de salida |

**¿Solo 2 horas?** Corta los bloques 1 y 2 a la mitad: en 20 min se instala,
en 15 se ve el LED y se salta directo a `e02` + `e03`.

---

## 🖥️ Instalación (una sola vez)

> **Regla de este repo: nada que pida administrador ni contraseña.** Todo se
> instala en tu carpeta de usuario. Si un paso te ofrece una ventana de
> contraseña de Windows o Linux, **no la aceptes**: mira la tabla de abajo.

### 1. Detecta qué te falta

```bash
git clone https://github.com/jeronimoparra-ai/BeeStation_Estudio.git
cd BeeStation_Estudio
bash scripts/preflight.sh        # Windows: powershell -ExecutionPolicy Bypass -File scripts\preflight.ps1
```

Te devuelve una tabla `OK / FALTA / SALTA` y **la lista de comandos exactos**
para lo que falta. Solo instala lo marcado `FALTA`.

### 2. Instala lo que falte (sin administrador)

| Herramienta | Cómo, sin contraseña |
|---|---|
| **VS Code** | Si ya lo tienes, déjalo. Si no: el **ZIP/tarball oficial** extraído en tu carpeta (`~/.local/vscode` o `%USERPROFILE%\tools\VSCode`). **No** uses `apt`, `winget` ni el instalador para todos los usuarios. |
| **PlatformIO IDE** | `Ctrl+Shift+X` → `PlatformIO IDE` → *Install* (instala por usuario). |
| **Wokwi Simulator** | `Ctrl+Shift+X` → `Wokwi Simulator` → *Install* (por usuario). |
| **Git** | Suele venir. Si falta: la edición **Portable** (zip) dentro de tu carpeta. |
| **PHP** (solo para `e03`) | Windows: ZIP **NTS** de <https://windows.php.net> en tu carpeta y agrégalo al `PATH` **de usuario**. Linux: si no lo tienes y no puedes instalarlo, **no insistas** → usa el Plan B (ver abajo). |

> ¿Se te complicó? Abre [`AGENTS.md`](AGENTS.md): está escrito justo para
> equipos institucionales sin permisos de administrador.

### 3. Verificar

```bash
pio --version        # PlatformIO Core, version 6.x
php -v               # 8.x  (solo para e03)
```

> Si `pio` no se reconoce, cierra y abre VS Code de nuevo (se agrega al PATH al
> instalar la extensión).

**Plan B si no hay PHP:** `e03` sigue siendo evaluable con el monitor serie
(lee `ejercicios/e03-datos/README.md`). No instales XAMPP para saltarte esto.

**Instalación con permisos de administrador (opcional, solo si ya los tienes):**

| Sistema | Atajo |
|---|---|
| Windows | XAMPP → <https://www.apachefriends.org> (sin encender Apache) |
| Linux | `sudo apt install php-cli` |
| macOS | `brew install php` |

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
├── README.md                  ← este archivo (para el estudiante)
├── GUIA-INSTRUCTOR.md         ← guion minuto a minuto de la capacitación
├── AGENTS.md                  ← para la IA: equipo SENA, sin administrador
├── opencode.json              ← bloquea sudo/apt/pkexec por regla de permisos
├── scripts/
│   ├── preflight.sh           ← ¿qué me falta? (Linux/macOS)
│   └── preflight.ps1          ← ¿qué me falta? (Windows)
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
    ├── prompts.md             7 prompts listos para pegar
    └── fuente-01.md           fuente base para el cuaderno
```

Cada ejercicio trae `platformio.ini`, `src/main.cpp`, `diagram.json`, `wokwi.toml` y su `README.md`.

> 🎓 **Impartes la capacitación:** empieza por [`GUIA-INSTRUCTOR.md`](GUIA-INSTRUCTOR.md).

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

## 🧠 Gemini Notebook (antes NotebookLM · material de refuerzo)

Todo el material para generar guías, quizzes y videos está en
[`notebooklm/`](notebooklm/COMO-USAR.md).

> **Nota:** desde julio 2026 NotebookLM se llama **Gemini Notebook** y vive en
> <https://notebook.google.com>. El nombre de los botones también cambió:
> ahora son *Cuestionarios*, *Tarjetas didácticas*, *Resumen de vídeo* y
> *Informe*, todos en el panel **Studio**.

Resumen rápido:

1. Crea un cuaderno en <https://notebook.google.com>.
2. Sube `notebooklm/fuente-01.md` (Markdown es formato admitido).
3. Usa los prompts de [`notebooklm/prompts.md`](notebooklm/prompts.md):
   en **Studio** pulsa el **lápiz** ✏️ y pégalos en *«Introduce una petición»*.

La cuenta gratuita da **3 videos y 3 audios al día** (los videos tardan
**más de 30 min**), así que reparte la generación en 2 días.

---

## ⚠️ Problemas frecuentes

| Síntoma | Causa | Solución |
|---|---|---|
| Windows/Linux pide **contraseña de administrador** | El paso era un instalador con elevación | **No la des.** Todo este repo es instalable por usuario; mira [`AGENTS.md`](AGENTS.md) |
| `pio: command not found` | VS Code recién instalado | Reinicia VS Code |
| El simulador no arranca | Abriste la raíz del repo | Abre la **carpeta del ejercicio** |
| Faltan `wokwi.toml` o `diagram.json` | No están junto a `platformio.ini` | No deben faltar; reclona |
| `No se pudo leer el DHT22` | Librería equivocada o cable | Usa `DHTesp.h` y `dht:SDA → esp:D4` |
| `no encontre PHP` | No está en el PATH | ZIP portable en tu carpeta, o **Plan B** |
| `Fallo la peticion: connection refused` | Backend apagado | Corre `iniciar.sh` antes de simular |
| `host.wokwi.internal` no resuelve | Gateway no disponible o wokwi.com | **Plan B** de `e03` |
| Extensión Wokwi pide licencia | Plan gratuito caducado | Activa en <https://wokwi.com/license> (30 días) o usa wokwi.com |
| Espacio en disco < 3 GB | El toolchain de ESP32 ocupa ~1.5 GB | Avisa antes de descargar; libera espacio |

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
