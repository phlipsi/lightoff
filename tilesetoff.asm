include "hardware.inc"

section "TILESOFF", rom0

tileset_off:
incbin "lightoff.bin"
tileset_off_end:

load_tileset_off::
    ld hl, _VRAM8000
    ld de, tileset_off
    ld bc, tileset_off_end - tileset_off
    jp copy_memory
