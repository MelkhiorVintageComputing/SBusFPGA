add_fan = 0; // not really compatible with USB...
add_vga = 1;

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

USB_PLUG_OFFSET = (add_vga!=0 ? 65 : 30);

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

    USBCABLE_HOLLOWOUT_WIDTH = 10;
    USBCABLE_HOLLOWOUT_LENGTH = 16.5;
    USBCABLE_HOLLOWOUT_OFFSETX = -7.5+0.001;
    USBCABLE_HOLLOWOUT_OFFSETY = -16.5;
    USBCABLE_HOLLOWOUT2_WIDTH = 21;
    USBCABLE_HOLLOWOUT2_LENGTH = 6;
    USBCABLE_HOLLOWOUT2_OFFSETX = -12.5;
    USBCABLE_HOLLOWOUT2_OFFSETY = -16.5;
    
    
  union () // A
  {
difference() { // B
    union() { // C
    color ("green") cube ([SBUS_WIDTH, MY_FULL_LENGTH, SBUS_THICKNESS], center = true);
    
    translate ([0, -MY_FULL_LENGTH / 2 + SBUS_BACKPLATE_THICKNESS / 2, SBUS_BACKPLATE_HEIGHT / 2 - SBUS_THICKNESS / 2 - SBUS_BACKPLATE_BOTTOM_TO_BOARD_BOTTOM]) {
      union ()
      {
	color ("black")
	  cube ([SBUS_BACKPLATE_WIDTH, SBUS_BACKPLATE_THICKNESS, SBUS_BACKPLATE_HEIGHT], center = true);
	translate ([0, 0, -SBUS_BACKPLATE_PROTUSION_HEIGHT / 2]) {
	  color ("black")
	    cube ([SBUS_BACKPLATE_PROTUSION_WIDTH, SBUS_BACKPLATE_THICKNESS, SBUS_BACKPLATE_FULLHEIGHT], center = true);
	}
      } // union
    }
    
    /* to fix the board to the machine */
    FIX_HOLES_STUB_LENGTH=3;
    translate ([-SBUS_WIDTH/2+(SBUS_WIDTH-SBUS_BACKPLATE_HOLESTOHOLES)/2,
        -MY_FULL_LENGTH / 2 + SBUS_BACKPLATE_THICKNESS / 2+FIX_HOLES_STUB_LENGTH/2,
        -SBUS_THICKNESS/2-SBUS_BACKPLATE_BOTTOM_TO_BOARD_BOTTOM+7.08]) rotate([90,0,0]) color ("black") cylinder (h = FIX_HOLES_STUB_LENGTH, r1 = 2, r2 = 2, center = true);
    translate ([+SBUS_WIDTH/2-(SBUS_WIDTH-SBUS_BACKPLATE_HOLESTOHOLES)/2,
        -MY_FULL_LENGTH / 2 + SBUS_BACKPLATE_THICKNESS / 2+FIX_HOLES_STUB_LENGTH/2,
        -SBUS_THICKNESS/2-SBUS_BACKPLATE_BOTTOM_TO_BOARD_BOTTOM+7.08]) rotate([90,0,0]) color ("black") cylinder (h = FIX_HOLES_STUB_LENGTH, r1 = 2, r2 = 2, center = true);
    
    /* USB plug (StarTech cable) */
    union() {
        color ("grey") 
      translate ([-SBUS_WIDTH/2+USB_PLUG_OFFSET,
        0.001-MY_FULL_LENGTH/2+4,
        14.8/2-SBUS_THICKNESS/2-SBUS_BACKPLATE_BOTTOM_TO_BOARD_BOTTOM-SBUS_BACKPLATE_PROTUSION_HEIGHT + 3.12])
	  cube ([16.5+4, 12, 9.5+4 /* 14.8 max */], center = true);
    }

    if (0) for (i =[-2: 1:2]) {
	translate ([i * 15 + 2.5, 0, STRUT_HEIGHT / 2 - 0.1]) color ("red") cube ([STRUT_WIDTH, MY_FULL_LENGTH, STRUT_HEIGHT], center = true);
      }
  } // union C
  union() { // Z
      
      
	translate ([SBUS_WIDTH / 2 - USBCABLE_HOLLOWOUT_WIDTH / 2 + 5+ USBCABLE_HOLLOWOUT_OFFSETX,
                MY_FULL_LENGTH / 2 + USBCABLE_HOLLOWOUT_LENGTH / 2 + USBCABLE_HOLLOWOUT_OFFSETY,
                0]) {
	  color ("yellow")
	    cube ([USBCABLE_HOLLOWOUT_WIDTH, USBCABLE_HOLLOWOUT_LENGTH, 50], center = true);
	}
	translate ([SBUS_WIDTH / 2 - USBCABLE_HOLLOWOUT2_WIDTH / 2 + 5+ USBCABLE_HOLLOWOUT2_OFFSETX,
                MY_FULL_LENGTH / 2 + USBCABLE_HOLLOWOUT2_LENGTH / 2 + USBCABLE_HOLLOWOUT2_OFFSETY,
                0]) {
	  color ("yellow")
	    cube ([USBCABLE_HOLLOWOUT2_WIDTH, USBCABLE_HOLLOWOUT2_LENGTH, 50], center = true);
	}
    
    
    /* to fix the board to the machine */
    translate ([-SBUS_WIDTH/2+(SBUS_WIDTH-SBUS_BACKPLATE_HOLESTOHOLES)/2,
        -MY_FULL_LENGTH / 2 + SBUS_BACKPLATE_THICKNESS / 2,
        -SBUS_THICKNESS/2-SBUS_BACKPLATE_BOTTOM_TO_BOARD_BOTTOM+7.08]) rotate([90,0,0]) color ("yellow") cylinder (h = 10, r1 = 1.5, r2 = 1.5, center = true);
    translate ([+SBUS_WIDTH/2-(SBUS_WIDTH-SBUS_BACKPLATE_HOLESTOHOLES)/2,
        -MY_FULL_LENGTH / 2 + SBUS_BACKPLATE_THICKNESS / 2,
        -SBUS_THICKNESS/2-SBUS_BACKPLATE_BOTTOM_TO_BOARD_BOTTOM+7.08]) rotate([90,0,0]) color ("yellow") cylinder (h = 10, r1 = 1.5, r2 = 1.5, center = true);
    
    /* USB plug (StarTech cable) */
    union() {
        color ("yellow") 
      translate ([-SBUS_WIDTH/2+USB_PLUG_OFFSET,
        0.001-MY_FULL_LENGTH/2+4,
        14.8/2-SBUS_THICKNESS/2-SBUS_BACKPLATE_BOTTOM_TO_BOARD_BOTTOM-SBUS_BACKPLATE_PROTUSION_HEIGHT + 3.12])
	  cube ([16, 20, 9.5], center = true);
    }
      
  } // union Z
  
  }// difference B
 
  //translate ([SBUS_WIDTH/2-18,7+(MY_FULL_LENGTH-SMALL_STRUT_LENGTH)/2,SMALL_STRUT_HEIGHT/2]) color("red") cube([SMALL_STRUT_WIDTH, SMALL_STRUT_LENGTH, SMALL_STRUT_HEIGHT], center = true);
  //translate ([-SBUS_WIDTH/2+24,7+(MY_FULL_LENGTH-SMALL_STRUT_LENGTH)/2,SMALL_STRUT_HEIGHT/2]) color("red") cube([SMALL_STRUT_WIDTH, SMALL_STRUT_LENGTH, SMALL_STRUT_HEIGHT], center = true);

    MY_BOARD_OVERLAP_LENGTH = 20;
    MY_BACKPLATE_OVERLAP_LENGTH = 12;
    MY_OVERLAP_LENGTH = MY_BOARD_OVERLAP_LENGTH + MY_BACKPLATE_OVERLAP_LENGTH;

    FIXHOLE_X_OFFSET = 13;
    FIXHOLE1_Y_OFFSET = SBUS_WIDTH - 16.3;
    FIXHOLE2_Y_OFFSET = SBUS_WIDTH - 66.82;
    FIXHOLE3_Y_OFFSET = 32;

    FIXHOLE_RAD = 1.5;

    SERIAL_HOLLOWOUT_WIDTH = 18;
    SERIAL_HOLLOWOUT_LENGTH = 5;
    SERIAL_HOLLOWOUT_OFFSET = 3;

    PMOD_HOLLOWOUT_WIDTH = 18;
    PMOD_HOLLOWOUT_LENGTH = 9;
    PMOD_HOLLOWOUT_OFFSETX = (31 - SBUS_WIDTH) + PMOD_HOLLOWOUT_WIDTH / 2;
    PMOD_HOLLOWOUT_OFFSETY = 7;

    USB_HOLLOWOUT_WIDTH = 14;
    USB_HOLLOWOUT_LENGTH = 5;
    USB_HOLLOWOUT_OFFSETX = -5+0.001;
    USB_HOLLOWOUT_OFFSETY = 6;

    SDCARD_HOLLOWOUT_WIDTH = 5;
    SDCARD_HOLLOWOUT_LENGTH = 5;
    SDCARD_HOLLOWOUT_OFFSETX = -36+SDCARD_HOLLOWOUT_WIDTH/2+0.001;
    SDCARD_HOLLOWOUT_OFFSETY = 2.501;


    JTAG_HOLLOWOUT_WIDTH = 5;
    JTAG_HOLLOWOUT_LENGTH = 16;
    JTAG_HOLLOWOUT_OFFSET = 6;

    difference () { // I
        union () {
      translate ([0,
		  MY_FULL_LENGTH / 2 + MY_OVERLAP_LENGTH / 2 -
		  MY_BACKPLATE_OVERLAP_LENGTH, 0.00000000001 - SBUS_THICKNESS / 2 - (SBUS_BACKPLATE_PROTUSION_HEIGHT + SBUS_BACKPLATE_BOTTOM_TO_BOARD_BOTTOM) / 2]) {
	color ("blue")
	  cube ([SBUS_WIDTH, MY_OVERLAP_LENGTH,	/*SBUS_THICKNESS */
		 SBUS_BACKPLATE_PROTUSION_HEIGHT + SBUS_BACKPLATE_BOTTOM_TO_BOARD_BOTTOM], center = true);
      }
      
      STRUT_WIDTH=2;
      translate ([
		  SBUS_WIDTH/2-STRUT_WIDTH/2,
          -12+MY_FULL_LENGTH / 2 + MY_OVERLAP_LENGTH / 2 -
		  MY_BACKPLATE_OVERLAP_LENGTH, 0.00000000001 - SBUS_THICKNESS / 2 - (SBUS_BACKPLATE_PROTUSION_HEIGHT + SBUS_BACKPLATE_BOTTOM_TO_BOARD_BOTTOM) / 2]) {
	color ("blue")
	  cube ([STRUT_WIDTH, MY_OVERLAP_LENGTH,	/*SBUS_THICKNESS */
		 SBUS_BACKPLATE_PROTUSION_HEIGHT + SBUS_BACKPLATE_BOTTOM_TO_BOARD_BOTTOM], center = true);
      }
  }

      union () // J
      {
      
      /* fixing holes (PCB to 3D printed part) */
	translate ([-SBUS_WIDTH / 2 + FIXHOLE1_Y_OFFSET, MY_FULL_LENGTH / 2 + FIXHOLE_X_OFFSET, 0]) {
	  color ("yellow") cylinder (h = 50, r1 = FIXHOLE_RAD, r2 = FIXHOLE_RAD, center = true);
	}
	translate ([-SBUS_WIDTH / 2 + FIXHOLE2_Y_OFFSET, MY_FULL_LENGTH / 2 + FIXHOLE_X_OFFSET, 0]) {
	  color ("yellow") cylinder (h = 50, r1 = FIXHOLE_RAD, r2 = FIXHOLE_RAD, center = true);
	}
    /*
	translate ([-SBUS_WIDTH / 2 + FIXHOLE3_Y_OFFSET, MY_FULL_LENGTH / 2 + FIXHOLE_X_OFFSET, 0]) {
	  color ("yellow") cylinder (h = 50, r1 = FIXHOLE_RAD, r2 = FIXHOLE_RAD, center = true);
	}
    */
    /*
	translate ([SBUS_WIDTH / 2 - SERIAL_HOLLOWOUT_WIDTH / 2 + 5, MY_FULL_LENGTH / 2 + SERIAL_HOLLOWOUT_OFFSET + SERIAL_HOLLOWOUT_LENGTH / 2, 0]) {
	  color ("yellow")
	    cube ([SERIAL_HOLLOWOUT_WIDTH + 10, SERIAL_HOLLOWOUT_LENGTH, 50], center = true);
	}
    */
	translate ([SBUS_WIDTH / 2 - PMOD_HOLLOWOUT_WIDTH / 2 + PMOD_HOLLOWOUT_OFFSETX,
                MY_FULL_LENGTH / 2 + PMOD_HOLLOWOUT_LENGTH / 2 + PMOD_HOLLOWOUT_OFFSETY,
                0]) {
	  color ("yellow")
	    cube ([PMOD_HOLLOWOUT_WIDTH, PMOD_HOLLOWOUT_LENGTH, 50], center = true);
	}
	translate ([SBUS_WIDTH / 2 - USB_HOLLOWOUT_WIDTH / 2 + 5+ USB_HOLLOWOUT_OFFSETX,
                MY_FULL_LENGTH / 2 + USB_HOLLOWOUT_LENGTH / 2 + USB_HOLLOWOUT_OFFSETY,
                0]) {
	  color ("yellow")
	    cube ([USB_HOLLOWOUT_WIDTH, USB_HOLLOWOUT_LENGTH, 50], center = true);
	}
	translate ([SBUS_WIDTH / 2 - SDCARD_HOLLOWOUT_WIDTH / 2 + 5+ SDCARD_HOLLOWOUT_OFFSETX,
                MY_FULL_LENGTH / 2 + SDCARD_HOLLOWOUT_LENGTH / 2 + SDCARD_HOLLOWOUT_OFFSETY,
                0]) {
	  color ("yellow")
	    cube ([SDCARD_HOLLOWOUT_WIDTH, SDCARD_HOLLOWOUT_LENGTH, 50], center = true);
	}
	translate ([-SBUS_WIDTH / 2 + JTAG_HOLLOWOUT_WIDTH / 2 + JTAG_HOLLOWOUT_OFFSET,
                MY_FULL_LENGTH / 2 + JTAG_HOLLOWOUT_LENGTH / 2,
              0]) {
	  color ("yellow")
	    cube ([JTAG_HOLLOWOUT_WIDTH, JTAG_HOLLOWOUT_LENGTH, 50], center = true);
	}
    
    /* USB */
	translate ([SBUS_WIDTH / 2 - USBCABLE_HOLLOWOUT_WIDTH / 2 + 5+ USBCABLE_HOLLOWOUT_OFFSETX,
                MY_FULL_LENGTH / 2 + USBCABLE_HOLLOWOUT_LENGTH / 2 + USBCABLE_HOLLOWOUT_OFFSETY,
                0]) {
	  color ("yellow")
	    cube ([USBCABLE_HOLLOWOUT_WIDTH, USBCABLE_HOLLOWOUT_LENGTH, 50], center = true);
                }
    
    
      } // union J
    } // difference I

  } // union A
}

