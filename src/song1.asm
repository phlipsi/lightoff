include "notes.inc"

section "SONG1", romx, bank[1]

def CH2  equs "$31, $f1"
def CH3  equs "$e0, $20"

channel3_wave:
    db $ff, $ee, $dd, $cc, $bb, $aa, $99, $88, $77, $66, $55, $44, $33, $22, $11, $00
    ;db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $00, $00, $00, $00, $00, $00, $00, $00

song1:
    ;dw beep_intro, base_intro,  perc_intro
    ;dw beep_intro, base_intro, perc_intro2
    dw beep_main,  base_main,   perc_main
    dw beep_main,  base_main,   perc_main
    dw beep_main,  base_main2,   perc_main
    dw beep_main,  base_main2,   perc_main2
    dw beep_main,  base_main,   perc_main
    dw beep_main,  base_main,   perc_main
    dw beep_main,  base_main2,   perc_main
    dw beep_main,  base_main2,   perc_main2
song1_end:

beep_intro:
    db NULL,      NULL,      NULL,      NULL
    db NULL,      NULL,      CH2, A5,   NULL
    db NULL,      NULL,      NULL,      CH2, A5
    db NULL,      NULL,      CH2, A5,   NULL
    db NULL,      NULL,      NULL,      NULL
    db NULL,      NULL,      CH2, A5,   NULL
    db NULL,      NULL,      NULL,      CH2, A5
    db NULL,      NULL,      CH2, A5,   NULL

base_intro:
    db CH3, D4,   NULL,      NULL,      NULL
    db CH3, C4,   NULL,      NULL,      CH3, D4
    db NULL,      NULL,      NULL,      NULL
    db NULL,      NULL,      NULL,      NULL
    db CH3, D4,   NULL,      CH3, D4,   NULL
    db CH3, F4,   NULL,      NULL,      CH3, D4
    db NULL,      NULL,      NULL,      NULL
    db NULL,      NULL,      CH3, C4,   NULL

base_intro2:
    db CH3, AIS3, NULL,      NULL,      NULL
    db CH3, A4,   NULL,      NULL,      CH3, AIS3
    db NULL,      NULL,      NULL,      NULL
    db NULL,      NULL,      NULL,      NULL

    db CH3, AIS3, NULL,      CH3, AIS3, NULL
    db CH3, D4,   NULL,      NULL,      CH3, AIS3
    db NULL,      NULL,      NULL,      NULL
    db NULL,      NULL,      NULL,      NULL

perc_intro:
    db NULL,      NULL,      HH,        NULL
    db NULL,      NULL,      HH,        NULL
    db NULL,      NULL,      HH,        NULL
    db NULL,      NULL,      HH,        NULL
    db NULL,      NULL,      HH,        NULL
    db NULL,      NULL,      HH,        NULL
    db NULL,      NULL,      HH,        NULL
    db NULL,      NULL,      HH,        NULL

perc_intro2:
    db NULL,      NULL,      HH,        NULL
    db NULL,      NULL,      HH,        NULL
    db NULL,      NULL,      HH,        NULL
    db NULL,      NULL,      HH,        NULL
    db NULL,      NULL,      NULL,      NULL
    db NULL,      NULL,      NULL,      NULL
    db NULL,      NULL,      NULL,      SN
    db SN,        NULL,      SN,        NULL

beep_main:
    db CH2, G4,   NULL,      CH2, A4,   NULL
    db NULL,      CH2, G4,   CH2, A5,   CH2, D4
    db NULL,      NULL,      NULL,      CH2, A5
    db NULL,      NULL,      CH2, A5,   NULL
    db NULL,      NULL,      CH2, A5,   NULL
    db CH2, D5,   CH2, D4,   CH2, A5,   NULL
    db CH2, D5,   NULL,      CH2, D4,   CH2, A5
    db NULL,      CH2, D5,   CH2, A5,   CH2, D6

base_main:
    db CH3, D4,   NULL,      NULL,      NULL
    db CH3, C4,   NULL,      NULL,      CH3, D4
    db NULL,      NULL,      NULL,      NULL
    db CH3, D5,   NULL,      NULL,      NULL
    db CH3, D4,   NULL,      CH3, D4,   NULL
    db CH3, F4,   NULL,      NULL,      CH3, D4
    db NULL,      NULL,      NULL,      NULL
    db CH3, D5,   NULL,      NULL,      NULL

base_main2:
    db CH3, AIS3, NULL,      NULL,      NULL
    db CH3, A4,   NULL,      NULL,      CH3, AIS3
    db NULL,      NULL,      NULL,      NULL
    db CH3, AIS4, NULL,      NULL,      NULL
    db CH3, AIS3, NULL,      CH3, AIS3, NULL
    db CH3, D4,   NULL,      NULL,      CH3, AIS3
    db NULL,      NULL,      NULL,      NULL
    db CH3, AIS4, NULL,      NULL,      NULL

perc_main:
    db BD,        BD,        HH,        NULL
    db SN,        NULL,      BD,        BD
    db NULL,      NULL,      HH,        NULL
    db SN,        NULL,      HH,        NULL
    db BD,        BD,        HH,        NULL
    db SN,        NULL,      BD,        BD
    db NULL,      NULL,      HH,        NULL
    db SN,        NULL,      HH,        NULL

perc_main2:
    db BD,        BD,        HH,        NULL
    db SN,        NULL,      BD,        BD
    db NULL,      NULL,      HH,        NULL
    db SN,        NULL,      HH,        NULL
    db BD,        BD,        HH,        NULL
    db SN,        NULL,      BD,        BD
    db NULL,      NULL,      HH,        SN
    db SN,        NULL,      SN,        NULL

section "SONG1_LOADER", rom0

load_song1::
    ; select rom bank 1
    ld a, $01
    ld [$2000], a

    ld de, channel3_wave
    call load_custom_wave
    ld bc, song1
    ld d, (song1_end - song1) / (2 * 3)
    ld e, 32
    ld hl, $e718
    jp init_song
