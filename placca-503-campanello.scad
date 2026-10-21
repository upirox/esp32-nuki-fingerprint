// ============================================================
//  Placca su misura per scatola 503
//  Display OLED 0.96" SPI | Lettore R503 | PIR AM312 | Pulsante campanello | Buzzer
//  Contatto reed antimanomissione (magnete incollato dentro la scatola)
//  Guarnizione perimetrale in TPU (stampa multimateriale o separata)
//
//  STAMPA MULTIMATERIALE: esporta due STL, uno con part = "placca" e uno
//  con part = "guarnizione", importali insieme nello slicer come un unico
//  oggetto multiparte e assegna ASA/PETG alla placca e TPU alla guarnizione.
//
//  Si avvita direttamente alla scatola 503 (interasse viti 83,5 mm)
//  al posto di supporto + placca standard.
//  Tutte le misure sono in mm e si cambiano qui sotto.
//  Prima di stampare la versione finale: stampa una prova a
//  bassa densita' e verifica i fori con i componenti veri.
// ============================================================

/* [Placca] */
plate_w      = 120;   // larghezza
plate_h      = 80;    // altezza
plate_t      = 3;     // spessore (il dado dell'R503 serra fino a ~10 mm)
corner_r     = 5;     // raggio degli angoli
edge_chamfer = 0.8;   // smusso del bordo frontale

/* [Viti scatola 503] */
screw_pitch  = 83.5;  // interasse viti standard 503
screw_d      = 3.6;   // foro passante
screw_head_d = 7;     // testa svasata
screw_head_h = 2;

/* [Display OLED 0.96" (scheda 25,2 x 26)] */
oled_x       = -19;   // posizione centro scheda
oled_y       = 13;
oled_pcb_w   = 25.2;
oled_pcb_h   = 26;
oled_win_w   = 23;    // finestra visibile (area attiva ~21,7 x 10,9)
oled_win_h   = 12.5;
oled_win_dy  = 1.5;   // centro finestra rispetto al centro scheda (+ = verso i pin)
oled_glass_t = 1.7;   // spessore vetro sopra il PCB = altezza distanziali
oled_hole_dx = 20.8;  // interasse fori scheda, orizzontale
oled_hole_dy = 21.6;  //                       verticale
oled_pin_d   = 1.7;   // perni che entrano nei fori della scheda (da fermare a caldo o con colla)
oled_pin_h   = 3.5;
oled_post_d  = 4;

/* [Lettore R503 (filetto M25, flangia 28)] */
r503_x       = 12;
r503_y       = 0;
r503_hole_d  = 25.6;  // passaggio filetto M25

/* [PIR AM312 (lente ~10 mm, larghezza 12)] */
pir_x        = 36;
pir_y        = 14;
pir_hole_d   = 10.2;  // la lente passa, il bordo da 12 mm fa battuta
pir_boss_h   = 3;     // anello di centraggio dietro alla placca
pir_boss_w   = 1.6;

/* [Pulsante campanello antivandalo (testa 22, foro 19, filetto 14, profondita' 27)] */
btn_x        = -22;
btn_y        = -13.5;
btn_hole_d   = 19.3;  // foro di installazione 19 mm + gioco

/* [Buzzer (modulo 32,5 x 13, nascosto dietro la placca)] */
buzz_x        = -40;   // centro del cilindretto del buzzer
buzz_y        = 14;
buzz_d        = 12;    // diametro cilindro buzzer
buzz_h        = 9.5;   // altezza cilindro sopra il PCB
buzz_ring_h   = 6;     // altezza dell'anello che lo trattiene
buzz_ring_w   = 1.2;
buzz_pcb_dir  = 1;     // il modulo si sviluppa verso +x (1) o -x (-1)
buzz_hole_off = 9.5;   // distanza foro M3 del modulo dal centro del buzzer
buzz_use_post = false; // la colonnina cadrebbe sulla scheda OLED: il modulo
                       // si tiene con l'anello + una goccia di colla a caldo
buzz_post_d   = 6;     // colonnina per la vite del modulo
buzz_screw_d  = 2.5;   // foro per vite autofilettante M3 (o 2,9 mm)
sound_hole_d  = 1.4;   // forellini per il suono
sound_holes   = true;  // false = placca piena (suono molto piu' debole)

/* [Reed antimanomissione (corpo 14 x 3,2 mm, reofori 14 mm)] */
// Il reed sta in una culla sul retro, parallelo al bordo inferiore della
// scatola. Il magnete (6 x 2 mm) si incolla sulla parete interna della
// scatola, di fronte a UNA ESTREMITA' del corpo del reed (vedi istruzioni).
reed_x        = 29;    // centro del corpo del reed
reed_y        = -22;   // piu' vicino al bordo scatola = magnete piu' efficace
reed_len      = 14.4;  // corpo 14 mm + gioco
reed_w        = 3.5;   // corpo 3,2 mm + gioco
reed_wall     = 1.2;   // spessore pareti della culla
reed_wall_h   = 3.4;   // altezza pareti (il reed sta tutto dentro)

