include "notes.inc"

section "SONG2", romx, bank[1]

def CH2  equs "$e8, $f1"
def CH3  equs "$cf, $20"
def CHL3 equs "$9f, $20"

channel3_wave:
    db $ff, $ee, $dd, $cc, $bb, $aa, $99, $88, $77, $66, $55, $44, $33, $22, $11, $00
    ;db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $00, $00, $00, $00, $00, $00, $00, $00

song2:
    dw intro_base,  intro_lead,  intro_perc
    dw intro_base2, intro_lead2, intro_perc
    dw intro_base3,  intro_lead3,  intro_perc
    dw intro_base4, intro_lead4, intro_perc2
song2_end:

intro_base:
    db CH2, G2,   NULL,      CH2, D3,   CH2, D3
    db NULL,      NULL,      CH2, D3,   NULL
    db CH2, AIS2, NULL,      CH2, D3,   CH2, D3
    db NULL,      NULL,      CH2, AIS2, NULL

    db CH2, A2,   NULL,      CH2, D3,   CH2, D3
    db NULL,      NULL,      CH2, A2,   NULL
    db CH2, D2,   NULL,      CH2, A2,   CH2, A2
    db NULL,      NULL,      CH2, FIS2, NULL

intro_base2:
    db CH2, D2,   NULL,      CH2, A2,   CH2, A2
    db NULL,      NULL,      CH2, A2,   NULL
    db CH2, FIS2, NULL,      CH2, D3,   CH2, D3
    db NULL,      NULL,      CH2, A2,   NULL

    db CH2, G2,   NULL,      CH2, D3,   CH2, D3
    db NULL,      NULL,      CH2, D3,   NULL
    db CH2, G2,   NULL,      CH2, G2,   CH2, AIS2
    db CH2, A2,   CH2, G2,   CH2, D2,   CH2, FIS2

intro_base3:
    db CH2, G2,   NULL,      CH2, D3,   CH2, D3
    db NULL,      NULL,      CH2, D3,   NULL
    db CH2, AIS2, NULL,      CH2, D3,   CH2, D3
    db NULL,      NULL,      CH2, AIS2, NULL

    db CH2, FIS2, NULL,      CH2, C3,   CH2, C3
    db NULL,      NULL,      CH2, A2,   NULL
    db CH2, A2,   NULL,      CH2, C3,   NULL
    db CH2, D3,   NULL,      CH2, DIS3, NULL

intro_base4:
    db CH2, G2,   NULL,      CH2, D3,   CH2, D3
    db NULL,      NULL,      CH2, D3,   NULL
    db CH2, D2,   NULL,      CH2, A2,   CH2, A2
    db NULL,      NULL,      CH2, A2,   NULL

    db CH2, G2,   NULL,      NULL,      NULL
    db CH2, D2,   NULL,      NULL,      NULL
    db CH2, G2,   NULL,      NULL,      NULL
    db NULL,      CH2, D2,   CH2, E2,   CH2, FIS2

intro_lead:
    db NULL,      NULL,      CH3, G6,   NULL
    db CH3, D6,   NULL,      CH3, C6,   NULL
    db CH3, D6,   NULL,      CH3, AIS5, NULL
    db CH3, A5,   NULL,      CH3, G5,   NULL

    db CHL3,FIS5, NULL,      NULL,      CH3, D6
    db CHL3, D6,  NULL,      NULL,      CH3, D6
    db NULL,      NULL,      NULL,      NULL
    db NULL,      NULL,      NULL,      NULL

intro_lead2:
    db NULL,      NULL,      CH3, FIS6, NULL
    db CH3, D6,   NULL,      CH3, C6,   NULL
    db CH3, D6,   NULL,      CH3, AIS5, NULL
    db CH3, A5,   NULL,      CH3, FIS5, NULL

    db CHL3, G5,  NULL,      NULL,      CH3, D6
    db CHL3, D6,  NULL,      NULL,      CH3, D6
    db NULL,      NULL,      NULL,      NULL
    db NULL,      NULL,      NULL,      NULL

intro_lead3:
    db NULL,      NULL,      CH3, G6,   NULL
    db CH3, D6,   NULL,      CH3, C6,   NULL
    db CH3, D6,   NULL,      CH3, AIS5, NULL
    db CH3, A5,   NULL,      CH3, G5,   NULL

    db CHL3,DIS6, NULL,      NULL,      CH3, C6
    db CHL3,C6,   NULL,      CH3, C6,   NULL
    db NULL,      NULL,      CH3, DIS6, NULL
    db CH3, D6,   NULL,      CH3, C6,   NULL

intro_lead4:
    db CH3, D6,   NULL,      CH3, AIS5, NULL
    db CH3, G5,   NULL,      CH3, AIS5, NULL
    db CH3, A5,   NULL,      NULL,      NULL
    db CH3, FIS5, NULL,      NULL,      NULL

    db CHL3, G5,  NULL,      NULL,      NULL
    db NULL,      NULL,      NULL,      NULL
    db NULL,      NULL,      NULL,      NULL
    db NULL,      NULL,      NULL,      NULL

intro_perc:
    db SH, HH,   SH,   NULL
    db SN, NULL,   SH,   NULL
    db SH, HH,   SH,   NULL
    db SN, NULL,   SH,   NULL

    db SH, HH,   SH,   NULL
    db SN, NULL,   SH,   NULL
    db SH, HH,   SH,   NULL
    db SN, NULL,   SH,   NULL

intro_perc2:
    db SH, HH,   SH,   NULL
    db SN, NULL,   SH,   NULL
    db SH, HH,   SH,   NULL
    db SN, NULL,   SH,   NULL

    db NULL, NULL, NULL, NULL
    db NULL, NULL, NULL, NULL
    db NULL, NULL, NULL, SN
    db SN, NULL, SN, NULL

section "SONG2_LOADER", rom0

load_song2::
    ; select rom bank 1
    ld a, $01
    ld [$2000], a

    ld de, channel3_wave
    call load_custom_wave
    ld bc, song2
    ld d, (song2_end - song2) / (2 * 3)
    ld e, 32
    ld hl, $e018
    jp init_song
