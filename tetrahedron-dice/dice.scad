$fn = 50;

edge_length = 20;

position_vertex_a = [0, 0, 0];
position_vertex_b = [edge_length, 0, 0];

halfway_length = sqrt(edge_length^2 - (edge_length / 2)^2);
echo("Halfway length", halfway_length);

position_vertex_c = [edge_length / 2, halfway_length, 0];

middle_point = [(position_vertex_a[0] + position_vertex_b[0] + position_vertex_c[0]) / 3, (position_vertex_a[1] + position_vertex_b[1] + position_vertex_c[1]) / 3];
echo("Middle point", middle_point);

middle_point_to_b_edge = sqrt(middle_point[1]^2 + (edge_length / 2)^2);
echo("Edge middle -> B", middle_point_to_b_edge);

middle_point_height = sqrt(edge_length^2 - middle_point_to_b_edge^2);
echo("Middle point height", middle_point_height);

module tetrahedron() {
    hull() {
        translate(position_vertex_a) {
            sphere(1);
        }
        
        translate(position_vertex_b) {
            sphere(1);
        }
        
        translate(position_vertex_c) {
            sphere(1);
        }
        
        translate([middle_point[0], middle_point[1], middle_point_height]) {
            sphere(1);
        }
    }
}

edge_middle_angle = atan(middle_point_height / middle_point[1]);
echo("Edge middle angle", edge_middle_angle);

difference() {
    tetrahedron();
    
    translate([edge_length / 2, middle_point[1], 0])
    linear_extrude(2, center=true)
    text("M", edge_length / 3, halign="center", valign="center");
    
    rotate([edge_middle_angle, 0, 0])
    translate([edge_length / 2, middle_point[1], 0])
    linear_extrude(2, center=true)
    text("C", edge_length / 3, halign="center", valign="center");
    
    translate([edge_length / 4 * 3, halfway_length / 2, 0])
    rotate([0, 0, 120])
    rotate([edge_middle_angle, 0, 0])
    translate([0, middle_point[1], 0])
    linear_extrude(2, center=true)
    text("D", edge_length / 3, halign="center", valign="center");
    
    translate([edge_length / 4, halfway_length / 2, 0])
    rotate([0, 0, -120])
    rotate([edge_middle_angle, 0, 0])
    translate([0, middle_point[1], 0])
    linear_extrude(2, center=true)
    text("I", edge_length / 3, halign="center", valign="center");
}




