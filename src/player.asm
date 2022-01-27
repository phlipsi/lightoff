include "hardware.inc"

section "PLAYER_PRIVATE", wram0

PLAYER_X: DS 2
PLAYER_Y: DS 2
PLAYER_VX: DS 1
PLAYER_VY: DS 1

section "PLAYER", rom0

; b - x coordinate
; c - y coordinate
init_player::
    ld a, 0
    ld [PLAYER_X], a
    ld [PLAYER_Y], a
    ld a, %10000
    ld [PLAYER_VX], a
    ld a, %100000
    ld [PLAYER_VY], a
    ld a, 8
    ld [PLAYER_X + 1], a
    ld a, 16
    ld [PLAYER_Y + 1], a
    ret

draw_player::
    ld hl, PLAYER_X + 1
    ld b, [hl]
    ld hl, PLAYER_Y + 1
    ld c, [hl]
    call relative_to_camera

    ld hl, _OAMRAM
    ld a, c
    ld [hli], a
    ld a, b
    ld [hli], a
    ld a, $e0
    ld [hli], a
    ld a, 0
    ld [hli], a

    ld a, c
    ld [hli], a
    ld a, b
    add a, 8
    ld [hli], a
    ld a, $e1
    ld [hli], a
    ld a, 0
    ld [hli], a

    ld a, c
    add a, 8
    ld [hli], a
    ld a, b
    ld [hli], a
    ld a, $f0
    ld [hli], a
    ld a, 0
    ld [hli], a

    ld a, c
    add a, 8
    ld [hli], a
    ld a, b
    add a, 8
    ld [hli], a
    ld a, $f1
    ld [hli], a
    ld a, 0
    ld [hli], a

    ret

move_player::
    ld a, [PLAYER_X + 1]
    ld h, a
    ld a, [PLAYER_X]
    ld l, a
    ld b, 0
    ld a, [PLAYER_VX]
    ld c, a
    add hl, bc
    ld a, h
    ld [PLAYER_X + 1], a
    ld a, l
    ld [PLAYER_X], a

    ld a, [PLAYER_Y + 1]
    ld h, a
    ld a, [PLAYER_Y]
    ld l, a
    ld b, 0
    ld a, [PLAYER_VY]
    ld c, a
    add hl, bc
    ld a, h
    ld [PLAYER_Y + 1], a
    ld a, l
    ld [PLAYER_Y], a

    ret
