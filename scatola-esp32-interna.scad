// ============================================================
//  Indoor enclosure for the ESP32 - smart entrance
//  Holds: ESP32 38 pin on a screw terminal expansion board,
//         indoor buzzer (doorbell / sirens),
//         WS2812B strip, 144 LEDs/m (12 LEDs) = door status light,
//         PowerBoost 1000C + 3 x 18650 pack (backup battery) in a
//         BATTERY BAY at the bottom, with its own front door (swap the
//         pack without opening the main lid),
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
//    "door"     front door of the battery bay (2 M3 screws), printed with
//               the visible face on the bed
//    "diffuser" LED window diffuser, depends on diff_type:
//               "plug" (default): printed plug, flush with the lid face.
//                 Print it in WHITE PETG, front face on the bed, 100% infill;
//                 push it into the window from inside, glue the flange.
//               "printed": flat diffuser in a pocket on the inside of the lid.
//               "pmma": nothing to print, cut an OPAL acrylic bar to
//                 diff_pmma_l x diff_pmma_w (sits behind the window, recessed)
//    "separator" (only with the OLD layout, pack under the board)
//    "all"      assembled preview with the lid lifted
//
//  Screws: 4 x M3 x 8 in the lid, 2 x M3 x 8 in the battery door and
//          2 x M3 x 6 in the 230 V cover, driven into 8 brass M3 heat-set inserts (soldering iron tip at
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
//    middle   ESP32 board on the left (USB-C to the right) on low standoffs |
//             PowerBoost 1000C and buzzer on the right
//    lower    230 V bay with the power supply
//    bottom   battery bay (3 x 18650 pack lying), behind its own door, split
//             from the rest by a full-height wall. The battery wires go
//             through a slot in that wall (left corner) and up the left side,
//             outside the 230 V bay. It is the coolest spot of the enclosure:
//             the warm air of the power supply and of the PowerBoost rises.
//    The pack is no longer under the board, so the enclosure is much thinner.
//
//  BEFORE PRINTING measure your screw terminal board and adjust
//  board_w / board_h and board_hole_dx / board_hole_dy: boards on the
//  market are not all the same.
// ============================================================

/* [Part to export] */
part = "all";            // "base", "lid", "door", "lid230", "diffuser", "logo_chip", "logo_wifi", "all"

/* [Logo on the lid (chip + Wi-Fi symbol)] */
// "engrave": recessed symbol, fill it with paint (chip blue, Wi-Fi light blue)
// "inlay":   same recess plus two extra STLs ("logo_chip", "logo_wifi") that fill
//            it exactly, for a multi-material printer (AMS / MMU): load lid + both
//            logo parts as ONE multi-part object, keep their positions, assign colours
//            (chip #0B3A82 blue, Wi-Fi #1F9BD7 light blue)
// "none":    plain lid
logo_mode  = "engrave";
logo_size  = 56;     // symbol width (mm)
logo_x     = 0;      // symbol centre on the lid, seen from the room
logo_y     = -5;
logo_depth = 0.8;    // engraving depth (lid is lid_t thick)

/* [Enclosure] */
in_w     = 140;   // inner width (outer = +4.8 mm: max 150)
in_h     = 160;   // inner height of the main part (LED strip, board, 230 V bay)
board_headroom = 20;  // min. room above the terminal board (ESP32 + terminals + wires)
                      // inner depth = the largest of board / power supply / pack needs
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
board_x       = -26;
board_y       = 17;
board_w       = 78;   // board + terminals footprint, lying: terminals on the top and
board_h       = 63;   // bottom sides, USB-C to the right (plug passes over the PowerBoost)
board_hole_dx = 72;   // mounting hole spacing (MEASURE IT), 3 mm holes
board_hole_dy = 57;
standoff_d    = 8;
board_standoff= 6;    // board height above the floor (air under the solder joints)
use_separator = false;// (OLD layout only: plate between the pack and the board)
sep_t         = 1.2;  // separator thickness (PETG, 100% infill)
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
diff_type  = "plug"; // "plug": printed plug flush with the lid face (white PETG)
                     // "pmma": opal acrylic bar inside the light box, against the lid
                     // "printed": printed diffuser in a pocket in the lid
