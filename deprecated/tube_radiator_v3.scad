function alternate(i) = i % 2 == 0 ? 1 : -1;

module lateral_tube() {
  rotate([0, 90, 0]) 
  cylinder(r=1/4*25.4/2, h=150, center=true, $fn=36);
}

module elbow() {
  translate([0, 0, 1.5 * 25.4/2]) 
  rotate([90, 90, 0]) 
  intersection() {
    rotate_extrude(convexity=3) {
      translate([1.5 * 25.4 / 2, 0, 0]) circle(r=1/4*25.4/2, $fn=36);
    }

    x = 1.5 * 25.4 / 2 + 1/2 * 25/4;
    translate([x/2, x/2, 0]) 
      cube(size=[x, x, 25], center=true);
  }
}

module joiner() {
  color("tan")
  translate([0, 0, 1.5 * 25.4/2]) 
  rotate([90, 90, 0]) 
  intersection() {
    rotate_extrude(convexity=10) {
      translate([1.5 * 25.4 / 2, 0, 0]) circle(r=3/8*25.4/2, $fn=36);
    }

    x = 1.5 * 25.4 / 2 + 3/4 * 25/4;
    translate([0, x/2, 0]) 
      cube(size=[x*3, x, 25], center=true);
  }
}

tube_rotations = [0, 180, 0, 180];
tube_offsets = [1, 1, -1, -1];

for (y=[0:9]) {

  o = 9/16 * 25.4;
  h = 1.5 * 25.4;
  a = sqrt(h*h-o*o);
  theta = asin(o/h);

  translate([tube_offsets[y % 4] * a / 2, y * 9/16 * 25.4 / 2, 0]) {
    lateral_tube();
    translate([150/2, 0, 0]) rotate([tube_rotations[y % 4], 0, 0]) elbow();
    translate([-150/2, 0, 0]) rotate([tube_rotations[y % 4], 0, 180]) elbow();

    if (y % 4 == 0) {
      translate([150/2 + 0.75 * 25.4, 0, 0.75 * 25.4])
        rotate([0, -90, -theta]) joiner();
    }

    if (y % 4 == 2) {
      translate([-(150/2 + 0.75 * 25.4), 0, 0.75 * 25.4])
        rotate([0, -90, 180 + theta]) joiner();
    }

    if (y % 4 == 1) {
      translate([150/2 + 0.75 * 25.4, 0, -0.75 * 25.4])
        rotate([0, 90, 180-theta]) joiner();
    }

    if (y % 4 == 3) {
      translate([-(150/2 + 0.75 * 25.4), 0, -0.75 * 25.4])
        rotate([0, 90, theta]) joiner();
    }
  }
}

