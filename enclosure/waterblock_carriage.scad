use <waterblock.scad>

wb_w = 41.1;
wb_d = 41.75;
wb_h = 12.25;
wb_inlet_d = (41.5 - 11.5);
wb_inlet_r = 11.5/2;

margin = 8;

tec_h = 3.3;
tec_w = 40;
tec_d = 40;

t = 6;

mounting_screw_d = 3;
mounting_screw_head_d = 5.5; // TODO: measure
mounting_screw_head_t = 2.5; // TODO: measure

components_depth = wb_h + tec_h + 2;
carriage_depth = 3 + components_depth;
echo("carriage depth", carriage_depth);

clamp_drill_d = .0890 * 25.4;

// TODO: rounded corners on main shape
module base() {
  translate([0, 0, carriage_depth/2])
  difference() {
    cube(size=[wb_w + 2 * margin, wb_d + 2 * margin, carriage_depth], center=true);

    translate([0, 0, carriage_depth/2 - components_depth/2]) {
      cube(size=[wb_w + 0.1, wb_d + 0.1, components_depth+0.1], center=true);
      for (x=[-1,1]) {
        translate([x * wb_inlet_d / 2, -(wb_d + 2 * margin) / 2, 0])
          cube(size=[wb_inlet_r * 2 + 0.1, margin*2, components_depth+0.1], center=true);
      }
    }

    for (x=[-1,1], y=[-1,1]) {
      translate([x * (wb_w / 2 + margin / 2), y * (wb_d / 2 + margin / 2), 0]) {
        cylinder(r=mounting_screw_d/2, h=2*carriage_depth, center=true, $fn=12);

        translate([0, 0, carriage_depth/2 - mounting_screw_head_t/2])
          cylinder(r=mounting_screw_head_d/2, h=mounting_screw_head_t+0.1, center=true, $fn=16);
      }
    }

    for (x=[-1,1], y=[-1,1]) {
      translate([x * (wb_w + margin) / 2, y * 4, carriage_depth/2]) 
        cylinder(r=clamp_drill_d/2, h=10, center=true, $fn=36);
    }
  }
}

module clamp() {
  color("pink") 
  translate([0, 0, 6/2]) {
    translate([0, 14, 0]) 
      cube(size=[wb_w + margin*2, 4, 6], center=true);
    translate([0, -15.5, 0]) 
      cube(size=[wb_w + margin*2, 4, 6], center=true);

    for (x=[-1,1]) {
      translate([x * (wb_w + margin) / 2, 0, 0]) {
        difference() {
          cube(size=[margin, wb_d, 6], center=true);
          hull() {
            for (y=[-1,1]) {
              translate([0, y * 6, 0])
                cylinder(r=1.5, h=10, center=true, $fn=12);
            }
          }
        }
      }
    }
  }
}

module tec() {
  color("white")
    cube(size=[40, 40, tec_h], center=true);
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

!base();

translate([0, 0, carriage_depth]) 
  clamp();


translate([0, 0, t/2 + wb_h/2])
  waterblock();

translate([0, 0, t/2 + wb_h + tec_h/2])
  tec();

translate([0, 0, t/2 + wb_h + tec_h])
  rotate([0, 0, 90]) heatsink();