#include <Arduino.h>
#include "DHTesp.h"

const int PIN_DHT = 4;

DHTesp dht;

void setup() {
  Serial.begin(115200);
  dht.setup(PIN_DHT, DHTesp::DHT22);
  Serial.println("e02-sensor: listo. Mueve los sliders del DHT22 en el simulador.");
}

void loop() {
  TempAndHumidity lectura = dht.getTempAndHumidity();
  float temperatura = lectura.temperature;
  float humedad = lectura.humidity;

  if (isnan(temperatura) || isnan(humedad)) {
    Serial.println("No se pudo leer el DHT22.");
  } else {
    Serial.print("temperatura = ");
    Serial.print(temperatura, 1);
    Serial.print(" C | humedad = ");
    Serial.print(humedad, 1);
    Serial.println(" %");

    if (temperatura > 35.0) {
      Serial.println("  -> ALERTA: demasiado calor para la colmena.");
    }
  }

  delay(2000);
}
