INCLUDE "hardware.inc"

SECTION "TILES", ROM0

tiles:
INCBIN "tileset.bin"
tiles_end:

load_tiles::
    ld hl, _VRAM8000
    ld de, tiles
    ld bc, tiles_end - tiles
    jp copy_memory
