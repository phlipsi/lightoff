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
SONG: DS 2
PATTERN_COUNT: DS 1
LINES_COUNT: DS 1

CURRENT_TICK: DS 1

CURRENT_PATTERN: DS 2
REMAINING_PATTERNS: DS 1

CURRENT_LINE: DS 1
REMAINING_LINES: DS 1

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

play_eye::
    ld a, $15
    ld [rAUD1SWEEP], a
    ld a, $80
    ld [rAUD1LEN], a
    ld a, $f2
    ld [rAUD1ENV], a
    ld a, $00
    ld [rAUD1LOW], a
    ld a, $81
    ld [rAUD1HIGH], a

    ret

play_door::
    ld a, $15
    ld [rAUD1SWEEP], a
    ld a, $00
    ld [rAUD1LEN], a
    ld a, $f7
    ld [rAUD1ENV], a
    ld a, $f3
    ld [rAUD1LOW], a
    ld a, $c2
    ld [rAUD1HIGH], a

    ret

play_pattern_ch2:
    ld a, d
    or e
    ret z

    push hl
    ld h, d
    ld l, e
    ld d, 0
    ld a, [CURRENT_LINE]
    sla a
    sla a
    ld e, a
    add hl, de

    ld a, [hli]
    or a
    jr z, .skip
    ld [rAUD2LEN], a
    ld a, [hli]
    ld [rAUD2ENV], a
    ld a, [hli]
    ld [rAUD2LOW], a
    ld a, [hli]
    ld [rAUD2HIGH], a

.skip:
    pop hl
    ret

play_pattern_ch3:
    ld a, d
    or e
    ret z

    push hl
    ld h, d
    ld l, e
    ld d, 0
    ld a, [CURRENT_LINE]
    sla a
    sla a
    ld e, a
    add hl, de

    ld a, [hli]
    or a
    jr z, .skip
    ld [rAUD3LEN], a
    ld a, [hli]
    ld [rAUD3LEVEL], a
    ld a, [hli]
    ld [rAUD3LOW], a
    ld a, [hli]
    ld [rAUD3HIGH], a
    ld a, $80
    ld [rAUD3ENA], a

.skip:
    pop hl
    ret

play_pattern_ch4:
    ld a, d
    or e
    ret z

    push hl
    ld h, d
    ld l, e
    ld d, 0
    ld a, [CURRENT_LINE]
    sla a
    sla a
    ld e, a
    add hl, de

    ld a, [hli]
    or a
    jr z, .skip
    ld [rAUD4LEN], a
    ld a, [hli]
    ld [rAUD4ENV], a
    ld a, [hli]
    ld [rAUD4POLY], a
    ld a, [hli]
    ld [rAUD4GO], a

.skip:
    pop hl
    ret

play_next_line:
    ld a, [ENABLED]
    or a
    ret z

    push bc
    push de

    ld a, [CURRENT_PATTERN]
    ld l, a
    ld a, [CURRENT_PATTERN + 1]
    ld h, a

    ld a, [hli]
    ld e, a
    ld a, [hli]
    ld d, a
    call play_pattern_ch2

    ld a, [hli]
    ld e, a
    ld a, [hli]
    ld d, a
    call play_pattern_ch3

    ld a, [hli]
    ld e, a
    ld a, [hli]
    ld d, a
    call play_pattern_ch4


    ld a, [CURRENT_LINE]
    inc a
    ld [CURRENT_LINE], a

    ld a, [REMAINING_LINES]
    dec a
    ld [REMAINING_LINES], a
    or a
    jr nz, .exit
    ; lines in pattern exhausted
    ld a, [LINES_COUNT]
    ld [REMAINING_LINES], a
    ld a, 0
    ld [CURRENT_LINE], a

    ; goto to next pattern
    ld a, l
    ld [CURRENT_PATTERN], a
    ld a, h
    ld [CURRENT_PATTERN + 1], a

    ld a, [REMAINING_PATTERNS]
    dec a
    ld [REMAINING_PATTERNS], a
    or 0
    jr nz, .exit
    ; patterns exhausted
    ld a, [PATTERN_COUNT]
    ld [REMAINING_PATTERNS], a

    ld a, [SONG]
    ld [CURRENT_PATTERN], a
    ld a, [SONG + 1]
    ld [CURRENT_PATTERN + 1], a

.exit:
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
    call play_next_line
.exit:
    pop hl
    pop af
    reti

; bc - song pointer
; d  - number of patterns
; e  - length of patterns
; h - timer divider
; l - ticks
init_song::
    ld a, 0
    ld [ENABLED], a

    ld a, c
    ld [SONG], a
    ld [CURRENT_PATTERN], a
    ld a, b
    ld [SONG + 1], a
    ld [CURRENT_PATTERN + 1], a

    ld a, d
    ld [PATTERN_COUNT], a
    ld [REMAINING_PATTERNS], a

    ld a, e
    ld [LINES_COUNT], a
    ld [REMAINING_LINES], a

    ld a, 0
    ld [CURRENT_LINE], a

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
