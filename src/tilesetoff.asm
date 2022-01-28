include "hardware.inc"

section "TILESOFF", rom0

tileset_off:
incbin "lightoff.bin"
tileset_off_end:

load_tileset_off::
    ld hl, _VRAM + $0800
    ld de, tileset_off + $0800
    ld bc, (tileset_off_end - tileset_off) / 2
    call copy_memory

    ld hl, _VRAM + $1000
    ld de, tileset_off
    ld bc, (tileset_off_end - tileset_off) / 2
    jp copy_memory