plug_clear = 0.15;   // plug: gap per side in the window (tight: 0.1, loose: 0.2)
plug_skin  = 0.8;    // plug: front skin = the diffuser (0.6 brighter, 1.0 more even)
plug_wall  = 0.8;    // plug: side walls (hollow behind the skin)
plug_flange= 2;      // plug: flange around the window, inside the light box
plug_flange_t = 1.2; // plug: flange thickness (glued to the inside of the lid)
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
pack_horizontal = true; // long side horizontal, in the battery bay
pack_t     = 19.5;  // thickness
pack_wall_h= 8;     // cradle height (a velcro strap holds the rest)
strap_w    = 16;    // slots for the strap that holds the pack

/* [Battery bay (bottom) and its door] */
div_t      = 3;     // wall between the main part and the battery bay (lid and
                    // door both rest on it)
bay_margin = 1.5;   // room above and below the cradle
bat_slot_x = -58;   // slot in the dividing wall for the battery wires (left
                    // corridor, between the lid column and the 230 V bay)
bat_slot_w = 4;     // 2 wires (the JST stays on the PowerBoost side: lay the
                    // wires in the slot from the top, nothing to thread)
door_ribs  = true;  // ribs on the inside of the door, 1 mm above the pack:
                    // it can't come out of the cradle even if the strap loosens
door_icon  = true;  // battery symbol engraved on the door

/* [PowerBoost 1000C (without the USB-A socket)] */
pb_l       = 36.2;
pb_w       = 22.9;
pb_x       = 44;
pb_y       = 22;
// Mount the board with the micro-USB towards the ESP32 (left) and the row of
// pads (USB, Bat, Vs, EN, GND, 5V) at the bottom: the light pipes line up with
// its LEDs only this way.

/* [PowerBoost LED light pipes (lid)] */
// Clear acrylic rods from the four PowerBoost LEDs to the lid, flush with its
// face: LOW (red), DONE (green), CHRG (orange), PWR (blue). Each rod runs in its
// own tube hanging from the lid, so the light of an LED doesn't leak into the
// rod next to it (DONE and CHRG are only 3.6 mm apart). Rod length: see the
// LIGHT PIPES line in the console. Sand the outer end matt (grit 400-600),
// keep the LED end polished.
use_lightpipes = true;
lp_d        = 2;      // rod diameter (2 mm acrylic rod)
lp_hole     = 2.1;    // hole in the lid: press fit
lp_bore     = 2.25;   // bore of the tubes
lp_wall     = 1;      // tube wall
lp_led_gap  = 0.5;    // rod end to LED top (small: less light reaches the next rod)
// LED positions on the board (Adafruit Eagle file, Rev B), from the board's
// corner at the micro-USB / pad-row side: [x, y, name]
// 4th value: how much higher that tube/rod stops (LOW sits next to the 6 mm
// tall JST battery connector, so its tube stops above it)
pb_leds = [[5.429, 20.861, "LOW", 6], [6.223, 1.143, "DONE", 0], [9.779, 1.143, "CHRG", 0], [33.723, 1.556, "PWR", 0]];

/* [230 V power supply bay (at the bottom, full width between the columns)] */
psu_x0     = -54;   // left wall of the bay (left of it: corridor for the battery wires)
psu_x1     = 60;    // right wall
psu_y1     = -25;   // top wall (below it is the outer wall of the enclosure)
psu_wall   = 2;
psu_top    = 3.5;   // the bay ends 3.5 mm below the rim (cover top 1.5 mm below the lid)
psu_comp_h = 21.5;  // tallest part on the supply board (IRM-10-5: 21.5 mm)
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
pcb_x      = 1;      // board centre: input end on the right (230 V entry),
pcb_y      = (-in_h/2 + 2.5 + psu_y1 - 2)/2; // centred in the bay; output end on the left (5 V hole)
pcb_hole_in= 2;      // hole centres 2 mm from the edges: 76 x 36 spacing
pcb_pilot_d= 1.7;    // 2 mm board holes: M2 self-tapping screws (M2 x 6-8)
pcb_post_d = 6;
pcb_post_h = 3;      // board height above the floor (room for the solder joints)
use_gland  = false; // OLD layout only (bay against the bottom wall): mains cable gland
gland_x    = 35;
gland_d    = 16.2;  // M16 gland (cable 4.5-10 mm, e.g. 3G1.5); 12.6 for M12
out_hole_d = 6;     // 5 V wires to the board (top wall of the bay)
out_hole_x = -40;

