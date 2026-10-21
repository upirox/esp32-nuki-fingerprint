// ============================================================
//  Custom plate for an Italian 503 wall box (3-module flush box)
//  0.96" SPI OLED display | R503 fingerprint reader | AM312 PIR |
//  doorbell push button | buzzer
//  Reed tamper switch (magnet glued inside the box)
//  Perimeter seal: 2 mm rubber cord (nitrile or closed-cell silicone
//  foam) pressed into a groove on the back (seal = "cord"), or a TPU
//  gasket printed separately or as multi-material (seal = "tpu").
//
//  CORD: cut it as long as the groove, starting on one side of the drain
//  gap at the bottom and ending on the other. Push it into the groove
//  without pulling (if you stretch it, it shrinks back later) and seal
//  both ends with a drop of cyanoacrylate. It protrudes ~0.5 mm and gets
//  squeezed when the screws are tightened.
//
//  It screws straight onto the 503 box (83.5 mm screw spacing) instead
//  of the standard frame + cover plate.
//  All dimensions are in mm and can be changed below.
//  Before printing the final version, print a low-density test and
//  check the holes against the real parts.
// ============================================================

/* [Plate] */
plate_w      = 120;   // width
plate_h      = 80;    // height
plate_t      = 3.5;   // thickness (the R503 nut clamps up to ~10 mm)
corner_r     = 5;     // corner radius
edge_chamfer = 0.8;   // front edge chamfer

/* [503 box screws] */
screw_pitch  = 83.5;  // standard 503 screw spacing
screw_d      = 3.6;   // through hole
screw_head_d = 7;     // countersunk head
screw_head_h = 2;

/* [0.96" OLED display (25.2 x 26 board)] */
oled_x       = -19;   // board centre position
oled_y       = 13;
oled_pcb_w   = 25.2;
oled_pcb_h   = 26;
oled_win_w   = 23;    // visible window (active area ~21.7 x 10.9)
oled_win_h   = 12.5;
oled_win_dy  = 1.5;   // window centre relative to board centre (+ = towards the pins)
oled_glass_t = 1.7;   // glass thickness above the PCB = standoff height
oled_hole_dx = 20.8;  // board hole spacing, horizontal
oled_hole_dy = 21.6;  //                   vertical
oled_pin_d   = 1.7;   // pins that go into the board holes (secure with heat or glue)
oled_pin_h   = 3.5;
oled_post_d  = 4;

/* [R503 reader (M25 thread, 28 mm flange)] */
r503_x       = 12;
r503_y       = 0;
r503_hole_d  = 25.6;  // M25 thread clearance

/* [AM312 PIR (~10 mm lens, 12 mm wide)] */
pir_x        = 36;
pir_y        = 14;
pir_hole_d   = 10.2;  // the lens goes through, the 12 mm rim seats against the plate
pir_boss_h   = 3;     // centring ring behind the plate
pir_boss_w   = 1.6;

/* [Vandal-proof doorbell button (22 head, 19 hole, 14 thread, 27 depth)] */
btn_x        = -22;
btn_y        = -13.5;
btn_hole_d   = 19.3;  // 19 mm mounting hole + clearance

/* [Buzzer (32.5 x 13 module, hidden behind the plate)] */
buzz_x        = -40;   // centre of the buzzer cylinder
buzz_y        = 14;
buzz_d        = 12;    // buzzer cylinder diameter
buzz_h        = 9.5;   // cylinder height above the PCB
buzz_ring_h   = 6;     // height of the retaining ring
buzz_ring_w   = 1.2;
buzz_pcb_dir  = 1;     // the module extends towards +x (1) or -x (-1)
buzz_hole_off = 9.5;   // distance of the module's M3 hole from the buzzer centre
buzz_use_post = false; // the post would land on the OLED board: the module
                       // is held by the ring + a drop of hot glue
buzz_post_d   = 6;     // post for the module screw
buzz_screw_d  = 2.5;   // hole for an M3 self-tapping screw (or 2.9 mm)
sound_hole_d  = 1.4;   // small sound holes
sound_holes   = true;  // false = solid plate (much quieter sound)

