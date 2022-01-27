include "hardware.inc"

section "SCREEN_DATA", wram0

CAMERA_X:: DS 1
CAMERA_Y:: DS 1
SCREEN: DS 32 * 32

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
