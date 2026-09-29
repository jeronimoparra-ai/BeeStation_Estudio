# 🎓 Guía del instructor · Capacitación BeeStation

> **Esta es la hoja de ruta de quien imparte.** El estudiante usa `README.md`;
> tú usas este. Está escrita para que alguien que nunca ha visto el proyecto
> pueda dirigir la sesión sin improvisar.

| | |
|---|---|
| **Tema** | De un sensor a una gráfica: PlatformIO + Wokwi + servidor |
| **Duración** | 2 h 30 min (150 min exactos) |
| **Formato** | Teoría mínima, práctica guiada, cierre con evaluación |
| **Grupo sugerido** | 12–20 personas · 1 equipo por cada 2 asistentes |
| **Nivel** | No requiere saber C++ ni electrónica |
| **Entregable** | Dashboard con la gráfica moviéndose en vivo |

---

## 0. El objetivo en una frase

> Que cada participante salga habiendo **compilado, simulado y conectado** un
> ESP32, y entendiendo qué hay en cada eslabón del pipeline:
> **sensor → microcontrolador → red → servidor → pantalla.**

No es una clase de C++. Si alguien no entiende un `if`, está bien. Si al final
no sabe **dónde está el archivo que hay que cambiar**, la sesión no sirvió.

---

## 1. Preparación — antes de la sesión

### 1.1 T-2 días · Prepara el material de refuerzo

Sigue [`notebooklm/COMO-USAR.md`](notebooklm/COMO-USAR.md). Genera **el día
anterior**, porque los resúmenes de vídeo tardan **más de 30 minutos**:

- [ ] Cuaderno creado en <https://notebook.google.com> con `fuente-01.md`
- [ ] **Informe** (prompt `01`) → enlace listo para compartir
- [ ] **Cuestionario de salida** (prompt `02`), 15 preguntas, dificultad *Intermedio*
- [ ] **Resumen de vídeo** variante A (prompt `04`) → para abrir la sesión
- [ ] (Opcional) tarjetas didácticas (prompt `03`) para el repaso posterior

> **Tienes 3 videos y 3 audios al día** en la cuenta gratuita. Rinde con dos.

### 1.2 T-1 día · Prueba la sala

- [ ] Proyector, puntero y bocina (el video tiene audio)
- [ ] WiFi del aula conectado **y probado** con un equipo
- [ ] Mira la guía entera al menos una vez

### 1.3 T-1 día · Prepara los equipos

Esto es lo que más tiempo ahorra. En **cada** equipo:

```bash
git clone https://github.com/jeronimoparra-ai/BeeStation_Estudio.git
cd BeeStation_Estudio
bash scripts/preflight.sh      # Windows: scripts\preflight.ps1
```

- [ ] **Ningún equipo debe tener filas `FALTA` críticas** (`pio`, extensiones)
- [ ] Si alguna máquina no tiene permisos de administrador, **no pasa nada**:
      todo el preflight está diseñado para instalarse sin contraseña.
      Lee [`AGENTS.md`](AGENTS.md) si te bloqueas.
- [ ] `cd ejercicios/e01-led && pio run` compila (esto baja el toolchain ~1.5 GB;
      **hazlo en una máquina de prueba** para que en la sesión sea instantáneo)

> ⚠️ **Prohibido pedirle a los asistentes que usen `sudo` o que escriban
> contraseñas.** Si una máquina pide administrador, marca `REQUIERE TI` y
> continúa con el resto. No pierdas la sesión en eso.

### 1.4 El día antes · Verifica tú mismo los 3 ejercicios

| Ejercicio | Qué debes ver |
|---|---|
| `e01-led` | El LED parpadea y el botón lo apaga |
| `e02-sensor` | Mover el slider del DHT22 cambia los °C en el monitor serie |
| `e03-datos` | La gráfica del dashboard se mueve sola |

**Si tú no lo ves, no lo propongas en clase.**

---

## 2. Sala y materiales

| Elemento | Detalle |
|---|---|
| Proyector | Necesario: el video de apertura y el dashboard se proyectan |
| WiFi | Debe dejar salir a internet (GitHub, Wokwi) |
| Copia offline | Opcional pero recomendada: USB con el repo + `.pio` ya descargado |
| Cinta / plumón | Para anotar en el tablero el pipeline: `sensor → ESP32 → WiFi → PHP → gráfica` |
| Códigos de estado | Escribe en el tablero: `201` = recibido · `400` = basura · `connection refused` = servidor apagado |

