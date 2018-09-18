// Module enclosure for proejct

// Subdivision resolution
FN_ROUND=200;
//FN_ROUND=10;
FN_HEX=6;

// Hex nut
HEX_NUT_WIDTH=7;
HEX_NUT_HEIGHT=3;

//PCB
PCB_OFFSET_Z=-6;

// PCB drill hole
PCB_HOLE_WIDTH=3.5;
PCB_HOLE_HEIGHT=50;
PCB_HOLE_OFFSET_X1=32;
PCB_HOLE_OFFSET_X2=34.7;
PCB_HOLE_OFFSET_Y1=-8.9;
PCB_HOLE_OFFSET_Y2=-41.33;

// Clamshell back
CLAMSHELL_INNER_X=74;
CLAMSHELL_INNER_Y=82;
CLAMSHELL_INNER_Z=5;
CLAMSHELL_OUTER_X=84;
CLAMSHELL_OUTER_Y=90;
CLAMSHELL_OUTER_Z=20;
CLAMSHELL_ROUND_W=10;
CLAMSHELL_BACK_Z=18;

// Clamshell back cutout
CLAMSHELL_CUTOUT1_X=5;
CLAMSHELL_CUTOUT1_Y=10;
CLAMSHELL_CUTOUT1_OFFSET_X=35;
CLAMSHELL_CUTOUT1_OFFSET_Y=7;
CLAMSHELL_CUTOUT2_X=52;
CLAMSHELL_CUTOUT2_Y=66;
CLAMSHELL_CUTOUT2_OFFSET_X=0;
CLAMSHELL_CUTOUT2_OFFSET_Y=-3;
CLAMSHELL_CUTOUT3_X=2;
CLAMSHELL_CUTOUT3_Y=2;
CLAMSHELL_CUTOUT3_OFFSET_X=33.25;
CLAMSHELL_CUTOUT3_OFFSET_Y=30.75;
CLAMSHELL_CUTOUT_ROUND_W=5;
CLAMSHELL_CUTOUT_Z=30;
CLAMSHELL_CUTOUT_OFFSET_Z=-10;
CLAMSHELL_VIEWPANE_SCALE_Z=5;
CLAMSHELL_CUTOUT_OFFSET_X=1;
CLAMSHELL_CUTOUT_OFFSET_Y=2.5;

// Clamshell viewpane drill holes
VIEWPANE_HOLE_WIDTH=3.5;
VIEWPANE_HOLE_HEIGHT=50;
VIEWPANE_HOLE_OFFSET_X1=43;
VIEWPANE_HOLE_OFFSET_X2=43;
VIEWPANE_HOLE_OFFSET_Y1=46;
VIEWPANE_HOLE_OFFSET_Y2=-46;
VIEWPANE_HOLE_SCALE = 1.25;
VIEWPANE_Z=1;

// Clamshell front
CLAMSHELL_VIEWPANE_Z=3;

// Clamshell connector
CLAMSHELL_CONNECTOR_OUTER_X=CLAMSHELL_OUTER_X+.001;
CLAMSHELL_CONNECTOR_OUTER_Y=7;
CLAMSHELL_CONNECTOR_OUTER_Z=13;
CLAMSHELL_CONNECTOR_INNER_X=CLAMSHELL_CONNECTOR_OUTER_X-2;
CLAMSHELL_CONNECTOR_INNER_Y=CLAMSHELL_CONNECTOR_OUTER_Y+100;
CLAMSHELL_CONNECTOR_INNER_Z=CLAMSHELL_CONNECTOR_OUTER_Z+8;
CLAMSHELL_CONNECTOR_INNER_OFFSET_Z=5;
CLAMSHELL_CONNECTOR_OFFSET_X=0;
CLAMSHELL_CONNECTOR_OFFSET_Y=-27;
CLAMSHELL_CONNECTOR_OFFSET_Z=-12;
CLAMSHELL_CONNECTOR_CUTOFF_X=100;
CLAMSHELL_CONNECTOR_CUTOFF_Y=60;
CLAMSHELL_CONNECTOR_CUTOFF_Z=18;
CLAMSHELL_CONNECTOR_CUTOFF_OFFSET_Z=14;
CLAMSHELL_CONNECTOR_ROUND_W=5;

// Clamshell connector holes
CLAMSHELL_CONNECTOR_HOLE_OFFSET_X=-8;
CLAMSHELL_CONNECTOR_HOLE_OFFSET_Y=-30.5;
CLAMSHELL_CONNECTOR_HOLE_OFFSET_Z=-14;
CLAMSHELL_CONNECTOR_INNER_HOLE_H=100;
CLAMSHELL_CONNECTOR_INNER_HOLE_RADIUS=2.5;
CLAMSHELL_CONNECTOR_OUTER_HOLE_H=16;
CLAMSHELL_CONNECTOR_OUTER_HOLE_RADIUS=4;
CLAMSHELL_CONNECTOR_HOLE_WIDTH=18;

