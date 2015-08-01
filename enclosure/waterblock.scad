// TODO: height needs to be measured
// TODO: barb dimensions!

module waterblock() {
  color("blue")
  union () {
    cube(size=[41.1, 41.75, 12.25], center=true);
    
    for (x=[-1,1]) {
      translate([x * (41.5 - 11.5) / 2, -25, 0])
        rotate([90, 0, 0])
          cylinder(r=11.5/2, h=12, center=true);
    }
  }
}