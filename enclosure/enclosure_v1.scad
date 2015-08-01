use <../radiator_block/radiator_block_v1.scad>
use <waterblock.scad>

base_t = 5; // assuming 3/16" acrylic?

outer_w = 200;
outer_d = 200;
outer_h = 150;

radiator_clearance = 25;

module _e(h=base_t) {
  linear_extrude(height=h) child(0);
}

module base2d() {
  square(size=[outer_w, outer_d], center=true);
}

module back2d() {
  square(size=[outer_w, outer_h], center=true);
}

translate([0, radiator_block_d()/2, base_t + radiator_clearance + radiator_block_h()]) 
  main_block();

color("gray")
translate([0, outer_d / 2, 0])
  _e() base2d();
  
color("pink")
translate([0, outer_d, outer_h/2])
  rotate([90, 0, 0]) 
    _e() back2d();

waterblock();