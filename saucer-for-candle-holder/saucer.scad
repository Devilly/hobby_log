$fn = 100;

diameter_inside = 109;
height_inside = 15;
height_foot = 2;
diameter_foot = diameter_inside + 6;

translate([0, 0, height_foot])
cylinder(h = height_inside, d = diameter_inside);

cylinder(h = height_foot, d = diameter_foot);