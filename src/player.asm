include "hardware.inc"

section "PLAYER_PRIVATE", wram0

PLAYER_X: DS 1
PLAYER_Y: DS 1

section "PLAYER", rom0

; b - x coordinate
; c - y coordinate
init_player::
    ld a, 8
    ld [PLAYER_X], a
    ld a, 16
    ld [PLAYER_Y], a
    ret

draw_player::
    ld hl, _OAMRAM
    ld a, [PLAYER_Y]
    ld [hli], a
    ld a, [PLAYER_X]
    ld [hli], a
    ld a, $e0
    ld [hli], a
    ld a, 0
    ld [hli], a

    ld a, [PLAYER_Y]
    ld [hli], a
    ld a, [PLAYER_X]
    add a, 8
    ld [hli], a
    ld a, $e1
    ld [hli], a
    ld a, 0
    ld [hli], a

    ld a, [PLAYER_Y]
    add a, 8
    ld [hli], a
    ld a, [PLAYER_X]
    ld [hli], a
    ld a, $f0
    ld [hli], a
    ld a, 0
    ld [hli], a

    ld a, [PLAYER_Y]
    add a, 8
    ld [hli], a
    ld a, [PLAYER_X]
    add a, 8
    ld [hli], a
    ld a, $f1
    ld [hli], a
    ld a, 0
    ld [hli], a

    ret