/* [Antenna (top wall)] */
ant_x    = -52;    // top wall, left: close to the ESP32 module (13 cm pigtail)
ant_d    = 6.6;    // panel-mount SMA / RP-SMA connector

/* [Wall mounting (holes in the back)] */
// [-27,17] is under the board: screw the enclosure to the wall BEFORE fitting it.
// The last two are in the battery bay (between the cradle and the door columns)
wall_holes   = [[-56,66],[55,52],[58,-8],[-27,17],[-50,-110],[50,-110]];
wall_screw_d = 4.5;
wall_head_d  = 8.5;

/* [Ventilation] */
vents      = true;
vent_w     = 2;
vent_l     = 14;
// Natural convection (chimney effect, enclosure on the wall): cool air comes in
// through the LOW slots just above the 230 V bay, warm air leaves through the
// HIGH slots near the top. Slots on the side walls (no dust falling in from above),
// horizontal like louvres. The 230 V bay stays closed.
vent_low_n  = 3;    // inlet slots on each side, starting just above the bay
vent_high_n = 4;    // outlet slots on each side
vent_high_y0= 44;   // first outlet slot (up to ~62)
vent_pitch  = 6;

$fn = 64;

// ------------------------------------------------------------
standoff_h = board_standoff;
pack_dx = pack_horizontal ? pack_l : pack_w;   // pack footprint along x / y
pack_dy = pack_horizontal ? pack_w : pack_l;
// inner depth: the largest need among the board, the power supply and the pack
in_d  = max(standoff_h + 1.6 + board_headroom,
            pcb_post_h + 1.6 + psu_comp_h + 0.5 + psu_top,
            pack_t + 3);
// battery bay below the main part: y from bay_y0 to bay_y1
cradle_dy = pack_dy + 2*0.6 + 2*1.6;
div_y1 = -in_h/2;                 // top face of the dividing wall
div_y0 = div_y1 - div_t;
bay_y1 = div_y0;
bay_y0 = bay_y1 - cradle_dy - 2*bay_margin;
bay_yc = (bay_y0 + bay_y1)/2;
seam_y = (div_y0 + div_y1)/2;     // lid / door joint
pack_x = 0;
pack_y = bay_yc;
in_yc  = (in_h/2 + bay_y0)/2;     // centre of the whole inside
in_ht  = in_h/2 - bay_y0;         // whole inner height
out_w = in_w + 2*wall;
out_h = in_ht + 2*wall;
door_boss = [for (sx = [-1,1]) [sx*(in_w/2 - boss_d/2 + 0.5), bay_yc]];
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
psu_y0   = div_y1;
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
                translate([0, in_yc, 0]) rrect(out_w, out_h, corner_r, base_h);
                translate([0, in_yc, floor_t])
                    rrect(in_w, in_ht, max(corner_r - wall, 0.5), base_h);
            }
            // wall between the main part and the battery bay (full height)
            translate([-in_w/2 - 0.5, div_y0, 0]) cube([in_w + 1, div_t, base_h]);
            // columns for the door screws
            for (p = door_boss) translate([p[0], p[1], 0]) cylinder(d = boss_d, h = base_h);
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
        for (p = concat(boss_pos, door_boss)) screw_hole_in(p, base_h);
        // slot for the battery wires in the dividing wall (open at the top)
        translate([bat_slot_x - bat_slot_w/2, div_y0 - 0.1, floor_t + 3])
            cube([bat_slot_w, div_t + 0.2, base_h]);
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
        // vent slots on the left and right walls: low inlets, high outlets
        if (vents) for (sx = [-1,1], y = concat(
                [for (i = [0:vent_low_n-1])  psu_y1 + 4 + i*vent_pitch],
                [for (i = [0:vent_high_n-1]) vent_high_y0 + i*vent_pitch]))
            translate([sx*(in_w/2 + wall/2), y, floor_t + in_d/2])
                cube([wall + 2, vent_w, vent_l], center = true);
    }
}

