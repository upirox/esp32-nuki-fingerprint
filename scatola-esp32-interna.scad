// ============================================================
//  Indoor enclosure for the ESP32 - smart entrance
//  Holds: ESP32 38 pin on a screw terminal expansion board,
//         indoor buzzer (doorbell / sirens),
//         WS2812B strip, 144 LEDs/m (12 LEDs) = door status light,
//         PowerBoost 1000C + 3 x 18650 pack (backup battery),
//         230 V -> 5 V 2 A power supply (Mean Well IRM-10-5) in a
//         SEPARATE BAY with its own cover (opening the enclosure to work
//         on the board never exposes live parts).
//  It is screwed to the wall indoors, next to the 503 box of a wall socket:
//  all cables come in through ONE opening in the right wall, flush with
//  the back, under a trunking from the nearby 503 box. A rib (the top wall
//  of the 230 V bay, extended to the outside) splits the opening in two:
//  - upper part: signal cables to the outdoor plate (main compartment);
//  - lower part: 230 V sheathed cable, which runs in a closed channel next
//    to the bay and enters it through a hole in the bay's right wall,
//    held by a cable tie (strain relief).
//  (Set use_back_hole = true for the old layout: box straight behind the
//   plate, cables through a hole in the back split by the bay wall.)
//
//  PARTS (set "part" and export one STL for each):
//    "base"     enclosure, printed with the back on the bed
//    "lid"      printed with the visible face on the bed
//    "lid230"   cover of the 230 V bay (2 M3 screws)
//    "diffuser" strip for the LED window, only if diff_type = "printed":
//               print it in WHITE PETG, 1.6 mm, 100% infill.
//               With diff_type = "pmma" (default) buy an OPAL (milk white)
//               acrylic bar instead, cut to diff_pmma_l x diff_pmma_w
//    "all"      assembled preview with the lid lifted
//
//  Screws: 4 x M3 x 8 in the lid and 2 x M3 x 6 in the 230 V cover,
//          driven into 6 brass M3 heat-set inserts (soldering iron tip at
//          ~220-240 C for PETG, keep the insert straight, don't force it),
//          4 x 4 mm screws + wall plugs for the wall.
//  Material: PETG or ASA (NOT PLA: there is a 230 V power supply inside).
//  230 V and signal cables enter on different sides: 230 V goes straight
//  into the bay and never runs among the 5 V wires.
//  Mains cable: sheathed, at least 1.5 mm2 (e.g. H05VV-F 3G1.5) if wired
//  to the socket terminals.
//
//  LAYOUT (vertical, outer width < 15 cm):
//    top      LED status strip (12 LEDs, 83 mm) inside a light box
//    middle   ESP32 board (upright) on the left, ABOVE the 3 x 18650 pack (lying)
//             (tall standoffs) | PowerBoost 1000C and buzzer on the right
//    bottom   230 V bay with the power supply (gland in the bottom wall)
//
//  BEFORE PRINTING measure your screw terminal board and adjust
//  board_w / board_h and board_hole_dx / board_hole_dy: boards on the
//  market are not all the same.
// ============================================================

/* [Part to export] */
part = "all";            // "base", "lid", "lid230", "diffuser", "all"

/* [Enclosure] */
in_w     = 140;   // inner width (outer = +4.8 mm: max 150)
in_h     = 160;   // inner height (the terminal board stands upright)
board_headroom = 20;  // room above the terminal board (ESP32 + terminals + wires)
                      // computed inner depth: pack + 4 + board + this
wall     = 2.4;   // wall thickness
floor_t  = 3;     // back thickness
lid_t    = 2.5;   // lid thickness
corner_r = 4;     // outer corner radius
fit      = 0.3;   // clearance between lid and walls

/* [Lid screws: brass M3 heat-set inserts] */
use_inserts  = true;  // false = self-tapping screws straight into the plastic
insert_d     = 4.0;   // hole for the insert (short M3, 5.7 mm type: 4.0 | check
                      // your insert's datasheet, usually 4.0-4.2)
insert_l     = 6;     // hole depth = insert length + ~0.5
boss_d       = 9;     // thicker column: at least 2.5 mm of plastic around the insert
boss_pilot_d = 2.6;   // pilot hole for M3 self-tapping screws (if use_inserts = false)
psu_post_d   = 8;     // posts of the 230 V cover (same inserts)
lid_screw_d  = 3.4;
lid_head_d   = 6.5;   // countersink for the screw head
lid_head_h   = 1.8;

