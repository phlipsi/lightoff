include "hardware.inc"

section "SCREEN_DATA", wram0[$C000]

SCREEN:: DS 32 * 32
CAMERA_X:: DS 1
CAMERA_Y:: DS 1
MAX_CAMERA_X:: DS 1
MAX_CAMERA_Y:: DS 1

section "SCREEN", rom0

; b - x
; c - y
init_camera::
    ld hl, CAMERA_X
    ld [hl], b
    ld hl, CAMERA_Y
    ld [hl], c
    ret

update_camera::
    ld hl, rSCX
    ld a, [CAMERA_X]
    ld [hl], a

    ld hl, rSCY
    ld a, [CAMERA_Y]
    ld [hl], a
    ret

; b - x
; c - y
relative_to_camera::
    ld a, b
    ld hl, CAMERA_X
    sub [hl]
    ld b, a

    ld a, c
    ld hl, CAMERA_Y
    sub [hl]
    ld c, a
    ret

; b - x
; c - y
relative_to_level::
    ld a, b
    ld hl, CAMERA_X
    add [hl]
    ld b, a

    ld a, c
    ld hl, CAMERA_Y
    add [hl]
    ld c, a
    ret

; b - x
; c - y
; hl - offset
get_block_offset_at_position::
    ; y: (de / 8) * 32 = (de >> 3) << 5 = (de & 0b1111'1111'1111'1000) << 2
    ld a, c
    and %11111000
    ld c, a ; output block y
    ld h, 0
    ld l, a
    sla l
    rl h
    sla l
    rl h

    ld d, 0
    ld e, b
    ; x: (e / 8) = e >> 3
    srl e
    srl e
    srl e

    ld a, b
    and %11111000
    ld b, a ; output block x

    add hl, de
    ret

; b - x
; c - y
move_camera_to::
    ld a, b
    sub a, SCRN_X / 2
    jr nc, .no_x_underflow
    ld a, 0
    jr .got_x
.no_x_underflow:
    ld hl, MAX_CAMERA_X
    cp [hl]
    jr c, .got_x
    ld a, [hl]
.got_x:
    ld [CAMERA_X], a

    ld a, c
    sub a, SCRN_Y / 2
    jr nc, .no_y_underflow
    ld a, 0
    jr .got_y
.no_y_underflow:
    ld hl, MAX_CAMERA_Y
    cp [hl]
    jr c, .got_y
    ld a, [hl]
.got_y:
    ld [CAMERA_Y], a

    ret

; de - source
; bc - size
load_to_screen::
    ld hl, SCREEN
    jp copy_memory

display_screen::
    ld hl, _SCRN0
    ld de, SCREEN
    ld bc, 32 * 32
    jp copy_memory
