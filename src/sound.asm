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

section "SONG_DATA", wram0

TICKS: DS 1
ENABLED: DS 1
START: DS 2
LENGTH: DS 2

CURRENT_TICK: DS 1
CURRENT: DS 2
REMAINING: DS 2

SECTION "SOUND_PUBLIC", ROM0

init_sound::
    ld a, 0
    ld [rTAC], a

    ld a, AUDVOL_VIN_LEFT | VOLUME_LEFT << 4 | \
          AUDVOL_VIN_RIGHT | VOLUME_RIGHT
    ld [rAUDVOL], a

    ld a, AUDTERM_1_LEFT | AUDTERM_2_LEFT | AUDTERM_3_LEFT | AUDTERM_4_LEFT | \
          AUDTERM_1_RIGHT | AUDTERM_2_RIGHT | AUDTERM_3_RIGHT | AUDTERM_4_RIGHT
    ld [rAUDTERM], a

    ld a, AUDENA_ON
    ld [rAUDENA], a

    ld a, 0
    ld [ENABLED], a

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

play_next_eighth:
    ld a, [ENABLED]
    or a
    ret z

    push bc
    push de

    ld a, [CURRENT]
    ld l, a
    ld a, [CURRENT + 1]
    ld h, a
    ld a, [REMAINING]
    ld c, a

    ld de, 3

    ld a, [hli]
    or a
    jr z, .skip_aud2
    ld [rAUD2LEN], a
    ld a, [hli]
    ld [rAUD2ENV], a
    ld a, [hli]
    ld [rAUD2LOW], a
    ld a, [hli]
    ld [rAUD2HIGH], a
    jr .aud3

.skip_aud2:
    add hl, de

.aud3:
    ld a, [hli]
    or a
    jr z, .skip_aud3
    ld [rAUD3LEN], a
    ld a, [hli]
    ld [rAUD3LEVEL], a
    ld a, [hli]
    ld [rAUD3LOW], a
    ld a, [hli]
    ld [rAUD3HIGH], a
    ld a, $80
    ld [rAUD3ENA], a
    jr .aud4

.skip_aud3:
    add hl, de

.aud4:
    ld a, [hli]
    or a
    jr z, .skip_aud4
    ld [rAUD4LEN], a
    ld a, [hli]
    ld [rAUD4ENV], a
    ld a, [hli]
    ld [rAUD4POLY], a
    ld a, [hli]
    ld [rAUD4GO], a
    jr .remaining

.skip_aud4:
    add hl, de

.remaining:
    ld a, [REMAINING]
    ld e, a
    ld a, [REMAINING + 1]
    ld d, a
    dec de
    ld a, e
    or d
    ld [REMAINING], a
    ld a, d
    ld [REMAINING + 1], a
    jr nz, .more

    ld a, [START]
    ld [CURRENT], a
    ld a, [START + 1]
    ld [CURRENT + 1], a
    ld a, [LENGTH]
    ld [REMAINING], a
    ld a, [LENGTH + 1]
    ld [REMAINING + 1], a
    jr .exit

.more:
    ld a, l
    ld [CURRENT], a
    ld a, h
    ld [CURRENT + 1], a

.exit
    pop de
    pop bc
    ret

next_tick::
    push af
    push hl
    ld hl, CURRENT_TICK
    dec [hl]
    jr nz, .exit
    ld a, [TICKS]
    ld [CURRENT_TICK], a
    call play_next_eighth
.exit:
    pop hl
    pop af
    reti


; bc - pointer
; de - length
; h - timer divider
; l - ticks
init_song::
    ld a, 0
    ld [ENABLED], a

    ld a, c
    ld [START], a
    ld [CURRENT], a
    ld a, b
    ld [START + 1], a
    ld [CURRENT + 1], a
    ld a, e
    ld [LENGTH], a
    ld [REMAINING], a
    ld a, d
    ld [LENGTH + 1], a
    ld [REMAINING + 1], a

    ld a, 1
    ld [ENABLED], a

    ld a, h
    ld [rTMA], a

    ld a, l
    ld [TICKS], a
    ld [CURRENT_TICK], a

    ld a, TACF_START | TACF_4KHZ
    ld [rTAC], a

    ret

load_custom_wave::
    ld hl, _AUD3WAVERAM
    ld bc, $10
    jp copy_memory
