tube_d = 1/4 * 25.4; // nom. measure.
// spacing = 3;
// spacing = (0.75 * 25.4 - tube_d);
spacing = 2 * 25.4 / 2 / 3;
echo("effective spacing: ", spacing);
num_tubes = 10;

d = tube_d * num_tubes + spacing * (num_tubes + 1);
echo("Overall bed depth:", d);

w = 100;
overlap = 10;

t = 3;

for (y=[0:num_tubes-1]) {
  translate([0, spacing + tube_d / 2 + y * (tube_d + spacing), 0])
    rotate([0, 90, 0])
      color("brown")
      cylinder(r=tube_d/2, h=w+2*overlap, center=true, $fn=36);
}

for (x=[-1,1]) {
  translate([x * (w/2 + t/2), d/2, 0]) 
    rotate([90, 0, 90]) linear_extrude(height=t, center=true) tube_carrier_side();

  color("green")
  translate([0, -t/2, 0]) 
    rotate([90, 0, 0]) linear_extrude(height=t, center=true) tube_carrier_frontback();

  color("green")
  translate([0, d + t/2, 0]) 
    rotate([90, 0, 0]) linear_extrude(height=t, center=true) tube_carrier_frontback();
}


color("tan")
translate([0, d/2, -tube_d/2 - 10 - t/2]) 
  linear_extrude(height=t, center=true) base();


module tube_carrier_side() {
  difference() {
    union() {
      square(size=[d, tube_d + 10 + 10], center=true);
      for (x=[-1,1]) {
        translate([x * d/2, 0, 0]) square(size=[t*2, 10], center=true);

        translate([x * (d / 3), - tube_d / 2 - 10, 0]) square(size=[10, t*2], center=true);
      }
    }

    for (dir=[-1,1], x=[0:num_tubes/2-1]) {
      translate([dir * (spacing/2 + tube_d/2 + x * (tube_d + spacing)), 0, 0])
        circle(r=tube_d/2+0.1, $fn=36);
    }
  }
}

module tube_carrier_frontback() {
  difference() {
    union() {
      square(size=[w + 2 * (t + t), tube_d + 10 + 10], center=true);
      for (x=[-1,1]) {
        translate([x * (w / 3), - tube_d / 2 - 10, 0]) square(size=[10, 2*t], center=true);
      }
    }

    for (x=[-1,1]) {
      translate([x * ((w + t) / 2), 0, 0]) {
        dogbone();
      }
    }
  }
}

module dogbone() {
  square(size=[t, 10], center=true);
  for (x=[-1,1], y=[-1,1]) {
    a = (1.7/2/sqrt(2));
    translate([x * (t/2 - a), y * (10/2 - a), 0]) circle(r=1.7/2, $fn=12);
  }
}

module base() {
  difference() {
    square(size=[w + 4 * t, d + 4 * t], center=true);
    for (x=[-1,1], y=[-1,1]) {
      translate([x * (w / 3), y * ((d + 2 * t) / 2 - t/2), 0])
        rotate([0, 0, 90]) dogbone();

      translate([x * (w / 2 + t/2), y * (d / 3), 0])
        dogbone();
    }
  }
}