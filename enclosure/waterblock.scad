// TODO: height needs to be measured
// TODO: barb dimensions!

module waterblock() {
  color("blue")
  union () {
    cube(size=[40, 40, 10], center=true);
    
    for (x=[-1,1]) {
      translate([x * 10, -25, 0])
        rotate([90, 0, 0])
          cylinder(r=4.5, h=10, center=true);
    }
  }
}