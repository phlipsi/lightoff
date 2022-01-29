include "hardware.inc"

section "DOOR_DATA", wram0

DOOR_X:: DS 1
DOOR_Y:: DS 1

section "DOOR", rom0

; b - x
; c - y
init_door::
    ld hl, DOOR_X
    ld [hl], b
    ld hl, DOOR_Y
    ld [hl], c
    ret
