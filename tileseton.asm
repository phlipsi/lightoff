include "hardware.inc"

section "TILESON", rom0

tileset_on:
incbin "lighton.bin"
tileset_on_end:

load_tileset_on::
    ld hl, _VRAM8000
    ld de, tileset_on
    ld bc, tileset_on_end - tileset_on
    jp copy_memory
