#include <Arduino.h>
#include <WiFi.h>
#include <HTTPClient.h>
#include "DHTesp.h"

const int PIN_DHT = 4;
DHTesp dht;

// ---------- CONFIGURA AQUÍ ----------
const char* WIFI_SSID     = "Wokwi-GUEST";
const char* WIFI_PASSWORD = "";
const int   WIFI_CHANNEL  = 6;

// Con el gateway de Wokwi para VS Code, esta URL llega a TU equipo.
const char* URL_BACKEND = "http://host.wokwi.internal:8080/recibir.php";
// -------------------------------------

bool wifiListo = false;

void conectarWiFi() {
  Serial.printf("Conectando a %s", WIFI_SSID);
  WiFi.mode(WIFI_STA);
  WiFi.begin(WIFI_SSID, WIFI_PASSWORD, WIFI_CHANNEL);

  for (int i = 0; i < 60 && WiFi.status() != WL_CONNECTED; i++) {
    delay(250);
    Serial.print(".");
  }
  Serial.println();

  wifiListo = (WiFi.status() == WL_CONNECTED);
  if (wifiListo) {
    Serial.print("WiFi OK. IP = ");
    Serial.println(WiFi.localIP());
  } else {
    Serial.println("SIN WiFi: el backend no recibira nada.");
    Serial.println("  -> Los datos saldran igual por el monitor serie (plan B).");
  }
}

void setup() {
  Serial.begin(115200);
  dht.setup(PIN_DHT, DHTesp::DHT22);
  Serial.println("e03-datos: arrancando...");
  conectarWiFi();
}

void loop() {
  TempAndHumidity lectura = dht.getTempAndHumidity();
  float temperatura = lectura.temperature;
  float humedad = lectura.humidity;

  if (isnan(temperatura) || isnan(humedad)) {
    Serial.println("No se pudo leer el DHT22.");
    delay(2000);
    return;
  }

  // JSON armado a mano: ves exactamente lo que viaja por la red.
  String cuerpo = String("{\"sensor\":\"dht22\",")
                + "\"temperatura\":" + String(temperatura, 1) + ","
                + "\"humedad\":" + String(humedad, 1) + "}";

  // SIEMPRE lo imprimimos: es el plan B si el gateway no conecta.
  Serial.print("JSON -> ");
  Serial.println(cuerpo);

  if (wifiListo && WiFi.status() == WL_CONNECTED) {
    HTTPClient http;
    http.begin(URL_BACKEND);
    http.addHeader("Content-Type", "application/json");
    int codigo = http.POST(cuerpo);

    if (codigo > 0) {
      Serial.printf("HTTP %d  %s\n", codigo, http.getString().c_str());
    } else {
      Serial.printf("Fallo la peticion: %s\n", http.errorToString(codigo).c_str());
      Serial.println("  -> Plan B: copia la linea JSON en backend/datos/lecturas.json");
    }
    http.end();
  }

  delay(3000);
}
