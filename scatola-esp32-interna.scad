// ============================================================
//  Scatola interna per ESP32 - ingresso terzo piano
//  Contiene: ESP32 38 pin su scheda di espansione a morsetti,
//            buzzer interno (campanello / sirene),
//            striscia WS2812 da 8 LED = luce di stato della porta,
//            alimentatore 230 V -> 5 V Hi-Link HLK-5M05 in un VANO
//            SEPARATO con coperchietto proprio (aprendo la scatola per
//            la scheda non si toccano parti in tensione).
//  Si fissa al muro dietro la placca esterna: i cavi arrivano
//  dal foro sul fondo, allineato al passaggio nel muro.
//
//  PARTI (cambia "part" ed esporta un STL per ognuna):
//    "base"       scatola, stampata con il fondo sul piano
//    "coperchio"  stampato con la faccia a vista sul piano
//    "coperchio230" coperchietto del vano 230 V (2 viti M3)
//    "diffusore"  lamella per la finestra dei LED: stampala in
//                 PETG bianco o trasparente (o "natural"), 2-3 strati
//    "tutto"      anteprima montata con coperchio sollevato
//
//  Viti: 4 x M3 x 10 autofilettanti per il coperchio,
//        2 x M3 x 8 per il coperchietto del vano 230 V,
//        4 viti da 4 mm + tasselli per il muro.
//  Materiale: PETG o ASA (NON PLA: c'e' un alimentatore a 230 V).
//  Il cavo di rete entra con un pressacavo PG7 sulla parete destra.
//
//  PRIMA DI STAMPARE misura la tua scheda a morsetti e correggi
//  board_w / board_h e board_hole_dx / board_hole_dy: le schede
//  in commercio non sono tutte uguali.
//  VERSIONE SENZA ALIMENTATORE BACKUPPATO DA BATTERIE
// ============================================================

/* [Parte da esportare] */
part = "tutto";            // "base", "coperchio", "coperchio230", "diffusore", "tutto"

/* [Scatola] */
in_w     = 190;   // larghezza interna
in_h     = 110;   // altezza interna
in_d     = 32;    // profondita' interna (dal fondo al coperchio)
wall     = 2.4;   // spessore pareti
floor_t  = 3;     // spessore fondo
lid_t    = 2.5;   // spessore coperchio
corner_r = 4;     // raggio esterno degli angoli
fit      = 0.3;   // gioco tra coperchio e pareti

/* [Viti del coperchio (M3 autofilettanti)] */
boss_d       = 8;
boss_pilot_d = 2.6;   // foro per vite M3 autofilettante
lid_screw_d  = 3.4;
lid_head_d   = 6.5;   // svasatura della testa
lid_head_h   = 1.8;

/* [Scheda ESP32 a morsetti (posizione = centro scheda)] */
board_x       = -45;
board_y       = 14;
board_w       = 80;   // ingombro scheda + morsetti
board_h       = 65;
board_hole_dx = 72;   // interasse fori di fissaggio (MISURALO)
board_hole_dy = 55;
standoff_d    = 6;
standoff_h    = 5;    // sotto la scheda: spazio per i fili
standoff_pilot= 2.5;  // vite M3 autofilettante o M2,5
board_guides  = true; // squadrette agli angoli che centrano la scheda

/* [Buzzer interno (modulo 32,5 x 13, fissato al coperchio)] */
buzz_x        = 52;
buzz_y        = 40;
buzz_d        = 12;
buzz_ring_h   = 6;
buzz_ring_w   = 1.2;
sound_hole_d  = 1.6;

/* [Striscia LED di stato (WS2812, 8 LED)] */
led_n      = 8;
led_pitch  = 16.67;  // 60 LED/m = 16,67 mm | 30 LED/m = 33,3 | stick 8 LED = 6,5
strip_w    = 10.5;   // larghezza striscia + gioco
strip_y    = -40;    // posizione della striscia (centro)
led_gap    = 6;      // distanza LED - coperchio: piu' alta = luce piu' uniforme
win_h      = 6;      // altezza della finestra luminosa
diff_t     = 1.0;    // spessore diffusore
diff_margin= 2;      // battuta del diffusore attorno alla finestra

