INCLUDE "hardware.inc"

DEF TIMER_MOD EQU $e7
DEF TICK_MOD EQU $18

SECTION "LIGHTOFF", ROM0

start::
    call init_timer
    call init_sound
    call init_keys
    call init_lcd
    call load_sprites
    call intro
    call level1
    call level2
    call outro
    jr start

wait_vblank::
    ld a, [rLY]
    cp 144
    jr c, wait_vblank
    ret

init_lcd:
    call wait_vblank
    ; Initialize LCD control
    ld hl, rLCDC
    ld [hl], LCDCF_OFF | LCDCF_WIN9800 | LCDCF_WINOFF | LCDCF_BG8800 | LCDCF_BG9800 | LCDCF_OBJ8 | LCDCF_OBJON | LCDCF_BGON
    ; Initialize background palette
    ld hl, rBGP
    ld [hl], %11100100
    ; Initialize object palette
    ld hl, rOBP0
    ld [hl], %11100100
    ; clear background
    ld hl, _SCRN0
    ld d, 0
    ld bc, $400
    call fill_memory
    ; clear oam
    ld hl, _OAMRAM
    ld d, 0
    ld bc, $a0
    jp fill_memory

intro:
    call load_tileset_off
    call load_intro_tilemap
    call load_song3
    call fade_in
    call wait_until_keypress
    call fade_out
    ret

outro:
    ld bc, 0
    call move_camera_to
    call update_camera
    call load_tileset_on
    call load_outro_tilemap
    call load_song3
    call fade_in
    call wait_until_keypress

    ret

lcd_off:
    call wait_vblank
    ld hl, rLCDC
    res 7, [hl]
    ret

lcd_on:
    ld hl, rLCDC
    set 7, [hl]
    ret

fade_out::
    ld b, 60
    call wait_b_frames
    call wait_vblank
    ld a, %10010000
    ld [rBGP], a

    ld b, 60
    call wait_b_frames
    call wait_vblank
    ld a, %01000000
    ld [rBGP], a

    ld b, 60
    call wait_b_frames
    call wait_vblank
    ld a, %00000000
    ld [rBGP], a
    jp lcd_off

fade_in::
    call lcd_on

    ld b, 60
    call wait_b_frames
    call wait_vblank
    ld a, %01000000
    ld [rBGP], a

    ld b, 60
    call wait_b_frames
    call wait_vblank
    ld a, %10010000
    ld [rBGP], a

    ld b, 60
    call wait_b_frames
    call wait_vblank
    ld a, %11100100
    ld [rBGP], a
    ret

wait_b_frames:
    dec b
    ret z
    call wait_next_frame
    jr wait_b_frames

wait_next_frame::
    ld a, [rLY]
    or a
    jr nz, wait_next_frame
    ret

init_timer:
    ;ld hl, tick
    ;ld [hl], TICK_MOD

    ld hl, rIE
    ld [hl], IEF_TIMER

    ;ld hl, rTAC
    ;ld [hl], TACF_START | TACF_4KHZ

    ;ld hl, rTMA
    ;ld [hl], TIMER_MOD

    ei

    ret

; tick_timer::
;     push af
;     push hl
;     ld hl, tick
;     dec [hl]
;     jr nz, .exit
;     ld [hl], TICK_MOD
;     call play_next_eighth
; .exit:
;     pop hl
;     pop af
;     reti
