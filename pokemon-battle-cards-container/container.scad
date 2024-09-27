$fn = 100;

widthCardStorage = 69;
heightCardStorage = 96;
depthCardStorage = 30;

diameterSmallCoinStorage = 40;
depthSmallCoinStorage = 20;

diameterBigCoinStorage = 60;
depthBigCoinStorage = 5;

widthWall = 5;
heightLid = widthWall;
widthSeparation = 2;

depthCoinStorage = depthSmallCoinStorage + depthBigCoinStorage;
maxWidthElement = max(widthCardStorage, diameterBigCoinStorage);
maxDepthElement = max(depthCardStorage, depthCoinStorage);

widthContainer = maxWidthElement * 2 + widthWall * 2 + widthSeparation;
heightContainer = heightCardStorage + widthWall * 2 + widthSeparation + diameterBigCoinStorage;
depthContainer = maxDepthElement + widthWall;

rounding = 5;

fingerGap = 15;

// container
difference() {
    union() {
        difference() {
            // container
            translate([rounding, rounding, 1])
            minkowski()
            {
                cube([widthContainer - 2 * rounding, heightContainer - 2 * rounding, depthContainer - 2]);
                cylinder(2, r=rounding, center=true);
            }
            
            // card holder, left
            translate([widthWall + maxWidthElement / 2, widthWall + heightCardStorage / 2, depthCardStorage / 2 + widthWall])
            cube([widthCardStorage, heightCardStorage, depthCardStorage + 1], true);
            
            // card holder, right
            translate([widthContainer - widthWall - maxWidthElement / 2, widthWall + heightCardStorage / 2, depthCardStorage / 2 + widthWall])
            cube([widthCardStorage, heightCardStorage, depthCardStorage + 1], true);
            
            // coin holder, left
            xLeftCoinStorage = widthWall + maxWidthElement / 2;
            yCoinStorage = heightContainer - widthWall - diameterBigCoinStorage / 2;
            
            // coin holder, left, big coin
            translate([xLeftCoinStorage, yCoinStorage, depthContainer - depthBigCoinStorage / 2 + 1])
            cylinder(h=depthBigCoinStorage, d=diameterBigCoinStorage, center=true);
            
            // coin holder, left, small coins
            translate([xLeftCoinStorage, yCoinStorage, depthContainer - depthBigCoinStorage - depthSmallCoinStorage / 2 + 2])
            cylinder(h=depthSmallCoinStorage, d=diameterSmallCoinStorage, center=true);
            
            // coin holder, right
            xRightCoinStorage = widthContainer - widthWall - maxWidthElement / 2;

            // coin holder, right, big coin
            translate([xRightCoinStorage, yCoinStorage, depthContainer - depthBigCoinStorage / 2 + 1])
            cylinder(h=depthBigCoinStorage, d=diameterBigCoinStorage, center=true);
            
            // coin holder, right, small coins
            translate([xRightCoinStorage, yCoinStorage, depthContainer - depthBigCoinStorage - depthSmallCoinStorage / 2 + 2])
            cylinder(h=depthSmallCoinStorage, d=diameterSmallCoinStorage, center=true);
        }

        // hightened border of container
        difference()
        {
            translate([rounding, rounding, depthContainer + 1])
            minkowski()
            {
                cube([widthContainer - 2 * rounding, heightContainer - 2 * rounding, heightLid - 2]);
                cylinder(2, r=rounding, center=true);
            }
            
            translate([widthWall, widthWall, 0])
            cube([widthContainer - 2 * widthWall, heightContainer - 2 * widthWall, 100]);
        }
    }
     
        // card holder notch, left
        translate([widthWall + 1, widthWall + heightCardStorage / 2, fingerGap / 2 + widthWall])
        rotate([0, -90, 0])
        union() {
            cylinder(widthWall + 2, d=fingerGap);
            
            translate([0, -(fingerGap / 2), 0])
            cube([depthCardStorage + heightLid, fingerGap, widthWall + 2], false);
        }
        
        // card holder notch, right
        translate([widthWall * 2 + widthSeparation + widthCardStorage * 2 + 1, widthWall + heightCardStorage / 2, fingerGap / 2 + widthWall])
        rotate([0, -90, 0])
        union() {
            cylinder(widthWall + 2, d=fingerGap);
            
            translate([0, -(fingerGap / 2), 0])
            cube([depthCardStorage + heightLid, fingerGap, widthWall + 2], false);
        }
}
 
 // lid
translate([300, heightContainer / 2, heightLid / 2])
union()
{
    printMargin = 2;
    
    cube([widthContainer - 2 * rounding - printMargin, heightContainer - 2 * rounding - printMargin, heightLid - printMargin], true);
    
    translate([0, 0, heightLid - printMargin])
    difference()
    {
        minkowski()
        {
            cube([widthContainer - 2 * rounding, heightContainer - 2 * rounding, heightLid - 2], true);
            cylinder(2, r=rounding, center=true);
        }
        
        textSize = 20;
    
        translate([0, 0, heightLid / 2 - heightLid / 4])
        linear_extrude()
        text("Pokémon", size=textSize, font="Pocket Monk", halign="center", valign="center");
    }
}