/* [ESP32 screw terminal board (position = board centre)] */
board_x       = -22;
board_y       = 16.5;
board_w       = 63;   // board + terminals footprint, upright: terminals on the
board_h       = 78;   // left and right sides, wires go sideways, USB at the bottom
board_hole_dx = 57;   // mounting hole spacing (MEASURE IT), 3 mm holes
board_hole_dy = 72;
standoff_d    = 8;
standoff_air  = 4;    // air gap between battery pack and board (the pack sits under the board)
standoff_pilot= 2.5;  // M3 self-tapping or M2.5 screw
board_guides  = true; // L-shaped corner guides that centre the board

/* [Indoor buzzer (32.5 x 13 module, fixed to the lid)] */
buzz_x        = 40;
buzz_y        = 42;
buzz_d        = 12;
buzz_ring_h   = 6;
buzz_ring_w   = 1.2;
sound_hole_d  = 1.6;

/* [LED status strip (WS2812B 144 LEDs/m, 12 mm wide PCB)] */
led_n      = 12;
led_pitch  = 1000/144; // 144 LEDs/m = 6.94 mm (8 LEDs/80 mm strip: 10) | length = led_n x led_pitch
strip_w    = 12.6;   // strip width (12 mm PCB) + clearance
strip_y    = 68;     // strip position (centre, at the top)
led_gap    = 12;     // LED to diffuser distance: >= 1.5 x led_pitch for an even bar
win_h      = 6;      // height of the light window
diff_type  = "pmma"; // "pmma": opal acrylic bar inside the light box, against the lid
                     // "printed": printed diffuser in a pocket in the lid
diff_t     = 2;      // diffuser thickness: 2 mm opal PMMA (printed: 1.6)
diff_margin= 2;      // diffuser ledge around the window
use_lightbox = true; // walls around the strip, hanging from the lid
box_wall   = 1.2;    // light box wall thickness
box_clear  = 0.5;    // gap between the light box walls and the rib
box_wire_w = 7;      // notches at the ends of the light box for the strip wires
box_wire_h = 3.5;

/* [Cable opening (right wall, flush with the back), split by the bay wall] */
use_side_open = true;
sig_open_w   = 12;    // signal part, above the rib (along the wall)
mains_open_w = 10;    // 230 V part, below the rib (cable up to ~8.5 mm)
side_open_h  = 11;    // height from the wall surface
// total = sig_open_w + psu_wall + mains_open_w = 24 mm: a 25 x 10 trunking
// with a divider, or two small ones side by side

/* [OLD layout: cable hole in the back, split by the 230 V bay wall] */
use_back_hole = false;
// The hole is centred on the top wall of the bay: the wall runs across it
// and splits it in two halves. The 230 V cable enters below (straight into the bay),
// the plate's signal cables enter above. It can only be moved horizontally.
cable_x  = 40;
cable_d  = 32;

/* [Backup battery: 3 x 18650 pack in parallel (MEASURE IT)] */
pack_l     = 68;    // long side of the pack (cell length + wrap)
pack_w     = 58;    // short side (3 cells side by side)
pack_horizontal = true; // long side horizontal: clears the board standoffs (57 x 72)
pack_t     = 19.5;  // thickness: sets the depth of the enclosure
pack_x     = board_x;  // under the board
pack_y     = board_y;
pack_wall_h= 8;     // cradle height (a velcro strap holds the rest)
strap_w    = 16;    // slots for the strap that holds the pack

/* [PowerBoost 1000C (without the USB-A socket)] */
pb_l       = 36.2;
pb_w       = 22.9;
pb_x       = 44;
pb_y       = 22;

