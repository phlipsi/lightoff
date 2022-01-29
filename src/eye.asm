include "hardware.inc"

section "EYE_DATA", wram0

EYE_X:: DS 1
EYE_Y:: DS 1

section "EYE", rom0

; b - x
; c - y
init_eye::
    ld hl, EYE_X
    ld [hl], b
    ld hl, EYE_Y
    ld [hl], c
    ret
