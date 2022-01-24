INCLUDE "hardware.inc"

; 4kHz = 4000Hz
; 240bpm = 4Hz
; 4000Hz / 4Hz = 1000 = 2 * 2 * 2 * 5 * 5 * 5 = 40 * 25
;              = (256 - 216) * 25 = (256 - $d8) * $19
DEF TIMER_MOD EQU $d8
DEF TICK_MOD EQU $19

SECTION "STATE", WRAM0[$C000]

tick: DS 1

SECTION "LIGHTOFF", ROM0

start::
    call init_timer
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

init_timer:
    ld hl, tick
    ld [hl], TICK_MOD

    ld hl, rIE
    ld [hl], IEF_TIMER

    ld hl, rTAC
    ld [hl], TACF_START | TACF_4KHZ

    ld hl, rTMA
    ld [hl], TIMER_MOD

    ei

    ret

tick_timer::
    push af
    push hl
    ld hl, tick
    dec [hl]
    jr nz, .exit
    ld [hl], TICK_MOD
    call play_next_eighth
.exit:
    pop hl
    pop af
    reti