/* [230 V power supply bay (at the bottom, full width between the columns)] */
psu_x0     = -60;   // left wall of the bay (the corner columns stay outside)
psu_x1     = 60;    // right wall
psu_y1     = -25;   // top wall (below it is the outer wall of the enclosure)
psu_wall   = 2;
psu_top    = 5;     // the bay ends 5 mm below the rim of the enclosure
psu_lid_t  = 2;
mod_l      = 46;    // Mean Well IRM-10-5: 45.7 x 25.4 x 21.5 (other module: measure it)
mod_w      = 25.5;
mod_x      = -20;   // module centre
mod_y      = -50;
// Power supply board (perfboard 80 x 40, 2 mm holes at 76 x 36) instead of
// the cradle: IRM-10-5 + input screw terminal, fuse holder, varistor,
// output capacitors and output screw terminal, all soldered on the board.
use_psu_board = true;  // false = bare module glued in the cradle
pcb_l      = 80;
pcb_w      = 40;
pcb_x      = -5;     // board centre: input end on the right (230 V entry),
pcb_y      = (-in_h/2 + 2.5 + psu_y1 - 2)/2; // centred in the bay; output end on the left (5 V hole)
pcb_hole_in= 2;      // hole centres 2 mm from the edges: 76 x 36 spacing
pcb_pilot_d= 1.7;    // 2 mm board holes: M2 self-tapping screws (M2 x 6-8)
pcb_post_d = 6;
pcb_post_h = 8;      // board height above the floor
use_gland  = false; // alternative: mains cable gland in the bottom wall of the bay
gland_x    = 35;
gland_d    = 16.2;  // M16 gland (cable 4.5-10 mm, e.g. 3G1.5); 12.6 for M12
out_hole_d = 6;     // 5 V wires to the board (top wall of the bay)
out_hole_x = -40;

/* [Antenna (top wall)] */
ant_x    = 55;
ant_d    = 6.6;    // panel-mount SMA / RP-SMA connector

/* [Wall mounting (holes in the back)] */
// [-27,17] is under the battery pack and the board:
// screw the enclosure to the wall BEFORE fitting them
wall_holes   = [[-56,66],[55,52],[58,-8],[-27,17]];
wall_screw_d = 4.5;
wall_head_d  = 8.5;

/* [Ventilation] */
vents      = true;
vent_w     = 2;
vent_l     = 14;
vent_n     = 8;
vent_y0    = -12;   // first vent slot (left and right walls: battery, board, PowerBoost)

$fn = 64;

// ------------------------------------------------------------
standoff_h = pack_t + standoff_air;
pack_dx = pack_horizontal ? pack_l : pack_w;   // pack footprint along x / y
pack_dy = pack_horizontal ? pack_w : pack_l;
in_d  = standoff_h + 1.6 + board_headroom;   // inner depth
out_w = in_w + 2*wall;
out_h = in_h + 2*wall;
base_h = floor_t + in_d;
strip_len = led_n * led_pitch;
// LED to diffuser = led_gap: with the acrylic bar below the lid the rib is lower
rib_top = base_h - led_gap - 2 - (use_lightbox && diff_type == "pmma" ? diff_t : 0);
box_iw = strip_len + 2*box_clear;          // light box inside
box_ih = strip_w + 2 + 2*box_clear;
diff_pmma_l = box_iw - 0.4;                // acrylic bar: fits inside the light box
diff_pmma_w = box_ih - 0.4;
win_w = strip_len - 4;
// the columns sink 0.5 mm into the walls: if they were merely tangent
// OpenSCAD would report "not a valid 2-manifold"
boss_pos = [for (sx=[-1,1], sy=[-1,1]) [sx*(in_w/2 - boss_d/2 + 0.5), sy*(in_h/2 - boss_d/2 + 0.5)]];
psu_y0   = -in_h/2;
pcb_posts = [for (sx = [-1,1], sy = [-1,1]) [pcb_x + sx*(pcb_l/2 - pcb_hole_in), pcb_y + sy*(pcb_w/2 - pcb_hole_in)]];
cable_y  = psu_y1 - psu_wall/2;          // hole centred on the wall of the bay
psu_ztop = floor_t + in_d - psu_top;     // height of the bay walls
psu_posts = [[psu_x0 + psu_wall + psu_post_d/2 - 0.5, psu_y1 - psu_wall - psu_post_d/2 + 0.5],  // they sink 0.5 mm into the walls
             [psu_x1 - psu_wall - psu_post_d/2 + 0.5, psu_y0 + psu_wall + psu_post_d/2 - 0.5]];

