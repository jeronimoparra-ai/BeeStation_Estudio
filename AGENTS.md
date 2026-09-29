# AGENTS.md — Lee esto antes de tocar nada

> **GATILLO.** Si te llegaron *solo* el enlace del repositorio, el nombre
> `BeeStation_Estudio` o un mensaje tipo *"instálalo en mi PC"*, detente y lee
> este archivo completo antes de ejecutar, instalar o editar algo. Existe
> precisamente para que identifiques el contexto en el primer intercambio.

---

## 1. Contexto: qué equipo es este

Este proyecto se trabaja en los equipos del grupo **3412544 (Técnico en
Programación de Software, CFMA SENA El Bagre)**.

Las máquinas son **equipos institucionales SENA**. Características que ya se
han confirmado:

| Situación real | Lo que implica para ti |
|---|---|
| El usuario **no siempre** tiene permisos de administrador | No asumas acceso root/Administrador |
| Cuando lo tiene, **el sistema pide contraseña en una ventana emergente** | **Nunca la pidas.** Si un paso abre ese diálogo, ese paso está prohibido |
| Hay políticas de TI / antivirus que bloquean instaladores y modifican el `PATH` | Prefiere copias portables y rutas en el directorio del usuario |
| Los compañeros abren opencode **desde la carpeta del proyecto** | El `opencode.json` de la raíz aplica solo si arrancan dentro del repo |

**Tu objetivo: instalar y dejar funcionando TODO sin una sola petición de
contraseña.**

---

## 2. Reglas duras

### 2.1 Prohibido (no lo ejecutes, no lo sugieras, no lo pidas)

- `sudo`, `su`, `pkexec`, `doas`, `runas`, `Start-Process -Verb RunAs`
- Cualquier cosa que **pregunte o espere una contraseña**
- `apt`, `apt-get`, `apt-cache`, `dpkg`, `snap`, `flatpak`, `aptitude`
- `yum`, `dnf`, `rpm`, `pacman`, `zypper`, `apk`
- `brew`, `port`
- `winget`, `choco`, `scoop` cuando necesiten elevación
- Instaladores `.msi`, `.exe` con instalación para *todos los usuarios*, `.deb`, `.rpm`, `.AppImage` en rutas del sistema, el instalador de Arduino IDE, XAMPP con instalación global
- Escribir en `/usr`, `/opt`, `/etc`, `/var`, `/System`, `C:\Program Files`, `C:\Program Files (x86)`, `C:\Windows`
- Editar las variables de entorno **del sistema** o el `PATH` global
- `systemctl`, `service`, `update-rc.d`, `sc.exe`, `netsh`
- `passwd`, `visudo`, cambiar dueños o permisos de archivos de otro usuario
- Desactivar o configurar antivirus, firewall o políticas del equipo
- Reiniciar o apagar la máquina
- **Descargar e instalar un paquete "porque sí"**: primero comprueba si ya está

> **Si una acción no se puede hacer sin administrador, no es una tarea para ti:
> es un pendiente para el área de TI del SENA.** Escríbelo en el resumen final
> y continúa con el resto.

### 2.2 Permitido (espacio de usuario)

Todo lo que se instale o viva dentro del directorio del usuario:

- Linux: `~/.local`, `~/.platformio`, `~/.vscode/extensions`, `~/.config`,
  `~/.cache`, `~/.bin`, `~/tools`, `~/opt`, `~/miniconda3`
