// ============================================================
//  Cable cover: indoor 503 (BTicino Livinglight, 3 modules) -> ESP32 box
//
//  The cables (230 V + 2 ethernet from the outdoor plate) leave the
//  indoor 503 through a PRE-DRILLED Livinglight blank in the leftmost
//  module. This cover:
//    - sits on the blank face, inside the plate window (it covers the
//      whole module, so it looks like a module of its own);
//    - climbs over the curved left border of the plate;
//    - crosses the gap to the wall and ends against the right wall of
//      the ESP32 box, in front of its side opening (signals above the
//      rib, 230 V below).
//  Open at the back (like a trunking): the wall, the plate and the blank
//  close it. An inner divider keeps the 230 V cable apart from the
//  ethernet cables all the way to the box (it ends at the blank hole).
//
//  Fixing: removable double-sided tape under the wall flanges and under
//  the cap walls. DO NOT glue it hard to the blank: the cover sits over
//  the plate border, so it must come off (pull it forward) before the
//  plate can be removed.
//
//  Box position: right wall of the box "gap" mm from the left edge of the
//  plate, TOP edge of the box box_top_y mm above the plate centre, so that
//  its side opening is centred on the plate (default: 107.4 mm above; the
//  ENCLOSURE line in the console of the box file gives the same number).
//
//  Coordinates: x to the right (x = 0 at the left edge of the plate),
//  y up (y = 0 at the plate centre), z out of the wall (z = 0 on the wall).
//  Print: lying on its top face (roof down), no supports except the
//  flanges (or print with the flanges on the bed: see print_flip).
//  Material: PETG (as the box).
// ============================================================

/* [Plate (measured)] */
pl_w     = 117.5;  // plate width
pl_h     = 78;     // plate height
win_w    = 67;     // window width (3 modules)
win_h    = 44;     // window height
bord_w   = 26;     // left border: outer edge -> window
t_edge   = 6;      // plate thickness at the outer edge
t_10     = 7;      // ... 10 mm in from the outer edge
t_max    = 10;     // ... at the window
blank_rec= 1;      // blank face behind the plate face

/* [Blank hole] */
hole_d   = 12;     // hole in the pre-drilled blank (drill it to 16 for 3 cables)
hole_dy  = 0;      // hole centre above the plate centre

/* [Channel] */
gap      = 20;     // plate left edge -> box right wall
ch_in_w  = 24;     // inner width (= box opening: 12 signals + 2 rib + 10 mains)
ch_clear = 9;      // inner height over the plate (largest cable + ~1)
open_h   = 11;     // box opening height (side_open_h in the box file)
t        = 1.6;    // wall / roof thickness
div_t    = 2;      // divider thickness (= the rib of the box)
div_y    = -2;     // divider bottom edge (y): 230 V below, signals above
flange_w = 5;      // wall flanges for the tape (each side, in the gap)
cap_clr  = 0.3;    // cap clearance in the window
cap_mods = 1;      // modules covered by the cap: 1 (pre-drilled blank only)
                   // or 2 (also the plain blank next to it: more room inside)
mod_w    = win_w/3; // window modules, from the left: pre-drilled blank,
                    // blank, Italian socket

/* [Box (for the preview only)] */
box_out_w = 144.8;
box_out_h = 233.2;
box_out_d = 35.6;
box_top_y = 107.4;  // top edge of the box above the side opening centre

$fn = 48;

// ---- derived ----
blank_z = t_max - blank_rec;
// left border profile: parabola through (0,t_edge) (10,t_10) (bord_w,t_max)
pa = ((t_max - t_edge) - (t_10 - t_edge) * bord_w / 10) / (bord_w*bord_w - 10*bord_w);
pb = (t_10 - t_edge) / 10 - pa * 10;
function pz(x) = x < 0 ? 0 : x <= bord_w ? t_edge + pb*x + pa*x*x : t_max;

