include "notes.inc"

section "SONG2", romx, bank[1]

def CH2  equs "$e8, $f1"
def CH3  equs "$cf, $20"
def CHL3 equs "$9f, $20"

channel3_wave:
    db $ff, $ee, $dd, $cc, $bb, $aa, $99, $88, $77, $66, $55, $44, $33, $22, $11, $00
    ;db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $00, $00, $00, $00, $00, $00, $00, $00

song2:
    dw base,  lead,  perc
    dw base2, lead2, perc
    dw base3, lead3, perc
    dw base4, lead4, perc

    dw base,  lead,  perc
    dw base5, lead5, perc
    dw base6, lead6, perc
    dw base7, lead7, perc7

    dw base,  lead8,  perc
    dw base2, lead9, perc
    dw base3, lead9, perc
    dw base4, lead10, perc

    dw base,  lead,  perc
    dw base5, lead5, perc
    dw base6, lead6, perc
    dw base7, lead7, perc7
song2_end:

base:
    db CH2, G2,   NULL,      CH2, D3,   CH2, D3
    db NULL,      NULL,      CH2, D3,   NULL
    db CH2, AIS2, NULL,      CH2, D3,   CH2, D3
    db NULL,      NULL,      CH2, AIS2, NULL

lead:
    db NULL,      NULL,      CH3, G6,   NULL
    db CH3, D6,   NULL,      CH3, C6,   NULL
    db CH3, D6,   NULL,      CH3, AIS5, NULL
    db CH3, A5,   NULL,      CH3, G5,   NULL

perc:
    db SH,   HH,   SH,   NULL
    db SN,   NULL, SH,   NULL
    db SH,   HH,   SH,   NULL
    db SN,   NULL, SH,   NULL

base2:
    db CH2, A2,   NULL,      CH2, D3,   CH2, D3
    db NULL,      NULL,      CH2, A2,   NULL
    db CH2, D2,   NULL,      CH2, A2,   CH2, A2
    db NULL,      NULL,      CH2, FIS2, NULL

lead2:
    db CHL3,FIS5, NULL,      NULL,      CH3, D6
    db CHL3, D6,  NULL,      NULL,      CH3, D6
    db NULL,      NULL,      NULL,      NULL
    db NULL,      NULL,      NULL,      NULL

base3:
    db CH2, D2,   NULL,      CH2, A2,   CH2, A2
    db NULL,      NULL,      CH2, A2,   NULL
    db CH2, FIS2, NULL,      CH2, D3,   CH2, D3
    db NULL,      NULL,      CH2, A2,   NULL

lead3:
    db NULL,      NULL,      CH3, FIS6, NULL
    db CH3, D6,   NULL,      CH3, C6,   NULL
    db CH3, D6,   NULL,      CH3, AIS5, NULL
    db CH3, A5,   NULL,      CH3, FIS5, NULL

base4:
    db CH2, G2,   NULL,      CH2, D3,   CH2, D3
    db NULL,      NULL,      CH2, D3,   NULL
    db CH2, G2,   NULL,      CH2, G2,   CH2, AIS2
    db CH2, A2,   CH2, G2,   CH2, D2,   CH2, FIS2

lead4:
    db CHL3, G5,  NULL,      NULL,      CH3, D6
    db CHL3, D6,  NULL,      NULL,      CH3, D6
    db NULL,      NULL,      NULL,      NULL
    db NULL,      NULL,      NULL,      NULL

base5:
    db CH2, FIS2, NULL,      CH2, C3,   CH2, C3
    db NULL,      NULL,      CH2, A2,   NULL
    db CH2, A2,   NULL,      CH2, C3,   NULL
    db CH2, D3,   NULL,      CH2, DIS3, NULL

lead5:
    db CHL3,DIS6, NULL,      NULL,      CH3, C6
    db CHL3,C6,   NULL,      CH3, C6,   NULL
    db NULL,      NULL,      CH3, DIS6, NULL
    db CH3, D6,   NULL,      CH3, C6,   NULL

base6:
    db CH2, G2,   NULL,      CH2, D3,   CH2, D3
    db NULL,      NULL,      CH2, D3,   NULL
    db CH2, D2,   NULL,      CH2, A2,   CH2, A2
    db NULL,      NULL,      CH2, A2,   NULL

lead6:
    db CH3, D6,   NULL,      CH3, AIS5, NULL
    db CH3, G5,   NULL,      CH3, AIS5, NULL
    db CH3, A5,   NULL,      NULL,      NULL
    db CH3, FIS5, NULL,      NULL,      NULL

base7:
    db CH2, G2,   NULL,      NULL,      NULL
    db CH2, D2,   NULL,      NULL,      NULL
    db CH2, G2,   NULL,      NULL,      NULL
    db NULL,      CH2, D2,   CH2, E2,   CH2, FIS2

lead7:
    db CHL3, G5,  NULL,      NULL,      NULL
    db NULL,      NULL,      NULL,      NULL
    db NULL,      NULL,      NULL,      NULL
    db NULL,      NULL,      NULL,      NULL

perc7:
    db NULL, NULL, NULL, NULL
    db NULL, NULL, NULL, NULL
    db NULL, NULL, NULL, SN
    db SN, NULL, SN, NULL

lead8:
    db NULL,      NULL,      CH3, AIS5,   NULL
    db CH3, G5,   NULL,      CH3, AIS5,   NULL
    db NULL,      NULL,      CH3, G5,     NULL
    db CH3, AIS5, NULL,      CH3, G5,     NULL

lead9:
    db NULL, NULL, CH3, FIS5, NULL
    db CH3, A5, NULL, CH3, FIS5, NULL
    db NULL, NULL, CH3, FIS5, NULL
    db CH3, C6, NULL, CH3, FIS5, NULL

lead10:
    db NULL,      NULL,      CH3, G5,     NULL
    db CH3, AIS5, NULL,      CH3, G5,     NULL
    db NULL,      NULL,      CH3, AIS5,   NULL
    db CH3, D6,   NULL,      CH3, FIS6,   NULL

section "SONG2_LOADER", rom0

load_song2::
    ; select rom bank 1
    ld a, $01
    ld [$2000], a

    ld de, channel3_wave
    call load_custom_wave
    ld bc, song2
    ld d, (song2_end - song2) / (2 * 3)
    ld e, 16
    ld hl, $e018
    jp init_song