// hole from the top in a column ending at height "top":
// pocket for a heat-set insert (with a chamfered lead-in) or a pilot hole
module screw_hole_in(p, top) {
    translate([p[0], p[1], 0]) {
        if (use_inserts) {
            translate([0, 0, top - insert_l]) cylinder(d = insert_d, h = insert_l + 0.1);
            translate([0, 0, top - 0.6]) cylinder(d1 = insert_d, d2 = insert_d + 0.8, h = 0.61);
            // below the insert: room for the screw tip and the displaced plastic
            translate([0, 0, top - insert_l - 4]) cylinder(d = 3.2, h = 4.1);
        } else {
            translate([0, 0, floor_t + 2]) cylinder(d = boss_pilot_d, h = top);
        }
    }
}

module rrect(w, h, r, t) {
    linear_extrude(t) offset(r) square([w - 2*r, h - 2*r], center = true);
}

// ---------------- BASE ----------------
module base() {
    difference() {
        union() {
            difference() {
                rrect(out_w, out_h, corner_r, base_h);
                translate([0, 0, floor_t])
                    rrect(in_w, in_h, max(corner_r - wall, 0.5), base_h);
            }
            // columns for the lid screws
            for (p = boss_pos) translate([p[0], p[1], 0])
                cylinder(d = boss_d, h = base_h);
            // board standoffs
            for (sx = [-1,1], sy = [-1,1])
                translate([board_x + sx*board_hole_dx/2, board_y + sy*board_hole_dy/2, 0])
                    cylinder(d = standoff_d, h = floor_t + standoff_h);
            if (board_guides) board_corner_guides();
            led_rib();
            psu_bay();
            pack_cradle();
            pb_cradle();
        }
        // lid screw holes (heat-set inserts or self-tapping screws)
        for (p = boss_pos) screw_hole_in(p, base_h);
        // standoff holes
        for (sx = [-1,1], sy = [-1,1])
            translate([board_x + sx*board_hole_dx/2, board_y + sy*board_hole_dy/2, 1])
                cylinder(d = standoff_pilot, h = base_h);
        // side opening, open at the back: signals above the rib, 230 V below
        if (use_side_open) {
            translate([in_w/2 - 1, psu_y1, -0.1])
                cube([wall + 2, sig_open_w, side_open_h + 0.1]);
            translate([in_w/2 - 1, psu_y1 - psu_wall - mains_open_w, -0.1])
                cube([wall + 2, mains_open_w, side_open_h + 0.1]);
            // into the bay through its right wall
            translate([psu_x1 - psu_wall - 0.1, psu_y1 - psu_wall - mains_open_w, floor_t])
                cube([psu_wall + 0.2, mains_open_w, side_open_h]);
        }
        // OLD: cable hole from the wall (the bay wall stays: it splits the hole in two)
        if (use_back_hole) difference() {
            translate([cable_x, cable_y, -0.1]) cylinder(d = cable_d, h = floor_t + 0.2);
            translate([cable_x - cable_d, psu_y1 - psu_wall - 0.1, -1]) cube([2*cable_d, psu_wall + 0.2, floor_t + 2]);
        }
        // slots for the battery pack strap
        for (sx = [-1,1])
            translate([pack_x + sx*(pack_dx/2 + 4.5), pack_y, -0.1])
                linear_extrude(floor_t + 0.2) offset(1) square([1.2, strap_w - 2], center = true);
        // wall screw holes (countersunk from the inside)
        for (p = wall_holes) translate([p[0], p[1], -0.1]) {
            cylinder(d = wall_screw_d, h = floor_t + 0.2);
            translate([0, 0, floor_t - 2.4 + 0.1])
                cylinder(d1 = wall_screw_d, d2 = wall_head_d, h = 2.4);
        }
        // mains cable gland (bottom wall, inside the bay)
        if (use_gland) translate([gland_x, -in_h/2 + psu_wall + 1, floor_t + 12])
            rotate([90, 0, 0]) cylinder(d = gland_d, h = wall + psu_wall + 3);
        // holes of the 230 V cover posts
        for (p = psu_posts) screw_hole_in(p, psu_ztop);
        // holes of the supply board posts
        if (use_psu_board) for (p = pcb_posts) translate([p[0], p[1], floor_t + 1]) cylinder(d = pcb_pilot_d, h = pcb_post_h);
        // 5 V wires from the bay to the board (top wall of the bay)
        translate([out_hole_x, psu_y1 + 1, floor_t + 6])
            rotate([90, 0, 0]) cylinder(d = out_hole_d, h = psu_wall + 2);
        // antenna (top wall)
        translate([ant_x, in_h/2 - 1, floor_t + in_d/2])
            rotate([-90, 0, 0]) cylinder(d = ant_d, h = wall + 2);
        // vent slots (left and right walls, at board height)
        if (vents) for (i = [0:vent_n-1], sx = [-1,1])
            translate([sx*(in_w/2 + wall/2), vent_y0 + i*(vent_w + 4), floor_t + in_d/2])
                cube([wall + 2, vent_w, vent_l], center = true);
    }
}

