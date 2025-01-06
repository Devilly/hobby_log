tea_bag_width = 57;
tea_bag_height = 65;

bags_hollow_width = tea_bag_width + 3;
bags_hollow_height = tea_bag_height + 5;

border_wall = 3;
inner_wall = 2;

margin = 0.001;

container_depth = 180;
number_of_depth_hollows = 3;
container_width = bags_hollow_width * 2 + border_wall * 2 + inner_wall;
container_height = bags_hollow_height + border_wall;

difference() {
    cube([container_width, container_depth, container_height]);
    
    bags_hollow_depth = (container_depth - border_wall * 2 - inner_wall * (number_of_depth_hollows - 1)) / number_of_depth_hollows;
    
    echo(bags_hollow_depth);
    
    for(xValue = [1:2]) {
        for(yValue = [1:number_of_depth_hollows]) {
            translate(
                [
                    border_wall + (xValue - 1) * inner_wall + (xValue - 1) * bags_hollow_width,
                    border_wall + (yValue - 1) * inner_wall + (yValue - 1) * bags_hollow_depth,
                    border_wall + margin
                ]
            )
            cube([bags_hollow_width, bags_hollow_depth, bags_hollow_height]);
        }
    }
}