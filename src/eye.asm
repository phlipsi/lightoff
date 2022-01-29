include "hardware.inc"

section "EYE_DATA", wram0

EYE_X:: DS 1
EYE_Y:: DS 1

section "EYE", rom0

; b - x
; c - y
init_eye::
    ld hl, EYE_X
    ld [hl], b
    ld hl, EYE_Y
    ld [hl], c
    ret

draw_eye::
    ld hl, EYE_X
    ld b, [hl]
    ld hl, EYE_Y
    ld c, [hl]
    call relative_to_camera
    ld hl, _OAMRAM + sizeof_OAM_ATTRS * 8

    ld a, c
    ld [hli], a
    ld a, b
    ld [hli], a
    ld a, $22
    ld [hli], a
    ld a, 0
    ld [hli], a

    ld a, c
    ld [hli], a
    ld a, b
    add a, $8
    ld [hli], a
    ld a, $23
    ld [hli], a
    ld a, 0
    ld [hli], a

    ld a, c
    add a, $8
    ld [hli], a
    ld a, b
    ld [hli], a
    ld a, $32
    ld [hli], a
    ld a, 0
    ld [hli], a

    ld a, c
    add a, $8
    ld [hli], a
    ld a, b
    add a, $8
    ld [hli], a
    ld a, $33
    ld [hli], a
    ld a, 0
    ld [hli], a

    ret
