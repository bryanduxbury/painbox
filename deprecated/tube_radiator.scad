tube_d = 1/4 * 25.4; // nom. measure.
spacing = 3;
zigs = 20;

w = 100;

for (y=[0:zigs-1]) {
  translate([0, y * (tube_d + spacing), 0])
    rotate([0, 90, 0])
      cylinder(r=tube_d/2, h=w, center=true, $fn=36);
}

module loop() {
  x = (tube_d * 2 + spacing * 2);
  intersection() {
    translate([x/2, 0, 0]) 
      cube(size=[x, x+tube_d, tube_d], center=true);

    rotate_extrude(convexity = 10) {
      translate([x/2, 0, 0]) circle(r=tube_d/2, $fn=36);
    }
  }

  for (y=[-1,1]) {
    translate([0, x/2 * y, 0]) sphere(r=tube_d/2, $fn=36);
  }
}

for (i=[0:(zigs-1) / 4]) {
  translate([w/2, tube_d + spacing + (tube_d + spacing) * i * 4, 0]) rotate([0, -45, 0]) loop();
}

for (i=[0:(zigs-1) / 4 - 1]) {
  translate([-w/2, 3 * (tube_d + spacing) + (tube_d + spacing) * i * 4, 0]) 
    rotate([0, 180 + 45, 0]) loop();
}

for (i=[0:(zigs-1) / 4 - 1]) {
  translate([w/2, 4 * (tube_d + spacing) + (tube_d + spacing) * i * 4, 0]) 
    rotate([0, 45, 0]) loop();
}

for (i=[0:(zigs-1) / 4]) {
  translate([-w/2, 2 * (tube_d + spacing) + (tube_d + spacing) * i * 4, 0])
    rotate([0, 180 - 45, 0]) loop();
}