---

## 3. Guion minuto a minuto

---

### ▸ Bloque 1 · 0–20 min — Instalar y verificar

**Objetivo:** que todos tengan `pio` respondiendo y las extensiones puestas.

| Min | Qué haces |
|---:|---|
| 0–3 | **Apertura.** Proyecta el resumen de vídeo. Di la frase del objetivo (§0). Escribe el pipeline en el tablero. |
| 3–5 | **Regla de oro.** «Hoy no se usa administrador ni contraseña. Todo se instala en su carpeta de usuario. Si algo pide contraseña, me avisan y lo dejamos como pendiente.» |
| 5–12 | **Clonar + verificar.** Cada quien abre `README.md` → *Instalación*. Tú recorres el aula. |
| 12–17 | **Preflight.** Todos corren `bash scripts/preflight.sh`. |
| 17–20 | **Checkpoint 1.** Mano arriba: ¿quién tiene `pio --version` OK? |

**Lo que debe verse:**

```
 PlatformIO Core     OK       .../bin/pio · PlatformIO Core, version 6.x
 RESULTADO: todo listo...
```

> **Si alguien no tiene `pio`:** el motivo casi siempre es que reinició mal
> VS Code. Cierra **todas** las ventanas y vuelve a abrir. No reinstales nada.

🛑 **Puerta de control 1:** no avances si más de 1/4 del grupo no tiene `pio`.
Dedica 5 min extra ahora; más tarde no hay tiempo.

---

### ▸ Bloque 2 · 20–45 min — `e01`: Hola, LED

**Objetivo:** compilar, simular y tocar el código por primera vez.

| Min | Qué haces |
|---:|---|
| 20–24 | **Contexto.** «Un ESP32 es una computadora mini. Este es su "hola mundo": encender un LED.» Abre `ejercicios/e01-led`. |
| 24–30 | **Primera compilación.** `pio run`. Que observen que tarda y que aparece `SUCCESS`. |
| 30–36 | **Simulación.** `Ctrl+Shift+P` → *Wokwi: Start Simulator*. El LED parpadea. |
| 36–41 | **Primer cambio de código.** Cambian `1000` por `200` en el `delay()`, recompilan, observan el parpadeo más rápido. |
| 41–45 | **Checkpoint 2.** Pídeles que apaguen el LED con el botón. |

**Lo que debe verse:** el LED parpadeando una vez por segundo, y al pulsar el
botón se queda fijo apagado.

**Concepto que debes fijar:** *el código se compila en tu máquina y corre en el
microcontrolador.* Dos mundos distintos.

🛑 **Puerta de control 2:** al menos la mitad debe tener el LED parpadeando.
Si el simulador no arranca → §5.1.

---

**⏸ 45–50 min — Pausa.** Aprovecha para revisar quién quedó rezagado.

---

### ▸ Bloque 3 · 50–85 min — `e02`: Un sensor

**Objetivo:** que entiendan que el hardware da **datos crudos** y que el
código los traduce a algo legible.

| Min | Qué haces |
|---:|---|
| 50–56 | **Concepto.** «El DHT22 mide dos cosas y las manda como señales eléctricas. Nuestro código las convierte en °C y %HR.» Muestra `diagram.json` brevemente. |
| 56–62 | **Compilar + simular.** Igual que antes, en `e02-sensor`. |
| 62–70 | **El momento "ah".** Que muevan el **slider de temperatura** del DHT22 en Wokwi y vean cambiar el valor en el monitor serie. |
| 70–78 | **Segundo cambio de código.** Cambian la frecuencia de lectura o agregan una línea extra al `Serial.printf`. |
| 78–85 | **Checkpoint 3.** Levanta la mano quien NO logró ver un °C distinto al mover el slider. |

**Lo que debe verse** en el monitor serie:

```
Humedad: 62.1 %  Temperatura: 25.4 °C
```

**Concepto que debes fijar:** *sensor → código → dato legible.* Ahí es donde
aparecen los errores típicos de calibración y conversión.

🛑 **Puerta de control 3:** si alguien quedó sin ver el °C, resuélvelo **ahí
mismo**. En el bloque siguiente ya depende de este.

