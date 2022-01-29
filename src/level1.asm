include "hardware.inc"

section "LEVEL1_DATA", wram0

LIGHT: DS 1

def LIGHT_ON  equ 1
def LIGHT_OFF equ 0

section "LEVEL1", rom0

level1_on:
incbin "level1-on.tilemap", 0, 32 * 32
level1_on_end:

level1_off:
    incbin "level1-off.tilemap", 0, 32 * 32
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
    ld hl, MAX_CAMERA_X
    ld [hl], SCRN_VX - SCRN_X
    ld hl, MAX_CAMERA_Y
    ld [hl], SCRN_VY - SCRN_Y

    ld a, LIGHT_ON
    ld [LIGHT], a

    ld bc, $0810
    call init_player
    call move_camera_to_player
    ld bc, $b840
    call init_key
    ld bc, $20a0
    call init_door
    ld bc, $7848
    call init_eye

.outer:
    ld a, [LIGHT]
    cp LIGHT_OFF
    jr z, .load_light_off

    ld de, level1_on
    ld bc, level1_on_end - level1_on
    call load_to_screen

    call load_tileset_on
    call display_screen
    jr .start

.load_light_off:
    ld de, level1_off
    ld bc, level1_off_end - level1_off
    call load_to_screen

    call load_tileset_off
    call display_screen

.start
    call update_camera
    call draw_player
    call draw_key
    call draw_eye

    call fade_in

.loop:
    call wait_next_frame
    call read_keys
    ld a, [JOYPAD_LEFT]
    bit 7, a
    jr z, .check_right
    ;cp $0f
    ;jr c, .check_right
    ld bc, -$150
    call player_walk
    jr .check_jump

.check_right:
    ld a, [JOYPAD_RIGHT]
    bit 7, a
    jr z, .check_jump
    ;cp $0f
    ;jr c, .check_jump
    ld bc, $150
    call player_walk

.check_jump:
    ld a, [JOYPAD_A]
    bit 7, a
    jr z, .move_player
    ;cp $0f
    ;jr c, .move_player
    call player_jump

.move_player:
    call move_player
    cp PLAYER_FOUND_DOOR
    jr z, .exit
    cp PLAYER_FOUND_EYE
    jr z, .switch
    call move_camera_to_player
    call wait_vblank
    call update_camera
    call draw_player
    call draw_key
    jr .loop

.switch:
    ld hl, LIGHT
    ld a, LIGHT_ON
    sub [hl]
    ld [hl], a
    call fade_out
    jp .outer

.exit:
    call fade_out
    ret