// Clamshell base
CLAMSHELL_BASE_ANGLE=84;
CLAMSHELL_BASE_OFFSET_X=-50;
CLAMSHELL_BASE_OFFSET_Y=-62;
CLAMSHELL_BASE_OFFSET_Z=-10;

// Demo
DEMO_BASE_ANGLE=84;

module board() {
	color("Green", 1.0) {
		translate([CLAMSHELL_CUTOUT_OFFSET_X,CLAMSHELL_CUTOUT_OFFSET_Y,PCB_OFFSET_Z]) {
			import("RevC.stl");
		}
	}
}

module base() {
	color("Magenta", 1.0) {
		translate([CLAMSHELL_BASE_OFFSET_X, CLAMSHELL_BASE_OFFSET_Y, CLAMSHELL_BASE_OFFSET_Z])
		rotate([-CLAMSHELL_BASE_ANGLE, 0, 0])
			import("Base.stl");
	}
}
		

// Drill hole 3d bodies
module drill_holes() {
	translate([PCB_HOLE_OFFSET_X1,0,-PCB_HOLE_HEIGHT/2]) {
		translate([0,PCB_HOLE_OFFSET_Y1,0])
			cylinder(r=PCB_HOLE_WIDTH/2, h=PCB_HOLE_HEIGHT, $fn=FN_ROUND);
		translate([0,PCB_HOLE_OFFSET_Y2,0])
			cylinder(r=PCB_HOLE_WIDTH/2, h=PCB_HOLE_HEIGHT, $fn=FN_ROUND);
	}

	translate([-PCB_HOLE_OFFSET_X2,0,-PCB_HOLE_HEIGHT/2]) {
		translate([0,PCB_HOLE_OFFSET_Y1,0])
			cylinder(r=PCB_HOLE_WIDTH/2, h=PCB_HOLE_HEIGHT, $fn=FN_ROUND);
		translate([0,PCB_HOLE_OFFSET_Y2,0])
			cylinder(r=PCB_HOLE_WIDTH/2, h=PCB_HOLE_HEIGHT, $fn=FN_ROUND);
	}
}

module hex_nut_holes() {
	translate([PCB_HOLE_OFFSET_X1,0,0]) {
		translate([0,PCB_HOLE_OFFSET_Y1,0])
			cylinder(r=HEX_NUT_WIDTH/2, h=HEX_NUT_HEIGHT, $fn=FN_HEX);
		translate([0,PCB_HOLE_OFFSET_Y2,0])
			cylinder(r=HEX_NUT_WIDTH/2, h=HEX_NUT_HEIGHT, $fn=FN_HEX);
	}

	translate([-PCB_HOLE_OFFSET_X2,0,0]) {
		translate([0,PCB_HOLE_OFFSET_Y1,0])
			cylinder(r=HEX_NUT_WIDTH/2, h=HEX_NUT_HEIGHT, $fn=FN_HEX);
		translate([0,PCB_HOLE_OFFSET_Y2,0])
			cylinder(r=HEX_NUT_WIDTH/2, h=HEX_NUT_HEIGHT, $fn=FN_HEX);
	}
}

module clamshell_inner_region() {
	minkowski() {
		cube([CLAMSHELL_INNER_X, CLAMSHELL_INNER_Y, CLAMSHELL_INNER_Z], center=true);
		sphere(r=CLAMSHELL_ROUND_W/2, center=true, $fn=FN_ROUND);
	}
}

module clamshell_outer_region() {
	minkowski() {
		cube([CLAMSHELL_OUTER_X, CLAMSHELL_OUTER_Y, CLAMSHELL_OUTER_Z], center=true);
		cylinder(r=CLAMSHELL_ROUND_W/2, center=true, $fn=FN_ROUND);
	}
}

module clamshell_viewpane_region(viewpane_z) {
	minkowski() {
		cube([CLAMSHELL_OUTER_X, CLAMSHELL_OUTER_Y, viewpane_z], center=true);
		cylinder(r=CLAMSHELL_ROUND_W/2, center=true, $fn=FN_ROUND);
	}
}