/* [Guarnizione TPU] */
part             = "tutto";  // "placca", "guarnizione" o "tutto" (anteprima)
gasket_inset     = 2.5;      // distanza dal bordo della placca
gasket_w         = 3;        // larghezza del cordone
gasket_h         = 1.6;      // altezza (si schiaccia a ~1 mm serrando le viti)
gasket_groove    = 0.6;      // profondita' della sede nella placca
gasket_drain     = 6;        // apertura in basso per far uscire la condensa (0 = chiusa)

$fn = 96;

// ------------------------------------------------------------

module rounded_rect(w, h, r, t) {
    linear_extrude(t)
        offset(r) square([w - 2*r, h - 2*r], center = true);
}

module plate_body() {
    // corpo con smusso sul bordo frontale (faccia frontale = z 0)
    hull() {
        translate([0, 0, edge_chamfer])
            rounded_rect(plate_w, plate_h, corner_r, plate_t - edge_chamfer);
        rounded_rect(plate_w - 2*edge_chamfer, plate_h - 2*edge_chamfer,
                     corner_r - edge_chamfer, plate_t);
    }
}

module screw_hole() {
    translate([0, 0, -0.01]) cylinder(d = screw_d, h = plate_t + 0.02);
    // svasatura sul fronte
    translate([0, 0, -0.01])
        cylinder(d1 = screw_head_d, d2 = screw_d, h = screw_head_h);
}

module oled_window() {
    translate([oled_x, oled_y + oled_win_dy, -0.01])
    hull() {
        // finestra con bordo svasato verso il fronte (si legge meglio di lato)
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
    // anello che trattiene il cilindro del buzzer, rivolto verso la placca
    translate([buzz_x, buzz_y, plate_t])
        difference() {
            cylinder(d = buzz_d + 0.3 + 2*buzz_ring_w, h = buzz_ring_h);
            translate([0, 0, -0.01]) cylinder(d = buzz_d + 0.3, h = buzz_ring_h + 0.02);
        }
    // colonnina per la vite: il PCB poggia sul buzzer e qui viene fissato
    if (buzz_use_post)
    translate([buzz_x + buzz_pcb_dir*buzz_hole_off, buzz_y, plate_t])
        difference() {
            cylinder(d = buzz_post_d, h = buzz_h);
            translate([0, 0, 2]) cylinder(d = buzz_screw_d, h = buzz_h);
        }
}

module sound_grille() {
    // 7 forellini a nido d'ape davanti al foro del buzzer
    if (sound_holes)
        for (p = concat([[0, 0]], [for (a = [0:60:300]) [3*cos(a), 3*sin(a)]]))
            translate([buzz_x + p[0], buzz_y + p[1], -0.01])
                cylinder(d = sound_hole_d, h = plate_t + 0.02, $fn = 24);
}

module reed_cradle() {
    // culla a U aperta alle estremita' per i reofori; si chiude con colla a caldo
    translate([reed_x, reed_y, plate_t])
        difference() {
            translate([-(reed_len)/2, -(reed_w/2 + reed_wall), 0])
                cube([reed_len, reed_w + 2*reed_wall, reed_wall_h]);
            translate([-(reed_len)/2 - 0.1, -reed_w/2, -0.01])
                cube([reed_len + 0.2, reed_w, reed_wall_h + 0.02]);
        }
}

// anello della guarnizione (in pianta), con apertura di drenaggio in basso
module gasket_ring_2d() {
    ow = plate_w - 2*gasket_inset;
    oh = plate_h - 2*gasket_inset;
    r  = max(corner_r - gasket_inset, 0.5);
    difference() {
        offset(r) square([ow - 2*r, oh - 2*r], center = true);
        offset(max(r - gasket_w, 0.1))
            square([ow - 2*gasket_w - 2*max(r - gasket_w, 0.1),
                    oh - 2*gasket_w - 2*max(r - gasket_w, 0.1)], center = true);
        if (gasket_drain > 0)
            translate([-gasket_drain/2, -plate_h/2 - 1]) square([gasket_drain, gasket_w + gasket_inset + 2]);
    }
}

// la guarnizione parte dal fondo della sede e sporge di gasket_h dal retro
module gasket() {
    translate([0, 0, plate_t - gasket_groove])
        linear_extrude(gasket_groove + gasket_h) gasket_ring_2d();
}

module plate() {
difference() {
    plate_body();

    // sede della guarnizione sul retro
    translate([0, 0, plate_t - gasket_groove])
        linear_extrude(gasket_groove + 0.01) gasket_ring_2d();

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

if (part == "placca" || part == "tutto") plate();
if (part == "guarnizione" || part == "tutto") color("DimGray") gasket();

// La faccia frontale e' quella appoggiata sul piano di stampa (z = 0):
// stampala cosi', senza supporti. Il retro guarda verso l'alto.
