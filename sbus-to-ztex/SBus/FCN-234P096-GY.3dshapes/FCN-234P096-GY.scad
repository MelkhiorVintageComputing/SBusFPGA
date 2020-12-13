SBUS_A=71.0;
SBUS_B=59.69;
SBUS_C=64.06;
SBUS_HOLE_WIDE=64.06;
SBUS_HOLE_NARROW=59.69;
SBUS_HOLE_WIDTH=5.7;
SBUS_WIDTH=7.3;
SBUS_HEIGHT=9.3;

HolePoints = [
  [ -SBUS_HOLE_NARROW/2, -SBUS_HOLE_WIDTH/2, -SBUS_HEIGHT/2+3 ],  //0
  [ +SBUS_HOLE_NARROW/2, -SBUS_HOLE_WIDTH/2, -SBUS_HEIGHT/2+3 ],  //1
  [ +SBUS_HOLE_WIDE/2, +SBUS_HOLE_WIDTH/2, -SBUS_HEIGHT/2+3 ],  //2
  [ -SBUS_HOLE_WIDE/2, +SBUS_HOLE_WIDTH/2,  ],  //3
  [ -SBUS_HOLE_NARROW/2, -SBUS_HOLE_WIDTH/2,  20 ],  //4
  [ +SBUS_HOLE_NARROW/2, -SBUS_HOLE_WIDTH/2,  20 ],  //5
  [ +SBUS_HOLE_WIDE/2, +SBUS_HOLE_WIDTH/2,  20 ],  //6
  [ -SBUS_HOLE_WIDE/2, +SBUS_HOLE_WIDTH/2,  20 ],  //7
  ]; //7
  
HoleFaces = [
  [0,1,2,3],  // bottom
  [4,5,1,0],  // front
  [7,6,5,4],  // top
  [5,6,2,1],  // right
  [6,7,3,2],  // back
  [7,4,0,3]]; // left

difference() {  
color("black") cube([SBUS_A, SBUS_WIDTH, SBUS_HEIGHT], center=true);
color("black") polyhedron( HolePoints, HoleFaces );
}

for (i = [0 : 47]) {
translate([-SBUS_B/2+i*1.27, -1.27, 0]) {
  color("silver") cylinder(h = 8, r1 = 0.2, r2 = 0.2, center = true);
}
translate([-SBUS_B/2+i*1.27, +1.27, 0]) {
  color("silver") cylinder(h = 8, r1 = 0.2, r2 = 0.2, center = true);
}
}