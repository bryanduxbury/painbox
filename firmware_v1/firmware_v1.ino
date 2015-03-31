void setup() {
  pinMode(10, OUTPUT);
  pinMode(5, OUTPUT);
  analogWrite(10, 255);
  analogWrite(5, 255);
}

void loop() {
  // analogWrite(10, 10);
  // setSinkMilliamps(10, 100);
//   setSinkMilliamps(5, 3000);
}

#define VREF 4970
void setSinkMilliamps(int pin, uint16_t ma) {
  int step_size = VREF / 254;
  analogWrite(pin, ma / 2 / step_size);
}