---

**⏸ 85–90 min — Pausa.**

---

### ▸ Bloque 4 · 90–140 min — `e03`: Enviar datos

**Objetivo:** completar el pipeline. **Es el bloque más largo y el más frágil.**
Si vas corto de tiempo, recorta el bloque 2, nunca este.

| Min | Qué haces |
|---:|---|
| 90–98 | **El mapa.** Dibuja en el tablero: `DHT22 → ESP32 → WiFi → POST → recibir.php → lecturas.json → dashboard.php`. Este es **todo** el sistema. |
| 98–105 | **Levantar el backend.** `cd backend && ./iniciar.sh` (o `iniciar.ps1`). Abrir <http://localhost:8080/dashboard.php>. |
| 105–110 | **Prueba sin Wokwi.** El `curl` del `README.md`. Ver `201 Created` en pantalla. Explica `201` vs `400`. |
| 110–125 | **Simular en vivo.** `e03-datos` compilado y corriendo. La gráfica empieza a moverse. |
| 125–135 | **Míralo funcionar 10 min.** Muevan el slider y vean **cómo la curva responde desde el sensor hasta la gráfica**. Es el momento de la sesión. |
| 135–140 | **Checkpoint 4.** Cada equipo muestra su dashboard en movimiento. |

**Lo que debe verse:** la gráfica ganando un punto cada pocos segundos.

**Concepto que debes fijar:** *nada de esto funciona si alguien en la cadena
falla.* Si la gráfica no se mueve, el problema está en **uno** de los cinco
eslabones — y solo hay que averiguar cuál.

🛑 **Puerta de control 5:** **esto es el entregable.** Si aún a las 135 min
nadie lo tiene, aplica el Plan B (§6.2) y dedica el bloque 5 a explicar en vez
de evaluar.

---

### ▸ Bloque 5 · 140–150 min — Cierre

**Objetivo:** evaluar y anclar.

| Min | Qué haces |
|---:|---|
| 140–144 | **Recapitulación.** Recorre el tablero: los 5 eslabones. Pregunta: «¿En cuál se rompería si se cae el WiFi?» |
| 144–149 | **Evaluación.** Abren el **cuestionario de salida** del cuaderno de Gemini Notebook en el celular. |
| 149–150 | **Cierre administrativo.** Regístralo en la lista de asistencia. Entrega el enlace del informe y de las tarjetas. |

**Si no hay tiempo para el quiz**, deja el informe y las tarjetas como tarea
de 10 minutos y aplica la rúbrica de §7.

---

## 4. Tablero de control — qué mirar en cada checkpoint

| # | Momento | Señal de éxito | Si falla |
|---|---|---|---|
| 1 | min 20 | `pio --version` responde en casi todas las máquinas | 5 min extra + atender rezagados a mano |
| 2 | min 45 | LED parpadea en ≥ 50 % de los equipos | Demorar 10 min; nunca seguir sin mitad |
| 3 | min 85 | Mover el slider cambia el °C | Resolver **ahí mismo**; el bloque 4 depende de esto |
| 4 | min 140 | Dashboard con gráfica moviéndose | Plan B (§6.2) |

**La regla de oro del instructor:** los checkpoints 1, 2 y 3 son **obligatorios
para avanzar**. El 4 es obligatorio para **aprobar**.

---

## 5. Errores esperados — ya aparecen en casi todas las sesiones

### 5.1 El simulador de Wokwi no arranca

- **Causa:** abrieron la **raíz** del repo en VS Code en vez de la carpeta del
  ejercicio (`wokwi.toml` no está junto a `platformio.ini`).
- **Corrige:** `Archivo → Abrir carpeta → ejercicios/e01-led`.
- **Si insiste:** usar el Plan alternativo de `wokwi.com` (README §Cómo arrancar).

### 5.2 `pio: command not found`

- **Causa:** VS Code recién instalado / extensión recién puesta.
- **Corrige:** cerrar **todas** las ventanas de VS Code y reabrirl.

### 5.3 `No se pudo leer el DHT22` / siempre `NaN`

- **Causa:** librería equivocada o pin mal conectado.
- **Corrige:** el proyecto ya usa **`DHTesp.h`**. El pin es `dht:SDA → esp:D4`.
  No dejes que "arreglen" el `#include`.