/* [Reed tamper switch (14 x 3.2 mm body, 14 mm leads)] */
// The reed sits in a cradle on the back, parallel to the bottom edge of
// the box. The magnet (6 x 2 mm) is glued to the inside wall of the box,
// facing ONE END of the reed body.
reed_x        = 29;    // centre of the reed body
reed_y        = -22;   // closer to the box edge = stronger magnet effect
reed_len      = 14.4;  // 14 mm body + clearance
reed_w        = 3.5;   // 3.2 mm body + clearance
reed_wall     = 1.2;   // cradle wall thickness
reed_wall_h   = 3.4;   // wall height (the reed fits completely inside)

/* [Seal] */
part             = "all";      // "plate", "gasket" (TPU only) or "all" (preview)
seal             = "cord";   // "cord" (rubber cord in the groove), "tpu" or "none"

/* [Rubber cord] */
cord_d           = 2;        // cord diameter
groove_w         = 2.0;      // groove width: = diameter, the cord stays in place
                             // (2.1 if it is hard to push in; closed-cell silicone foam: groove_depth 1.1)
groove_depth     = 1.45;     // depth: protrudes ~0.55 mm, ~27% squeeze
groove_inset     = 3;        // distance from the plate edge to the groove
                             // (for a 3 mm cord: groove_w 3, depth 2.2, plate_t 4)

/* [TPU gasket (only if seal = "tpu")] */
gasket_inset     = 2.5;      // distance from the plate edge
gasket_w         = 3;        // bead width
gasket_h         = 1.6;      // height (squeezed to ~1 mm when the screws are tight)
gasket_groove    = 0.6;      // depth of the seat in the plate
gasket_drain     = 6;        // gap at the bottom to let condensation out (0 = closed)

$fn = 96;

// ------------------------------------------------------------

module rounded_rect(w, h, r, t) {
    linear_extrude(t)
        offset(r) square([w - 2*r, h - 2*r], center = true);
}

module plate_body() {
    // body with a chamfer on the front edge (front face = z 0)
    hull() {
        translate([0, 0, edge_chamfer])
            rounded_rect(plate_w, plate_h, corner_r, plate_t - edge_chamfer);
        rounded_rect(plate_w - 2*edge_chamfer, plate_h - 2*edge_chamfer,
                     corner_r - edge_chamfer, plate_t);
    }
}

module screw_hole() {
    translate([0, 0, -0.01]) cylinder(d = screw_d, h = plate_t + 0.02);
    // countersink on the front
    translate([0, 0, -0.01])
        cylinder(d1 = screw_head_d, d2 = screw_d, h = screw_head_h);
}

module oled_window() {
    translate([oled_x, oled_y + oled_win_dy, -0.01])
    hull() {
        // window with a bevelled edge towards the front (easier to read from the side)
        linear_extrude(0.01)
            offset(1) square([oled_win_w + 2, oled_win_h + 2] - [2, 2], center = true);
        translate([0, 0, plate_t])
            linear_extrude(0.02)
                offset(0.5) square([oled_win_w, oled_win_h] - [1, 1], center = true);
    }
}

module oled_mounts() {
    for (sx = [-1, 1], sy = [-1, 1])
        translate([oled_x + sx*oled_hole_dx/2, oled_y + sy*oled_hole_dy/2, plate_t]) {
            cylinder(d = oled_post_d, h = oled_glass_t);
            cylinder(d = oled_pin_d, h = oled_glass_t + oled_pin_h);
        }
}

module pir_boss() {
    translate([pir_x, pir_y, plate_t])
        difference() {
            cylinder(d = 12.4 + 2*pir_boss_w, h = pir_boss_h);
            translate([0, 0, -0.01]) cylinder(d = 12.4, h = pir_boss_h + 0.02);
        }
}

