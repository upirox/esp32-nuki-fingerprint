// ============================================================
//  OXID logo, 2D (y up), for engraving / multi-material inlays.
//  Same geometry as the SVG files in logo/ (oxid-wordmark.svg,
//  oxid-icon.svg, oxid-engrave.svg).
//  Use it with:  use <oxid_logo.scad>
//
//  oxid_wordmark_2d(w, which): "OXID", w = width in mm (height = 0.294 w)
//      which = "dark"   O, I, D            (navy  #0F1E3D)
//              "accent" X + chip + dot     (blue  #1F8BF5)
//              "all"    both
//      centred on the origin
//  oxid_icon_2d(size, simple): ring + X + chip, size = width in mm,
//      centred on the origin. simple = true: no chip pins and a wider gap
//      around the chip, for small engravings (below ~30 mm)
// ============================================================


// ---- helpers (logo units) ----
module _ring_arc(cx, cy, r, w, a0, a1, step = 3) {     // round-capped arc, a0 < a1
    n = ceil((a1 - a0)/step);
    for (i = [0 : n - 1]) hull()
        for (b = [a0 + i*(a1 - a0)/n, a0 + (i + 1)*(a1 - a0)/n])
            translate([cx + r*cos(b), cy + r*sin(b)]) circle(d = w, $fn = 32);
}
module _rsq(cx, cy, s, r) {                             // rounded square
    translate([cx, cy]) offset(r) square(s - 2*r, center = true);
}
module _chip(cx, cy, s, ko, pins = true, die = true) {
    difference() {
        _rsq(cx, cy, s, s*0.2);
        if (die) _rsq(cx, cy, s*0.32, s*0.08);
    }
    if (pins) {
        pl = (ko - s)/2*0.62; pw = s*0.11;
        for (i = [-1:1]) let(o = i*s*0.28) {
            translate([cx + o - pw/2, cy + s/2])      square([pw, pl]);
            translate([cx + o - pw/2, cy - s/2 - pl]) square([pw, pl]);
            translate([cx + s/2, cy + o - pw/2])      square([pl, pw]);
            translate([cx - s/2 - pl, cy + o - pw/2]) square([pl, pw]);
        }
    }
}

// ---- wordmark: units 0..340 x 0..100 ----
module _wm_dark() {
    _ring_arc(50, 50, 41, 18, 78, 372);                  // O, open at the top-right
    translate([216, 0]) square([18, 100]);              // I
    difference() {                                      // D
        union() {
            translate([250, 0]) square([42, 100]);
            translate([292, 50]) intersection() { circle(50, $fn = 96); translate([0, -50]) square([50, 100]); }
        }
        union() {
            translate([268, 18]) square([24.01, 64]);
            translate([292, 50]) intersection() { circle(32, $fn = 96); translate([0, -32]) square([32, 64]); }
        }
    }
}
module _wm_accent() {
    translate([50 + 41*cos(45), 50 + 41*sin(45)]) circle(6.5);   // signal dot
    difference() {                                      // X, with room for the chip
        union() {
            polygon([[116, 0], [137, 0], [200, 100], [179, 100]]);
            polygon([[179, 0], [200, 0], [137, 100], [116, 100]]);
        }
        _rsq(158, 50, 40, 7.2);
    }
    _chip(158, 50, 24, 40);
}
module oxid_wordmark_2d(w = 100, which = "all") {
    scale(w/340) translate([-170, -50]) {
        if (which == "dark"   || which == "all") _wm_dark();
        if (which == "accent" || which == "all") _wm_accent();
    }
}

// ---- icon: units 0..120 ----
module oxid_icon_2d(size = 20, simple = false) {
    ko = simple ? 21 : 19;
    cs = simple ? 11 : 12;
    scale(size/120) translate([-60, -60]) {
        _ring_arc(60, 60, 38, 11, 73, 377);
        translate([60 + 38*cos(45), 60 + 38*sin(45)]) circle(4.6);
        difference() {
            for (a = [45, 135]) hull()
                for (s = [-1, 1]) translate([60 + s*21*cos(a), 60 + s*21*sin(a)]) circle(d = 9);
            _rsq(60, 60, ko, ko*0.18);
        }
        _chip(60, 60, cs, ko, pins = !simple, die = !simple);
    }
}
