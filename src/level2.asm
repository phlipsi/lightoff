include "hardware.inc"

section "LEVEL2_DATA", wram0

LIGHT: DS 1

def LIGHT_ON  equ 1
def LIGHT_OFF equ 0

section "LEVEL2_MAPS", romx, bank[1]

level2_on:
incbin "level2-on.tilemap", 0, 32 * 32
level2_on_end:

level2_off:
    incbin "level2-off.tilemap", 0, 32 * 32
level2_off_end:

section "LEVEL2", rom0

load_level2_on_tilemap:
    ; select rom bank 1
    ld a, $01
    ld [$2000], a

    ld de, level2_on
    ld hl, _SCRN0
    ld bc, level2_on_end - level2_on
    jp copy_memory

load_level2_off_tilemap:
    ; select rom bank 1
    ld a, $01
    ld [$2000], a

    ld de, level2_off
    ld hl, _SCRN0
    ld bc, level2_off_end - level2_off
    jp copy_memory

level2::
    ld hl, MAX_CAMERA_X
    ld [hl], SCRN_VX - SCRN_X
    ld hl, MAX_CAMERA_Y
    ld [hl], SCRN_VY - SCRN_Y

    ld a, LIGHT_ON
    ld [LIGHT], a

    ld bc, $1010
    call init_player
    call move_camera_to_player
    ld bc, $f838
    call init_key
    ld bc, $1028
    call init_door
    ;ld bc, $7848
    ;call init_eye

.outer:
    ld a, [LIGHT]
    cp LIGHT_OFF
    jr z, .load_light_off

    call load_song1

    ld de, level2_on
    ld bc, level2_on_end - level2_on
    call load_to_screen

    call load_tileset_on
    call display_screen
    jr .start

.load_light_off:
    call load_song2

    ld de, level2_off
    ld bc, level2_off_end - level2_off
    call load_to_screen

    call load_tileset_off
    call display_screen

.start
    call update_camera
    call draw_player
    call draw_key
    ;call draw_eye

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

    ld a, 0
    ld [PLAYER_X], a
    ld [PLAYER_X + 1], a
    ld [PLAYER_Y], a
    ld [PLAYER_Y + 1], a
    ld [KEY_X], a
    ld [KEY_Y], a
    call draw_key
    call draw_player
    ret