cap_x0 = bord_w + cap_clr;
cap_x1 = bord_w + cap_mods*mod_w - cap_clr;
cap_h  = win_h - 2*cap_clr;
hole_x = bord_w + mod_w/2;
cap_zi = t_max + ch_clear;              // inside of the cap roof
// roof inside: ramps from the box opening up to the plate, then follows it
function zi(x) = x < 0 ? open_h + (pz(0) + ch_clear - open_h) * (x + gap) / gap
                       : min(pz(x) + ch_clear, cap_zi);
function zo(x) = zi(x) + t;

// region under f between x0 and x1, in the xz plane, y from y0 to y1
module under(x0, x1, y0, y1, outer = true, n = 40) {
    pts = concat([[x0, -1]],
                 [for (i = [0:n]) let(x = x0 + (x1 - x0) * i / n)
                     [x, outer ? zo(x) : zi(x)]],
                 [[x1, -1]]);
    translate([0, y1, 0]) rotate([90, 0, 0])
        linear_extrude(y1 - y0) polygon(pts);
}

// what is already there: wall, plate, blank
module env() {
    translate([-500, -500, -50]) cube([1000, 1000, 50]);
    difference() {
        translate([0, pl_h/2, 0]) rotate([90, 0, 0]) linear_extrude(pl_h)
            polygon(concat([[0, -1]],
                [for (i = [0:40]) let(x = bord_w * i / 40) [x, pz(x)]],
                [[pl_w - bord_w, t_max], [pl_w, t_edge], [pl_w, -1]]));
        translate([bord_w, -win_h/2, -1]) cube([win_w, win_h, 50]);
    }
    translate([bord_w, -win_h/2, -1]) cube([win_w, win_h, blank_z + 1]);
}

module cover() {
    yo = ch_in_w/2 + t;
    difference() {
        union() {
            difference() {
                union() {
                    under(-gap, cap_x0 + t, -yo, yo);                       // channel
                    translate([cap_x0, -cap_h/2, 0])
                        cube([cap_x1 - cap_x0, cap_h, cap_zi + t]);          // cap
                    translate([-gap, -yo - flange_w, 0])
                        cube([gap - 1, 2*(yo + flange_w), t]);               // flanges
                }
                under(-gap - 1, cap_x1 - t, -ch_in_w/2, ch_in_w/2, false);   // channel inside
                translate([cap_x0 + t, -cap_h/2 + t, -1])
                    cube([cap_x1 - cap_x0 - 2*t, cap_h - 2*t, cap_zi + 1]);  // cap inside
                translate([-gap - 1, -ch_in_w/2, -1])
                    cube([gap, ch_in_w, open_h + 1]);                         // flanges: cable path
            }
            // divider: from the box to the edge of the blank hole
            intersection() {
                translate([-gap, div_y, -1])
                    cube([hole_x - hole_d/2 - 1 + gap, div_t, 100]);
                union() {
                    under(-gap - 1, cap_x1, -50, 50, false);
                    translate([cap_x0, -50, -1]) cube([cap_x1 - cap_x0, 100, cap_zi + 1]);
                }
            }
        }
        env();
    }
}

cover();

// preview of the surroundings (%: not exported)
%env_preview();
module env_preview() {
    intersection() { env(); translate([-1, -pl_h/2, 0]) cube([pl_w + 2, pl_h, 30]); }
    translate([hole_x, hole_dy, blank_z - 2]) color("red") cylinder(d = hole_d, h = 2.1);
    translate([-gap - box_out_w, box_top_y - box_out_h, 0])
        cube([box_out_w, box_out_h, box_out_d]);
}

echo(str("COVER: cap top ", cap_zi + t, " mm from the wall, ",
         cap_zi + t - t_max, " mm in front of the plate; cap inside ",
         cap_x1 - cap_x0 - 2*t, " x ", cap_h - 2*t, " mm (hole up to ~",
         min(cap_x1 - cap_x0 - 2*t, ch_in_w) - 1, " mm)"));
