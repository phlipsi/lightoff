INCLUDE "hardware.inc"

DEF VOLUME EQU 7
DEF VOLUME_LEFT EQU VOLUME
DEF VOLUME_RIGHT EQU VOLUME

DEF SWEEP_TIME EQU %010
DEF SWEEP_SHIFT EQU %011

DEF WAVE_DUTY EQU %10
DEF SOUND_LENGTH EQU 1

DEF ENV_INITIAL_VOL EQU 4
DEF ENV_SWEEP EQU 3

DEF FREQUENCY EQU 2048 - (131072 / 110)
DEF EXPIRES EQU 1

SECTION "SOUND_PUBLIC", ROM0

init_sound::
    ld a, AUDVOL_VIN_LEFT | VOLUME_LEFT << 4 | \
          AUDVOL_VIN_RIGHT | VOLUME_RIGHT
    ld [rAUDVOL], a

    ld a, AUDTERM_1_LEFT | AUDTERM_2_LEFT | AUDTERM_3_LEFT | AUDTERM_4_LEFT | \
          AUDTERM_1_RIGHT | AUDTERM_2_RIGHT | AUDTERM_3_RIGHT | AUDTERM_4_RIGHT
    ld [rAUDTERM], a

    ld a, AUDENA_ON
    ld [rAUDENA], a

    ret

play_bounce::
    ld a, SWEEP_TIME << 4 | AUD1SWEEP_DOWN | SWEEP_SHIFT
    ld [rAUD1SWEEP], a

    ld a, WAVE_DUTY << 6 | SOUND_LENGTH
    ld [rAUD1LEN], a

    ld a, ENV_INITIAL_VOL << 4 | ENV_SWEEP
    ld [rAUD1ENV], a

    ld a, %10000100
    ld [rAUD1LOW], a

    ld a, %10000011
    ld [rAUD1HIGH], a

    ret

play_jump::
    ld a, $13
    ld [rAUD1SWEEP], a
    ld a, $9f
    ld [rAUD1LEN], a
    ld a, $f0
    ld [rAUD1ENV], a
    ld a, $80
    ld [rAUD1LOW], a
    ld a, $c0
    ld [rAUD1HIGH], a
    ret

play_step::
    ld a, $13
    ld [rAUD1SWEEP], a
    ld a, $b9
    ld [rAUD1LEN], a
    ld a, $f0
    ld [rAUD1ENV], a
    ld a, $00
    ld [rAUD1LOW], a
    ld a, $c0
    ld [rAUD1HIGH], a
    ret

play_got_key::
    ld a, $15
    ld [rAUD1SWEEP], a
    ld a, $80
    ld [rAUD1LEN], a
    ld a, $f0
    ld [rAUD1ENV], a
    ld a, $f0
    ld [rAUD1LOW], a
    ld a, $c4
    ld [rAUD1HIGH], a
    ret

play_next_eighth::
    ret
