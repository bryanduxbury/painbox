w = 100;
d = 200;
h = 1.5;

isolate = 1;

fin_w = 5;

peltier_w = 40;
peltier_h = 5;
peltier_d = 40;

module peltier() {
  color("white")
  cube(size=[peltier_w, peltier_d, peltier_h], center=true);
}

module heatsink() {
  color("gray") {
    translate([0, 0, 2.5/2])
      cube(size=[40, 40, 2.5], center=true);

    translate([40/2 - 3/2, 0, 30/2]) cube(size=[3, 40, 30], center=true);

    for (x=[0:4]) {
      translate([-40/2 + 1.8/2 + x * (5.5 + 1.8), 0, 30/2]) cube(size=[1.8, 40, 30], center=true);
    }
  }
}

module radiator_traces_2d() {
  difference() {
    intersection() {
      // outline
      square(size=[w, d], center=true);

      union() {
        // left rail
        translate([-w/2 + fin_w/2, 0, 0])
          square(size=[fin_w, d], center=true);

        // right rail
        translate([w/2 - fin_w/2, 0, 0])
          square(size=[fin_w, d], center=true);

        // left peltier pad
        translate([-w/2 + (w/2 - isolate)/2, d/2 - (peltier_d + 12) / 2, 0]) 
          square(size=[w/2 - isolate / 2, peltier_d+12], center=true);

        // right peltier pad
        translate([w/2 - (w/2 - isolate)/2, d/2 - (peltier_d + 12) / 2, 0]) 
          square(size=[w/2 - isolate / 2, peltier_d+12], center=true);

        translate([0, d / 2 - peltier_d - 12 - isolate - fin_w / 2, 0]) {
          fin_len = w - fin_w - isolate;
          // left fins
          for (y=[0:12]) {
            translate([-w/2 + fin_len/2, -y * (2 * fin_w + 2 * isolate), 0]) 
              square(size=[fin_len, fin_w], center=true);
          }

          // right fins
          for (y=[0:11]) {
            translate([w/2 - fin_len/2, -(y + 0.5) * (2 * fin_w + 2 * isolate), 0])
              square(size=[fin_len, fin_w], center=true);
          }
        }
      }
    }

    for (x1=[-1,1]) {
      for (x2=[-1,1], y=[-1,1]) {
        x = x1 * (w / 2 - fin_w - peltier_w / 2) + x2 * (peltier_w / 2 - 5);
        y = d/2 - 6 - peltier_d/2 + y * (peltier_d / 2 + 3);
        translate([x, y, 0]) circle(r=3.2/2, $fn=36);
      }
    }
  }
}

module clamp_plate_2d() {
  union() {
    difference() {
      // square(size=[45, 50], center=true);
      hull() for (x=[-1,1], y=[-1,1]) {
        translate([x * (45/2 - 1), y * (50/2 - 1), 0]) circle(r=1, $fn=36);
      }

      square(size=[40, 40], center=true);

      for (x1=[-1,1]) {
        for (x2=[-1,1], y=[-1,1]) {
          x = x1 * 0 + x2 * (peltier_w / 2 - 5);
          y = y * (peltier_d / 2 + 3);
          translate([x, y, 0]) circle(r=3.2/2, $fn=36);
        }
      }
    }
    translate([-40/2 + 4.5, 0, 0]) square(size=[4, 40.1], center=true);

    translate([40/2 - 5.5, 0, 0]) square(size=[5, 40.1], center=true);
  }
}

module assembly() {
  for (x=[-1,1]) {
    translate([w / 2 + x * (5 + peltier_w / 2), d - peltier_d/2 - 6, peltier_h / 2]) {
      peltier();

      translate([0, 0, peltier_h/2]) !heatsink();

      color("blue")
      translate([0, 0, peltier_h/2 + 2]) linear_extrude(height=3) clamp_plate_2d();
    }
  }

  //difference() {
    translate([w/2, d/2, -1.60])
      color("green")
        square(size=[w + 0.1, d + 0.1], center=true);

    translate([w/2, d/2, 0])
      radiator_traces_2d();
  //}
}

assembly();