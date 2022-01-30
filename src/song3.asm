include "notes.inc"

section "SONG3", romx, bank[1]

def CH2  equs "$0a, $f1"
def CH3  equs "$01, $20"
def CHL3 equs "$9f, $20"

channel3_wave:
    db $77, $88, $99, $aa, $bb, $cc, $dd, $ee, $ff, $66, $55, $44, $33, $22, $11, $00
    ;db $ff, $ee, $dd, $cc, $bb, $aa, $99, $88, $77, $66, $55, $44, $33, $22, $11, $00
    ;db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $00, $00, $00, $00, $00, $00, $00, $00

song3:
    dw lead, bass, perc
song3_end:

lead:
    db NULL,      NULL, NULL, NULL
    db CH2, A4,   NULL, NULL, NULL
    db CH2, FIS4, NULL, NULL, NULL
    db CH2, A4,   NULL, NULL, NULL

    db NULL,      NULL, NULL, NULL
    db CH2, H4,   NULL, NULL, NULL
    db CH2, H3,   NULL, NULL, NULL
    db CH2, D4,   NULL, NULL, NULL

    db NULL,      NULL, NULL, NULL
    db CH2, FIS4, NULL, NULL, NULL
    db CH2, D4,   NULL, NULL, NULL
    db NULL,      NULL, NULL, NULL

    db NULL,      NULL, NULL, NULL
    db NULL,      NULL, NULL, NULL
    db CH2, E4,   NULL, NULL, NULL
    db NULL,      NULL, NULL, NULL

bass:
    db CH3, D3,   NULL, NULL, NULL
    db NULL,      NULL, NULL, NULL
    db NULL,      NULL, NULL, NULL
    db CH3, CIS3, NULL, NULL, NULL

    db CH3, H2,   NULL, NULL, NULL
    db NULL,      NULL, NULL, NULL
    db NULL,      NULL, NULL, NULL
    db CH3, A2,   NULL, NULL, NULL

    db CH3, G2,   NULL, NULL, NULL
    db NULL,      NULL, NULL, NULL
    db NULL,      NULL, NULL, NULL
    db NULL,      NULL, NULL, NULL

    db CH3, A2,   NULL, NULL, NULL
    db NULL,      NULL, NULL, NULL
    db NULL,      NULL, NULL, NULL
    db NULL,      NULL, NULL, NULL

perc:
    db BD, NULL, NULL, NULL
    db NULL, NULL, NULL, NULL
    db SN, NULL, NULL, NULL
    db NULL, NULL, NULL, NULL

    db BD, NULL, NULL, NULL
    db NULL, NULL, NULL, NULL
    db SN, NULL, NULL, NULL
    db NULL, NULL, NULL, NULL

    db BD, NULL, NULL, NULL
    db NULL, NULL, NULL, NULL
    db SN, NULL, NULL, NULL
    db NULL, NULL, NULL, NULL

    db BD, NULL, NULL, NULL
    db NULL, NULL, NULL, NULL
    db SN, NULL, NULL, NULL
    db NULL, NULL, NULL, NULL

section "SONG3_LOADER", rom0

load_song3::
    ; select rom bank 1
    ld a, $01
    ld [$2000], a

    ld de, channel3_wave
    call load_custom_wave
    ld bc, song3
    ld d, (song3_end - song3) / (2 * 3)
    ld e, 64
    ld hl, $eb18
    jp init_song
