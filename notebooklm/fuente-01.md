# Fuente 01 — BeeStation: cómo funciona el sistema

> Material base para el cuaderno de Gemini Notebook (antes NotebookLM). Escrito en tercera persona,
> con hechos y números, sin relleno. Cubre qué es, cómo fluye un dato, qué mide
> cada cosa y cuáles son las limitaciones actuales.

---

## 1. Qué es

BeeStation_Sena es un sistema de monitoreo apícola (de colmenas) que combina
hardware, software web y una base de datos. Un equipo electrónico instalado en
la colmena mide condiciones del interior, las envía por WiFi y un sitio web las
presenta en un dashboard con indicadores de bienestar de la colmena.

El objetivo práctico es sustituir la revisión manual y periódica de las colmenas
por lecturas continuas, de modo que el apicultor detecte problemas antes de que
se noten a simple vista.

Proyecto desarrollado en el Centro Minero Ambiental (CFMA) del SENA, en El
Bagre, Antioquia, dentro del programa Técnico en Programación de Software.

---

## 2. Los cuatro componentes

| Componente | Tecnología | Función |
|---|---|---|
| **1. Equipo de campo** | ESP32 + sensores | Mide y envía |
| **2. API** | PHP 8.2 | Recibe, valida y persiste |
| **3. Base de datos** | MariaDB / MySQL | Almacena las lecturas |
| **4. Dashboard** | PHP + JS | Calcula indicadores y los grafica |

Se pueden resumir en una frase: **el equipo mide, la API valida, la base de
datos guarda, el dashboard interpreta.**

---

## 3. Hardware

El microcontrolador es un **ESP32**, un chip con WiFi integrado y capacidad de
trabajar con muchos sensores a la vez. Conecta:

| Sensor | Qué mide | Unidad |
|---|---|---|
| BME280 | Temperatura y humedad del interior de la colmena | °C y % |
| HX711 con celda de carga | Peso de la colmena | kg |
| MAX4466 (micrófono) | Sonido de las abejas | nivel de voltaje |
| BH1750 | Luz ambiental | lux |
| INA219 | Estado de la batería | voltios |
| (Previsto) CO₂ | Dióxido de carbono en el interior | ppm |

Las abejas regulan la temperatura de la colmena con su propio cuerpo. Cuando
están sanas y cría en desarrollo, mantienen el interior cerca de 34–36 °C. Si
la lectura se sale de ese rango, puede indicar problemas de ventilación,
enfermedad o falta de abejas para mantener la temperatura.

El peso permite ver cuándo entra néctar (sube rápido) y cuándo se produce miel
o el enjambre se va (baja).

El sonido se usa porque una colmena que se prepara para enjambrar tiene un
patrón acústico distinto del de una colmena tranquila.

---

## 4. Flujo de un dato, paso a paso

1. **El sensor mide** una magnitud física (por ejemplo 34.5 °C).
2. **El ESP32 lo convierte** en un número y lo agrega a un paquete JSON junto
   con el identificador del sensor y el token de la colmena.
3. **Envía la petición HTTP** `POST` a la dirección `api/ingest.php` del
   servidor, incluyendo una API Key en los encabezados.
4. **La API valida**: que la API Key sea correcta (comparación en tiempo
   constante, resistente a ataques de temporización), que el token corresponda a
   una colmena activa, y que el sensor exista en la base de datos.
5. **Se aplica el factor de corrección** del sensor (calibración) y se guarda
   la lectura.
6. **Se recalculan los indicadores** de la colmena con los datos nuevos.
7. **El dashboard consulta** la base de datos y dibuja gráficas y estados.

Si en cualquiera de los pasos 3 a 5 algo falla, la API responde con un código
de estado HTTP de error y no se guarda nada. Los códigos usados son `200` y
`201` para éxito, `400` para datos inválidos y `401` para credenciales
incorrectas.

---

## 5. API y seguridad

El sistema expone **tres endpoints** (direcciones de la API):

- Uno para recibir lecturas del equipo (`ingest`).
- Uno para vincular una colmena nueva con un **token único**.
- Uno de consulta para el dashboard.

Protecciones implementadas:

- **API Key** obligatoria, verificada con comparación en tiempo constante.
- **Token de vinculación único por colmena**, con control de intentos y
  posibilidad de revocación.
- Sin contraseñas ni secretos escritos en el código fuente.

---

## 6. Base de datos

El esquema tiene **9 tablas** principales: colmena, dispositivo, sensor, lectura,
alerta, variable bioclimática, calibración, usuario y auditoría. La copia de
producción incluye una décima tabla de apoyo.

Tabla por tabla, en una frase:

- **colmena** — qué colmena es y quién la administra.
- **dispositivo** — qué equipo ESP32 está asignado a cada colmena.
- **sensor** — qué magnitudes admite el sistema y en qué unidad se guardan.
- **lectura** — el registro histórico: fecha, hora, valor, sensor.
- **alerta** — avisos generados automáticamente cuando algo se sale de rango.
- **variable_bioclimatica** — umbrales configurables por variable.
- **calibración** — factor de corrección de cada sensor.
- **usuario** — quién entra al dashboard.
- **auditoría** — quién hizo qué y cuándo.

Todas las fechas se registran en la zona horaria `America/Bogota`, tanto en PHP
como en MySQL, para que no haya desfases.

---

