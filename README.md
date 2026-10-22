# ESP32 Nuki fingerprint entrance

ESPHome firmware and 3D-printable enclosures for an ESP32 that drives a **Nuki Smart Lock locally over Bluetooth**, with a **fingerprint reader**, OLED display, doorbell and tamper detection at the front door. Unlocking happens on the ESP32 itself, so it keeps working when Home Assistant or the Wi-Fi are down.

Tested with **ESPHome 2026.9.1**, an ESP32-WROOM-32U DevKit (38 pin) and a **Nuki Smart Lock 3.0**.

> **ESPHome 2026.10.x does not build yet**: ESPHome's new `esphome/libsodium` (used by API encryption) clashes with the `espressif/libsodium` pulled in by the [`nuki_lock`](https://github.com/uriyacovy/ESPHome_nuki_lock) component (`esphome__libsodium and espressif__libsodium are both added as project_managed_components`). Stay on 2026.9.x until the component is updated.

## Features

- **Full Nuki control from Home Assistant**: the ESP32 replaces the Nuki Bridge, so the lock is still a regular `lock` entity you can lock, unlock and open from the HA app, dashboards and automations, together with battery level, door sensor and Bluetooth signal. Changes made from the Nuki app or by hand show up immediately.
- **Fingerprint unlock** (R503 reader) with a configurable confidence threshold and sensor password protection against swapping the sensor.
- **Alarm after 3 wrong fingerprints**: reader locked for 15 minutes, siren, Home Assistant entities for notifications. The lockout survives reboots and power cuts.
- **Tamper detection** (reed switch behind the outdoor plate): reader disabled until reset from Home Assistant.
- **OLED display** woken by a PIR sensor, with messages that follow the lock state.
- **LED status strip** indoors: green = locked, red = unlocked, yellow = moving, purple = jammed, blue = Nuki unreachable.
- **Doorbell** push button with LED ring; double ding-dong on an indoor buzzer, plus a Home Assistant `event` entity.
- **Backup battery** (PowerBoost 1000C + Li-ion): mains/battery sensors, battery percentage and an automatic power saving mode during blackouts.
- Home Assistant **actions** to enroll/delete fingerprints, cancel the alarm and play tunes on the indoor buzzer.

## Files

| File | What it is |
|---|---|
| `nuki_fingerprint.yaml` | ESPHome configuration. Wiring is documented in the header. |
| `common/base_config.yaml` | Shared ESPHome package: Wi-Fi, encrypted OTA/API, SNTP, diagnostics (its diagnostic entity names are still in Italian, since other devices share it). |
| `common/secrets.example.yaml` | Secrets you need to provide (copy to `secrets.yaml`). |
| `placca-503-campanello.scad` | OpenSCAD outdoor plate for an Italian 503 flush box (OLED, R503, PIR, push button, buzzer, reed, rubber cord seal). |
| `scatola-esp32-interna.scad` | OpenSCAD indoor enclosure: ESP32 terminal board over the battery pack, PowerBoost, LED strip window, indoor buzzer, separate 230 V bay. |
| `scatola-esp32-anteprima.png` | Layout preview of the indoor enclosure. |
| `esp32-nuki-fingerprint.code-workspace` | VS Code / Studio Code Server workspace: opens the YAML files as plain YAML and declares the ESPHome tags (`!lambda`, `!secret`...), so the editor shows no false "Unresolved tag" errors. |
| `power schema.pdf` | Backup power wiring: power supply, PowerBoost 1000C, battery and the two voltage dividers. |

## Hardware

- ESP32-WROOM-32U DevKit (38 pin) on a screw terminal expansion board, external antenna
- Grow R503 fingerprint sensor
- SSD1306 0.96" OLED, 7-pin SPI version (**CS must be wired to a GPIO**, not tied to GND)
- AM312 PIR (HW-740) with a **100 kΩ** pull-down (10 kΩ is too strong for its output)
- 2 × passive buzzer modules ("low level trigger"), outdoor and indoor
- WS2812 strip, 8 LEDs (330 Ω in series with DIN)
- 19 mm vandal-proof push button with 3–6 V LED ring
- Reed switch + 6 × 2 mm magnet
- Mean Well IRM-10-5 (5 V 2 A) with fuse, varistor and output capacitors
- Adafruit PowerBoost 1000C + single-cell Li-ion pack (3.7 V)

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

The indoor enclosure contains a mains power supply. Mains wiring must be done with the power off, through a breaker and RCD, by someone qualified to do it. Keep the 230 V cable sheathed all the way into the 230 V bay, and print the enclosures in PETG or ASA, not PLA.

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
