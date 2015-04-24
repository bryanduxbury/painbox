fin_w = 0.375 * 25.4;
fin_l = 100;
fin_d = 5;
fin_shoulder = 0.75;
fin_skin_t = 0.025 * 25.4; // thin Al sheet

fin_sep = 3;

num_fins = 12;

block_t = 12;

block_border = 12;
block_w = fin_l + block_border * 2;
block_d = (fin_w + fin_sep) * num_fins + 2 * block_border;

mounting_screw_r = 5.5/2; // M5 screw + clearance
mounting_screw_head_r = 9.5/2; // measured + clearance

barb_hole_d = 0.5 * 25.4;

echo("Final block dimensions:", block_w, block_d);


module _rounded_slot(l,r) {
  hull() {
    for (x=[-1,1]) {
      translate([x * (l/2 - r), 0, 0]) circle(r=r);
    }
  }
}

module _top_groove_negative() {
  $fn=36;
  render() {
    translate([0, 0,  - fin_d/2])
      linear_extrude(height=fin_d+0.1, center=true)
        _rounded_slot(fin_l, fin_w/2);
    translate([0, 0, - fin_skin_t/2])
      linear_extrude(height=fin_skin_t+0.1, center=true)
        !_rounded_slot(fin_l + fin_shoulder*2, fin_w/2+fin_shoulder);
  }
}

module _bottom_bridge() {
  $fn=36;
  length = fin_w * 3 + fin_sep * 2;
  rotate([0, 0, 90])
    render() {
      translate([0, 0, fin_d/2]) 
      linear_extrude(height=fin_d+0.01, center=true)
        _rounded_slot(length, fin_w/2);
      translate([0, 0, fin_skin_t/2]) 
      linear_extrude(height=fin_skin_t+0.1, center=true)
        _rounded_slot(length + fin_shoulder * 2, fin_w/2 + fin_shoulder);
    }
}

module main_block() {
  difference() {
    dy = fin_w + fin_sep;

    union() {
      cube(size=[block_w, block_d, block_t], center=true);

      // // flip alignment holes
      // for (x=[-1,1]) {
      //   translate([x * (block_w / 2 + 15), 0, 0]) cylinder(r=6.25/2, h=block_t, center=true);
      // }
    }

    // mounting screw holes
    ox = block_w / 2 - block_border / 2;
    oy = block_d / 2 - block_border / 2;
    for (x=[-1:1], y=[-1:1]) {
      // avoid drilling center
      if (!(x == 0 && y == 0)) {
        translate([ox * x, oy * y, 0]) {
          // bore
          cylinder(r=mounting_screw_r, h=block_t*2, center=true, $fn=36);
          // counterbore
          translate([0, 0, block_t/2])
            cylinder(r=mounting_screw_head_r, h=block_t, center=true, $fn=36);
        }
      }
    }

    // water channels
    translate([0, -num_fins / 2 * dy - fin_sep/2, 0]) 
    for (n=[0:num_fins-1]) {
      y = fin_sep + fin_w/2 + (fin_w + fin_sep) * n;
      translate([0, y, 0]) {
        // top groove
        translate([0, 0, block_t/2])
          _top_groove_negative();

        // top-to-bottom holes
        for (x=[-1,1]) {
          base_x = fin_l/2 - fin_w/2;
          stagger = x == 1 ? 0 : 1;
          translate([x * (base_x - (n % 2 == stagger ? 0 : dy)), 0, 0])
            cylinder(r=fin_w/2-0.1, h=25, center=true, $fn=36);
        }
      }

      // bottom bridges
      translate([0, 0, -block_t/2])
      if (n + 2 < num_fins) {
        p_off = (n % 4 == 0 || n % 4 == 3 ? 1 : -1) * (fin_l / 2 - fin_w / 2 - dy / 2);
        s_off = (n % 4 == 0 || n % 4 == 2 ? 1 : -1) * (fin_w / 2 + fin_sep / 2);

        translate([p_off + s_off, fin_sep + fin_w/2 + (n + 1) * (fin_w + fin_sep), 0]) {
          _bottom_bridge();
        }
      }
    }
  }
}

module barb_extension() {
  difference() {
    cube(size=[barb_hole_d * 2, barb_hole_d * 2, block_t], center=true);
    cylinder(r=barb_hole_d/2, h=block_t*2, center=true);
  }
}

// projection(cut=true) {
//   translate([0, 0, (block_t / 2 - 0.1)])
  main_block();
// }

// translate([0, 0, -block_t])
// for (pos=[1,2,num_fins-2,num_fins-1]) {
//   translate([0, -num_fins / 2 * dy - fin_sep/2, 0]) {
//     y = fin_sep + fin_w/2 + (fin_w + fin_sep) * pos;
//     translate([0, y, 0]) {
//       // top-to-bottom holes
//       for (x=[-1,1]) {
//         base_x = fin_l/2 - fin_w/2;
//         stagger = x == 1 ? 0 : 1;
//         translate([x * (base_x - (n % 2 == stagger ? 0 : dy)), 0, 0])
//             barb_extension();
//       }
//     }
//   }
//
//
// }