## 7. Los cuatro indicadores

A partir de las lecturas, el sistema calcula cuatro indicadores de salud:

**Índice de Bienestar Bioclimático (IBB)**
Combina temperatura, humedad y concentración de CO₂ en un solo número que
resume qué tan adecuado es el ambiente interior. Es el indicador central del
sistema. Cuando todos los parámetros están en rango, el valor es alto y se
etiqueta como «Bueno».

**Estrés de Calor (EV)**
Estima cuánta energía gasta la colmena en enfriarse. Valores altos significan
que las abejas están trabajando de más para mantener la temperatura, lo que
reduce la producción.

**Diferencia de temperatura (ΔT)**
Compara la temperatura de adentro con la de afuera. Una colmena bien poblada y
activa mantiene su interior más caliente que el exterior. Si la diferencia se
acerca a cero, la colmena puede estar vacía o debilitada.

**Peso de miel (H_miel)**
Estima la miel almacenada a partir de la variación de peso de la colmena.

Además se calcula el **flujo diario de peso**: cuánto subió o bajó la colmena
en las últimas 24 horas, que es lo que indica si está entrando néctar.

---

## 8. Umbrales de referencia

| Variable | Óptimo | Alerta | Crítico |
|---|---|---|---|
| Temperatura interior | 34–36 °C | 32–38 °C | 30–40 °C |
| Humedad relativa | 50–70 % | 45–80 % | 35–85 % |
| Sonido | 200–380 | 400–600 | 600–900 |
| CO₂ | 2000–4000 ppm | 1000–6000 ppm | 500–10000 ppm |
| Presión atmosférica | 1000–1025 hPa | 980–1040 hPa | 960–1060 hPa |
| Energía de la batería | 3.7–4.2 V | 3.0–4.2 V | 2.8–4.2 V |

Estos valores provienen de la literatura apícola: el rango de cría es de
34–36 °C; la humedad óptima reportada es de 50–60 % aunque en la práctica se
trabaja con 50–70 %; y la organización EFSA publicó en 2016 un índice de salud
de colmenas (HEALTHY-B) que es la referencia europea para este tipo de
seguimiento.

---

## 9. Limitaciones conocidas del código actual

Estas son diferencias reales entre lo que el firmware envía y lo que el backend
acepta. Son un buen caso de estudio para pensar en cómo se prueba un sistema
completo:

1. **El firmware no envía CO₂.** Como el IBB depende del CO₂, mientras no
   llegue ese dato el índice no se calcula y la diferencia de temperatura
   queda vacía.
2. **El backend rechaza dos de los datos que sí llegan** (presión y luz),
   porque esas magnitudes no tienen registro en la tabla de sensores. Se
   reciben y se descartan.
3. **El sensor acústico devuelve voltaje, no frecuencia.** El código de alerta
   de enjambrazón busca un rango de 400–600, que corresponde a hercios, así
   que esa alerta nunca se dispara con la lectura actual.
4. **Los umbrales de la tabla `variable_bioclimatica` no se usan para las
   decisiones.** El código y las vistas traen sus propios rangos en duro; la
   tabla solo se consulta para saber la unidad de medida.
5. **La tabla de calibración está vacía**, y en el firmware la escala de la
   báscula está fijada en 1.0, así que los pesos se reportan sin calibrar.

6. **Los pines del sensor de peso y el del micrófono están declarados de
   forma distinta en el manual técnico y en el firmware.** Es el tipo de detalle
   que solo aparece cuando alguien revisa las dos fuentes con atención.

---

## 10. Stack tecnológico resumido

| Capa | Herramientas |
|---|---|
| Firmware | C++ de Arduino, ESP32 core 3.3.12, bibliotecas Adafruit, BH1750, HX711 |
| Herramientas de desarrollo | Arduino IDE (producción), PlatformIO (simulación) |
| Backend | PHP 8.2, XAMPP, MariaDB 10.4 |
| Frontend | PHP + HTML + JavaScript + CSS |
| Control de versiones | GitHub |
| Simulación | Wokwi (circuito virtual), sin hardware físico |
| Material didáctico | Google Gemini Notebook (antes NotebookLM) |

---

## 11. Simulación: cómo se practica sin hardware

Para aprender a manejar el sistema sin tener una placa ESP32 se usan dos
herramientas:

**PlatformIO** compila el mismo código que se cargaría en el hardware real y
genera un archivo binario. Se ejecuta con `pio run`.

**Wokwi** es un simulador de circuitos. Recibe el binario y muestra un ESP32
virtual con los sensores conectados, permitiendo mover los valores a mano (por
ejemplo subir la temperatura de un sensor) y ver cómo reacciona el código.

La combinación permite recorrer el pipeline completo — sensor, firmware, red,
servidor y dashboard — en una sola sesión, con datos que viajan de verdad
aunque no exista el equipo físico.

---

## 12. Preguntas clave para comprender

1. ¿Por qué hace falta una base de datos si el dashboard podría solo mostrar
   lo último que llegó?
2. Si el backend rechaza la presión, ¿qué debería cambiar: el backend o el
   firmware?
3. ¿Qué pasaría con el IBB si corrigiéramos el envío de CO₂?
4. ¿Por qué se usa comparación en tiempo constante para la API Key en vez de
   una comparación normal?
5. ¿Qué indicador diría que una colmena está vacía y por qué?
