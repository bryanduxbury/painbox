#include "thermistor.h"
#define K2C(t) ((t) - 273.15)

Thermistor t1(0, 5000, 9970);
Thermistor t2(1, 5000, 9940);
Thermistor t3(2, 5000, 10000);

void setup() {
  Serial.begin(115200);
}

int m = 0;
int s = 0;
void loop() {
  char buf[7];
  buf[6] = '\0';
  sprintf(buf, "%03d:%02d", m, s);
  Serial.print(buf);
  Serial.print("\t");
  Serial.print(K2C(t1.getDegK()));
  Serial.print("\t");
  Serial.print(K2C(t2.getDegK()));
  Serial.print("\t");
  Serial.print(K2C(t3.getDegK()));
  Serial.println();

  s++;
  if (s == 60) {
    s = 0;
    m++;
  }
  delay(1000);
}
