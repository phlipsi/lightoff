include "notes.inc"

section "SONG1", romx, bank[1]

def CH2  equs "$31, $f1"
def CH3  equs "$e0, $20"

channel3_wave:
    ;db $ff, $ee, $dd, $cc, $bb, $aa, $99, $88, $77, $66, $55, $44, $33, $22, $11, $00
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $00, $00, $00, $00, $00, $00, $00, $00

song1:
    ;  SQUARE2    WAVE       PERC
    ; 1 -------------------------
    db NULL,      CH3, D4,   NULL
    db NULL,      NULL,      NULL
    db NULL,      NULL,      NULL
    db NULL,      NULL,      NULL

    db NULL,      CH3, C4,   NULL
    db NULL,      NULL,      NULL
    db CH2, A5,   NULL,      NULL
    db NULL,      CH3, D4,   NULL

    db NULL,      NULL,      NULL
    db NULL,      NULL,      NULL
    db NULL,      NULL,      NULL
    db CH2, A5,   NULL,      NULL

    db NULL,      NULL,      NULL
    db NULL,      NULL,      NULL
    db CH2, A5,   NULL,      NULL
    db NULL,      NULL,      NULL
    ; 2 -------------------------
    db NULL,      CH3, D4,   NULL
    db NULL,      NULL,      NULL
    db CH2, A5,   CH3, D4,   NULL
    db NULL,      NULL,      NULL

    db NULL,      CH3, F4,   NULL
    db NULL,      NULL,      NULL
    db CH2, A5,   NULL,      NULL
    db NULL,      CH3, D4,   NULL

    db NULL,      NULL,      NULL
    db NULL,      NULL,      NULL
    db NULL,      NULL,      NULL
    db CH2, A5,   NULL,      NULL

    db NULL,      NULL,      NULL
    db NULL,      NULL,      NULL
    db CH2, A5,   NULL,      NULL
    db NULL,      NULL,      NULL
    ; 3 -------------------------
    db NULL,      CH3, D4,   NULL
    db NULL,      NULL,      NULL
    db NULL,      NULL,      NULL
    db NULL,      NULL,      NULL

    db NULL,      CH3, C4,   NULL
    db NULL,      NULL,      NULL
    db CH2, A5,   NULL,      NULL
    db NULL,      CH3, D4,   NULL

    db NULL,      NULL,      NULL
    db NULL,      NULL,      NULL
    db NULL,      NULL,      NULL
    db CH2, A5,   NULL,      NULL

    db NULL,      NULL,      NULL
    db NULL,      NULL,      NULL
    db CH2, A5,   NULL,      NULL
    db NULL,      NULL,      NULL
    ; 4 -------------------------
    db NULL,      CH3, D4,   NULL
    db NULL,      NULL,      NULL
    db CH2, A5,   CH3, D4,   NULL
    db NULL,      NULL,      NULL

    db NULL,      CH3, F4,   NULL
    db NULL,      NULL,      NULL
    db CH2, A5,   NULL,      NULL
    db NULL,      CH3, D4,   NULL

    db NULL,      NULL,      NULL
    db NULL,      NULL,      NULL
    db NULL,      NULL,      NULL
    db CH2, A5,   NULL,      NULL

    db NULL,      NULL,      NULL
    db NULL,      NULL,      NULL
    db CH2, A5,   CH3, C4,   NULL
    db NULL,      NULL,      NULL
    ; 5 -------------------------
    db CH2, G4,   CH3, D4,   SH
    db NULL,      NULL,      SH
    db CH2, A4,   NULL,      HH
    db NULL,      NULL,      NULL

    db NULL,      CH3, C4,   SN
    db CH2, G4,   NULL,      NULL
    db CH2, A5,   NULL,      SH
    db CH2, D4,   CH3, D4,   SH

    db NULL,      NULL,      NULL
    db NULL,      NULL,      NULL
    db NULL,      NULL,      HH
    db CH2, A5,   NULL,      NULL

    db NULL,      CH3, D5,   SN
    db NULL,      NULL,      NULL
    db CH2, A5,   NULL,      HH
    db NULL,      NULL,      NULL
    ; 6 -------------------------
    db NULL,      CH3, D4,   SH
    db NULL,      NULL,      SH
    db CH2, A5,   CH3, D4,   HH
    db NULL,      NULL,      NULL

    db CH2, D5,   CH3, F4,   SN
    db CH2, D4,   NULL,      NULL
    db CH2, A5,   NULL,      SH
    db NULL,      CH3, D4,   SH

    db CH2, D5,   NULL,      NULL
    db NULL,      NULL,      NULL
    db CH2, D4,   NULL,      HH
    db CH2, A5,   NULL,      NULL

    db NULL,      CH3, D5,   SN
    db CH2, D5,   NULL,      NULL
    db CH2, A5,   NULL,      HH
    db CH2, D6,   NULL,      NULL
    ; 7 -------------------------
    db CH2, G4,   CH3, D4,   SH
    db NULL,      NULL,      SH
    db CH2, A4,   NULL,      HH
    db NULL,      NULL,      NULL

    db NULL,      CH3, C4,   SN
    db CH2, G4,   NULL,      NULL
    db CH2, A5,   NULL,      SH
    db CH2, D4,   CH3, D4,   SH

    db NULL,      NULL,      NULL
    db NULL,      NULL,      NULL
    db NULL,      NULL,      HH
    db CH2, A5,   NULL,      NULL

    db NULL,      CH3, D5,   SN
    db NULL,      NULL,      NULL
    db CH2, A5,   NULL,      HH
    db NULL,      NULL,      NULL
    ; 8 -------------------------
    db NULL,      CH3, D4,   SH
    db NULL,      NULL,      SH
    db CH2, A5,   CH3, D4,   HH
    db NULL,      NULL,      NULL

    db CH2, D5,   CH3, F4,   SN
    db CH2, D4,   NULL,      NULL
    db CH2, A5,   NULL,      SH
    db NULL,      CH3, D4,   SH

    db CH2, D5,   NULL,      NULL
    db NULL,      NULL,      NULL
    db CH2, D4,   NULL,      HH
    db CH2, A5,   NULL,      NULL

    db NULL,      CH3, D5,   SN
    db CH2, D5,   NULL,      NULL
    db CH2, A5,   CH3, C4,   HH
    db CH2, D6,   NULL,      NULL
    ; 9 -------------------------
    db CH2, G4,   CH3, AIS3, SH
    db NULL,      NULL,      SH
    db CH2, A4,   NULL,      HH
    db NULL,      NULL,      NULL

    db NULL,      CH3, A4,   SN
    db CH2, G4,   NULL,      NULL
    db CH2, A5,   NULL,      SH
    db CH2, D4,   CH3, AIS3, SH

    db NULL,      NULL,      NULL
    db NULL,      NULL,      NULL
    db NULL,      NULL,      HH
    db CH2, A5,   NULL,      NULL

    db NULL,      CH3, AIS4, SN
    db NULL,      NULL,      NULL
    db CH2, A5,   NULL,      HH
    db NULL,      NULL,      NULL
    ; 10 ------------------------
    db NULL,      CH3, AIS3, SH
    db NULL,      NULL,      SH
    db CH2, A5,   CH3, AIS3, HH
    db NULL,      NULL,      NULL

    db CH2, D5,   CH3, D4,   SN
    db CH2, D4,   NULL,      NULL
    db CH2, A5,   NULL,      SH
    db NULL,      CH3, AIS3, SH

    db CH2, D5,   NULL,      NULL
    db NULL,      NULL,      NULL
    db CH2, D4,   NULL,      HH
    db CH2, A5,   NULL,      NULL

    db NULL,      CH3, AIS4, SN
    db CH2, D5,   NULL,      NULL
    db CH2, A5,   NULL,      HH
    db CH2, D6,   NULL,      NULL
    ; 11 ------------------------
    db CH2, G4,   CH3, AIS3, SH
    db NULL,      NULL,      SH
    db CH2, A4,   NULL,      HH
    db NULL,      NULL,      NULL

    db NULL,      CH3, A4,   SN
    db CH2, G4,   NULL,      NULL
    db CH2, A5,   NULL,      SH
    db CH2, D4,   CH3, AIS3, SH

    db NULL,      NULL,      NULL
    db NULL,      NULL,      NULL
    db NULL,      NULL,      HH
    db CH2, A5,   NULL,      NULL

    db NULL,      CH3, AIS4, SN
    db NULL,      NULL,      NULL
    db CH2, A5,   NULL,      HH
    db NULL,      NULL,      NULL
    ; 12 ------------------------
    db NULL,      CH3, AIS3, SH
    db NULL,      NULL,      SH
    db CH2, A5,   CH3, AIS3, HH
    db NULL,      NULL,      NULL

    db CH2, D5,   CH3, D4,   SN
    db CH2, D4,   NULL,      NULL
    db CH2, A5,   NULL,      SH
    db NULL,      CH3, AIS3, SH

    db CH2, D5,   NULL,      NULL
    db NULL,      NULL,      NULL
    db CH2, D4,   NULL,      HH
    db CH2, A5,   NULL,      NULL

    db NULL,      CH3, AIS4, SN
    db CH2, D5,   NULL,      NULL
    db CH2, A5,   CH3, C4,   HH
    db CH2, D6,   NULL,      NULL
    ; ===========================
song1_end:

section "SONG1_LOADER", rom0

load_song1::
    ; select rom bank 1
    ld a, $01
    ld [$2000], a

    ld de, channel3_wave
    call load_custom_wave
    ld bc, song1
    ld d, (song1_end - song1) / 12
    jp init_song