// L-shaped guides at the board corners (they centre it, they don't clamp it)
module board_corner_guides() {
    g = 1.2; l = 8; h = floor_t + standoff_h + 3;
    for (sx = [-1,1], sy = [-1,1])
        translate([board_x + sx*(board_w/2 + 0.4 + g/2), board_y + sy*(board_h/2 + 0.4 + g/2), 0]) {
            translate([-sx*(l/2 - g/2), 0, h/2]) cube([l, g, h], center = true);
            translate([0, -sy*(l/2 - g/2), h/2]) cube([g, l, h], center = true);
        }
}

// hollow beam carrying the LED strip, facing the lid
module led_rib() {
    top = rib_top;                  // 2 mm below = strip + LED thickness
    w = strip_w + 2;
    translate([0, strip_y, 0])
    difference() {
        translate([-strip_len/2, -w/2, 0]) cube([strip_len, w, top]);
        // hollow inside (less plastic), closed on top where the strip is stuck
        translate([-strip_len/2 + 1.6, -w/2 + 1.6, floor_t]) cube([strip_len - 3.2, w - 3.2, top - floor_t - 1.6]);
    }
    // small rails that keep the strip straight
    translate([0, strip_y, top])
        for (sy = [-1,1]) translate([-strip_len/2, sy*(strip_w/2 + 0.6) - 0.6, 0])
            cube([strip_len, 1.2, 1.2]);
}

// battery pack cradle under the board (long side horizontal if pack_horizontal).
// Opening for the wires on the PowerBoost side, notches for the strap.
module pack_cradle() {
    c = 0.6; t = 1.6;
    X = pack_dx + 2*c; Y = pack_dy + 2*c;   // cradle inside
    translate([pack_x, pack_y, floor_t])
    difference() {
        translate([-X/2 - t, -Y/2 - t, 0]) cube([X + 2*t, Y + 2*t, pack_wall_h]);
        translate([-X/2, -Y/2, -0.1]) cube([X, Y, pack_wall_h + 0.2]);
        // wire / connector passage towards the PowerBoost (right side)
        translate([X/2 - 0.1, Y/2 - 22, 2]) cube([t + 0.2, 18, pack_wall_h]);
        // notches for the velcro strap (left and right sides)
        for (sx = [-1,1]) translate([sx*(X/2 + t/2), 0, pack_wall_h/2 + 0.1])
            cube([t + 0.4, strap_w, pack_wall_h], center = true);
    }
}

// PowerBoost cradle on small feet (air flows underneath: it gets warm while charging)
module pb_cradle() {
    c = 0.4; t = 1.2; h = 5;
    translate([pb_x, pb_y, floor_t]) {
        difference() {
            translate([-(pb_l + 2*c)/2 - t, -(pb_w + 2*c)/2 - t, 0])
                cube([pb_l + 2*c + 2*t, pb_w + 2*c + 2*t, h]);
            translate([-(pb_l + 2*c)/2, -(pb_w + 2*c)/2, -0.1])
                cube([pb_l + 2*c, pb_w + 2*c, h + 0.2]);
            // short sides open for wires, JST and micro-USB connectors
            for (sx = [-1,1]) translate([sx*((pb_l + 2*c)/2 + t/2), 0, h/2 + 1.5])
                cube([t + 0.4, pb_w - 6, h], center = true);
        }
        // feet: the board sits 2 mm above the floor
        for (sx = [-1,1], sy = [-1,1])
            translate([sx*(pb_l/2 - 3), sy*(pb_w/2 - 2.5), 0]) cylinder(d = 4, h = 2);
    }
}

