tube_d = 0.250 * 25.4;

grid_w = 100;
num_turns = 10;

turn_r = 12 / 2;

screw_r = 3 / 2;

depth = num_turns * (turn_r * 2 + tube_d);
echo("depth: ", depth);

module mandrel_half2d() {
  difference() {
    circle(r=turn_r + tube_d/2, $fn=72);
    circle(r=screw_r, $fn=12);
  }
}

module mandrel_half() {
  render()
  difference() {
    linear_extrude(height=20, center=true) mandrel_half2d();

    translate([0, 0, 10]) 
    rotate_extrude(convexity=10) 
      translate([turn_r + tube_d/2, 0, 0]) 
        circle(r=tube_d/2, $fn=12);
  }
}

module mandrel_positions() {
  translate([0, turn_r + tube_d/2, 0]) 
  for (x=[-1, 1], y=[0:floor(num_turns/2)-1]) {
    dx = x * (grid_w / 2 + tube_d/2 + turn_r);
    dy = (y * 2 + (x==-1 ? 1 : 0)) * (turn_r * 2 + tube_d);
    translate([dx, dy, 0]) {
      children();
    }
  }
}

module base2d() {
  difference() {
    square(size=[grid_w + turn_r * 4 + tube_d * 2, depth], center=true);
    translate([0, depth/-2, 0]) 
    mandrel_positions() {
      circle(r=screw_r, $fn=36);
    }
  }
}

module assembled() {
  mandrel_positions() {
    translate([0, 0, 10]) 
      mandrel_half();
    color("pink")
    translate([0, 0, 30]) 
      rotate([180, 0, 0]) mandrel_half();
  }

  color("brown")
  translate([0, depth/2, -1.5]) 
  linear_extrude(height=3, center=true) base2d();
}

module tube() {
  rotate([0, 90, 0]) 
    cylinder(r=tube_d/2, h=grid_w + turn_r * 2 + tube_d, center=true, $fn=16);
}

module bend() {
  translate([0, turn_r + tube_d/2, 0]) {
    intersection() {
      translate([50, 0, 0]) 
        cube(size=[100, 100, 100], center=true);
      rotate_extrude(convexity=10)
        translate([turn_r + tube_d/2, 0, 0])
          circle(r=tube_d/2, $fn=12);
    }
  }
}

module tube_mockup(dir) {
  for (i=[0:num_turns]) {
    translate([0, (i) * (turn_r * 2 + tube_d), 0])
      tube();
    if (i != num_turns) {
      rotate([0, i % 2 == 1 ? 180 : 0, 0]) 
        translate([grid_w/2 + turn_r + tube_d/2, (i) * (turn_r * 2 + tube_d), 0])
          rotate([0, dir * 15, 0]) 
            bend();
    }
  }
}


assembled();

translate([0, 0, 20]) tube_mockup();

!union() {
  tube_mockup(1);
  translate([0, (turn_r + tube_d/2), 0])
    rotate([0, 0, 0]) tube_mockup(-1);
}
