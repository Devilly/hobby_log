/*

Card storage:

* 10cm height
* 7.5cm width
* 3cm depth

Coin storage:

* two layers, lower layer
    * small coins
    * 2cm depth
    * 4cm diameter
* two layers, upper layer
    * big coin
    * 0.5cm depth
    * 6cm diameter
    
*/

widthCardStorage = 75;
heightCardStorage = 100;
depthCardStorage = 20;

diameterSmallCoinStorage = 40;
depthSmallCoinStorage = 20;

diameterBigCoinStorage = 60;
depthBigCoinStorage = 5;

widthWall = 5;
widthSeparation = 2;

depthCoinStorage = depthSmallCoinStorage + depthBigCoinStorage;
maxWidthElement = max(widthCardStorage, diameterBigCoinStorage);
maxDepthElement = max(depthCardStorage, depthCoinStorage);

widthContainer = maxWidthElement * 2 + widthWall * 2 + widthSeparation;
heightContainer = heightCardStorage + widthWall * 2 + widthSeparation + diameterBigCoinStorage;
depthContainer = maxDepthElement + widthWall;

rounding = 5;

difference() {
    // container
    translate([rounding, rounding, 1])
    minkowski()
    {
        cube([widthContainer - 2 * rounding, heightContainer - 2 * rounding, depthContainer - 2]);
        cylinder(2, rounding, rounding, true);
    }
    
    // card holder, left
    translate([widthWall + maxWidthElement / 2, widthWall + heightCardStorage / 2, 21])
    cube([widthCardStorage, heightCardStorage, depthCardStorage], true);
    
    // card holder, right
    translate([widthContainer - widthWall - maxWidthElement / 2, widthWall + heightCardStorage / 2, 21])
    cube([widthCardStorage, heightCardStorage, depthCardStorage], true);
    
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