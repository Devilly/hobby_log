text = "Test";
fontSize = 10;
textDepth = 2;
solidDepth = 2;
blockDepth = textDepth + solidDepth;
margin = 3;

metrics = textmetrics(text, fontSize);

difference() {
    // Adding - 0.001 so the text and polygon don't stop at the same height and confuse OpenSCAD
    translate([metrics.position.x - margin, metrics.position.y - margin, -solidDepth - 0.001])
    rotate([0, -270, 0])
    linear_extrude(metrics.size.x + margin * 2)
    // Adapt below code to make the containing object something more special than a cube
    polygon([
        [0, 0],
        [0, metrics.size.y + margin * 2],
        [-blockDepth, metrics.size.y + margin * 2],
        [-blockDepth, 0]]);

    linear_extrude(textDepth)
    text(text, fontSize);
}