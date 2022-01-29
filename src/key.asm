include "hardware.inc"

section "KEY_DATA", wram0

KEY_X:: DS 1
KEY_Y:: DS 1

section "KEY", rom0

; b - x
; c - y
init_key::
    ld hl, KEY_X
    ld [hl], b
    ld hl, KEY_Y
    ld [hl], c
    ret

draw_key::
    ld hl, KEY_X
    ld b, [hl]
    ld hl, KEY_Y
    ld c, [hl]
    call relative_to_camera
    ld hl, _OAMRAM + sizeof_OAM_ATTRS * 8

    ld a, c
    ld [hli], a
    ld a, b
    ld [hli], a
    ld a, $24
    ld [hli], a
    ld a, 0
    ld [hli], a

    ld a, c
    ld [hli], a
    ld a, b
    add a, $8
    ld [hli], a
    ld a, $25
    ld [hli], a
    ld a, 0
    ld [hli], a

    ld a, c
    add a, $8
    ld [hli], a
    ld a, b
    ld [hli], a
    ld a, $34
    ld [hli], a
    ld a, 0
    ld [hli], a

    ld a, c
    add a, $8
    ld [hli], a
    ld a, b
    add a, $8
    ld [hli], a
    ld a, $35
    ld [hli], a
    ld a, 0
    ld [hli], a

    ret
