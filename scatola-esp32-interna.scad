// ============================================================
//  Scatola interna per ESP32 - ingresso terzo piano
//  Contiene: ESP32 38 pin su scheda di espansione a morsetti,
//            buzzer interno (campanello / sirene),
//            striscia WS2812 da 8 LED = luce di stato della porta,
//            alimentatore 230 V -> 5 V 2 A (Mean Well IRM-10-5) in un VANO
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
//  Viti: 4 x M3 x 8 nel coperchio e 2 x M3 x 6 nel coperchietto 230 V,
//        avvitate in 6 inserti filettati M3 in ottone annegati a caldo
//        (punta del saldatore a ~220-240 C per PETG, inserto dritto, senza forzare),
//        4 viti da 4 mm + tasselli per il muro.
//  Materiale: PETG o ASA (NON PLA: c'e' un alimentatore a 230 V).
//  Il cavo di rete arriva dallo stesso passaggio nel muro dei cavi di
//  segnale: il foro sul fondo e' diviso in due dalla parete del vano, cosi'
//  la 230 V entra direttamente nel vano e non passa mai tra i fili a 5 V.
//
//  DISPOSIZIONE (verticale, larghezza esterna < 15 cm):
//    in alto     striscia LED di stato (8 cm)
//    al centro   scheda ESP32 a sinistra, SOPRA il pacco batteria 3 x 18650
//                (distanziali alti) | PowerBoost 1000C e buzzer a destra
//    in basso    vano 230 V con l'alimentatore (il foro cavi e' a cavallo
//                della sua parete superiore)
//
//  PRIMA DI STAMPARE misura la tua scheda a morsetti e correggi
//  board_w / board_h e board_hole_dx / board_hole_dy: le schede
//  in commercio non sono tutte uguali.
// ============================================================

/* [Parte da esportare] */
part = "tutto";            // "base", "coperchio", "coperchio230", "diffusore", "tutto"

/* [Scatola] */
in_w     = 140;   // larghezza interna (esterno = +4,8 mm: max 150)
in_h     = 150;   // altezza interna
board_headroom = 20;  // spazio sopra la scheda a morsetti (ESP32 + morsetti + fili)
                      // profondita' interna calcolata: pacco + 4 + scheda + questo
wall     = 2.4;   // spessore pareti
floor_t  = 3;     // spessore fondo
lid_t    = 2.5;   // spessore coperchio
corner_r = 4;     // raggio esterno degli angoli
fit      = 0.3;   // gioco tra coperchio e pareti

/* [Viti del coperchio: inserti filettati M3 in ottone, annegati a caldo] */
use_inserts  = true;  // false = viti autofilettanti direttamente nella plastica
insert_d     = 4.0;   // foro per l'inserto (M3 corto tipo 5,7 mm: 4,0 | controlla
                      // la scheda del tuo inserto, di solito 4,0-4,2)
insert_l     = 6;     // profondita' del foro = lunghezza inserto + ~0,5
boss_d       = 9;     // colonna piu' grossa: almeno 2,5 mm di plastica attorno
boss_pilot_d = 2.6;   // foro per vite M3 autofilettante (se use_inserts = false)
psu_post_d   = 8;     // paletti del coperchietto 230 V (stessi inserti)
lid_screw_d  = 3.4;
lid_head_d   = 6.5;   // svasatura della testa
lid_head_h   = 1.8;

/* [Scheda ESP32 a morsetti (posizione = centro scheda)] */
board_x       = -27;
board_y       = 17;
board_w       = 80;   // ingombro scheda + morsetti
board_h       = 65;
board_hole_dx = 72;   // interasse fori di fissaggio (MISURALO)
board_hole_dy = 55;
standoff_d    = 8;
standoff_air  = 4;    // aria tra pacco batteria e scheda (sotto la scheda c'e' il pacco)
standoff_pilot= 2.5;  // vite M3 autofilettante o M2,5
board_guides  = true; // squadrette agli angoli che centrano la scheda

