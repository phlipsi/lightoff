include "hardware.inc"

section "SPRITES", rom0

sprites:
incbin "sprites.bin"
sprites_end:

load_sprites::
    ld hl, _VRAM
    ld de, sprites
    ld bc, sprites_end - sprites
    jp copy_memory
