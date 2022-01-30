include "notes.inc"

section "SONG2", romx, bank[1]

def CH2  equs "$e8, $f1"
def CH3  equs "$cf, $20"
def CHL3 equs "$9f, $20"

channel3_wave:
    db $ff, $ee, $dd, $cc, $bb, $aa, $99, $88, $77, $66, $55, $44, $33, $22, $11, $00
    ;db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $00, $00, $00, $00, $00, $00, $00, $00

song2:
    ;  SQUARE2    WAVE       PERC
    ; 1 -------------------------
    db CH2, G2,   NULL,      NULL
    db NULL,      NULL,      NULL
    db CH2, D3,   CH3, G6,   SH
    db CH2, D3,   NULL,      NULL

    db NULL,      CH3, D6,   NULL
    db NULL,      NULL,      NULL
    db CH2, D3,   CH3, C6,   SH
    db NULL,      NULL,      NULL

    db CH2, AIS2, CH3, D6,   NULL
    db NULL,      NULL,      NULL
    db CH2, G3,   CH3, AIS5, SH
    db CH2, G3,   NULL,      NULL

    db NULL,      CH3, A5,   NULL
    db NULL,      NULL,      NULL
    db CH2, AIS2, CH3, G5,   SH
    db NULL,      NULL,      NULL

    db CH2, A2,   CHL3,FIS5, NULL
    db NULL,      NULL,      NULL
    db CH2, D3,   NULL,      SH
    db CH2, D3,   CH3, D6,   NULL

    db NULL,      CHL3, D6,  NULL
    db NULL,      NULL,      NULL
    db CH2, A2,   NULL,      SH
    db NULL,      CH3, D6,   NULL

    db CH2, D2,   NULL,      NULL
    db NULL,      NULL,      NULL
    db CH2, A2,   NULL,      SH
    db CH2, A2,   NULL,      NULL

    db NULL,      NULL,      NULL
    db NULL,      NULL,      NULL
    db CH2, AIS2, NULL,      SH
    db NULL,      NULL,      NULL
    ; ---------------------------
    db CH2, A2,   NULL,      NULL
    db NULL,      NULL,      NULL
    db CH2, D3,   CH3, FIS6, SH
    db CH2, D3,   NULL,      NULL

    db NULL,      CH3, D6,   NULL
    db NULL,      NULL,      NULL
    db CH2, A2,   CH3, C6,   SH
    db NULL,      NULL,      NULL

    db CH2, D2,   CH3, D6,   NULL
    db NULL,      NULL,      NULL
    db CH2, A2,   CH3, AIS5, SH
    db CH2, A2,   NULL,      NULL

    db NULL,      CH3, A5,   NULL
    db NULL,      NULL,      NULL
    db CH2, AIS2, CH3, FIS5, SH
    db NULL,      NULL,      NULL

    db CH2, AIS2, CHL3,G5,   NULL
    db NULL,      NULL,      NULL
    db CH2, G3,   NULL,      SH
    db CH2, G3,   CH3, D6,   NULL

    db NULL,      CHL3, D6,  NULL
    db NULL,      NULL,      NULL
    db CH2, AIS2, NULL,      SH
    db NULL,      CH3, D6,   NULL

    db CH2, G2,   NULL,      NULL
    db NULL,      NULL,      NULL
    db CH2, D3,   NULL,      SH
    db CH2, D3,   NULL,      NULL

    db NULL,      NULL,      NULL
    db NULL,      NULL,      NULL
    db CH2, D3,   NULL,      SH
    db NULL,      NULL,      NULL

    ; ===========================
song2_end:

section "SONG2_LOADER", rom0

load_song2::
    ; select rom bank 1
    ld a, $01
    ld [$2000], a

    ld de, channel3_wave
    call load_custom_wave
    ld bc, song2
    ld de, (song2_end - song2) / 12

    ld hl, $e018
    jp init_song
