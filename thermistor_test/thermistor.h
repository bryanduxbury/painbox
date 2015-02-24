#ifndef __THERMISTOR_H__
#define __THERMISTOR_H__

#include "Arduino.h"

class Thermistor {
public:
  Thermistor(uint8_t analogPin, uint16_t refMv, uint16_t refOhms) {
    pin = analogPin;
    ref_mv = refMv;
    ref_ohms = refOhms;
  }

  float getDegK() {
    return r2t(v2r(analogRead(pin)));
  }

private:
  uint8_t pin;
  uint16_t ref_mv;
  uint16_t ref_ohms;

  float v2r(int sample) {
    float mvSample = (sample / 1023.0) * ref_mv;
    return ref_ohms * (float)ref_mv / (float)mvSample - ref_ohms;
  }

  // constants for the steinhart-hart extended function
  #define SH_A1 3.354016E-03
  #define SH_B1 2.569850E-04
  #define SH_C1 2.620131E-06
  #define SH_D1 6.383091E-08

  float r2t(int ohms) {
    float r = ohms/10000.0;
    return 1.0f / (
      SH_A1
      + SH_B1 * log(r)
      + SH_C1 * pow(log(r), 2)
      + SH_D1 * pow(log(r), 3));
  }
};

#endif