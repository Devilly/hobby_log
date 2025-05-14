$fn = 100;

cross_border_margin = 0.01;

plate_width = 35;
plate_height = 70;
plate_depth = 3;
distance_peg_and_hollow = 51;

screw_head_top_diameter = 5.65;
screw_head_bottom_diameter = 3.09;
screw_head_height = 2.5;
screw_head_slope = (screw_head_top_diameter - screw_head_bottom_diameter) / screw_head_height;
screw_hole_top_diameter = screw_head_bottom_diameter + plate_depth * screw_head_slope;

screw_hole_margin = 3;

module ScrewHole() {
    cylinder(h = plate_depth + cross_border_margin, d1 = screw_head_bottom_diameter, d2 = screw_hole_top_diameter, center = true);
}

difference() {
    minkowski() {
        plate_rounding = 1;
        
        cube([plate_height - 2 * plate_rounding, plate_width - 2 * plate_rounding, plate_depth - 2 * plate_rounding], center=true);
        cylinder(h = plate_rounding * 2, r = plate_rounding, center=true);
    }
    
    translate([plate_height / 2 - screw_hole_top_diameter / 2 - screw_hole_margin, plate_width / 2 - screw_hole_top_diameter / 2 - screw_hole_margin, 0])
    ScrewHole();
    
    translate([plate_height / 2 - screw_hole_top_diameter / 2 - screw_hole_margin, -plate_width / 2 + screw_hole_top_diameter / 2 + screw_hole_margin, 0])
    ScrewHole();
    
    translate([-plate_height / 2 + screw_hole_top_diameter / 2 + screw_hole_margin, plate_width / 2 - screw_hole_top_diameter / 2 - screw_hole_margin, 0])
    ScrewHole();
    
    translate([-plate_height / 2 + screw_hole_top_diameter / 2 + screw_hole_margin, -plate_width / 2 + screw_hole_top_diameter / 2 + screw_hole_margin, 0])
    ScrewHole();
}

lower_peg_diameter = 9;
lower_peg_depth = 4;
lower_peg_rounding = 1;

translate([distance_peg_and_hollow / 2, 0, plate_depth / 2 + lower_peg_depth / 2])
union() {
    minkowski() {
        cylinder(h = lower_peg_depth - 2 * lower_peg_rounding, d = lower_peg_diameter - 2 * lower_peg_rounding, center = true);
        sphere(r = lower_peg_rounding);
    }

    translate([0, 0, -lower_peg_rounding])
    cylinder(h = lower_peg_depth - 2 * lower_peg_rounding, d = lower_peg_diameter, center = true);
}

upper_peg_slider_depth = 1.9;
upper_peg_slider_diameter = 9;
upper_peg_base_depth = 2.3;
upper_peg_base_diameter = 5;

translate([-distance_peg_and_hollow / 2, 0, plate_depth / 2 + upper_peg_base_depth / 2])
union() {
    cylinder(h = upper_peg_base_depth, d = upper_peg_base_diameter, center = true);
    
    translate([0, 0, upper_peg_base_depth / 2 + upper_peg_slider_depth / 2])
    cylinder(h = upper_peg_slider_depth, d = upper_peg_slider_diameter, center = true);
}