/* [Foro cavi dal muro (sul fondo)] */
cable_x  = 12;
cable_y  = -5;
cable_d  = 25;

/* [Vano 230 V per HLK-5M05 (in basso a destra)] */
psu_x0     = 32;    // bordo sinistro del vano (interno scatola)
psu_y0     = -32;   // bordo inferiore
psu_y1     = 26;    // bordo superiore
psu_wall   = 2;
psu_top    = 5;     // il vano finisce 5 mm sotto il bordo della scatola
psu_lid_t  = 2;
mod_l      = 38;    // ingombro modulo HLK-5M05 (MISURALO: 35-38)
mod_w      = 25;    //                                    23-25
mod_x      = 62;    // centro del modulo
mod_y      = 4;
gland_y    = -6;    // pressacavo PG7 sulla parete destra
gland_d    = 12.6;
out_hole_d = 6;     // passaggio fili 5 V verso la scheda

/* [Antenna (parete superiore)] */
ant_x    = 60;
ant_d    = 6.6;    // connettore SMA / RP-SMA da pannello

/* [Fissaggio a muro (fori sul fondo)] */
wall_holes   = [[-60,-26],[20,-26],[8,45],[72,45]];
wall_screw_d = 4.5;
wall_head_d  = 8.5;

/* [Aerazione] */
vents      = true;
vent_w     = 2;
vent_l     = 14;
vent_n     = 7;
vent_x0    = -80;   // prima feritoia (pareti superiore e inferiore)

$fn = 64;

// ------------------------------------------------------------
out_w = in_w + 2*wall;
out_h = in_h + 2*wall;
base_h = floor_t + in_d;
strip_len = led_n * led_pitch;
win_w = strip_len - 4;
// le colonne entrano di 0,5 mm nelle pareti: se fossero solo tangenti
// OpenSCAD segnalerebbe "not a valid 2-manifold"
boss_pos = [for (sx=[-1,1], sy=[-1,1]) [sx*(in_w/2 - boss_d/2 + 0.5), sy*(in_h/2 - boss_d/2 + 0.5)]];
psu_x1   = in_w/2;                       // a destra il vano usa la parete esterna
psu_ztop = floor_t + in_d - psu_top;     // altezza pareti del vano
psu_posts = [[psu_x0 + psu_wall + 3, psu_y0 + psu_wall + 3],     // d = 7: entrano 0,5 mm nelle pareti
             [psu_x1 - 3,            psu_y1 - psu_wall - 3]];

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
            // colonne per le viti del coperchio
            for (p = boss_pos) translate([p[0], p[1], 0])
                cylinder(d = boss_d, h = base_h);
            // distanziali della scheda
            for (sx = [-1,1], sy = [-1,1])
                translate([board_x + sx*board_hole_dx/2, board_y + sy*board_hole_dy/2, 0])
                    cylinder(d = standoff_d, h = floor_t + standoff_h);
            if (board_guides) board_corner_guides();
            led_rib();
            psu_bay();
        }
        // fori viti coperchio
        for (p = boss_pos) translate([p[0], p[1], floor_t])
            cylinder(d = boss_pilot_d, h = base_h);
        // fori distanziali
        for (sx = [-1,1], sy = [-1,1])
            translate([board_x + sx*board_hole_dx/2, board_y + sy*board_hole_dy/2, 1])
                cylinder(d = standoff_pilot, h = base_h);
        // foro cavi dal muro
        translate([cable_x, cable_y, -0.1]) cylinder(d = cable_d, h = floor_t + 0.2);
        // fori per il muro (svasati dall'interno)
        for (p = wall_holes) translate([p[0], p[1], -0.1]) {
            cylinder(d = wall_screw_d, h = floor_t + 0.2);
            translate([0, 0, floor_t - 2.4 + 0.1])
                cylinder(d1 = wall_screw_d, d2 = wall_head_d, h = 2.4);
        }
        // pressacavo del cavo di rete (parete destra, dentro il vano)
        translate([in_w/2 - 1, gland_y, floor_t + 12])
            rotate([0, 90, 0]) cylinder(d = gland_d, h = wall + 2);
        // fori dei paletti del coperchietto 230 V
        for (p = psu_posts) translate([p[0], p[1], floor_t + 2])
            cylinder(d = boss_pilot_d, h = base_h);
        // passaggio dei fili 5 V dal vano verso la scheda
        translate([psu_x0 - 1, 0, floor_t + 6])
            rotate([0, 90, 0]) cylinder(d = out_hole_d, h = psu_wall + 2);
        // antenna (parete superiore)
        translate([ant_x, in_h/2 - 1, floor_t + in_d/2])
            rotate([-90, 0, 0]) cylinder(d = ant_d, h = wall + 2);
        // feritoie di aerazione (pareti superiore e inferiore)
        if (vents) for (i = [0:vent_n-1], sy = [-1,1])
            translate([vent_x0 + i*(vent_w + 4), sy*(in_h/2 + wall/2), floor_t + in_d/2])
                cube([vent_w, wall + 2, vent_l], center = true);
    }
}

