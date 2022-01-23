SECTION "VBLANK_INTERRUPT", ROM0[$0040]
vblank_interrupt:
    reti

SECTION "STAT_INTERRUPT", ROM0[$0048]
stat_interrupt:
    reti

SECTION "TIMER_INTERRUPT", ROM0[$0050]
timer_interrupt:
    reti

SECTION "SERIAL_INTERRUPT", ROM0[$0058]
serial_interrupt:
    reti

SECTION "JOYPAD_INTERRUPT", ROM0[$0060]
joypad_interrupt:
    reti

SECTION "HEADER", ROM0[$100]

entry_point:
    di
    jp start

REPT $150 - $104
    db 0
ENDR
