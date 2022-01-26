include "hardware.inc"

section "Intro", rom0

intro:
incbin "intro.tilemap", 0, 20 * 18
intro_end:

load_intro_tilemap::
    ld de, intro
    ld hl, _SCRN0
    ld b, 20
    ld c, 18
.loop:
    ld a, [de]
    ld [hli], a
    inc de
    dec b
    jr nz, .loop
    ld b, 20
    ld a, l
    add a, 32 - 20
    ld l, a
    ld a, h
    adc a, 0
    ld h, a
    dec c
    jr nz, .loop
    ret