// L-shaped guides at the board corners (they centre it, they don't clamp it)
// insulating separator: board footprint (fits inside the corner guides), holes for
// the standoffs, a few slots so warm air from the pack can still rise
module separator() {
    difference() {
        translate([-(board_w - 0.6)/2, -(board_h - 0.6)/2, 0]) cube([board_w - 0.6, board_h - 0.6, sep_t]);
        for (sx = [-1,1], sy = [-1,1])
            translate([sx*board_hole_dx/2, sy*board_hole_dy/2, -0.1]) cylinder(d = standoff_d + 0.8, h = sep_t + 0.2);
        for (i = [-2:2]) translate([i*10, 0, -0.1])
            linear_extrude(sep_t + 0.2) offset(1) square([0.01, board_h/2], center = true);
    }
}

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

// battery pack cradle in the battery bay (long side horizontal if pack_horizontal).
// Opening for the wires on the left, notches for the strap.
module pack_cradle() {
    c = 0.6; t = 1.6;
    X = pack_dx + 2*c; Y = pack_dy + 2*c;   // cradle inside
    translate([pack_x, pack_y, floor_t])
    difference() {
        translate([-X/2 - t, -Y/2 - t, 0]) cube([X + 2*t, Y + 2*t, pack_wall_h]);
        translate([-X/2, -Y/2, -0.1]) cube([X, Y, pack_wall_h + 0.2]);
        // wire passage on the left side, top end (towards the slot in the wall)
        translate([-X/2 - t - 0.1, Y/2 - 20, 2]) cube([t + 0.2, 16, pack_wall_h]);
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
// outline of the whole enclosure (2D), offset by o (negative = inwards)
module outline2d(o = 0) {
    r = max(corner_r + o, 0.5);
    translate([0, in_yc]) offset(r) square([out_w + 2*o - 2*r, out_h + 2*o - 2*r], center = true);
}
// part of the outline above (top = true) or below the seam
module half2d(top, o = 0, cut = 0) {
    intersection() {
        outline2d(o);
        if (top) translate([-500, seam_y + cut]) square(1000);
        else     translate([-500, seam_y - cut - 1000]) square(1000);
    }
}
// centring lip: U-shaped (open on the dividing wall side), 3 mm deep
module lip(top) {
    o = -wall - fit;
    linear_extrude(3) difference() {
        half2d(top, o, div_t/2 + fit);
        half2d(top, o - 1.6, 0);
        for (p = concat(boss_pos, door_boss)) translate(p) circle(d = boss_d + 1);
        translate([-500, seam_y - (div_t/2 + fit + 1.7)]) square([1000, 2*(div_t/2 + fit + 1.7)]);
    }
}

module lid_assembled() {
    z0 = base_h;    // the lid rests on the rim of the walls
    difference() {
        union() {
            translate([0, 0, z0]) linear_extrude(lid_t) half2d(true, 0, fit/2);
            // centring lip that fits inside the enclosure
            translate([0, 0, z0 - 3]) lip(true);
            // light box: white walls around the strip, from the lid down to just
            // above the LED rib. Light bounces inside and leaves only through the
            // diffuser, so the LEDs merge into one even bar. Print the lid in white
            // or line the inside of the box with white paint / aluminium tape.
            if (use_lightbox) lightbox();
            // tubes guiding the PowerBoost light pipes
            if (use_lightpipes) lp_tubes();
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
        // logo recess on the visible face
        if (logo_mode != "none")
            translate([0, 0, z0 + lid_t - logo_depth]) logo_solid("all", logo_depth + 0.1);
        // PowerBoost light pipe holes (through the lid and the tubes)
        if (use_lightpipes) for (p = lp_pos)
            translate([p[0], p[1], lp_bot + p[2] - 0.1]) {
                cylinder(d = lp_bore, h = base_h - lp_bot - p[2] + 0.1, $fn = 24);
                translate([0, 0, base_h - lp_bot - p[2]]) cylinder(d = lp_hole, h = lid_t + 0.3, $fn = 24);
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

// ---------------- LOGO ----------------
// Chip with Wi-Fi waves, from the upirox logo (SVG viewBox 120 x 120, y down).
function lg(p) = [(p[0] - 60) * logo_size / 120, (60 - p[1]) * logo_size / 120];
module lg_line(a, b, w) {   // stroke with round caps
    hull() for (p = [a, b]) translate(lg(p)) circle(d = w * logo_size / 120, $fn = 24);
}
module lg_arc(r, w) {       // Wi-Fi wave centred on the dot, 45..135 degrees
    k = logo_size / 120;
    for (i = [0:17]) hull() for (a = [45 + i*5, 50 + i*5])
        translate(lg([60 + r*cos(a), 72 - r*sin(a)])) circle(d = w * k, $fn = 20);
}
module logo_2d(which) {
    k = logo_size / 120;
    if (which == "chip" || which == "all") {
        // body: 64 x 64 rounded square, 7 wide stroke
        difference() {
            offset(r = (12 + 3.5) * k) square((64 - 24) * k, center = true);
            offset(r = (12 - 3.5) * k) square((64 - 24) * k, center = true);
        }
        // pins
        for (v = [44, 60, 76]) {
            lg_line([12, v], [26, v], 6);  lg_line([94, v], [108, v], 6);
            lg_line([v, 12], [v, 26], 6);  lg_line([v, 94], [v, 108], 6);
        }
    }
    if (which == "wifi" || which == "all") {
        lg_arc(24, 6);
        lg_arc(14, 6);
        translate(lg([60, 72])) circle(r = 5 * k, $fn = 32);
    }
}
module logo_solid(which, h) {
    translate([logo_x, logo_y, 0]) linear_extrude(h) logo_2d(which);
}
// inlay parts, in the same position as the printed lid (visible face on the bed)
module logo_part_print(which) {
    rotate([180, 0, 0]) translate([0, 0, -(base_h + lid_t)])
        translate([0, 0, base_h + lid_t - logo_depth]) logo_solid(which, logo_depth);
}

// ---------------- POWERBOOST LIGHT PIPES ----------------
pb_x0 = pb_x - pb_l/2;                 // board corner on the micro-USB / pads side
pb_y0 = pb_y - pb_w/2;
lp_pos = [for (l = pb_leds) [pb_x0 + l[0], pb_y0 + l[1], l[3]]];
lp_pcb_top = floor_t + 2 + 1.6;        // feet + PCB
lp_led_top = lp_pcb_top + 0.8;         // + 0805 LED
lp_div_t   = 0.8;                      // divider between DONE and CHRG
lp_bot = lp_led_top + lp_led_gap;      // bottom of the tubes and of the rods
lp_len = base_h + lid_t - lp_bot;      // rod length, flush with the lid face

module lp_tubes() {
    for (p = lp_pos) translate([p[0], p[1], lp_bot + p[2]])
        cylinder(d = lp_bore + 2*lp_wall, h = base_h - lp_bot - p[2] + 0.5, $fn = 24);
    // DONE and CHRG are close: join their tubes with a web (stiffer, no gap)
    hull() for (i = [1, 2]) translate([lp_pos[i][0], lp_pos[i][1], lp_bot])
        cylinder(d = lp_bore + 2*lp_wall, h = base_h - lp_bot + 0.5, $fn = 24);
    // divider between DONE and CHRG, down to just above the LED tops (it never
    // touches the LEDs, even with the board shifted in its cradle): it blocks the
    // straight path from one LED to the end of the other rod
    translate([(lp_pos[1][0] + lp_pos[2][0])/2 - lp_div_t/2, lp_pos[1][1] - (lp_bore/2 + lp_wall),
               lp_led_top + 0.1])
        cube([lp_div_t, lp_bore + 2*lp_wall, lp_bot - lp_led_top - 0.1 + 0.5]);
}
echo(str("LIGHT PIPES: acrylic rods d", lp_d, " mm: DONE, CHRG, PWR ", lp_len,
         " mm, LOW ", lp_len - pb_leds[0][3], " mm"));

// ---------------- BATTERY DOOR (in assembled position) ----------------
module door_assembled() {
    z0 = base_h;
    difference() {
        union() {
            translate([0, 0, z0]) linear_extrude(lid_t) half2d(false, 0, fit/2);
            translate([0, 0, z0 - 3]) lip(false);
            // ribs that keep the pack in its cradle (1 mm above it)
            if (door_ribs) for (sx = [-1, 1])
                translate([pack_x + sx*pack_dx/4 - 0.8, pack_y - pack_dy/2 + 6, floor_t + pack_t + 1])
                    cube([1.6, pack_dy - 12, z0 - floor_t - pack_t - 1 + 0.5]);
        }
        for (p = door_boss) translate([p[0], p[1], z0 - 0.1]) {
            cylinder(d = lid_screw_d, h = lid_t + 0.2);
            translate([0, 0, lid_t - lid_head_h + 0.1])
                cylinder(d1 = lid_screw_d, d2 = lid_head_d, h = lid_head_h);
        }
        if (door_icon) translate([0, bay_yc, z0 + lid_t - 0.6]) linear_extrude(1) {
            difference() { square([26, 13], center = true); square([22.4, 9.4], center = true); }
            translate([13, 0]) square([3, 5], center = true);
        }
    }
}
module door_print() {
    rotate([180, 0, 0]) translate([0, 0, -(base_h + lid_t)]) door_assembled();
}

// lid rotated for printing: visible face on the bed
module lid_print() {
    rotate([180, 0, 0]) translate([0, 0, -(base_h + lid_t)]) lid_assembled();
}

// ---------------- DIFFUSER ----------------
module win_slot(r) { offset(r) square([win_w - win_h, 0.02], center = true); }
// plug, front face at z = 0 (as printed); in the lid the front is flush with the face
module window_plug() {
    difference() {
        union() {
            linear_extrude(lid_t) win_slot(win_h/2 - plug_clear);
            translate([0, 0, lid_t]) linear_extrude(plug_flange_t) win_slot(win_h/2 + plug_flange);
        }
        // hollow behind the skin: the light only crosses plug_skin of plastic
        translate([0, 0, plug_skin]) linear_extrude(lid_t + plug_flange_t)
            win_slot(win_h/2 - plug_clear - plug_wall);
    }
}
module diffuser() {
    if (diff_type == "plug") window_plug();
    else if (diff_type == "printed")
        linear_extrude(diff_t - 0.15)
            offset(win_h/2 + diff_margin - 0.25) square([win_w - win_h, 0.02], center = true);
    else   // the acrylic bar (preview only)
        translate([-diff_pmma_l/2, -diff_pmma_w/2, 0]) cube([diff_pmma_l, diff_pmma_w, diff_t]);
}

// ------------------------------------------------------------
if (part == "base") base();
if (part == "lid") lid_print();
if (part == "diffuser") diffuser();
if (part == "separator") separator();
if (part == "logo_chip" && logo_mode == "inlay") logo_part_print("chip");
if (part == "logo_wifi" && logo_mode == "inlay") logo_part_print("wifi");
echo(str("ENCLOSURE: ", out_w, " x ", out_h, " x ", base_h + lid_t,
         " mm; side opening centre ", in_h/2 + wall - psu_y1, " mm below the top edge"));
echo(str("DIFFUSER: ", diff_type == "pmma" ? str("opal acrylic bar ", diff_pmma_l, " x ", diff_pmma_w, " x ", diff_t, " mm")
     : diff_type == "plug" ? "printed plug flush with the lid, part = diffuser (white PETG)" : "printed, part = diffuser"));
if (part == "lid230") psu_lid();
if (part == "door") door_print();
if (part == "all") {
    base();
    color("OrangeRed") translate([psu_x0, psu_y0 + fit, psu_ztop + 8]) psu_lid();
    if (use_separator)   // resting on the pack, under the board
        color("Gold") translate([board_x, board_y, floor_t + standoff_h - sep_t - 0.5]) separator();
    color("SteelBlue", 0.6) translate([0, 0, 25]) lid_assembled();
    color("SlateGray", 0.6) translate([0, 0, 25]) door_assembled();
    if (logo_mode != "none") translate([0, 0, 25 + base_h + lid_t - logo_depth]) {
        color("#0B3A82") logo_solid("chip", logo_depth);
        color("#1F9BD7") logo_solid("wifi", logo_depth);
    }
    if (diff_type == "plug")   // in place: front flush with the lid face
        color("White") translate([0, strip_y, 25 + base_h + lid_t]) mirror([0,0,1]) window_plug();
    else
        color("White") translate([0, strip_y, base_h + 25 - 0.05]) mirror([0,0,1]) diffuser();
    // (pmma: the bar lies inside the light box, against the lid)
}