// squadrette a L agli angoli della scheda (la centrano, non la stringono)
module board_corner_guides() {
    g = 1.2; l = 8; h = floor_t + standoff_h + 3;
    for (sx = [-1,1], sy = [-1,1])
        translate([board_x + sx*(board_w/2 + 0.4 + g/2), board_y + sy*(board_h/2 + 0.4 + g/2), 0]) {
            translate([-sx*(l/2 - g/2), 0, h/2]) cube([l, g, h], center = true);
            translate([0, -sy*(l/2 - g/2), h/2]) cube([g, l, h], center = true);
        }
}

// trave cava che porta la striscia LED rivolta verso il coperchio
module led_rib() {
    top = base_h - led_gap - 2;     // 2 mm = spessore striscia + LED
    w = strip_w + 2;
    translate([0, strip_y, 0])
    difference() {
        translate([-strip_len/2, -w/2, 0]) cube([strip_len, w, top]);
        // interno vuoto (meno plastica), chiuso sopra dove si incolla la striscia
        translate([-strip_len/2 + 1.6, -w/2 + 1.6, floor_t]) cube([strip_len - 3.2, w - 3.2, top - floor_t - 1.6]);
    }
    // bordini che tengono la striscia dritta
    translate([0, strip_y, top])
        for (sy = [-1,1]) translate([-strip_len/2, sy*(strip_w/2 + 0.6) - 0.6, 0])
            cube([strip_len, 1.2, 1.2]);
}

// vano separato per l'alimentatore 230 V: pareti, paletti, culla del modulo
module psu_bay() {
    // pareti sinistra, inferiore e superiore (a destra c'e' la parete esterna)
    translate([psu_x0, psu_y0, 0]) cube([psu_wall, psu_y1 - psu_y0, psu_ztop]);
    translate([psu_x0, psu_y0, 0]) cube([psu_x1 - psu_x0, psu_wall, psu_ztop]);
    translate([psu_x0, psu_y1 - psu_wall, 0]) cube([psu_x1 - psu_x0, psu_wall, psu_ztop]);
    // paletti per le viti del coperchietto
    for (p = psu_posts) translate([p[0], p[1], 0]) cylinder(d = 7, h = psu_ztop);
    // culla del modulo: bordini alti 4 mm (fissalo con una goccia di colla a caldo)
    translate([mod_x, mod_y, floor_t])
    difference() {
        translate([-(mod_l + 0.6)/2 - 1.2, -(mod_w + 0.6)/2 - 1.2, 0])
            cube([mod_l + 0.6 + 2.4, mod_w + 0.6 + 2.4, 4]);
        translate([-(mod_l + 0.6)/2, -(mod_w + 0.6)/2, -0.1])
            cube([mod_l + 0.6, mod_w + 0.6, 4.2]);
        // aperture per i piedini e i fili
        for (sx = [-1,1]) translate([sx*(mod_l/2 + 0.6), 0, 2.2]) cube([4, mod_w - 6, 4.4], center = true);
    }
}

