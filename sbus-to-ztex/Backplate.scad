SBUS_WIDTH = 83.82;
SBUS_LENGTH = 146.7;
SBUS_THICKNESS = 1.6;
MYSBUS_MISSING_LENGTH = 47;

SBUS_BACKPLATE_THICKNESS = 1.19;
SBUS_BACKPLATE_FULLHEIGHT = 19.64;
SBUS_BACKPLATE_PROTUSION_HEIGHT = 1.22;
SBUS_BACKPLATE_HEIGHT = SBUS_BACKPLATE_FULLHEIGHT - SBUS_BACKPLATE_PROTUSION_HEIGHT;
SBUS_BACKPLATE_PROTUSION_FROMSIDE = 13;

SBUS_BACKPLATE_BOTTOM_TO_BOARD_BOTTOM = 1.12;

SBUS_GAP_BACKPLATE = 2.54;
SBUS_BACKPLATE_TOPHOLETOTOPHOLE = 79.24;
SBUS_BACKPLATE_TOPHOLEFROMSIDE = 2.29;
SBUS_BACKPLATE_TOPHOLEFROMBOTTOM = 15.43;
SBUS_BACKPLATE_TOPHOLEFROMFULLBOTTOM = SBUS_BACKPLATE_TOPHOLEFROMBOTTOM + SBUS_BACKPLATE_PROTUSION_HEIGHT;

SBUS_BACKPLATE_HOLESTOHOLES = 78.23;
SBUS_BACKPLATE_HOLEFROMSIDE = 2.795;
SBUS_BACKPLATE_HOLEFROMFULLBOTTOM = 7.08;
SBUS_BACKPLATE_HOLEFROMBOTTOM = SBUS_BACKPLATE_HOLEFROMFULLBOTTOM - SBUS_BACKPLATE_PROTUSION_HEIGHT;


SBUS_BACKPLATE_WIDTH = SBUS_BACKPLATE_TOPHOLETOTOPHOLE + 2 * SBUS_BACKPLATE_TOPHOLEFROMSIDE;
SBUS_BACKPLATE_PROTUSION_WIDTH = SBUS_BACKPLATE_WIDTH - 2 * SBUS_BACKPLATE_PROTUSION_FROMSIDE;

MY_FULL_LENGTH = MYSBUS_MISSING_LENGTH + SBUS_GAP_BACKPLATE + SBUS_BACKPLATE_THICKNESS;

//holes:
// 110,130.82
// 110,120.82
// 110,82
// top left 97,50
// -> 13,80.82 ; 13,70.82 ; 13,32 from top left

STRUT_HEIGHT = 10.01;		// max 15.31
STRUT_WIDTH = 3;
SMALL_STRUT_HEIGHT = 5;
SMALL_STRUT_WIDTH = 2;
SMALL_STRUT_LENGTH = 20;


fan_depth=8;
fan_height=25;
fan_width=fan_height;
fan_carrier_depth=5;
fan_extra_height=3;
vertical_offset=fan_height/2-SBUS_THICKNESS/2-(SBUS_BACKPLATE_PROTUSION_HEIGHT + SBUS_BACKPLATE_BOTTOM_TO_BOARD_BOTTOM)+fan_extra_height/2;
carrier_offset_from_backplate=8;
carrier_offset=-MY_FULL_LENGTH/2+fan_width/2+carrier_offset_from_backplate; // negative -> toward back
echo(carrier_offset);

