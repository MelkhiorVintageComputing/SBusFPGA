LENGTH = 77.8;
WIDTH = 4;
WIDTH2 = 2;
HEIGHT = 19.3;
THICKNESS = 2.5;
THICKNESS2V = 4;
THICKNESS2H = 2;
PINHEIGHT_HOLE = 1.7;
PINHEIGHT_THICK = 2;
PINHEIGHT = PINHEIGHT_HOLE + PINHEIGHT_THICK;
PIN_RADIUS = 3.6 / 2;
PIN_INT_WIDTH = 1.6;		// .2 short for flat surface
PINHOLE_OFFSET = 1.6;


module
body ()
{
  translate ([0, 0, -THICKNESS / 2]) cube ([LENGTH, WIDTH, THICKNESS],
					   center = true);
  translate ([0, 0, -THICKNESS / 2 - THICKNESS2V / 2]) cube ([LENGTH, WIDTH2,
							      THICKNESS2V],
							     center = true);
  color("pink") translate ([+LENGTH / 2 - THICKNESS/2, 0, -HEIGHT / 2]) cube ([THICKNESS, WIDTH, HEIGHT],
						  center = true);
  color("pink") translate ([-LENGTH / 2 + THICKNESS/2, 0, -HEIGHT / 2]) cube ([THICKNESS, WIDTH, HEIGHT],
						  center = true);
  color("blue") translate ([+LENGTH / 2-THICKNESS-THICKNESS2H/2, 0, -HEIGHT / 2]) cube ([THICKNESS2H,
							       WIDTH2,
							       HEIGHT],
							      center = true);
  color("blue") translate ([-LENGTH / 2+THICKNESS+THICKNESS2H/2, 0, -HEIGHT / 2]) cube ([THICKNESS2H,
							       WIDTH2,
							       HEIGHT],
							      center = true);
}

module
pin_negative_hole() {
    translate([0,0,PINHEIGHT/2-PINHEIGHT_HOLE/2])
    difference() {
    color ("purple") cylinder (r1 = 10, r2 = 10, h = PINHEIGHT_HOLE, center = true);
    color("black") translate([-1.8,0,0]) cylinder (r1 = PIN_RADIUS, r2 = PIN_RADIUS, h = 2*PINHEIGHT_HOLE, center = true);
    }
}

module
pin_negative ()
{
  union ()
  {
    difference ()
    {
      union ()
      {
	color ("purple") cylinder (r1 = 10, r2 = 10, h = 10, center = true);
      }
      union ()
      {
	cylinder (r1 = PIN_RADIUS, r2 = PIN_RADIUS, h = 30, center = true);
      }
    }

    color ("red") translate ([PIN_INT_WIDTH + 5, 0, 0]) cube ([10, 10, 10],
							      center = true);
    pin_negative_hole();
  }
}

module
pin ()
{
  translate([0,0,-PINHEIGHT/2])
    difference ()
  {
    union ()
    {
      translate([0,0,0.0001]) color ("green") cylinder (r1 = PIN_RADIUS, r2 = PIN_RADIUS, h =
				PINHEIGHT+0.0001, center = true);
    }
    pin_negative ();
  }
}

module retainer() {
    body();
    translate([-LENGTH/2+PIN_RADIUS,0,-HEIGHT]) pin();
    translate([+LENGTH/2-PIN_RADIUS,0,-HEIGHT]) rotate([0,0,180]) pin();
}

retainer();