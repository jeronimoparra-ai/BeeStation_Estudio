# Prompts para NotebookLM

Pega el bloque completo en el **chat** del cuaderno (o en Studio, para las piezas
indicadas). Cambia solo lo que está entre `[corchetes]`.

---

## 01 · Guía interactiva → usa **Studio › Report**

```
Crea una guía de estudio interactiva para aprender el proyecto BeeStation.

AUDIENCIA: estudiantes de Técnico en Programación que NO saben Arduino ni PHP.
NIVEL: principiante absoluto, lenguaje llano, sin jerga innecesaria.
EXTENSIÓN: 3 a 4 páginas.

Debe contener, en este orden:
1. Qué es BeeStation y por qué existe (máximo 5 líneas).
2. El recorrido de un dato, paso a paso: sensor → ESP32 → WiFi → API → base de datos → dashboard. Un párrafo por paso.
3. Qué mide cada sensor y qué significa en una colmena real.
4. Los 4 indicadores que calcula el sistema (IBB, EV, diferencia de temperatura, peso de miel), con una frase cada uno.
5. Un glosario de 15 términos técnicos, cada uno en una sola línea y con un ejemplo cotidiano.
6. Los 5 errores más probables y cómo se arreglan.

Reglas:
- Nada de fórmulas completas; basta decir qué comparan.
- Usa viñetas cortas, ninguna de más de 3 líneas.
- Marca en negrita los 10 términos más importantes.
- Si algo de la fuente es una limitación del código actual, dilo con claridad en la sección 4.
```

---

## 02 · Quiz de salida → usa **Studio › Quizzes**

```
Genera un quiz de 15 preguntas para evaluar al final de una sesión de 2 horas 30 minutos.

AUDIENCIA: 4 estudiantes principiantes que hoy vieron por primera vez PlatformIO, Wokwi y una API.
FORMATO: opción múltiple (4 opciones), con la respuesta correcta y una explicación de UNA frase que cite el dato de la fuente.

Distribución:
- 4 preguntas sobre el recorrido de un dato (sensor → servidor → dashboard)
- 3 sobre qué mide cada sensor
- 3 sobre PlatformIO y Wokwi (compilar, simular, para qué sirve cada cosa)
- 3 sobre la API (qué es un POST, qué es JSON, qué es un código de estado)
- 2 preguntas de aplicación: "el sensor marca 36.5 °C, ¿qué pasa?"

Dificultad: 8 fáciles, 5 medianas, 2 difíciles.
Al final, incluye una tabla resumen de los temas donde suele fallar este grupo.
```

---

## 03 · Flashcards → usa **Studio › Flashcards**

```
Crea 25 tarjetas de repaso a partir de la fuente.

FORMATO: anverso = pregunta o término; reverso = respuesta de máximo 2 líneas.
AUDIENCIA: principiantes, así que nada de definiciones enciclopédicas.

Reparte así:
- 8 tarjetas de glosario técnico (JSON, API, endpoint, firmware, sensor, WiFi, base de datos, dashboard)
- 7 tarjetas sobre los sensores y qué miden
- 5 tarjetas sobre los pasos del pipeline de datos
- 5 tarjetas de troubleshooting: anverso = mensaje de error, reverso = causa y arreglo

Reglas:
- Cada reverso debe poder entenderse aislado, sin leer nada más.
- Usa números concretos de la fuente cuando existan.
```

---

## 04 · Video Overview → usa **Studio › Video Overview**

Genera uno por día (límite: 3 al día). Copia una variante:

### Variante A — presentación (para abrir la sesión)

```
Crea un video explicativo de 3 a 4 minutos titulado "¿Qué es BeeStation?".

OBJETIVO: que alguien que nunca ha visto el proyecto entienda en qué consiste y por qué importa.
PÚBLICO: 4 estudiantes de programación, principiantes.
TONO: cercano, directo, sin tecnicismos innecesarios.

Estructura:
1. El problema: cómo se vigila hoy una colmena.
2. Qué hace BeeStation en una frase.
3. Los 4 componentes del sistema y qué hace cada uno.
4. Un dato recorriendo todo el sistema, en 60 segundos.
5. Cierre: qué van a construir hoy en la práctica.

Incluye en pantalla los números concretos de la fuente (cantidad de sensores, tipos de indicador).
```

### Variante B — el pipeline (para el bloque 5)

```
Crea un video explicativo de 3 a 4 minutos titulado "De un sensor a una gráfica".

OBJETIVO: mostrar el viaje completo de un dato, paso por paso, sin saltos.
PÚBLICO: principiantes que ya vieron los ejercicios e01 y e02.

Estructura, UN paso por pantalla:
1. El sensor mide.
2. El ESP32 convierte a número.
3. Se arma un JSON.
4. Viaja por WiFi con una petición HTTP.
5. El servidor PHP lo valida.
6. Se guarda como archivo (o base de datos).
7. El dashboard lo grafica.

Termina con: "si cualquier paso falla, ¿dónde miras?". Responde esa pregunta.
```

### Variante C — troubleshooting (refuerzo)

```
Crea un video de 3 a 4 minutos titulado "Los 5 errores más comunes".

PÚBLICO: principiantes que ya intentaron los ejercicios.

Recorre los 5 problemas más probables de la fuente y del README:
qué se ve en pantalla, por qué pasa y cuál es el arreglo en una línea cada uno.
Muestra el mensaje de error literal en pantalla.
Tono tranquilo: el objetivo es que dejen de tener miedo a los errores.
```

---

## 05 · Mapa mental → usa **Studio › Mind Map**

```
Crea un mapa mental del sistema BeeStation con 3 niveles:

NIVEL 1 (raíces):  Hardware · Software · Datos · Aprendizaje

NIVEL 2:
- Hardware → ESP32 · sensores · alimentación
- Software → firmware · API PHP · base de datos · dashboard
- Datos → JSON · HTTP · indicadores · alertas
- Aprendizaje → PlatformIO · Wokwi · NotebookLM · ejercicios e01-e03

NIVEL 3: 2 a 4 hojas por rama, con términos concretos de la fuente.

Evita términos vagos como "configuración" o "ajustes".
```

---

## 06 · Informe ejecutivo (si piden resumen) → usa **Studio › Report**

```
Resume la fuente en un informe de UNA página para presentar el proyecto a un
instructor o jurado. Público: docente técnico. Tono formal pero claro.

Debe tener: propósito del sistema (3 líneas), arquitectura (tabla), indicadores
que calcula (lista), limitaciones actuales (lista honesta), y los próximos pasos
delimitados en 5 puntos.
```

---

## 07 · Pregunta libre (chat)

Útila cuando alguien se trabe:

```
Según la fuente, explícame [TEMA] como si tuviera 15 años y nunca hubiera
programado. Máximo 6 líneas, sin usar las palabras [PALABRAS QUE NO ENTIENDE],
y dame un ejemplo de la vida real.
```

---

## Truco: que el quiz ataque los huecos

Después del primer quiz, pega esto:

```
Con base en mis resultados, genera 10 preguntas nuevas SOLO sobre los temas
donde me equivoqué o tardé más. Mis aciertos y errores: [PEGA EL RESUMEN].
Mismo formato y misma dificultad.
```