module
primary ()
{
  union ()
  {

    color ("green") cube ([SBUS_WIDTH, MY_FULL_LENGTH, SBUS_THICKNESS], center = true);

    if (0) for (i =[-2: 1:2]) {
	translate ([i * 15 + 2.5, 0, STRUT_HEIGHT / 2 - 0.1]) color ("red") cube ([STRUT_WIDTH, MY_FULL_LENGTH, STRUT_HEIGHT], center = true);
      }
 
  //translate ([SBUS_WIDTH/2-18,7+(MY_FULL_LENGTH-SMALL_STRUT_LENGTH)/2,SMALL_STRUT_HEIGHT/2]) color("red") cube([SMALL_STRUT_WIDTH, SMALL_STRUT_LENGTH, SMALL_STRUT_HEIGHT], center = true);
  //translate ([-SBUS_WIDTH/2+24,7+(MY_FULL_LENGTH-SMALL_STRUT_LENGTH)/2,SMALL_STRUT_HEIGHT/2]) color("red") cube([SMALL_STRUT_WIDTH, SMALL_STRUT_LENGTH, SMALL_STRUT_HEIGHT], center = true);

    translate ([0, -MY_FULL_LENGTH / 2 + SBUS_BACKPLATE_THICKNESS / 2, SBUS_BACKPLATE_HEIGHT / 2 - SBUS_THICKNESS / 2 - SBUS_BACKPLATE_BOTTOM_TO_BOARD_BOTTOM]) {
      union ()
      {
	color ("black")
	  cube ([SBUS_BACKPLATE_WIDTH, SBUS_BACKPLATE_THICKNESS, SBUS_BACKPLATE_HEIGHT], center = true);
	translate ([0, 0, -SBUS_BACKPLATE_PROTUSION_HEIGHT / 2]) {
	  color ("black")
	    cube ([SBUS_BACKPLATE_PROTUSION_WIDTH, SBUS_BACKPLATE_THICKNESS, SBUS_BACKPLATE_FULLHEIGHT], center = true);
	}
      }
    }

    MY_BOARD_OVERLAP_LENGTH = 20;
    MY_BACKPLATE_OVERLAP_LENGTH = 12;
    MY_OVERLAP_LENGTH = MY_BOARD_OVERLAP_LENGTH + MY_BACKPLATE_OVERLAP_LENGTH;

    FIXHOLE_X_OFFSET = 13;
    FIXHOLE1_Y_OFFSET = 80.82;
    FIXHOLE2_Y_OFFSET = 70.82;
    FIXHOLE3_Y_OFFSET = 32;

    FIXHOLE_RAD = 1.55;

    SERIAL_HOLLOWOUT_WIDTH = 18;
    SERIAL_HOLLOWOUT_LENGTH = 5;
    SERIAL_HOLLOWOUT_OFFSET = 3;


    JTAG_HOLLOWOUT_WIDTH = 5;
    JTAG_HOLLOWOUT_LENGTH = 16;
    JTAG_HOLLOWOUT_OFFSET = 6;

    difference () {
      translate ([0,
		  MY_FULL_LENGTH / 2 + MY_OVERLAP_LENGTH / 2 -
		  MY_BACKPLATE_OVERLAP_LENGTH, 0.00000000001 - SBUS_THICKNESS / 2 - (SBUS_BACKPLATE_PROTUSION_HEIGHT + SBUS_BACKPLATE_BOTTOM_TO_BOARD_BOTTOM) / 2]) {
	color ("blue")
	  cube ([SBUS_WIDTH, MY_OVERLAP_LENGTH,	/*SBUS_THICKNESS */
		 SBUS_BACKPLATE_PROTUSION_HEIGHT + SBUS_BACKPLATE_BOTTOM_TO_BOARD_BOTTOM], center = true);
      }

      union ()
      {
	translate ([-SBUS_WIDTH / 2 + FIXHOLE1_Y_OFFSET, MY_FULL_LENGTH / 2 + FIXHOLE_X_OFFSET, 0]) {
	  color ("yellow") cylinder (h = 50, r1 = FIXHOLE_RAD, r2 = FIXHOLE_RAD, center = true);
	}
	translate ([-SBUS_WIDTH / 2 + FIXHOLE2_Y_OFFSET, MY_FULL_LENGTH / 2 + FIXHOLE_X_OFFSET, 0]) {
	  color ("yellow") cylinder (h = 50, r1 = FIXHOLE_RAD, r2 = FIXHOLE_RAD, center = true);
	}
	translate ([-SBUS_WIDTH / 2 + FIXHOLE3_Y_OFFSET, MY_FULL_LENGTH / 2 + FIXHOLE_X_OFFSET, 0]) {
	  color ("yellow") cylinder (h = 50, r1 = FIXHOLE_RAD, r2 = FIXHOLE_RAD, center = true);
	}
	translate ([SBUS_WIDTH / 2 - SERIAL_HOLLOWOUT_WIDTH / 2 + 5, MY_FULL_LENGTH / 2 + SERIAL_HOLLOWOUT_OFFSET + SERIAL_HOLLOWOUT_LENGTH / 2, 0]) {
	  color ("yellow")
	    cube ([SERIAL_HOLLOWOUT_WIDTH + 10, SERIAL_HOLLOWOUT_LENGTH, 50], center = true);
	}
	translate ([-SBUS_WIDTH / 2 + JTAG_HOLLOWOUT_WIDTH / 2 + JTAG_HOLLOWOUT_OFFSET, MY_FULL_LENGTH / 2 + JTAG_HOLLOWOUT_LENGTH / 2, 0]) {
	  color ("yellow")
	    cube ([JTAG_HOLLOWOUT_WIDTH, JTAG_HOLLOWOUT_LENGTH, 50], center = true);
	}
      }
    }

  }
}

