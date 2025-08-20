// Trojan Horse on Four-Wheeled Platform
// Units: mm (scale to real-world sizes)
// Total horse height: ~3000 mm from platform top to head top

// Dimensions
platform_length = 3000;  // 4m long
platform_width = 1600;   // 2m wide
platform_thickness = 200; // 0.2m thick
wheel_radius = 300;      // Wheel size
wheel_thickness = 100;
clearance = 10;          // Small gap between platform and wheels

horse_leg_height = 1200; // Legs
horse_leg_bottom_diam = 250;
horse_leg_top_diam = 300;
horse_body_length = 2200;
horse_body_radius = 600;
horse_neck_height = 800;
horse_neck_bottom_diam = 500;
horse_neck_top_diam = 400;
horse_head_length = 900;
horse_head_radius = 400;
horse_tail_length = 800;
horse_tail_diam = 200;
horse_mane_length = 600;
horse_ear_height = 150;

$fn = 10;
// Calculate platform bottom z
platform_z = wheel_radius + clearance + platform_thickness / 2;

// Platform base
translate([0, 0, platform_z]) {
    cube([platform_length, platform_width, platform_thickness], center = true);
}

// Wheels (centered on platform edges, oriented for lengthways rolling)
wheel_positions = [
    [-platform_length/2 + wheel_radius * 1.2, -platform_width/2],
    [-platform_length/2 + wheel_radius * 1.2, platform_width/2],
    [platform_length/2 - wheel_radius * 1.2, -platform_width/2],
    [platform_length/2 - wheel_radius * 1.2, platform_width/2]
];

for (pos = wheel_positions) {
    translate([pos[0], pos[1], wheel_radius]) {
        rotate([90, 0, 0]) {  // Axis along y, rolls along x (lengthways)
            cylinder(h = wheel_thickness, r = wheel_radius, center = true, $fn = 100);
        }
    }
}

// Horse legs (tapered and slightly angled for realism)
leg_positions = [
    [-horse_body_length/2.4, -horse_body_radius + horse_leg_top_diam / 2, platform_z + platform_thickness / 2],
    [-horse_body_length/2.4, horse_body_radius - horse_leg_top_diam / 2, platform_z + platform_thickness / 2],
    [horse_body_length/2.4, -horse_body_radius + horse_leg_top_diam / 2, platform_z + platform_thickness / 2],
    [horse_body_length/2.4, horse_body_radius - horse_leg_top_diam / 2, platform_z + platform_thickness / 2]
];

for (i = [0:3]) {
    pos = leg_positions[i];
    angle = (i < 2 ? 10 : -10);  // Slight outward angle for front/rear
    translate([pos[0], pos[1], pos[2]]) {
        rotate([5 * sign(pos[1]), angle, 0]) {
            linear_extrude(height = horse_leg_height, scale = horse_leg_bottom_diam / horse_leg_top_diam) {
                square(horse_leg_top_diam, center = true);
            }
        }
    }
}

// Horse body (horizontal cylinder)
body_z = platform_z + platform_thickness / 2 + horse_leg_height + horse_body_radius - 200;
translate([0, 0, body_z]) rotate([0, 90, 0]) scale([1.2,0.9,0.8]) cylinder(h = horse_body_length, r = horse_body_radius, $fn = 16,center=true);

// Horse neck (tapered, angled)
neck_z = body_z + horse_body_radius / 2;
translate([horse_body_length / 2.3, 0, neck_z]) {
    rotate([0, 40, 0]) {
        cylinder(h = horse_neck_height, r1 = horse_neck_bottom_diam / 2, r2 = horse_neck_top_diam / 2, $fn = 10);
    }
}

// Horse head (sphere skull + cylinder muzzle)
head_z = neck_z + horse_neck_height - 100;
translate([horse_body_length / 1.8 + horse_head_length / 2, 0, head_z]) {
    union() {
        // main head
        rotate([90,0,0]) {
            cylinder(h = horse_neck_top_diam, r = horse_head_radius,center = true);}
        // nose
        rotate([0,160,0]) {
            translate([-horse_head_radius/2.8,0,0])
            linear_extrude(height = horse_head_length, scale =    0.7) {
                        square(horse_neck_top_diam*1.2, center = true);}
                    }
        // mane
        rotate([90,0,0]) {
            union() {
                intersection() {
                    cylinder(h = horse_neck_top_diam/2, r = horse_head_radius*1.6,center = true);
                    rotate([0,0,30]) translate([0,horse_mane_length*2,0]) cube(horse_mane_length*4,center = true);
                }
                rotate([0,0,40]) translate([-horse_head_radius*2,horse_head_radius-10,0]) cube([horse_neck_top_diam*4,horse_neck_top_diam*1.1,horse_neck_top_diam/2],center=true);
            }
        }
    }
}

// Horse tail (curved, tapered)
translate([-horse_body_length / 2 +100, 0, body_z + horse_body_radius -100]) {
    rotate([90, 10, 0]) union() {
        cylinder(h = horse_tail_diam, r = horse_tail_length / 2,center=true);
        translate([0,-horse_tail_diam*2,0]) cube([horse_tail_diam*4,horse_tail_diam*4,horse_tail_diam],center=true);
    }
}
// Haunches
translate([horse_body_length/3,0,horse_leg_height*1.75]) scale([1,1.1,1.4]) sphere(r=horse_body_radius);
translate([-horse_body_length/3,0,horse_leg_height*1.75]) scale([1,1.1,1.4]) sphere(r=horse_body_radius);
