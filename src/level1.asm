include "hardware.inc"

section "LEVEL1", rom0

level1_on:
incbin "level1-on.tilemap", 0, 32 * 18
level1_on_end:

level1_off:
    incbin "level1-off.tilemap", 0, $1c0
level1_off_end:
    
load_level1_on_tilemap:
    ld de, level1_on
    ld hl, _SCRN0
    ld bc, level1_on_end - level1_on
    jp copy_memory

load_level1_off_tilemap:
    ld de, level1_off
    ld hl, _SCRN0
    ld bc, level1_off_end - level1_off
    jp copy_memory

level1::
    ld de, level1_on
    ld bc, level1_on_end - level1_on
    call load_to_screen

    call load_tileset_on
    call display_screen

    ld bc, $0810
    call init_player
    ld bc, $0000
    call init_camera
    call update_camera
    call draw_player

    call fade_in

.loop:
    call wait_next_frame
    call move_player
    call wait_vblank
    ld hl, CAMERA_X
    inc [hl]
    call update_camera
    call draw_player
    jr .loop
