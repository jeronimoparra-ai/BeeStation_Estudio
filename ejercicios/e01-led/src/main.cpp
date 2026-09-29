#include <Arduino.h>

const int PIN_LED   = 2;
const int PIN_BOTON = 4;

void setup() {
  Serial.begin(115200);
  pinMode(PIN_LED, OUTPUT);
  pinMode(PIN_BOTON, INPUT_PULLUP);
  Serial.println("e01-hello-led: listo. Pulsa el boton para detener el parpadeo.");
}

void loop() {
  if (digitalRead(PIN_BOTON) == LOW) {
    digitalWrite(PIN_LED, LOW);
    Serial.println("Boton pulsado -> LED apagado");
    while (digitalRead(PIN_BOTON) == LOW) {
      delay(10);
    }
    delay(200);
    return;
  }

  digitalWrite(PIN_LED, HIGH);
  delay(500);
  digitalWrite(PIN_LED, LOW);
  delay(500);
}
