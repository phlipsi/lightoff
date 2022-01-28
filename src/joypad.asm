include "hardware.inc"

section "JOYPAD_DATA", wram0

JOYPAD_DOWN:   DS 1
JOYPAD_UP:     DS 1
JOYPAD_LEFT::  DS 1
JOYPAD_RIGHT:: DS 1

section "JOYPAD", rom0

wait_until_keypress::
    ld hl, rP1
.loop:
    ; read action buttons
    ld [hl], P1F_GET_BTN
    ld a, [hl]
    and a, %1111
    xor a, %1111
    jr z, .loop
    ret

init_keys::
    ld a, 0
    ld [JOYPAD_DOWN], a
    ld [JOYPAD_UP], a
    ld [JOYPAD_LEFT], a
    ld [JOYPAD_RIGHT], a
    ret

read_keys::
    ld hl, rP1
    ld [hl], P1F_GET_DPAD
    ld a, [hl]
    srl a
    ld hl, JOYPAD_RIGHT
    ccf
    rr [hl]
    srl a
    ld hl, JOYPAD_LEFT
    ccf
    rr [hl]
    srl a
    ld hl, JOYPAD_UP
    ccf
    rr [hl]
    srl a
    ld hl, JOYPAD_DOWN
    ccf
    rr [hl]
    ret