// separate bay for the 230 V power supply: walls, posts, module cradle
module psu_bay() {
    // left, right and top walls; at the bottom a ledge against the
    // outer wall that the cover rests on (it sinks 0.5 mm into the wall)
    translate([psu_x0, psu_y0 - 0.5, 0]) cube([psu_wall, psu_y1 - psu_y0 + 0.5, psu_ztop]);
    translate([psu_x1 - psu_wall, psu_y0 - 0.5, 0]) cube([psu_wall, psu_y1 - psu_y0 + 0.5, psu_ztop]);
    translate([psu_x0, psu_y1 - psu_wall, 0]) cube([psu_x1 - psu_x0, psu_wall, psu_ztop]);
    translate([psu_x0, psu_y0 - 0.5, 0]) cube([psu_x1 - psu_x0, psu_wall + 0.5, psu_ztop]);
    if (use_side_open) {
        // rib: top wall of the bay extended to the outer wall, it closes the
        // 230 V channel between the bay and the right wall of the enclosure
        translate([psu_x1 - 0.5, psu_y1 - psu_wall, 0]) cube([in_w/2 - psu_x1 + 1, psu_wall, psu_ztop]);
        // cable tie block inside the bay: the tie goes through the tunnel
        // and clamps the 230 V cable (strain relief)
        translate([psu_x1 - psu_wall - 10, psu_y1 - psu_wall - mains_open_w - 1, floor_t - 0.5])
        difference() {
            cube([7, mains_open_w + 1 - 0.5, 4]);
            translate([1.25, -0.1, 1.3]) cube([4.5, mains_open_w + 1, 1.8]);
        }
    }
    // posts for the cover screws
    for (p = psu_posts) translate([p[0], p[1], 0]) cylinder(d = psu_post_d, h = psu_ztop);
    // supply board posts (holes cut in base())
    if (use_psu_board)
        for (p = pcb_posts) translate([p[0], p[1], 0]) cylinder(d = pcb_post_d, h = floor_t + pcb_post_h);
    // module cradle: 4 mm rims (fix it with a drop of hot glue)
    if (!use_psu_board) translate([mod_x, mod_y, floor_t])
    difference() {
        translate([-(mod_l + 0.6)/2 - 1.2, -(mod_w + 0.6)/2 - 1.2, 0])
            cube([mod_l + 0.6 + 2.4, mod_w + 0.6 + 2.4, 4]);
        translate([-(mod_l + 0.6)/2, -(mod_w + 0.6)/2, -0.1])
            cube([mod_l + 0.6, mod_w + 0.6, 4.2]);
        // openings for pins and wires
        for (sx = [-1,1]) translate([sx*(mod_l/2 + 0.6), 0, 2.2]) cube([4, mod_w - 6, 4.4], center = true);
    }
}

// cover of the 230 V bay (printed as is, flat)
module psu_lid() {
    w = psu_x1 - psu_x0;
    h = psu_y1 - psu_y0 - fit;     // at the bottom it touches the outer wall: leave clearance
    difference() {
        cube([w, h, psu_lid_t]);
        for (p = psu_posts) translate([p[0] - psu_x0, p[1] - psu_y0 - fit, -0.1]) {
            cylinder(d = 3.4, h = psu_lid_t + 0.2);
            translate([0, 0, psu_lid_t - 1.5 + 0.1]) cylinder(d1 = 3.4, d2 = 6.2, h = 1.5);
        }
        // engraved warning text
        translate([w/2, h/2, psu_lid_t - 0.6])
            linear_extrude(1) text("230 V", size = 9, halign = "center", valign = "center");
    }
}