module
extra_holes ()
{
  EXTRA_RAD = 2;
  union ()
  {
  for (i =[-8: 16:8]) {
    for (j =[-4: 1:5]) {
	translate ([i * 5, j * 5, 0])
	  color ("pink") cylinder (h = 50, r1 = 1.5, r2 = 1.5, center = true);
      }
    }
  for (i =[-8: 5000:8]) {
    for (j =[6: 1:8]) {
	translate ([i * 5, j * 5, 0])
	  color ("pink") cylinder (h = 50, r1 = 1.5, r2 = 1.5, center = true);
      }
    }

  for (i =[-6: 2:6]) {
    for (j =[-4: 1:5]) {
	translate ([i * 5, j * 5, 0])
	  color ("pink") cylinder (h = 50, r1 = EXTRA_RAD, r2 = EXTRA_RAD, center = true);
      }
    }
  for (i =[-7: 2:7]) {
    for (j =[-4.5: 1:4.5]) {
	translate ([i * 5, j * 5, 0])
	  color ("pink") cylinder (h = 50, r1 = EXTRA_RAD, r2 = EXTRA_RAD, center = true);
      }
    }
  for (i =[-4: 2:4]) {
    for (j =[5: 1:8]) {
	if (!((i == -2) && (j >= 7)))
	  translate ([i * 5, j * 5, 0])
	    color ("pink") cylinder (h = 50, r1 = EXTRA_RAD, r2 = EXTRA_RAD, center = true);
      }
    }
  for (i =[-5: 2:3]) {
    for (j =[5.5: 1:8.5]) {
	translate ([i * 5, j * 5, 0])
	  color ("pink") cylinder (h = 50, r1 = EXTRA_RAD, r2 = EXTRA_RAD, center = true);
      }
    }
  }
}

