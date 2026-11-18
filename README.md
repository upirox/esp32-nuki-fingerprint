# ESP32 Nuki fingerprint entrance

ESPHome firmware and 3D-printable enclosures for an ESP32 that drives a **Nuki Smart Lock locally over Bluetooth**, with a **fingerprint reader**, OLED display, doorbell and tamper detection at the front door. Unlocking happens on the ESP32 itself, so it keeps working when Home Assistant or the Wi-Fi are down.

Tested with **ESPHome 2026.10.1**, an ESP32-WROOM-32U DevKit (38 pin) and a **Nuki Smart Lock 3.0**.

> **ESPHome version**: the current [`nuki_lock`](https://github.com/uriyacovy/ESPHome_nuki_lock) component uses ESPHome's own BLE stack and needs **ESPHome 2026.10 or later** (older component releases failed to build on 2026.10 because of a libsodium conflict). Upgrading from an older component release keeps the pairing: it is migrated automatically on the first boot.

## Features

- **Full Nuki control from Home Assistant**: the ESP32 replaces the Nuki Bridge, so the lock is still a regular `lock` entity you can lock, unlock and open from the HA app, dashboards and automations, together with battery level, door sensor and Bluetooth signal. Changes made from the Nuki app or by hand show up immediately.
- **Fingerprint unlock** (R503 reader) with a configurable confidence threshold and sensor password protection against swapping the sensor.
- **Alarm after 3 wrong fingerprints**: reader locked for 15 minutes, siren, Home Assistant entities for notifications. The lockout survives reboots and power cuts.
- **Tamper detection**: a lever microswitch and a reed switch **in series** behind the outdoor plate. Removing the plate (or cutting the cable) opens the circuit, disables the reader until it is reset from Home Assistant and sounds the siren. The microswitch is pressed mechanically by the wall box, so it cannot be fooled with a magnet held outside the plate, which would keep a reed alone closed; the reed stays as a second, independent sensor.
- **OLED display** woken by a PIR sensor. It never shows whether the door is locked (it faces the street): the fingerprint sensor ring tells it instead, blue = locked, green = already unlocked (colours set in `substitutions`).
- **LED status strip** indoors: green = locked, red = unlocked, yellow = moving, red slow blink = alarm (reader locked out or tamper), purple = jammed, blue = Nuki unreachable.
- **Doorbell** push button with LED ring; double ding-dong on an indoor buzzer, plus a Home Assistant `event` entity.
- **Backup battery** (PowerBoost 1000C + Li-ion): mains/battery sensors, battery percentage, a UPS-style **Power Status** (Online / Online - Charging / On Battery / On Battery - Low) and an automatic power saving mode during blackouts.
- Home Assistant **actions** to enroll/delete fingerprints, cancel the alarm and play tunes on the indoor buzzer.

## Files

| File | What it is |
|---|---|
| `nuki_fingerprint.yaml` | ESPHome configuration. Wiring is documented in the header. |
| `common/base_config.yaml` | Shared ESPHome package: Wi-Fi, encrypted OTA/API, SNTP, diagnostics (its diagnostic entity names are still in Italian, since other devices share it). |
| `common/secrets.example.yaml` | Secrets you need to provide (copy to `secrets.yaml`). |
| `placca-503-campanello.scad` | OpenSCAD outdoor plate for an Italian 503 flush box (OLED, R503, PIR, push button, buzzer, reed, rubber cord seal). The two 503 screws are hidden under flush printed caps held by small magnets (`part = "screw_cap"`); OXID icon engraved bottom-right. A fin on the back holds the tamper lever microswitch (pressed by the inner wall of the box), and two cable-tie bridges hold the JST pigtail bundle (the old RJ45 tray is still available with `use_rj45`). |
| `scatola-esp32-interna.scad` | OpenSCAD indoor enclosure (144.8 × 257.2 × 36.6 mm): ESP32 terminal board, PowerBoost, LED strip with light box and diffuser, indoor buzzer, optional holder for three Wago 221-412 (`use_wago`), cable-tie bridges along the wire runs, separate 230 V bay and, at the bottom, a battery bay for the 3 × 18650 pack with its own screwed door (part `door`), split from the rest by a full-height wall. Lid and door are held by hidden 8 × 2 mm magnets: no screws on the front (`lid_fix`). Mounted next to an indoor wall socket: all cables come in through one opening in the right wall, split by a rib into a signal part and a 230 V part that leads into the bay through a closed channel with a cable tie (no mains in the outdoor box). |
| `copricavo-503.scad` | OpenSCAD cable cover from the indoor 503 (BTicino Livinglight, 3 modules) to the ESP32 box: it sits on a pre-drilled blank in the leftmost module, climbs over the curved plate border and ends at the side opening of the box, with a divider between the 230 V cable and the ethernet cables. Box 20 mm to the left of the plate, its top edge 124.4 mm above the plate centre. Fixed with removable tape (it must come off before the plate). |
| `copricavo-anteprima.png` | Front view and section of the cable cover. |
| `placca-anteprima.png` | Layout of the outdoor plate, front and back. |
| `scatola-esp32-anteprima.png` | Layout preview of the indoor enclosure. |
| `internal-wiring.png` | Internal wiring of the indoor enclosure: route and length of every wire (power supply PCB, PowerBoost, battery, divider, LED strip, buzzer, JST SM connectors of the plate cables). |
| `coperchio-logo-anteprima.png` | Lid with the OXID wordmark as a two-colour inlay (`logo_mode`: "inlay" with the `logo_dark` / `logo_accent` parts for a multi-material printer, or "engrave" and paint). On a black lid print `logo_dark` in white; the light box walls are a separate `lightbox` part to print in white. |
| `oxid_logo.scad` | OXID logo in OpenSCAD (wordmark and icon, 2D), used by the lid and the plate. |
| `esp32-nuki-fingerprint.code-workspace` | VS Code / Studio Code Server workspace: opens the YAML files as plain YAML and declares the ESPHome tags (`!lambda`, `!secret`...), so the editor shows no false "Unresolved tag" errors. |
| `plate-power-strip.png` | 3V3 / GND distribution strip behind the outdoor plate. |
| `power schema.pdf` | Backup power wiring (in Italian): power supply PCB (IRM-10-5, fuse, varistor, mains-sense divider, J1/J2 terminals), PowerBoost 1000C, battery and the battery voltage divider. |

## Hardware

- ESP32-WROOM-32U DevKit (38 pin) on a screw terminal expansion board, external antenna
- Grow R503 fingerprint sensor
- SSD1306 0.96" OLED, 7-pin SPI version (**CS must be wired to a GPIO**, not tied to GND)
- AM312 PIR (HW-740) with a **100 kΩ** pull-down (10 kΩ is too strong for its output)
- 2 × passive buzzer modules ("low level trigger"), outdoor and indoor
- WS2812B strip, 144 LEDs/m, 12 mm wide PCB (e.g. BTF-LIGHTING ECO), cut to 12 LEDs (330 Ω in series with DIN). The enclosure lid has a light box and a diffuser: by default a white PETG plug printed separately that fills the window flush with the lid face (or a 2 mm opal acrylic bar behind the window, or a flat printed one), so the LEDs show as one even bar instead of separate dots. For a 60 LEDs/m strip or an 8-LED stick change `led_n`/`led_pitch` in the enclosure and `num_leds` in the firmware.
- 19 mm vandal-proof push button with 3–6 V LED ring
- Subminiature lever microswitch (20 × 10.8 × 6.5 mm, steel lever, C/NO/NC contacts; use C + NO)
- Reed switch + 6 × 2 mm magnet, wired in series with the microswitch
- Mean Well IRM-10-5 (5 V 2 A) with fuse, varistor and output capacitors, on an 80 × 40 mm perfboard (2 mm mounting holes at 76 × 36, M2 self-tapping screws) with screw terminals; keep at least 6 mm between the 230 V and the 5 V copper
- Adafruit PowerBoost 1000C + single-cell Li-ion pack (3.7 V)

### Tamper switch wiring

```
GPIO19 ──── microswitch C ──── microswitch NO ──── reed ──── GND
```

Both contacts are closed while the plate is screwed on, so GPIO19 reads LOW. If either opens (plate removed, cable cut, microswitch released even with a magnet holding the reed) the input goes HIGH through the internal pull-up and the tamper alarm fires. The firmware sees a single contact, so no configuration change is needed when adding the microswitch.

### Plate connections (JST pigtails)

Two slim patch cables (28 AWG, stranded) run from the indoor enclosure to the plate, labelled **A** and **B**, colours in **T568B** order.

- **At the plate:** the cable wires are soldered (with heat-shrink) to 6-pin JST pigtails **J1–J4**; the mating pigtails go to the parts. Two cable-tie bridges on the back of the plate hold the bundle, so a pull never reaches the solder joints.
- **In the enclosure:** each cable ends in JST SM wire-to-wire connectors (A: 6 poles, B: 6 + 2 poles) right inside the side slot; the other halves go to the ESP32 terminals. The cables are laid in the slot from the front, already fitted, and a tongue under the lid holds them.

| Pair | T568B colour | Cable A | Cable B |
|---|---|---|---|
| 1 | white-orange | GND | GND |
| 2 | orange | OLED D0 / SCK → GPIO18 | R503 TX (yellow) → GPIO16 |
| 3 | white-green | 3V3 | R503 RX (purple) → GPIO17 |
| 4 | blue | OLED CS → GPIO5 | doorbell button → GPIO33 |
| 5 | white-blue | OLED DC → GPIO27 | button LED ring + → GPIO32 |
| 6 | green | OLED D1 / MOSI → GPIO23 | R503 WAKEUP (blue) → GPIO4 |
| 7 | white-brown | *(unused)* | PIR OUT → GPIO34 |
| 8 | brown | *(unused)* | tamper loop → GPIO19 |

**OLED RES (GPIO26)** and the **outdoor buzzer (GPIO25)** run on the two wires of the old doorbell, which already connected the two boxes (A7 and A8 broke inside their JST and are not used).

JST pigtails at the plate (black is always GND, red always 3V3):

| JST | black | red | yellow | white | orange | green |
|---|---|---|---|---|---|---|
| J1 | GND (A1) | 3V3 (A3) | SCK (A2) | MOSI (A6) | CS (A4) | DC (A5) |
| J2 | GND (B1) | spare | RES* | buzzer* | PIR (B7) | tamper (B8) |
| J3 | spare | spare | R503 TX (B2) | R503 RX (B3) | WAKEUP (B6) | spare |
| J4 | spare | spare | button (B4) | ring LED + (B5) | spare | spare |

\* now on the old doorbell wires.

On the plate, 3V3 and GND go to a small distribution strip (see `plate-power-strip.png`): 3V3 feeds the R503 (VCC and 3.3VT), OLED, PIR and outdoor buzzer; GND goes to all of them plus the push button, the LED ring cathode and the end of the tamper loop. The PIR's 100 kΩ pull-down is soldered at the PIR, between OUT and GND. The routing inside the enclosure is in `internal-wiring.png`.

## Getting started

1. Copy `nuki_fingerprint.yaml` and the `common/` folder into your ESPHome config folder.
2. Create `common/secrets.yaml` from the example (secrets for an included package are looked up next to the package file).
3. Pair the Nuki: turn on the "Nuki Pairing Mode" switch, then hold the button on the lock until the ring lights up.
4. Enroll fingerprints with the `enroll` action (`finger_id`, `num_scans`).

### Home Assistant actions

| Action | Data |
|---|---|
| `esphome.nuki_fingerprint_enroll` | `finger_id`, `num_scans` |
| `esphome.nuki_fingerprint_cancel_enroll` | |
| `esphome.nuki_fingerprint_delete` | `finger_id` |
| `esphome.nuki_fingerprint_delete_all` | |
| `esphome.nuki_fingerprint_reset_alarm` | |
| `esphome.nuki_fingerprint_play_indoor` | `tune` (RTTTL string) |
| `esphome.nuki_fingerprint_stop_indoor` | |

The doorbell is an `event` entity ("Doorbell") with event type `pressed`.

Home Assistant entities and texts are in English; the messages on the OLED display are in Italian and can be changed in the display lambda and the `show_msg` calls. Renaming an entity changes its `entity_id` in Home Assistant.

## Safety

The indoor enclosure contains a mains power supply. Mains wiring must be done with the power off, through a breaker and RCD, by someone qualified to do it. Keep the 230 V cable sheathed all the way into the 230 V bay (at least 1.5 mm² if it is wired to a socket's terminals), never bring mains into the outdoor box, and print the enclosures in PETG or ASA, not PLA.

## Disclaimer

This is a personal hobby project, shared **as is** in the hope that it is useful. It is **not** a certified security or electrical product, and it comes with **no warranty of any kind**.

By using any part of this repository (firmware, enclosures, wiring diagrams, documentation) you accept that:

- **You use it entirely at your own risk.** You are responsible for checking that it is suitable and safe for your installation, and for building, wiring and testing it correctly.
- **Door access is security-critical.** Bugs, hardware faults, power or radio failures, firmware or library updates may leave a door locked, unlocked or unreachable. Always keep an independent way to open the door (a mechanical key) and never rely on this project as your only means of access or protection.
- **Mains voltage (230 V) can kill and can start fires.** Any work on mains wiring must be carried out with the power off, in compliance with the electrical regulations of your country, and by a qualified person where required.
- **Lithium batteries can overheat, swell or catch fire** if damaged, short-circuited or charged incorrectly.
- 3D-printed parts, third-party components and libraries (such as ESPHome and the `nuki_lock` component) are outside the author's control.

To the maximum extent permitted by applicable law, the author and contributors **accept no liability** for any damage, injury, loss, theft, property damage or other consequence arising from the use, misuse or inability to use this project. Nothing here is professional advice.

This project is not affiliated with or endorsed by Nuki Home Solutions, Espressif, Adafruit, Mean Well or any other manufacturer mentioned. All trademarks belong to their respective owners.

## License

Released under the [MIT License](LICENSE).