/* [Buzzer interno (modulo 32,5 x 13, fissato al coperchio)] */
buzz_x        = 40;
buzz_y        = 42;
buzz_d        = 12;
buzz_ring_h   = 6;
buzz_ring_w   = 1.2;
sound_hole_d  = 1.6;

/* [Striscia LED di stato (WS2812, 8 LED)] */
led_n      = 8;
led_pitch  = 10;     // striscia da 8 cm con 8 LED = 10 mm (lunghezza = led_n x led_pitch)
strip_w    = 10.5;   // larghezza striscia + gioco
strip_y    = 62;     // posizione della striscia (centro, in alto)
led_gap    = 6;      // distanza LED - coperchio: piu' alta = luce piu' uniforme
win_h      = 6;      // altezza della finestra luminosa
diff_t     = 1.0;    // spessore diffusore
diff_margin= 2;      // battuta del diffusore attorno alla finestra

/* [Foro cavi dal muro (sul fondo), DIVISO in due dalla parete del vano 230 V] */
// Il foro e' centrato sulla parete superiore del vano: la parete lo attraversa
// e lo divide in due meta'. Sotto entra il cavo 230 V (direttamente nel vano),
// sopra entrano i cavi di segnale della placca. Si sposta solo in orizzontale.
cable_x  = 40;
cable_d  = 32;

/* [Batteria di backup: pacco 3 x 18650 in parallelo (MISURALO)] */
pack_l     = 68;    // lato lungo del pacco (lunghezza delle celle + guaina), in verticale
pack_w     = 58;    // lato corto (3 celle affiancate), in orizzontale
pack_t     = 19.5;  // spessore: decide la profondita' della scatola
pack_x     = board_x;  // sotto la scheda
pack_y     = board_y;
pack_wall_h= 8;     // altezza della culla (il resto lo tiene una fascetta in velcro)
strap_w    = 16;    // asole per la fascetta che blocca il pacco

/* [PowerBoost 1000C (senza presa USB-A)] */
pb_l       = 36.2;
pb_w       = 22.9;
pb_x       = 44;
pb_y       = 22;

/* [Vano 230 V per l'alimentatore (in basso, tutta la larghezza tra le colonne)] */
psu_x0     = -60;   // parete sinistra del vano (le colonne d'angolo restano fuori)
psu_x1     = 60;    // parete destra
psu_y1     = -25;   // parete superiore (sotto c'e' la parete esterna della scatola)
psu_wall   = 2;
psu_top    = 5;     // il vano finisce 5 mm sotto il bordo della scatola
psu_lid_t  = 2;
mod_l      = 46;    // Mean Well IRM-10-5: 45,7 x 25,4 x 21,5 (altro modulo: misuralo)
mod_w      = 25.5;
mod_x      = -20;   // centro del modulo
mod_y      = -50;
use_gland  = false; // pressacavo sulla parete inferiore (non serve: la 230 V entra dal foro diviso)
gland_x    = 35;
gland_d    = 12.6;
out_hole_d = 6;     // passaggio fili 5 V verso la scheda (parete superiore del vano)
out_hole_x = -40;

/* [Antenna (parete superiore)] */
ant_x    = 55;
ant_d    = 6.6;    // connettore SMA / RP-SMA da pannello

/* [Fissaggio a muro (fori sul fondo)] */
// [-27,17] e' sotto il pacco batteria e la scheda:
// fissa la scatola al muro PRIMA di montarli
wall_holes   = [[-50,60],[55,52],[58,-8],[-27,17]];
wall_screw_d = 4.5;
wall_head_d  = 8.5;

/* [Aerazione] */
vents      = true;
vent_w     = 2;
vent_l     = 14;
vent_n     = 8;
vent_y0    = -12;   // prima feritoia (pareti sinistra e destra: batteria, scheda, PowerBoost)

$fn = 64;