// Drill holes for clamshell viewpane
module viewpane_drill_holes(viewpane_hole_scale) {
	if (!viewpane_hole_scale) {
		translate([VIEWPANE_HOLE_OFFSET_X1,0,-VIEWPANE_HOLE_HEIGHT/2]) {
			translate([0,VIEWPANE_HOLE_OFFSET_Y1,0])
				cylinder(r=VIEWPANE_HOLE_WIDTH/2, h=VIEWPANE_HOLE_HEIGHT, $fn=FN_ROUND);
			translate([0,VIEWPANE_HOLE_OFFSET_Y2,0])
				cylinder(r=VIEWPANE_HOLE_WIDTH/2, h=VIEWPANE_HOLE_HEIGHT, $fn=FN_ROUND);
		}

		translate([-VIEWPANE_HOLE_OFFSET_X2,0,-VIEWPANE_HOLE_HEIGHT/2]) {
			translate([0,VIEWPANE_HOLE_OFFSET_Y1,0])
				cylinder(r=VIEWPANE_HOLE_WIDTH/2, h=VIEWPANE_HOLE_HEIGHT, $fn=FN_ROUND);
			translate([0,VIEWPANE_HOLE_OFFSET_Y2,0])
				cylinder(r=VIEWPANE_HOLE_WIDTH/2, h=VIEWPANE_HOLE_HEIGHT, $fn=FN_ROUND);
		}
	} else {
		translate([VIEWPANE_HOLE_OFFSET_X1,0,-VIEWPANE_HOLE_HEIGHT/2]) {
			translate([0,VIEWPANE_HOLE_OFFSET_Y1,0])
				cylinder(r=(VIEWPANE_HOLE_WIDTH*VIEWPANE_HOLE_SCALE)/2, h=VIEWPANE_HOLE_HEIGHT, $fn=FN_ROUND);
			translate([0,VIEWPANE_HOLE_OFFSET_Y2,0])
				cylinder(r=(VIEWPANE_HOLE_WIDTH*VIEWPANE_HOLE_SCALE)/2, h=VIEWPANE_HOLE_HEIGHT, $fn=FN_ROUND);
		}

		translate([-VIEWPANE_HOLE_OFFSET_X2,0,-VIEWPANE_HOLE_HEIGHT/2]) {
			translate([0,VIEWPANE_HOLE_OFFSET_Y1,0])
				cylinder(r=(VIEWPANE_HOLE_WIDTH*VIEWPANE_HOLE_SCALE)/2, h=VIEWPANE_HOLE_HEIGHT, $fn=FN_ROUND);
			translate([0,VIEWPANE_HOLE_OFFSET_Y2,0])
				cylinder(r=(VIEWPANE_HOLE_WIDTH*VIEWPANE_HOLE_SCALE)/2, h=VIEWPANE_HOLE_HEIGHT, $fn=FN_ROUND);
		}
	}
}

module clamshell_back_cutout_region() {
	union() {
		// This is for the OBD2 connection
		translate([CLAMSHELL_CUTOUT1_OFFSET_X, CLAMSHELL_CUTOUT1_OFFSET_Y, CLAMSHELL_CUTOUT_OFFSET_Z]) {
			minkowski() {
				cube([CLAMSHELL_CUTOUT1_X, CLAMSHELL_CUTOUT1_Y, CLAMSHELL_CUTOUT_Z], center=true);
				sphere(r=CLAMSHELL_CUTOUT_ROUND_W/2, center=true, $fn=FN_ROUND);
			}
		}
		
		// This relief area for the FPGA module
		translate([CLAMSHELL_CUTOUT2_OFFSET_X, CLAMSHELL_CUTOUT2_OFFSET_Y, CLAMSHELL_CUTOUT_OFFSET_Z]) {
			minkowski() {
				cube([CLAMSHELL_CUTOUT2_X, CLAMSHELL_CUTOUT2_Y, CLAMSHELL_CUTOUT_Z], center=true);
				sphere(r=CLAMSHELL_CUTOUT_ROUND_W/2, center=true, $fn=FN_ROUND);
			}
		}
		
		// This is for the daylight sensor to poke out
		translate([CLAMSHELL_CUTOUT3_OFFSET_X, CLAMSHELL_CUTOUT3_OFFSET_Y, CLAMSHELL_CUTOUT_OFFSET_Z]) {
			minkowski() {
				cube([CLAMSHELL_CUTOUT3_X, CLAMSHELL_CUTOUT3_Y, CLAMSHELL_CUTOUT_Z], center=true);
				sphere(r=CLAMSHELL_CUTOUT_ROUND_W/2, center=true, $fn=FN_ROUND);
			}
		}
	}
}

