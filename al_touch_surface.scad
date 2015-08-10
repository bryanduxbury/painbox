case_t = 3; // (pretending) acrylic... measure!

bar_num = 14;
surface_w = 5.5 * 25.4;
heat_spreader_w = 2.5 * 25.4; // 2 1/2", measure when in hand
heat_spreader_t = 1/4 * 25.4;

bar_w = 3/8 * 25.4; // measure!
bar_t = 3/8 * 25.4; // measure!
bar_s = 1/8 * 25.4;
bar_screw_d = 3; // #4-40
bar_hole_depth = 6;
bar_spacing = bar_w + bar_s;

surface_d = bar_num * bar_w + (bar_num - 1) * bar_s;
echo("touch surface depth", surface_d);

bar_hole_spacing = 35;

tec_w = 40;
tec_d = 40;
tec_t = 2.5;

num_heatsink_fins = 6;
heatsink_spacer_t = 1/4 * 25.4;
heatsink_spacer_w = 1/4 * 25.4;
heatsink_fin_t = 0.069 * 25.4;
heatsink_fin_h = 2 * 25.4;

support_margin = 1/8 * 25.4;

surface_headroom = 75;

echo("heatsink width", heat_spreader_t + num_heatsink_fins * (heatsink_fin_t + heatsink_spacer_t));

module bar() {
  difference() {
    cube(size=[surface_w, bar_w, bar_t], center=true);

    // hold-down holes
    for (x1=[-1,1], x2=[-1,1]) {
      translate([x1 * (surface_w / 2 - heat_spreader_w / 2) + x2 * (bar_hole_spacing / 2), 0, -bar_t/2])
        cylinder(r=bar_screw_d/2, h=bar_hole_depth*2, center=true);
    }

    // temp probe holes
    translate([0, 0, -bar_t/2]) 
      cylinder(r=5/2, h=bar_t, center=true);
  }
}

module bar_stacker() {
  render()
  difference() {
    cube(size=[heat_spreader_w, bar_w, bar_t], center=true);
    for (x2=[-1,1]) {
      translate([x2 * (bar_hole_spacing / 2), 0, -bar_t/2])
        cylinder(r=bar_screw_d/2, h=bar_t*2, center=true, $fn=12);
    }
  }
}

module bar_array() {
  for (i=[0:(bar_num - 1)]) {
    translate([0, bar_spacing / 2 - bar_s / 2 + i * bar_spacing, 0]) {
      color(i % 2 == 1 ? "blue" : "red")
      bar();

      color("green")
      translate([(i % 2 == 1 ? 1 : -1) * (surface_w / 2 - heat_spreader_w / 2), 0, -bar_t])
        bar_stacker();
    }
  }
}

module active_heat_spreader() {
  difference() {
    cube(size=[heat_spreader_w, surface_d, heat_spreader_t], center=true);

    for (y=[0:bar_num-1], x=[-1,1]) {
      if (y % 2 == 0) {
        translate([x * (bar_hole_spacing/2), - surface_d / 2 + bar_spacing / 2 - bar_s/2 + y * (bar_spacing), 0]) 
          cylinder(r=bar_screw_d/2, h=heat_spreader_t*2, center=true, $fn=12);
      }
    }

    heatsink_w = num_heatsink_fins * heatsink_fin_t + (num_heatsink_fins - 1) * heatsink_spacer_t;
    margin_w = (heat_spreader_w - heatsink_w) / 2;
    for (x=[-1,1], y=[-1,1]) {
      translate([x * (heat_spreader_w / 2 - margin_w / 2), y * (surface_d / 2 - margin_w), 0])
        cylinder(r=bar_screw_d/2, h=heat_spreader_t*2, center=true, $fn=12);
    }
  }
}

module touch_surface() {
  bar_array();

  translate([0, 0, - bar_t - bar_t / 2 - heat_spreader_t/2]) {
    color("red")
    translate([-surface_w / 2 + heat_spreader_w/2, surface_d/2, 0])
      active_heat_spreader();

    color("blue")
    translate([surface_w / 2 - heat_spreader_w/2, surface_d/2, 0])
      active_heat_spreader();
  }
}

module heatsink_baseplate() {
  difference() {
    cube(size=[heat_spreader_w, surface_d, heat_spreader_t], center=true);

    heatsink_w = num_heatsink_fins * heatsink_fin_t + (num_heatsink_fins - 1) * heatsink_spacer_t;
    translate([-heatsink_w / 2 + heatsink_fin_t + heatsink_spacer_t / 2, 0, 0]) 
    for (x=[0:num_heatsink_fins-2], y=[-1,1]) {
      translate([x * (heatsink_fin_t + heatsink_spacer_t), y * (surface_d / 4), 0])
        cylinder(r=bar_screw_d / 2, h=heatsink_spacer_t*2, center=true, $fn=12);
    }

    margin_w = (heat_spreader_w - heatsink_w) / 2;
    for (x=[-1,1], y=[-1,1]) {
      translate([x * (heat_spreader_w / 2 - margin_w / 2), y * (surface_d / 2 - margin_w), 0])
        cylinder(r=bar_screw_d/2, h=heat_spreader_t*2, center=true, $fn=12);
    }
  }
}

module heatsink_fin() {
  translate([heatsink_fin_h/2, 0, 0])
  difference() {
    cube(size=[heatsink_fin_h, surface_d, heatsink_fin_t], center=true);
    translate([- heatsink_fin_h / 2 + heatsink_spacer_t / 2, 0, 0])
    for (y=[-1:1]) {
      translate([0, y * (surface_d / 2 - 10), 0])
        cylinder(r=bar_screw_d / 2, h=heatsink_spacer_t*2, center=true, $fn=12);
    }
  }
}