module buzzer_mount() {
    // ring holding the buzzer cylinder, facing the plate
    translate([buzz_x, buzz_y, plate_t])
        difference() {
            cylinder(d = buzz_d + 0.3 + 2*buzz_ring_w, h = buzz_ring_h);
            translate([0, 0, -0.01]) cylinder(d = buzz_d + 0.3, h = buzz_ring_h + 0.02);
        }
    // post for the screw: the PCB rests on the buzzer and is fixed here
    if (buzz_use_post)
    translate([buzz_x + buzz_pcb_dir*buzz_hole_off, buzz_y, plate_t])
        difference() {
            cylinder(d = buzz_post_d, h = buzz_h);
            translate([0, 0, 2]) cylinder(d = buzz_screw_d, h = buzz_h);
        }
}

module sound_grille() {
    // 7 small honeycomb holes in front of the buzzer
    if (sound_holes)
        for (p = concat([[0, 0]], [for (a = [0:60:300]) [3*cos(a), 3*sin(a)]]))
            translate([buzz_x + p[0], buzz_y + p[1], -0.01])
                cylinder(d = sound_hole_d, h = plate_t + 0.02, $fn = 24);
}

module reed_cradle() {
    // U cradle open at the ends for the leads; close it with hot glue
    translate([reed_x, reed_y, plate_t])
        difference() {
            translate([-(reed_len)/2, -(reed_w/2 + reed_wall), 0])
                cube([reed_len, reed_w + 2*reed_wall, reed_wall_h]);
            translate([-(reed_len)/2 - 0.1, -reed_w/2, -0.01])
                cube([reed_len + 0.2, reed_w, reed_wall_h + 0.02]);
        }
}

// perimeter ring (plan view) w wide at distance inset from the edge,
// with a drain gap at the bottom
module ring_2d(inset, w) {
    ow = plate_w - 2*inset;
    oh = plate_h - 2*inset;
    r  = max(corner_r - inset, 0.5);
    ri = max(r - w, 0.1);
    difference() {
        offset(r) square([ow - 2*r, oh - 2*r], center = true);
        offset(ri) square([ow - 2*w - 2*ri, oh - 2*w - 2*ri], center = true);
        if (gasket_drain > 0)
            translate([-gasket_drain/2, -plate_h/2 - 1]) square([gasket_drain, w + inset + 2]);
    }
}
module gasket_ring_2d() { ring_2d(gasket_inset, gasket_w); }
module groove_ring_2d() { ring_2d(groove_inset, groove_w); }

// cord (preview only): protrudes from the back of the plate
module cord_preview() {
    translate([0, 0, plate_t - groove_depth])
        linear_extrude(cord_d) offset(-(groove_w - cord_d)/2) groove_ring_2d();
}

// the gasket starts at the bottom of its seat and protrudes gasket_h from the back
module gasket() {
    translate([0, 0, plate_t - gasket_groove])
        linear_extrude(gasket_groove + gasket_h) gasket_ring_2d();
}

module plate() {
difference() {
    plate_body();

    // gasket seat on the back
    if (seal == "tpu")
        translate([0, 0, plate_t - gasket_groove])
            linear_extrude(gasket_groove + 0.01) gasket_ring_2d();
    // groove for the rubber cord
    if (seal == "cord")
        translate([0, 0, plate_t - groove_depth])
            linear_extrude(groove_depth + 0.01) groove_ring_2d();

    sound_grille();

    for (sx = [-1, 1]) translate([sx*screw_pitch/2, 0, 0]) screw_hole();

    oled_window();

    translate([r503_x, r503_y, -0.01]) cylinder(d = r503_hole_d, h = plate_t + 0.02);
    translate([pir_x,  pir_y,  -0.01]) cylinder(d = pir_hole_d,  h = plate_t + 0.02);
    translate([btn_x,  btn_y,  -0.01]) cylinder(d = btn_hole_d,  h = plate_t + 0.02);
}

oled_mounts();
pir_boss();
buzzer_mount();
reed_cradle();
}

if (part == "plate" || part == "all") plate();
if (seal == "tpu" && (part == "gasket" || part == "all")) color("DimGray") gasket();
if (seal == "cord" && part == "all") color("Black") cord_preview();

// The front face is the one on the print bed (z = 0):
// print it like this, no supports. The back faces up.