module
extra_holes ()
{
  EXTRA_RAD = 2;
  union ()
  {
      /* border line (fan & jtag sides) */
  for (i =[-8: 16:8]) {
    for (j =[-4: 1:8]) {
        if ((i!=8) || (j < 1))
	translate ([i * 5, j * 5, 0])
	  color ("pink") cylinder (h = 50, r1 = 1.5, r2 = 1.5, center = true);
      }
    }

/* holes in extension */
  for (i =[-6: 2:6]) {
    for (j =[-4: 1:5]) {
        if (((i<-4) || (i>0)) || (add_vga==0))
           if (((i<=2) || i>=8) || (j>-3)) // USB plug
          if (!((i>=5) && (j>=4))) // USB weakness
	translate ([i * 5, j * 5, 0])
	  color ("pink") cylinder (h = 50, r1 = EXTRA_RAD, r2 = EXTRA_RAD, center = true);
      }
    }
/* holes in extension */
  for (i =[-7: 2:7]) {
    for (j =[-4.5: 1:4.5]) {
        if (((i<-5) || (i>1)) || (j>0 && j<4 ) || (add_vga==0))
           if (((i<=2) || i>=7) || (j>-3)) // USB plug
	translate ([i * 5, j * 5, 0])
	  color ("pink") cylinder (h = 50, r1 = EXTRA_RAD, r2 = EXTRA_RAD, center = true);
      }
    }
/* holes in support */
  for (i =[-4: 2:6]) {
    for (j =[5: 1:8]) {
        if (((i<-4) || (i>0)) || (j>5) || (add_vga==0))
          if (!((i==6) && (j>=5) && (j<=8))) // USB weakness
	  translate ([i * 5, j * 5, 0])
	    color ("pink") cylinder (h = 50, r1 = EXTRA_RAD, r2 = EXTRA_RAD, center = true);
      }
    }
/* holes in support */
  for (i =[-5: 2:7]) {
    for (j =[5.5: 1:8.5]) {
      if (!((i==5) && (j > 7)) && !((i==-5) && (j > 7))) // fixation holes are there
          if (!((i==7) && (j>=5.5) && (j<=7.5))) // USB weakness
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

module vga_support() {
    /* plug */
    union() {
        color ("grey") 
      translate ([-SBUS_WIDTH/2+31,
        0.001-MY_FULL_LENGTH/2-1/2,
        14.8/2-SBUS_THICKNESS/2-SBUS_BACKPLATE_BOTTOM_TO_BOARD_BOTTOM-SBUS_BACKPLATE_PROTUSION_HEIGHT + 3.12])
	  cube ([31.8+10, 2, 14.8], center = true);
    }
    
    /* pcb */
        if (0) color ("violet") 
      translate ([-SBUS_WIDTH/2+31,
        0,
        0.00000000001 - SBUS_THICKNESS / 2 - (SBUS_BACKPLATE_PROTUSION_HEIGHT + SBUS_BACKPLATE_BOTTOM_TO_BOARD_BOTTOM) / 2]) 
	  cube ([19.2+4, MY_FULL_LENGTH,
		 SBUS_BACKPLATE_PROTUSION_HEIGHT + SBUS_BACKPLATE_BOTTOM_TO_BOARD_BOTTOM], center = true);
        if (0) color ("violet") 
      translate ([-SBUS_WIDTH/2+31,
        -MY_FULL_LENGTH/2+22/2,
        0.00000000001 - SBUS_THICKNESS / 2 - (SBUS_BACKPLATE_PROTUSION_HEIGHT + SBUS_BACKPLATE_BOTTOM_TO_BOARD_BOTTOM) / 2])
	  cube ([31.8+4, 22,	/*SBUS_THICKNESS */
		 SBUS_BACKPLATE_PROTUSION_HEIGHT + SBUS_BACKPLATE_BOTTOM_TO_BOARD_BOTTOM], center = true);
        
        color ("violet") 
      translate ([-SBUS_WIDTH/2+31,
        -MY_FULL_LENGTH/2+5/2+3.5,
        0.00000000001 - SBUS_THICKNESS / 2 - (SBUS_BACKPLATE_PROTUSION_HEIGHT + SBUS_BACKPLATE_BOTTOM_TO_BOARD_BOTTOM) / 2])
	  cube ([31.8+8, 4,	/*SBUS_THICKNESS */
		 SBUS_BACKPLATE_PROTUSION_HEIGHT + SBUS_BACKPLATE_BOTTOM_TO_BOARD_BOTTOM], center = true);
        color ("violet") 
      translate ([-SBUS_WIDTH/2+31,
        -MY_FULL_LENGTH/2+5/2+15,
        0.00000000001 - SBUS_THICKNESS / 2 - (SBUS_BACKPLATE_PROTUSION_HEIGHT + SBUS_BACKPLATE_BOTTOM_TO_BOARD_BOTTOM) / 2])
	  cube ([31.8+8, 4,	/*SBUS_THICKNESS */
		 SBUS_BACKPLATE_PROTUSION_HEIGHT + SBUS_BACKPLATE_BOTTOM_TO_BOARD_BOTTOM], center = true);
}

module vga_carveout() {
    union() {
        /* plug */
        color ("yellow") 
      translate ([-SBUS_WIDTH/2+31,
        -0-MY_FULL_LENGTH/2-1/2,
        0.001/2+14.5/2])
	  cube ([18, 5+0.001, 10], center = true); // hole big enough for the cable shield
                  
                  
      translate ([-SBUS_WIDTH/2+31-12.5,
        -MY_FULL_LENGTH/2-1/2,
        6.3+SBUS_THICKNESS/2]) rotate([90,0,0]) color ("yellow") cylinder (h = 10, r1 = 1.6, r2 = 1.6, center = true);
      translate ([-SBUS_WIDTH/2+31+12.5,
        -MY_FULL_LENGTH/2-1/2,
        6.3+SBUS_THICKNESS/2]) rotate([90,0,0]) color ("yellow") cylinder (h = 10, r1 = 1.6, r2 = 1.6, center = true);
        /* pcb */
        
        color ("yellow") 
      translate ([-SBUS_WIDTH/2+31,
        0,
        -0.001]) 
	  cube ([19.2+0.8, MY_FULL_LENGTH+0.001, SBUS_THICKNESS + 0.003], center = true);
      
        color ("yellow")
      translate ([-SBUS_WIDTH/2+31,
        0.5-MY_FULL_LENGTH/2+23/2,
        -0.001+14.5/2-0.5])
	  cube ([32+0.8, 1+23+0.001, SBUS_THICKNESS + 0.003+14.5-1], center = true);
        
        
        
      
      color ("yellow") 
      translate ([-SBUS_WIDTH/2+31,
        MY_FULL_LENGTH/2-10-2,
        0]) 
	  cube ([19.2+0.8, 20, 50], center = true);
          
          
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
    /* extra -2 (translate) and -4 (size) for usb */
    translate([(SBUS_WIDTH-fan_carrier_depth)/2-fan_depth+0.5,carrier_offset-2.4-2,0]) {
        color("purple") cube([fan_carrier_depth+5, fan_width+fan_extra_height+8-4, SBUS_THICKNESS], center = true);
    }
      // strut between the backplate and the fan carrier
    /* extra -2 (translate) and -4 (size) for usb */
	translate ([(SBUS_WIDTH-fan_carrier_depth)/2-fan_depth, carrier_offset-1-2, (SBUS_BACKPLATE_FULLHEIGHT-5)/2-SBUS_THICKNESS/2-SBUS_BACKPLATE_BOTTOM_TO_BOARD_BOTTOM]) color ("purple") cube ([fan_carrier_depth/2, 38-4,SBUS_BACKPLATE_FULLHEIGHT-5 ], center = true);
    
    translate ([(SBUS_WIDTH-fan_carrier_depth)/2-fan_depth, carrier_offset-(fan_width+fan_extra_height)/2-triangle_width/2, triangle_height/2-SBUS_THICKNESS/2-SBUS_BACKPLATE_BOTTOM_TO_BOARD_BOTTOM+SBUS_BACKPLATE_FULLHEIGHT-5]) rotate([0,90,0]) color("pink") translate([0,0,-fan_carrier_depth/4]) linear_extrude(height=fan_carrier_depth/2) polygon( points=[[triangle_height/2,-triangle_width/2],[-triangle_height/2,triangle_width/2],[triangle_height/2,triangle_width/2]] );
    
    /* incompatible with usb */
    if (0) translate ([(SBUS_WIDTH-fan_carrier_depth)/2-fan_depth, carrier_offset+(fan_width+fan_extra_height)/2+triangle_width/2, triangle_height/2-SBUS_THICKNESS/2-SBUS_BACKPLATE_BOTTOM_TO_BOARD_BOTTOM+SBUS_BACKPLATE_FULLHEIGHT-5]) rotate([0,90,0]) color("pink") translate([0,0,-fan_carrier_depth/4]) linear_extrude(height=fan_carrier_depth/2) polygon( points=[[triangle_height/2,-triangle_width/2],[-triangle_height/2,-triangle_width/2],[triangle_height/2,triangle_width/2]] );

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

if (add_fan!=0) fan_25mm_support();
if (add_vga!=0) vga_support();
}

if (add_fan!=0) fan_25mm_carveout();
if (add_vga!=0) vga_carveout();
}