// coperchietto del vano 230 V (si stampa cosi', piatto)
module psu_lid() {
    w = psu_x1 - psu_x0 - fit;
    h = psu_y1 - psu_y0;
    difference() {
        cube([w, h, psu_lid_t]);
        for (p = psu_posts) translate([p[0] - psu_x0, p[1] - psu_y0, -0.1]) {
            cylinder(d = 3.4, h = psu_lid_t + 0.2);
            translate([0, 0, psu_lid_t - 1.5 + 0.1]) cylinder(d1 = 3.4, d2 = 6.2, h = 1.5);
        }
        // scritta di avvertimento incisa
        translate([w/2, h/2, psu_lid_t - 0.6])
            linear_extrude(1) text("230 V", size = 9, halign = "center", valign = "center");
    }
}

// ---------------- COPERCHIO (in posizione di montaggio) ----------------
module lid_assembled() {
    z0 = base_h;    // il coperchio appoggia sul bordo delle pareti
    difference() {
        union() {
            translate([0, 0, z0]) rrect(out_w, out_h, corner_r, lid_t);
            // bordino di centraggio che entra nella scatola
            translate([0, 0, z0 - 3])
            difference() {
                rrect(in_w - 2*fit, in_h - 2*fit, max(corner_r - wall - fit, 0.5), 3);
                translate([0, 0, -0.1]) rrect(in_w - 2*fit - 3.2, in_h - 2*fit - 3.2, 0.5, 3.2);
                for (p = boss_pos) translate([p[0], p[1], -0.1]) cylinder(d = boss_d + 1, h = 3.2);
            }
            // anello che trattiene il buzzer
            translate([buzz_x, buzz_y, z0 - buzz_ring_h])
            difference() {
                cylinder(d = buzz_d + 0.3 + 2*buzz_ring_w, h = buzz_ring_h);
                translate([0, 0, -0.1]) cylinder(d = buzz_d + 0.3, h = buzz_ring_h + 0.2);
            }
        }
        // viti del coperchio, svasate sul fronte
        for (p = boss_pos) translate([p[0], p[1], z0 - 0.1]) {
            cylinder(d = lid_screw_d, h = lid_t + 0.2);
            translate([0, 0, lid_t - lid_head_h + 0.1])
                cylinder(d1 = lid_screw_d, d2 = lid_head_d, h = lid_head_h);
        }
        // finestra luminosa + sede del diffusore (dal lato interno)
        translate([0, strip_y, z0 - 0.1])
            linear_extrude(lid_t + 0.2) offset(win_h/2 - 0.01) square([win_w - win_h, 0.02], center = true);
        translate([0, strip_y, z0 - 0.1])
            linear_extrude(diff_t + 0.1)
                offset(win_h/2 + diff_margin) square([win_w - win_h, 0.02], center = true);
        // forellini del buzzer
        for (p = concat([[0,0]], [for (a = [0:60:300]) [3.2*cos(a), 3.2*sin(a)]]))
            translate([buzz_x + p[0], buzz_y + p[1], z0 - 0.1])
                cylinder(d = sound_hole_d, h = lid_t + 0.2, $fn = 24);
    }
}

// coperchio ruotato per la stampa: faccia a vista sul piano
module lid_print() {
    rotate([180, 0, 0]) translate([0, 0, -(base_h + lid_t)]) lid_assembled();
}

// ---------------- DIFFUSORE ----------------
module diffuser() {
    linear_extrude(diff_t - 0.15)
        offset(win_h/2 + diff_margin - 0.25) square([win_w - win_h, 0.02], center = true);
}

// ------------------------------------------------------------
if (part == "base") base();
if (part == "coperchio") lid_print();
if (part == "diffusore") diffuser();
if (part == "coperchio230") psu_lid();
if (part == "tutto") {
    base();
    color("OrangeRed") translate([psu_x0 + fit/2, psu_y0, psu_ztop + 8]) psu_lid();
    color("SteelBlue", 0.6) translate([0, 0, 25]) lid_assembled();
    color("White") translate([0, strip_y, base_h + 25 - 0.05]) mirror([0,0,1]) diffuser();
}
