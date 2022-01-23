INCLUDE "hardware.inc"

SECTION "Intro", ROM0

intro:
INCBIN "intro.tilemap", 0, 564
intro_end:

load_intro_tilemap::
    ld de, intro
    ld hl, _SCRN0
    ld bc, intro_end - intro
    jp copy_memory
