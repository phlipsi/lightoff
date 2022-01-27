include "hardware.inc"

section "SCREEN_DATA", wram0

SCREEN: DS 32 * 32

section "SCREEN", rom0

; de - source
; bc - size
load_to_screen::
    ld hl, SCREEN
    jp copy_memory

display_screen::
    ld hl, _SCRN0
    ld de, SCREEN
    ld bc, 32 * 32
    jp copy_memory
