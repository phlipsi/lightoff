include "hardware.inc"

section "JOYPAD", rom0

wait_until_keypress::
    ld hl, rP1
.loop:
    ; read action buttons
    ld [hl], %010000
    ld a, [hl]
    and a, %1111
    xor a, %1111
    jr z, .loop
    ret