// ------------------------------------------------------------
standoff_h = pack_t + standoff_air;
in_d  = standoff_h + 1.6 + board_headroom;   // profondita' interna
out_w = in_w + 2*wall;
out_h = in_h + 2*wall;
base_h = floor_t + in_d;
strip_len = led_n * led_pitch;
win_w = strip_len - 4;
// le colonne entrano di 0,5 mm nelle pareti: se fossero solo tangenti
// OpenSCAD segnalerebbe "not a valid 2-manifold"
boss_pos = [for (sx=[-1,1], sy=[-1,1]) [sx*(in_w/2 - boss_d/2 + 0.5), sy*(in_h/2 - boss_d/2 + 0.5)]];
psu_y0   = -in_h/2;
cable_y  = psu_y1 - psu_wall/2;          // foro centrato sulla parete del vano
psu_ztop = floor_t + in_d - psu_top;     // altezza pareti del vano
psu_posts = [[psu_x0 + psu_wall + psu_post_d/2 - 0.5, psu_y1 - psu_wall - psu_post_d/2 + 0.5],  // entrano 0,5 mm nelle pareti
             [psu_x1 - psu_wall - psu_post_d/2 + 0.5, psu_y0 + psu_wall + psu_post_d/2 - 0.5]];

// foro dall'alto in una colonna che finisce all'altezza "top":
// sede per inserto a caldo (con invito svasato) oppure foro pilota
module screw_hole_in(p, top) {
    translate([p[0], p[1], 0]) {
        if (use_inserts) {
            translate([0, 0, top - insert_l]) cylinder(d = insert_d, h = insert_l + 0.1);
            translate([0, 0, top - 0.6]) cylinder(d1 = insert_d, d2 = insert_d + 0.8, h = 0.61);
            // sotto l'inserto: spazio per la punta della vite e la plastica fusa
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
            pack_cradle();
            pb_cradle();
        }
        // fori viti coperchio (inserti a caldo o vite autofilettante)
        for (p = boss_pos) screw_hole_in(p, base_h);
        // fori distanziali
        for (sx = [-1,1], sy = [-1,1])
            translate([board_x + sx*board_hole_dx/2, board_y + sy*board_hole_dy/2, 1])
                cylinder(d = standoff_pilot, h = base_h);
        // foro cavi dal muro
        // (la parete del vano resta: divide il foro in due)
        difference() {
            translate([cable_x, cable_y, -0.1]) cylinder(d = cable_d, h = floor_t + 0.2);
            translate([cable_x - cable_d, psu_y1 - psu_wall - 0.1, -1]) cube([2*cable_d, psu_wall + 0.2, floor_t + 2]);
        }
        // asole per la fascetta del pacco batteria
        for (sx = [-1,1])
            translate([pack_x + sx*(pack_w/2 + 4.5), pack_y, -0.1])
                linear_extrude(floor_t + 0.2) offset(1) square([1.2, strap_w - 2], center = true);
        // fori per il muro (svasati dall'interno)
        for (p = wall_holes) translate([p[0], p[1], -0.1]) {
            cylinder(d = wall_screw_d, h = floor_t + 0.2);
            translate([0, 0, floor_t - 2.4 + 0.1])
                cylinder(d1 = wall_screw_d, d2 = wall_head_d, h = 2.4);
        }
        // pressacavo del cavo di rete (parete inferiore, dentro il vano)
        if (use_gland) translate([gland_x, -in_h/2 + psu_wall + 1, floor_t + 12])
            rotate([90, 0, 0]) cylinder(d = gland_d, h = wall + psu_wall + 3);
        // fori dei paletti del coperchietto 230 V
        for (p = psu_posts) screw_hole_in(p, psu_ztop);
        // passaggio dei fili 5 V dal vano verso la scheda (parete superiore del vano)
        translate([out_hole_x, psu_y1 + 1, floor_t + 6])
            rotate([90, 0, 0]) cylinder(d = out_hole_d, h = psu_wall + 2);
        // antenna (parete superiore)
        translate([ant_x, in_h/2 - 1, floor_t + in_d/2])
            rotate([-90, 0, 0]) cylinder(d = ant_d, h = wall + 2);
        // feritoie di aerazione (pareti sinistra e destra, all'altezza della scheda)
        if (vents) for (i = [0:vent_n-1], sx = [-1,1])
            translate([sx*(in_w/2 + wall/2), vent_y0 + i*(vent_w + 4), floor_t + in_d/2])
                cube([wall + 2, vent_w, vent_l], center = true);
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

// culla del pacco batteria (lato lungo in verticale), sotto la scheda.
// Apertura per i fili sul lato verso il PowerBoost, tacche per la fascetta.
module pack_cradle() {
    c = 0.6; t = 1.6;
    X = pack_w + 2*c; Y = pack_l + 2*c;     // interno culla
    translate([pack_x, pack_y, floor_t])
    difference() {
        translate([-X/2 - t, -Y/2 - t, 0]) cube([X + 2*t, Y + 2*t, pack_wall_h]);
        translate([-X/2, -Y/2, -0.1]) cube([X, Y, pack_wall_h + 0.2]);
        // passaggio fili / connettore verso il PowerBoost (lato destro)
        translate([X/2 - 0.1, Y/2 - 22, 2]) cube([t + 0.2, 18, pack_wall_h]);
        // tacche per la fascetta in velcro (lati sinistro e destro)
        for (sx = [-1,1]) translate([sx*(X/2 + t/2), 0, pack_wall_h/2 + 0.1])
            cube([t + 0.4, strap_w, pack_wall_h], center = true);
    }
}

// culla del PowerBoost su piccoli rialzi (sotto passa l'aria: in carica scalda)
module pb_cradle() {
    c = 0.4; t = 1.2; h = 5;
    translate([pb_x, pb_y, floor_t]) {
        difference() {
            translate([-(pb_l + 2*c)/2 - t, -(pb_w + 2*c)/2 - t, 0])
                cube([pb_l + 2*c + 2*t, pb_w + 2*c + 2*t, h]);
            translate([-(pb_l + 2*c)/2, -(pb_w + 2*c)/2, -0.1])
                cube([pb_l + 2*c, pb_w + 2*c, h + 0.2]);
            // lati corti aperti per fili, connettore JST e micro-USB
            for (sx = [-1,1]) translate([sx*((pb_l + 2*c)/2 + t/2), 0, h/2 + 1.5])
                cube([t + 0.4, pb_w - 6, h], center = true);
        }
        // appoggi: la scheda sta 2 mm sopra il fondo
        for (sx = [-1,1], sy = [-1,1])
            translate([sx*(pb_l/2 - 3), sy*(pb_w/2 - 2.5), 0]) cylinder(d = 4, h = 2);
    }
}

// vano separato per l'alimentatore 230 V: pareti, paletti, culla del modulo
module psu_bay() {
    // pareti sinistra, destra e superiore; in basso una battuta contro la
    // parete esterna su cui appoggia il coperchietto (entra 0,5 mm nella parete)
    translate([psu_x0, psu_y0 - 0.5, 0]) cube([psu_wall, psu_y1 - psu_y0 + 0.5, psu_ztop]);
    translate([psu_x1 - psu_wall, psu_y0 - 0.5, 0]) cube([psu_wall, psu_y1 - psu_y0 + 0.5, psu_ztop]);
    translate([psu_x0, psu_y1 - psu_wall, 0]) cube([psu_x1 - psu_x0, psu_wall, psu_ztop]);
    translate([psu_x0, psu_y0 - 0.5, 0]) cube([psu_x1 - psu_x0, psu_wall + 0.5, psu_ztop]);
    // paletti per le viti del coperchietto
    for (p = psu_posts) translate([p[0], p[1], 0]) cylinder(d = psu_post_d, h = psu_ztop);
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
    w = psu_x1 - psu_x0;
    h = psu_y1 - psu_y0 - fit;     // in basso tocca la parete esterna: lascia il gioco
    difference() {
        cube([w, h, psu_lid_t]);
        for (p = psu_posts) translate([p[0] - psu_x0, p[1] - psu_y0 - fit, -0.1]) {
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
    color("OrangeRed") translate([psu_x0, psu_y0 + fit, psu_ztop + 8]) psu_lid();
    color("SteelBlue", 0.6) translate([0, 0, 25]) lid_assembled();
    color("White") translate([0, strip_y, base_h + 25 - 0.05]) mirror([0,0,1]) diffuser();
}
