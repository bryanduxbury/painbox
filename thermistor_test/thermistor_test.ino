#include "thermistor.h"

Thermistor t1(0, 5000, 10000);

void setup() {
  Serial.begin(115200);
}

void loop() {
  Serial.print(t1.getDegK());
  Serial.println(" degK");
  // int a = analogRead(0);
  // Serial.print(a);
  // Serial.print(" ");
  // Serial.print(vtor(5000, a, 10000));
  // Serial.print(" ");
  // Serial.print(rtot(vtor(5000, a, 10000)));
  // Serial.print(" degK ");
  // Serial.print(rtot(vtor(5000, a, 10000)) - 273.15);
  // Serial.print(" degC ");
  // Serial.println();

  delay(100);
}

// int vtor(int mvRef, int sample, int rRefOhms) {
//   int mvSample = (int)((sample / 1023.0) * mvRef);
//   return rRefOhms * (float)mvRef / (float)mvSample - rRefOhms;
// }
//
// #define SH_A1 3.354016E-03
// #define SH_B1 2.569850E-04
// #define SH_C1 2.620131E-06
// #define SH_D1 6.383091E-08
//
//
// float rtot(int ohms) {
//   float r = ohms/10000.0;
//   return 1.0f / (
//     SH_A1
//     + SH_B1 * log(r)
//     + SH_C1 * pow(log(r), 2)
//     + SH_D1 * pow(log(r), 3));
// }