module
fan_25mm_carveout() {
    translate([(SBUS_WIDTH-fan_depth)/2+fan_carrier_depth/2+0.4999,carrier_offset,vertical_offset]) {
        color("pink") cube([fan_depth+fan_carrier_depth+1, fan_width, fan_height], center = true);
    }
    translate([(SBUS_WIDTH-fan_carrier_depth)/2-fan_depth,carrier_offset,vertical_offset]) {
        rotate([0,90,0]) color("red") cylinder(h=0.01+fan_carrier_depth,r1=(fan_width/2-1),r2=(fan_width/2-1), center=true);
    }
        union() {
    if (0) translate([(SBUS_WIDTH-fan_carrier_depth)/2-fan_depth,carrier_offset,vertical_offset]) {
        rotate([0,90,0]) color("red") cylinder(h=2+fan_carrier_depth,r1=(fan_width/2-1),r2=(fan_width/2-1), center=true);
    }
    translate([0,-10,-10])
    translate([(SBUS_WIDTH-fan_carrier_depth)/2-fan_depth,carrier_offset,vertical_offset]) {
        rotate([0,90,0]) color("red") cylinder(h=2+fan_carrier_depth,r1=screw_hole_r,r2=screw_hole_r, center=true);
    }
    translate([0, 10,-10])
    translate([(SBUS_WIDTH-fan_carrier_depth)/2-fan_depth,carrier_offset,vertical_offset]) {
        rotate([0,90,0]) color("red") cylinder(h=2+fan_carrier_depth,r1=screw_hole_r,r2=screw_hole_r, center=true);
    }
    translate([0, 10, 10])
    translate([(SBUS_WIDTH-fan_carrier_depth)/2-fan_depth,carrier_offset,vertical_offset]) {
        rotate([0,90,0]) color("red") cylinder(h=2+fan_carrier_depth,r1=screw_hole_r,r2=screw_hole_r, center=true);
    }
    translate([0,-10, 10])
    translate([(SBUS_WIDTH-fan_carrier_depth)/2-fan_depth,carrier_offset,vertical_offset]) {
        rotate([0,90,0]) color("red") cylinder(h=2+fan_carrier_depth,r1=screw_hole_r,r2=screw_hole_r, center=true);
    }
}
}

screw_hole_r=1.55;
triangle_width=4;
triangle_height=12;
module
fan_25mm_support() {
        union() {
            // body
    translate([(SBUS_WIDTH-fan_carrier_depth)/2-fan_depth,carrier_offset,vertical_offset]) {
        color("black") cube([fan_carrier_depth, fan_width+fan_extra_height, fan_height+fan_extra_height], center = true);
    }
    // support
    translate([(SBUS_WIDTH-fan_carrier_depth)/2-fan_depth+0.5,carrier_offset-2.4,0]) {
        color("purple") cube([fan_carrier_depth+5, fan_width+fan_extra_height+8, SBUS_THICKNESS], center = true);
    }
      // strut between the backplate and the fan carrier
	translate ([(SBUS_WIDTH-fan_carrier_depth)/2-fan_depth, carrier_offset-1, (SBUS_BACKPLATE_FULLHEIGHT-5)/2-SBUS_THICKNESS/2-SBUS_BACKPLATE_BOTTOM_TO_BOARD_BOTTOM]) color ("purple") cube ([fan_carrier_depth/2, 38,SBUS_BACKPLATE_FULLHEIGHT-5 ], center = true);
    
    translate ([(SBUS_WIDTH-fan_carrier_depth)/2-fan_depth, carrier_offset-(fan_width+fan_extra_height)/2-triangle_width/2, triangle_height/2-SBUS_THICKNESS/2-SBUS_BACKPLATE_BOTTOM_TO_BOARD_BOTTOM+SBUS_BACKPLATE_FULLHEIGHT-5]) rotate([0,90,0]) color("pink") translate([0,0,-fan_carrier_depth/4]) linear_extrude(height=fan_carrier_depth/2) polygon( points=[[triangle_height/2,-triangle_width/2],[-triangle_height/2,triangle_width/2],[triangle_height/2,triangle_width/2]] );
    
    translate ([(SBUS_WIDTH-fan_carrier_depth)/2-fan_depth, carrier_offset+(fan_width+fan_extra_height)/2+triangle_width/2, triangle_height/2-SBUS_THICKNESS/2-SBUS_BACKPLATE_BOTTOM_TO_BOARD_BOTTOM+SBUS_BACKPLATE_FULLHEIGHT-5]) rotate([0,90,0]) color("pink") translate([0,0,-fan_carrier_depth/4]) linear_extrude(height=fan_carrier_depth/2) polygon( points=[[triangle_height/2,-triangle_width/2],[-triangle_height/2,-triangle_width/2],[triangle_height/2,triangle_width/2]] );

}
}


difference() {
union() {
difference ()
{
  primary ();
  union() {
  extra_holes ();
  }
}

fan_25mm_support();
}

fan_25mm_carveout();
}
