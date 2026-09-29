# Cómo usar Gemini Notebook (antes NotebookLM)

> **Importante:** desde el **16 de julio de 2026** NotebookLM se llama
> **Gemini Notebook**. La dirección antigua redirige sola, pero el nombre del
> producto y de los botones cambió. Todo lo de este archivo está verificado
> contra la ayuda oficial de Google (septiembre 2026).

---

## 1. Crear el cuaderno (5 min)

1. Abre **<https://notebook.google.com/>** e inicia sesión con tu cuenta Google.
2. **Nuevo cuaderno** → nómbralo `BeeStation · Estudio`.
3. A la izquierda, selecciona **Añadir fuentes**.
4. Sube [`fuente-01.md`](fuente-01.md).

**Markdown (`.md`) es un formato admitido**, junto con PDF, DOCX, TXT, CSV y
PPTX. No hace falta convertir nada.

Fuentes adicionales opcionales (arrastra también):

| Archivo | Para qué sirve |
|---|---|
| `../README.md` | Preguntas sobre la agenda y los ejercicios |
| `../ejercicios/e02-sensor/README.md` | Preguntas sobre el DHT22 y sus errores |
| `../ejercicios/e03-datos/README.md` | Preguntas sobre el POST, el gateway y el Plan B |
| `../backend/README.md` | Preguntas sobre los códigos de estado |

**Límites de la versión gratuita:** 50 fuentes por cuaderno, 500 000 palabras
por fuente. Vas a usar 5 de 50.

---

## 2. Cuánto puedes generar al día (cuenta gratuita)

| Elemento | Al día |
|---|---|
| Chats (preguntas con citas) | 50 |
| **Resumen de audio** (tipo podcast) | **3** |
| **Resumen de vídeo** | **3** |
| Cuestionarios | 10 |
| Tarjetas didácticas | 10 |
| Mapas mentales | 10 |
| Informes | 10 |
| Infografías / presentaciones | 10 |

Los contadores se reinician en rodillo cada 24 h (no a medianoche).

⚠️ **Los resúmenes de vídeo pueden tardar más de 30 minutos** en generarse.
Se hacen en segundo plano: puedes seguir trabajando o cerrar el cuaderno.

### Oportunidad: año gratis de Google AI Plus

Google ofrece **1 año gratis de Google AI Plus** (plan de 4,99 USD) a
estudiantes en más de 140 mercados fuera de EE. UU., incluido Colombia,
canjeable **hasta el 31 de diciembre de 2026**. **Duplica todos los límites**
(6 audios y 6 vídeos al día, 20 cuestionarios, 100 fuentes por cuaderno).

Requiere verificación de estudiante. Vale la pena intentarlo antes de la sesión:
menos límites y vídeo rápido.

---

## 3. Cómo se usan los prompts

Los prompts están en [`prompts.md`](prompts.md). El flujo real es:

1. Copia el bloque completo del prompt.
2. En el panel **Studio** (columna derecha), busca la pieza:
   `Informe`, `Cuestionarios`, `Tarjetas didácticas`, `Resumen de vídeo`,
   `Mapa mental`.
3. Pulsa el **icono del lápiz** ✏️ → se abre el panel de personalización.
4. En **«Introduce una petición»**, pega el prompt.
5. Si te lo pregunta: **dificultad** = *Intermedio*; para vídeo elige
   **Formato** = *Explicación* e **Idioma** = *Español (Latinoamérica)*.
6. Pulsa **Generar**.

Así de simple: el botón genera con valores por defecto, el lápiz es donde manda
tu instrucción.

---

## 4. Calendario recomendado (2 días)

**Día 1** — piezas que salen rápido

| # | Pieza | Prompt |
|---|---|---|
| 1 | Informe (guía interactiva) | `01` |
| 2 | Cuestionario de 15 preguntas | `02` |
| 3 | Resumen de vídeo «¿Qué es BeeStation?» | `04` variante A |

**Día 2** — piezas de refuerzo

| # | Pieza | Prompt |
|---|---|---|
| 4 | Tarjetas didácticas | `03` |
| 5 | Mapa mental del pipeline | `05` |
| 6 | Resumen de vídeo «De un sensor a una gráfica» | `04` variante B |

Te sobran cupos. Para un tercer vídeo usa la variante C (`04`).
**Arranca los vídeos primero**: tardan más de 30 minutos.

---

## 5. Cómo usar cada pieza con el grupo

| Pieza | Cuándo | Cómo |
|---|---|---|
| **Informe** | Antes de la sesión | Compartir enlace; lectura de 20 min |
| **Cuestionario** | Cierre, min 140 | Que lo hagan en el celular; comparar puntajes |
| **Tarjetas didácticas** | Después, en casa | Repaso de 10 min/día; marcar «No la entiendo» |
| **Resumen de vídeo** | Apertura o quien faltó | Proyectarlo en el aula |
| **Mapa mental** | Bloque 5 | Imprimirlo como hoja de apoyo |

**Para compartir:** en el reproductor del vídeo, **Compartir** → asegúrate de
que el cuaderno esté compartido con *Cualquier usuario con el enlace* → copia
el enlace. O bien **Descargar** el vídeo y pasarlo por USB.

> Solo se puede hacer público el cuaderno desde una **cuenta personal**. En
> cuentas de Workspace/Education esa opción está desactivada.

---

## 6. Consejos de calidad

- **El prompt importa más que la fuente.** Los de `prompts.md` ya traen
  audiencia, nivel y formato; cambia solo lo que está entre `[corchetes]`.
- **Vídeo: elige formato *Explicación*** para piezas de 3–4 min, o *Corto*
  (60 segundos) si necesitas algo rápido para redes o para el cierre.
- **Estilos visuales** disponibles: Clásico, Pizarra, Acuarela, Dibujo retro,
  Legado, Papiroflexia, Kawaii, Anime. *Cinematográfico* solo en inglés y +18.
- **Regenera lo que no guste.** En el cuestionario puedes pedir otro set
  centrado en los temas donde el grupo se equivoque.
- Las respuestas **citan la fuente**: si un dato suena raro, haz clic en la
  cita y compruébalo.

---

## 7. Problemas frecuentes

| Problema | Solución |
|---|---|
| No encuentro «Flashcards» / «Quizzes» | Se llaman **Tarjetas didácticas** y **Cuestionarios** |
| El prompt no hace nada | Lo pegaste en el botón; usa el **lápiz** → *Introduce una petición* |
| El vídeo no aparece | Puede tardar >30 min; se genera en segundo plano |
| «Añadir fuentes» no me deja el `.md` | Usa la web `notebook.google.com` (en móvil la app es más limitada) |
| Me pide verificación de edad | Los vídeos y Deep Research son +18 |
| Se acabaron los cupos | Espera 24 h, reparte entre cuentas o canjea Google AI Plus |
| La cuenta es de empresa/SENA | El administrador debe habilitar Gemini Notebook en el Workspace |

---

## 8. Checklist antes de la sesión

- [ ] Cuaderno creado en `notebook.google.com`
- [ ] `fuente-01.md` subida y visible en el panel de fuentes
- [ ] Informe generado (prompt 01) y enlace guardado
- [ ] Cuestionario de salida generado (prompt 02)
- [ ] Al menos 1 resumen de vídeo listo para proyectar
- [ ] Enlaces compartidos con el grupo
- [ ] (Opcional) Año gratis de Google AI Plus canjeado
