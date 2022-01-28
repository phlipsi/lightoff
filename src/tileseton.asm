include "hardware.inc"

section "TILESON", rom0

tileset_on:
incbin "lighton.bin"
tileset_on_end:

load_tileset_on::
    ld hl, _VRAM + $0800
    ld de, tileset_on + $0800
    ld bc, (tileset_on_end - tileset_on) / 2
    call copy_memory

    ld hl, _VRAM + $1000
    ld de, tileset_on
    ld bc, (tileset_on_end - tileset_on) / 2
    jp copy_memory
