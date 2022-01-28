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
    ld hl, MAX_CAMERA_X
    ld [hl], SCRN_VX - SCRN_X
    ld hl, MAX_CAMERA_Y
    ld [hl], 0

    call load_tileset_on
    call display_screen

    ld bc, $0810
    call init_player
    call move_camera_to_player
    call update_camera
    call draw_player

    call fade_in

.loop:
    call wait_next_frame
    call read_keys
    ld a, [JOYPAD_LEFT]
    cp $0f
    jr c, .check_right
    ld a, low(-32)
    ld [PLAYER_VX], a
    ld a, high(-32)
    ld [PLAYER_VX + 1], a
    jr .move_player
.check_right:
    ld a, [JOYPAD_RIGHT]
    cp $0f
    jr c, .move_player
    ld a, low(32)
    ld [PLAYER_VX], a
    ld a, high(32)
    ld [PLAYER_VX + 1], a

.move_player:
    call move_player
    call move_camera_to_player
    call wait_vblank
    call update_camera
    call draw_player
    jr .loop