### 5.4 `no encontre PHP` / el backend no abre

- **Causa:** PHP no está en el `PATH`.
- **Corrige:** Windows → ruta de XAMPP
  (`C:\xampp\php\php.exe`); Linux → marcar **REQUIERE TI** y usar el **Plan B**.
  **Nunca instales XAMPP ni `sudo apt` frente al grupo.**

### 5.5 `Fallo la peticion: connection refused`

- **Causa:** el backend está apagado.
- **Corrige:** `./iniciar.sh` en otra pestaña, sin cerrar la simulación.

### 5.6 `host.wokwi.internal` no resuelve

- **Causa:** el gateway privado de Wokwi no está disponible, o se usa
  `wokwi.com` en el navegador.
- **Corrige:** **Plan B** de `e03` — copiar la línea `JSON -> {...}` del monitor
  serie dentro de `backend/datos/lecturas.json`. La gráfica se mueve igual.

### 5.7 La extensión Wokwi pide licencia

- **Corrige:** Plan alternativo de `wokwi.com` (README) o activar la licencia
  gratuita en <https://wokwi.com/license> (30 días; el repo es público con
  licencia MIT, aplica la opción de repositorios de código abierto).

### 5.8 Un equipo no tiene permisos de administrador

- **No es un error, es el caso previsto.** Consulta
  [`AGENTS.md`](AGENTS.md) y sigue instalando en el directorio del usuario.
  Si algo puntual sí exige contraseña → `REQUIERE TI`, continúa con lo demás.

---

## 6. Plan B cuando algo grande falla

### 6.1 Sin internet

- `e01` y `e02` funcionan **si el toolchain ya está descargado** en
  `~/.platformio` (por eso preparaste T-1 día).
- `e03` necesita red para GitHub/Wokwi; si no la hay, solo demuestra el backend
  con el `curl` y proyecta el dashboard de una máquina ya preparada.

### 6.2 El backend no funciona en ningún equipo

1. Proyecta `e03-datos` en tu máquina (la que sí tiene PHP).
2. Muestra el monitor serie con la línea `JSON -> {...}`.
3. Explica los 5 eslabones **apuntando al código**, no a la pantalla.
4. Evalúa con el quiz igualmente: el pipeline se entendió aunque no corra.

### 6.3 Vas corto de tiempo

| Recorte | Minutos recuperados |
|---|---|
| Bloque 2 corto a la mitad (sin segundo cambio de código) | +10 |
| Bloque 3 solo demostración, sin cambio de código | +8 |
| Pausas a 3 min | +4 |

**Nunca recortes** el checkpoint 1 ni los primeros 20 min del bloque 4.

---

## 7. Evaluación

| Instrumento | Cuándo | Criterio |
|---|---|---|
| **Checkpoints 1–4** (§4) | En vivo | Es lo que de verdad mide el logro |
| **Cuestionario de salida** (Gemini Notebook) | min 144 | ≥ 10 de 15 correctas |
| **Lista de cotejo por ejercicio** | Por bloque | 3/3 ejercicios completos = aprobado |
| **Tarjetas didácticas** | Después | Tarea, no se evalúa en sesión |

**Aprobado =** checkpoint 1 ✔ + checkpoint 4 ✔ + quiz ≥ 10/15.

---

## 8. Checklist del instructor

**Antes**

- [ ] Cuaderno de Gemini Notebook creado y material generado (T-2 días)
- [ ] Sala probada: proyector, WiFi, audio
- [ ] Repo clonado y `pio run` probado en equipo de prueba
- [ ] Preflight corriendo limpio en los equipos del aula
- [ ] `GUIA-INSTRUCTOR.md` leída entera al menos una vez

**Durante**

- [ ] No se pidió ninguna contraseña en toda la sesión
- [ ] Se escribió el pipeline en el tablero
- [ ] Checkpoints 1, 2 y 3 superados antes de avanzar
- [ ] Dashboard moviéndose al final del bloque 4

**Después**

- [ ] Registro de asistencia firmado
- [ ] Enlaces (informe, cuestionario, tarjetas) enviados al grupo
- [ ] Pendientes `REQUIERE TI` listados para el área de TI
- [ ] Notas sobre qué salió mal → para la próxima versión de este repo