module heatsink_spacer() {
  difference() {
    cube(size=[heatsink_spacer_w, surface_d, heatsink_spacer_t], center=true);  
    for (y=[-1:1]) {
      translate([0, y * (surface_d / 2 - 10), 0])
        rotate([0, 90, 0]) 
        cylinder(r=bar_screw_d / 2, h=heatsink_spacer_t*2, center=true, $fn=12);
    }

    for (y=[-1,1]) {
      translate([0, y * (surface_d / 4), 0])
        cylinder(r=bar_screw_d / 2, h=heatsink_spacer_t*2, center=true, $fn=12);
    }
  }
}

module heatsink() {
  color("lavender")
  translate([0, 0, -heat_spreader_t / 2])
    heatsink_baseplate();

  heatsink_w = num_heatsink_fins * heatsink_fin_t + (num_heatsink_fins - 1) * heatsink_spacer_t;
  translate([-heatsink_w / 2 + heatsink_fin_t/2, 0, -heat_spreader_t]) 
  for (x=[0:num_heatsink_fins-1]) {
    color("orange")
    translate([x * (heatsink_fin_t + heatsink_spacer_t), 0, 0])
      rotate([0, 90, 0])
      heatsink_fin();
  }
  
  translate([-heatsink_w / 2 + heatsink_spacer_t, 0, -heat_spreader_t - heatsink_spacer_t/2]) 
  for (x=[0:num_heatsink_fins-2]) {
    color("pink")
    translate([x * (heatsink_fin_t + heatsink_spacer_t), 0, 0])
      heatsink_spacer();
  }
}

module tec() {
  color("white")
    cube(size=[40, 40, tec_t], center=true);
}

module surface_support() {
  color("white", 0.75)
  render()
  difference() {
    cube(size=[surface_w + support_margin * 2, surface_d + support_margin * 2, bar_t], center=true);

    // stackers and attachment holes
    translate([0, -surface_d/2, 0]) 
    for (i=[0:(bar_num - 1)]) {
      translate([0, bar_spacing / 2 - bar_s / 2 + i * bar_spacing, 0]) {
        // cutouts for bar stackers
        translate([(i % 2 == 1 ? 1 : -1) * (surface_w / 2 - heat_spreader_w / 2), 0, 0])
          cube(size=[heat_spreader_w + 0.1, bar_w + 0.1, bar_t*2], center=true);

        // through-holes for disconnected sides of bars
        translate([(i % 2 == 1 ? -1 : 1) * (surface_w / 2 - heat_spreader_w / 2), 0, 0]) {
          for (x=[-1,1]) {
            translate([x * bar_hole_spacing / 2, 0, 0]) cylinder(r=bar_screw_d/2, h=bar_t*2, center=true, $fn=12);
          }
        }
      }
    }

    // hole for temp probes
    hull()
    for (y=[-1,1]) {
      translate([0, y * bar_spacing / 2, 0]) cylinder(r=10/2, h=bar_t*2, center=true);
    }
  }
}

module tec_retainer() {
  difference() {
    cube(size=[surface_w, surface_d, tec_t - 0.1], center=true);

    // tec cutouts
    for (x=[-1,1], y=[-1:1]) {
      translate([x * (surface_w / 2 - heat_spreader_w / 2), y * ((surface_d - margin_w * 2) / 3), 0]) {
        cube(size=[tec_w + 0.5, tec_d + 0.5, tec_t*2], center=true);

        // space for wires
        for (y2=[-1,1]) {
          translate([-x * tec_w/2, y2 * (tec_d/2 - 1 / 16 * 25.4), 0])
            cube(size=[1.25 * 25.4, 1/8 * 25.4, tec_t*2], center=true);
        }
      }
    }

    // corner holes
    heatsink_w = num_heatsink_fins * heatsink_fin_t + (num_heatsink_fins - 1) * heatsink_spacer_t;
    margin_w = (heat_spreader_w - heatsink_w) / 2;
    for (x1=[-1,1], x2=[-1,1], y=[-1,1]) {
      a = x1 * (surface_w / 2 - heat_spreader_w / 2);
      b = x2 * (heat_spreader_w / 2 - margin_w / 2);
      translate([a + b, y * (surface_d / 2 - margin_w), 0])
        cylinder(r=bar_screw_d/2, h=tec_t*2, center=true, $fn=8);
    }
  }
}

module fan() {
  color("black", 0.5)
  cube(size=[5 * 25.4, 5 * 25.4, 25], center=true);
}


module inner_box_side() {
  
}

module inner_box_assembly() {
  
}


module assembly() {
  translate([0, 0, -bar_t / 2]) 
    touch_surface();

  translate([0, surface_d / 2, -bar_t * 2 - heat_spreader_t - tec_t/2])
  for (x=[-1,1]) {
    translate([x * (surface_w / 2 - heat_spreader_w / 2), 0, 0])
      tec();
  }

  translate([0, surface_d/2, - bar_t * 2 - heat_spreader_t - tec_t]) {
    for (x=[-1,1]) {
      translate([x * (-surface_w / 2 + heat_spreader_w / 2), 0, 0])
      rotate([0, 0, x == -1 ? 180 : 0])
      heatsink();
    }
  }

  translate([0, surface_d / 2, - bar_t - bar_t - heat_spreader_t - tec_t - heat_spreader_t - heatsink_fin_h - 25/2])
    fan();

  translate([0, surface_d / 2,  - bar_t / 2 - bar_t]) 
    surface_support();

  translate([0, surface_d/2, - bar_t * 2 - heat_spreader_t - tec_t / 2])
    tec_retainer();
}

assembly();