- Windows: `%USERPROFILE%` (`C:\Users\<usuario>`), `AppData\Local`,
  `AppData\Roaming`, `tools\`, `.platformio`, `.vscode\extensions`
- `git clone`, `curl`/`wget`, descomprimir `zip`/`tar.gz` en el home
- `python3 -m pip install --user …` o cualquier instalador que use el
  instalador propio de PlatformIO (escribe en `~/.platformio`)
- `code --install-extension …` (instala por usuario, **no** pide admin)
- Scripts propios del repo con `chmod +x` dentro del repo
- `chmod u+x` sobre archivos **del usuario**

---

## 3. Paso 0: preflight (obligatorio)

Antes de instalar nada, ejecuta la detección. Devuelve qué existe, qué falta y
si el equipo permite administración.

**Linux / macOS (Zorin, Ubuntu, etc.)**

```bash
bash scripts/preflight.sh
```

**Windows (PowerShell)**

```powershell
powershell -ExecutionPolicy Bypass -File scripts\preflight.ps1
```

El reporte te da:

- `ACCESO ADMIN` → casi siempre `NO` en estos equipos. **Actúa en consecuencia.**
- `HERRAMIENTA / ESTADO / RUTA` → instala **solo** las filas `FALTA`.
- `ESPACIO LIBRE` → si hay menos de ~3 GB, avisa antes de bajar el toolchain
  de ESP32 (ocupa ~1.5 GB en `~/.platformio`).

**Guarda ese reporte:** forma parte del resumen que entregas al final.

---

## 4. Qué instalar y cómo (sin administrador)

Orden de decisión, siempre igual:

1. **¿Ya está instalado y responde?** → no lo toques, no lo reinstales.
2. **¿Existe versión portable o de instalación por usuario?** → úsala y guárdala
   en el home.
3. **¿Requiere administrador y no hay alternativa sin admin?** → **no instales.**
   Márcalo `REQUIERE TI` y sigue con lo que sí se puede.

| Herramienta | Linux (sin admin) | Windows (sin admin) | Comprobación |
|---|---|---|---|
| Git | Suele venir. Si falta: binario/portable en `~/tools` | Edición **Portable** de Git for Windows (zip) en `%USERPROFILE%\tools\git` | `git --version` |
| Python 3 | Suele venir. Si falta: **Miniconda** con instalación en el home | Instalador de python.org con opción *Install for current user* | `python3 --version` / `py --version` |
| PlatformIO Core | `python3 -m pip install --user platformio` (si PEP 668 lo bloquea, usa el instalador oficial de PlatformIO: escribe en `~/.platformio`) | `py -m pip install --user platformio` o el instalador oficial de PlatformIO | `pio --version` |
| Plataforma ESP32 | `pio pkg install` → cae en `~/.platformio` | igual | `pio pkg list` |
| Bibliotecas del proyecto | `pio pkg install` en cada ejercicio | igual | `pio run` |
| Extensión PlatformIO (VS Code) | `code --install-extension platformio.platformio-ide` | idem | `code --list-extensions` |
| Extensión Wokwi (VS Code) | `code --install-extension wokwi.wokwi-vscode` | idem | `code --list-extensions` |
| VS Code en sí | Tarball oficial extraído a `~/.local/vscode`, sin tocar `apt` | ZIP oficial extraído a `%USERPROFILE%\tools\VSCode` | `code --version` |
| Arduino IDE | **No usar.** Requiere instalador con admin | igual | — |
| XAMPP | **No instalar** (admin) | **No instalar** (admin) | — |
| PHP (para `backend/`) | Ver §4.1 | ZIP **NTS no-thread-safe** de windows.php.net en `%USERPROFILE%\tools\php` | `php -v` |

### 4.1 PHP es el único punto sensible

El backend es PHP (`php -S 0.0.0.0:8080`). Si el equipo **no trae PHP**:

1. **Windows:** el ZIP portable basta; se descomprime y se agrega la carpeta al
   `PATH` **de usuario** (no al del sistema).
2. **Linux:** si no hay PHP y no se puede instalar sin admin, **no insistas**.
   - Marca el paso del backend como `REQUIERE TI` (p. ej. `sudo apt install php-cli`).
   - El ejercicio 03 sigue siendo evaluable con el **Plan B**: el firmware
     imprime el JSON por el monitor serie (ya está implementado en
     `ejercicios/e03-datos/src/main.cpp` y documentado en su `README.md`).
3. Nunca instales XAMPP para resolver esto.

---

## 5. Flujo completo cuando solo te dan el enlace

Si alguien te dice *"https://github.com/jeronimoparra-ai/BeeStation_Estudio
y necesito que lo dejes listo en mi PC"*, haz exactamente esto:

1. **Reconoce el contexto por el nombre del repo.** `BeeStation_Estudio` +
   este `AGENTS.md` = equipo SENA sin permisos de administrador. Ese es el
   indicador.
2. Clona dentro del home, nunca en `C:\` ni en `/`:
   `git clone https://github.com/jeronimoparra-ai/BeeStation_Estudio.git`
3. **Abre opencode desde esa carpeta** (para que carguen `opencode.json` y
   este archivo). Si opencode ya estaba abierto en otro sitio, reinícialo
   dentro del repo.
4. Ejecuta el preflight (§3) y **no toques nada marcado `OK`**.
5. Instala únicamente lo que está `FALTA`, siguiendo §4. Sin `sudo`.
6. Verifica compilando los tres ejercicios:
   ```bash
   cd ejercicios/e01-led && pio run
   cd ../e02-sensor && pio run
   cd ../e03-datos && pio run
   ```
7. Si hay PHP, levanta el backend y comprueba el dashboard:
   ```bash
   cd backend && bash iniciar.sh
   curl -X POST -H 'Content-Type: application/json' \
     -d '{"sensor":"temperatura","temperatura":25.4}' \
     http://localhost:8080/recibir.php
   ```
8. **Entrega un resumen** con tres bloques:
   - ✅ `INSTALADO` — qué había y qué se instaló (ruta concreta en el home)
   - ⏭️ `YA VENÍA` — para que no lo reinstalen en otras máquinas
   - 🛑 `REQUIERE TI` — lo que sí necesita administrador, con el comando
     exacto que debería correr el personal del SENA

---

## 6. Verificación final mínima

No des el trabajo por terminado si falta algo de esto:

- [ ] `preflight.sh` / `preflight.ps1` ejecutado y reporte guardado
- [ ] `pio --version` responde
- [ ] Los 3 ejercicios compilan con `pio run`
- [ ] Ni un `sudo`/`pkexec` ejecutado, ni una contraseña pedida
- [ ] Todo lo nuevo vive en el directorio del usuario
- [ ] Resumen con `INSTALADO` / `YA VENÍA` / `REQUIERE TI` entregado

---

## 7. Reglas de este repositorio (para cualquier edición)

- **No hagas `commit` ni `push` sin que te lo pidan de forma explícita.**
- Rama `main` = material del estudiante. Rama `soluciones` = respuestas.
  Nunca mezcles.
- El firmware usa **`DHTesp.h`** (`beegee-tokyo/DHT sensor library for ESPx`),
  no `DHT.h` de Adafruit.
- `WIFI_SSID` es `"Wokwi-GUEST"` y `URL_BACKEND` apunta a
  `http://host.wokwi.internal:8080` — no los "arregles" por parecer
  provisionales; son correctos para la simulación.
- Si cambias `platformio.ini` o los diagramas de Wokwi, recompila y revisa el
  `diagram.json` antes de dar por hecho el cambio.
