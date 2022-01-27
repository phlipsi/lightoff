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
    call load_tileset_on
    call load_level1_on_tilemap
    jp fade_in