module clamshell_back() {
	color("Blue", 1) {
		difference() {
			clamshell_outer_region();
			clamshell_inner_region();
			translate([0,0,CLAMSHELL_BACK_Z/2])
			scale([1.05, 1.05, CLAMSHELL_VIEWPANE_SCALE_Z])
				clamshell_viewpane_region(CLAMSHELL_VIEWPANE_Z);			
			viewpane_drill_holes(false);
			clamshell_back_cutout_region();
			clamshell_connector();
			translate([CLAMSHELL_CUTOUT_OFFSET_X, CLAMSHELL_CUTOUT_OFFSET_Y, 0]) {
				drill_holes();
				translate([0,0,-(CLAMSHELL_OUTER_Z+HEX_NUT_HEIGHT)/2])
					hex_nut_holes();
			}
		}
	}
}

module clamshell_viewpane() {
	color("Yellow", 0.25) {
		translate([0,0,10]) {
			difference() {
				clamshell_viewpane_region(VIEWPANE_Z);
				viewpane_drill_holes(true);
			}
		}
	}
}

module clamshell_connector_holes() {
	// Add speed holes...
	translate([CLAMSHELL_CONNECTOR_HOLE_OFFSET_X, CLAMSHELL_CONNECTOR_HOLE_OFFSET_Y, CLAMSHELL_CONNECTOR_HOLE_OFFSET_Z]) {	
		union() {
			cylinder(r=CLAMSHELL_CONNECTOR_INNER_HOLE_RADIUS,h=CLAMSHELL_CONNECTOR_INNER_HOLE_H, $fn=FN_ROUND, center=true);
			cylinder(r=CLAMSHELL_CONNECTOR_OUTER_HOLE_RADIUS,h=CLAMSHELL_CONNECTOR_OUTER_HOLE_H, $fn=FN_ROUND, center=true);
		}
		
		translate([CLAMSHELL_CONNECTOR_HOLE_WIDTH,0,0]) 
		union() {
			cylinder(r=CLAMSHELL_CONNECTOR_INNER_HOLE_RADIUS,h=CLAMSHELL_CONNECTOR_INNER_HOLE_H, $fn=FN_ROUND, center=true);
			cylinder(r=CLAMSHELL_CONNECTOR_OUTER_HOLE_RADIUS,h=CLAMSHELL_CONNECTOR_OUTER_HOLE_H, $fn=FN_ROUND, center=true);
		}
	}
}

module clamshell_connector() {
	color("Orange", 1.0) {
		difference() {
			translate([CLAMSHELL_CONNECTOR_OFFSET_X, CLAMSHELL_CONNECTOR_OFFSET_Y, CLAMSHELL_CONNECTOR_OFFSET_Z]) {
				difference() {
					minkowski() {
						cube([CLAMSHELL_CONNECTOR_OUTER_X, CLAMSHELL_CONNECTOR_OUTER_Y, CLAMSHELL_CONNECTOR_OUTER_Z], center=true);
						rotate([90,0,0])
						cylinder(r=CLAMSHELL_CONNECTOR_ROUND_W, h=CLAMSHELL_CONNECTOR_OUTER_Y, $fn=FN_ROUND);
					}
					translate([0,0,CLAMSHELL_CONNECTOR_INNER_OFFSET_Z])
							cube([CLAMSHELL_CONNECTOR_INNER_X, CLAMSHELL_CONNECTOR_INNER_Y, CLAMSHELL_CONNECTOR_INNER_Z], center=true);
					translate([0,0,CLAMSHELL_CONNECTOR_CUTOFF_OFFSET_Z])
						cube([CLAMSHELL_CONNECTOR_CUTOFF_X, CLAMSHELL_CONNECTOR_CUTOFF_Y, CLAMSHELL_CONNECTOR_CUTOFF_Z], center=true);
				}
			}
			
			clamshell_connector_holes();
		}
	}
}

module main(demo, viewpane, back, connector, base) {
	// Select which thing to print, or demo
	if (demo) {
		rotate([DEMO_BASE_ANGLE,0,0]) {
			clamshell_viewpane();
			board();
			clamshell_back();
			clamshell_connector();
			base();
		}
	} else if (viewpane) {
		clamshell_viewpane();
	} else if (back) {
		clamshell_back();
	} else if (connector) {
		clamshell_connector();
	} else if (base) {
		rotate([DEMO_BASE_ANGLE,0,0])
			base();
	}
}

//main(true, false, false, false, false);  // Uncomment to view the whole thing
main(false, true, false, false, false);  // Uncomment for viewpane
//main(false, false, true, false, false);  // Uncomment for back
//main(false, false, false, true, false);  // Uncomment for connector
//main(false, false, false, false, true);  // Uncomment for base