// ---------------- LID (in assembled position) ----------------
module lid_assembled() {
    z0 = base_h;    // the lid rests on the rim of the walls
    difference() {
        union() {
            translate([0, 0, z0]) rrect(out_w, out_h, corner_r, lid_t);
            // centring lip that fits inside the enclosure
            translate([0, 0, z0 - 3])
            difference() {
                rrect(in_w - 2*fit, in_h - 2*fit, max(corner_r - wall - fit, 0.5), 3);
                translate([0, 0, -0.1]) rrect(in_w - 2*fit - 3.2, in_h - 2*fit - 3.2, 0.5, 3.2);
                for (p = boss_pos) translate([p[0], p[1], -0.1]) cylinder(d = boss_d + 1, h = 3.2);
            }
            // light box: white walls around the strip, from the lid down to just
            // above the LED rib. Light bounces inside and leaves only through the
            // diffuser, so the LEDs merge into one even bar. Print the lid in white
            // or line the inside of the box with white paint / aluminium tape.
            if (use_lightbox) lightbox();
            // ring that holds the buzzer
            translate([buzz_x, buzz_y, z0 - buzz_ring_h])
            difference() {
                cylinder(d = buzz_d + 0.3 + 2*buzz_ring_w, h = buzz_ring_h);
                translate([0, 0, -0.1]) cylinder(d = buzz_d + 0.3, h = buzz_ring_h + 0.2);
            }
        }
        // lid screws, countersunk on the front
        for (p = boss_pos) translate([p[0], p[1], z0 - 0.1]) {
            cylinder(d = lid_screw_d, h = lid_t + 0.2);
            translate([0, 0, lid_t - lid_head_h + 0.1])
                cylinder(d1 = lid_screw_d, d2 = lid_head_d, h = lid_head_h);
        }
        // light window + diffuser pocket (on the inside)
        translate([0, strip_y, z0 - 0.1])
            linear_extrude(lid_t + 0.2) offset(win_h/2 - 0.01) square([win_w - win_h, 0.02], center = true);
        if (diff_type == "printed") translate([0, strip_y, z0 - 0.1])
            linear_extrude(diff_t + 0.1)
                offset(win_h/2 + diff_margin) square([win_w - win_h, 0.02], center = true);
        // small holes for the buzzer
        for (p = concat([[0,0]], [for (a = [0:60:300]) [3.2*cos(a), 3.2*sin(a)]]))
            translate([buzz_x + p[0], buzz_y + p[1], z0 - 0.1])
                cylinder(d = sound_hole_d, h = lid_t + 0.2, $fn = 24);
    }
}

module lightbox() {
    h  = base_h - rib_top - box_clear;                // from the lid down to the rib
    iw = box_iw;                                      // inside: the rib + rails fit in
    ih = box_ih;
    translate([0, strip_y, base_h - h])
    difference() {
        // +0.5 mm into the lid, so the union is a clean solid
        translate([-iw/2 - box_wall, -ih/2 - box_wall, 0]) cube([iw + 2*box_wall, ih + 2*box_wall, h + 0.5]);
        translate([-iw/2, -ih/2, -0.1]) cube([iw, ih, h + 0.7]);
        // wire notches at both ends (the strip can face either way)
        for (sx = [-1, 1]) translate([sx*(iw/2 + box_wall/2) - box_wall, -box_wire_w/2, -0.1])
            cube([2*box_wall, box_wire_w, box_wire_h + 0.1]);
    }
}

// lid rotated for printing: visible face on the bed
module lid_print() {
    rotate([180, 0, 0]) translate([0, 0, -(base_h + lid_t)]) lid_assembled();
}

// ---------------- DIFFUSER ----------------
module diffuser() {
    if (diff_type == "printed")
        linear_extrude(diff_t - 0.15)
            offset(win_h/2 + diff_margin - 0.25) square([win_w - win_h, 0.02], center = true);
    else   // the acrylic bar (preview only)
        translate([-diff_pmma_l/2, -diff_pmma_w/2, 0]) cube([diff_pmma_l, diff_pmma_w, diff_t]);
}

// ------------------------------------------------------------
if (part == "base") base();
if (part == "lid") lid_print();
if (part == "diffuser") diffuser();
echo(str("DIFFUSER: ", diff_type == "pmma" ? str("opal acrylic bar ", diff_pmma_l, " x ", diff_pmma_w, " x ", diff_t, " mm") : "printed, part = diffuser"));
if (part == "lid230") psu_lid();
if (part == "all") {
    base();
    color("OrangeRed") translate([psu_x0, psu_y0 + fit, psu_ztop + 8]) psu_lid();
    color("SteelBlue", 0.6) translate([0, 0, 25]) lid_assembled();
    color("White") translate([0, strip_y, base_h + 25 - 0.05]) mirror([0,0,1]) diffuser();
    // (pmma: the bar lies inside the light box, against the lid)
}
