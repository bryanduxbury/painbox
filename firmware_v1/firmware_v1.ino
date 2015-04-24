#include "PID_v1.h"
#include "thermistor.h"

#define HOT_OUT 5
#define COLD_OUT 10
#define HOT_IN 0
#define COLD_IN 1
#define AMBIENT_IN 2

// (5v / 254 steps) = 19.6 mV / step
// 5:1 voltage divider = 3.9 mV / step
// I=V/R, R=0.1, I=10V
// 39mA / step
#define MA_PER_STEP 39

double hot_target, hot_current, hot_milliamps;
double cold_target, cold_current, cold_milliamps;

PID hot_pid(&hot_current, &hot_milliamps, &hot_target, 2, 5, 1, DIRECT);
// note the cold PID is in reverse, since it is a chiller
PID cold_pid(&cold_current, &cold_milliamps, &cold_target, 2, 5, 1, REVERSE);

Thermistor hot_therm(HOT_IN, 5000, 9970);
Thermistor cold_therm(COLD_IN, 5000, 9940);
Thermistor ambient_therm(AMBIENT_IN, 5000, 10000);

void setup() {
  // for debugging output
  Serial.begin(115200);

  pinMode(HOT_OUT, OUTPUT);
  pinMode(COLD_OUT, OUTPUT);

  // start with heater/chiller off
  analogWrite(0, 255);
  analogWrite(0, 255);

  hot_target = 41.0;
  hot_milliamps = 0.0;
  cold_target = 18.0;
  cold_milliamps = 0.0;

  // 3A range on hot output
  hot_pid.SetOutputLimits(0, 3000);
  hot_pid.SetMode(AUTOMATIC);

  // 6A range on cold output
  cold_pid.SetOutputLimits(0, 6000);
  cold_pid.SetMode(AUTOMATIC);
}

void loop() {
  updateTemps();

  // update PID computations
  hot_pid.Compute();
  cold_pid.Compute();

  // reset output current control
  setSinkMilliamps(HOT_OUT, hot_milliamps);
  setSinkMilliamps(COLD_OUT, cold_milliamps);

  // print debugging info
  Serial.print(ambient_therm.getDegC());
  Serial.print("\t");
  Serial.print(hot_target);
  Serial.print("\t");
  Serial.print(hot_current);
  Serial.print("\t");
  Serial.print(hot_milliamps);
  Serial.print("\t");
  Serial.print(cold_target);
  Serial.print("\t");
  Serial.print(cold_current);
  Serial.print("\t");
  Serial.print(cold_milliamps);
  Serial.println();

  // no more than 100Hz updates
  delay(250);
}


void updateTemps() {
  hot_current = hot_therm.getDegC();
  cold_current = cold_therm.getDegC();
}

void setSinkMilliamps(int pin, uint16_t ma) {
  // Serial.print("Setting pin ");
  // Serial.print(pin);
  // Serial.print(" to step ");
  // Serial.println(ma / MA_PER_STEP);
  analogWrite(pin, ma / MA_PER_STEP);
}