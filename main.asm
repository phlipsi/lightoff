INCLUDE "hardware.inc"

SECTION "LIGHTOFF", ROM0

start::
    call load_screen
    call init_sound
    call play_bounce
.loop:
    jr .loop

wait_vblank:
    ld a, [rLY]
    cp 144
    jr c, wait_vblank
    ret

clear_bg_map:
    ld hl, _SCRN1
    ld d, 0
    ld bc, $400
    jp fill_memory

load_screen:
    call wait_vblank
    ld hl, rLCDC
    ; LCD off
    res 7, [hl]

    ld hl, rBGP
    ld [hl], %11100100

    call load_tiles
    call load_intro_tilemap

    ld hl, rLCDC
    ld [hl], LCDCF_ON | LCDCF_WIN9800 | LCDCF_WINOFF | LCDCF_BG8000 | LCDCF_BG9800 | LCDCF_OBJ8 | LCDCF_OBJOFF | LCDCF_BGON

    ret
