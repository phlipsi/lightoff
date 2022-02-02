include "hardware.inc"

section "PLAYER_PRIVATE", wram0

PLAYER_X:: DS 2
PLAYER_Y:: DS 2
PLAYER_VX:: DS 2
PLAYER_VY:: DS 2
PLAYER_AY: DS 2
PLAYER_STANDING: DS 1
PLAYER_GOT_KEY: DS 1
PLAYER_ANIMATION: DS 1

def PLAYER_GRAVITY equ $0040
def PLAYER_FRICTION equ $0020
def PLAYER_JUMP_STRENGTH equ -$0500
def MAX_PLAYER_VY equ $0800
def MAX_PLAYER_VX equ $0170

def INIT_PLAYER_X equ $6000
def INIT_PLAYER_Y equ $0f00

def INIT_PLAYER_VX equ 0 ;+32
def INIT_PLAYER_VY equ 0

def PLAYER_FOUND_NOTHING equ 0
def PLAYER_FOUND_DOOR    equ 1
def PLAYER_FOUND_EYE     equ 2

export PLAYER_FOUND_NOTHING, PLAYER_FOUND_DOOR, PLAYER_FOUND_EYE

section "PLAYER", rom0

; b - x coordinate
; c - y coordinate
init_player::
    ld hl, PLAYER_X
    ld [hl], 0
    ld hl, PLAYER_X + 1
    ld [hl], b

    ld hl, PLAYER_Y
    ld [hl], 0
    ld hl, PLAYER_Y + 1
    ld [hl], c

    ld hl, PLAYER_VX
    ld [hl], low(INIT_PLAYER_VX)
    ld hl, PLAYER_VX + 1
    ld [hl], high(INIT_PLAYER_VX)

    ld hl, PLAYER_VY
    ld [hl], low(INIT_PLAYER_VY)
    ld hl, PLAYER_VY + 1
    ld [hl], high(INIT_PLAYER_VY)

    ld hl, PLAYER_AY
    ld [hl], low(PLAYER_GRAVITY)
    ld hl, PLAYER_AY + 1
    ld [hl], high(PLAYER_GRAVITY)

    ld hl, PLAYER_STANDING
    ld [hl], 0

    ld hl, PLAYER_GOT_KEY
    ld [hl], 0

    ld a, 0
    ld [PLAYER_ANIMATION], a
    ; ld hl, PLAYER_AX
    ; ld [hl], 0
    ; ld hl, PLAYER_AX + 1
    ; ld [hl], 0

    ret

draw_player::
    ld hl, PLAYER_X + 1
    ld b, [hl]
    ld hl, PLAYER_Y + 1
    ld c, [hl]
    call relative_to_camera

    ld a, [PLAYER_VX]
    or 0
    jr z, .still
    ld d, 4
    bit 7, a
    jr nz, .right
    ld e, OAMF_XFLIP
    jr .animation
.right
    ld e, 0
    jr .animation
.still:
    ld e, 0
    ld d, 0
.animation
    ld a, [PLAYER_ANIMATION]
    srl a
    srl a
    srl a
    and %00000010
    add a, d
    ld d, a
    ld hl, _OAMRAM
    ld a, c
    ld [hli], a
    ld a, b
    bit 5, e
    jr z, .normal1
    add a, 8
.normal1
    ld [hli], a
    ld a, d
    ld [hli], a
    ld a, e
    ld [hli], a

    ld a, c
    ld [hli], a
    ld a, b
    bit 5, e
    jr nz, .normal2
    add a, 8
.normal2
    ld [hli], a
    ld a, d
    inc a
    ld [hli], a
    ld a, e
    ld [hli], a

    ld a, c
    add a, 8
    ld [hli], a
    ld a, b
    bit 5, e
    jr z, .normal3
    add a, 8
.normal3
    ld [hli], a
    ld a, d
    add a, $10
    ld [hli], a
    ld a, e
    ld [hli], a

    ld a, c
    add a, 8
    ld [hli], a
    ld a, b
    bit 5, e
    jr nz, .normal4
    add a, 8
.normal4
    ld [hli], a
    ld a, d
    add a, $11
    ld [hli], a
    ld a, e
    ld [hli], a

    ret

apply_friction:
    ld a, [PLAYER_VX + 1]
    ld h, a
    ld a, [PLAYER_VX]
    ld l, a
    bit 7, h
    jr nz, .negative
    ; positive vx
    ld a, l
    sub low(PLAYER_FRICTION)
    ld l, a
    ld a, h
    sbc high(PLAYER_FRICTION)
    ld h, a
    bit 7, h
    jr z, .store
    ; vx was positive, now negativ --> vx = 0!
    ld hl, 0
    jr .store

.negative:
    ; vx = -vx (two's complement)
    ld a, h
    cpl
    ld h, a
    ld a, l
    cpl
    ld l, a
    inc hl

    ld a, l
    sub low(PLAYER_FRICTION)
    ld l, a
    ld a, h
    sbc high(PLAYER_FRICTION)
    ld h, a
    bit 7, a
    jr z, .store_negative
    ld hl, 0
    jr .store

.store_negative:
    ; vx = -vx
    ld a, h
    cpl
    ld h, a
    ld a, l
    cpl
    ld l, a
    inc hl

.store:
    ld a, h
    ld [PLAYER_VX + 1], a
    ld a, l
    ld [PLAYER_VX], a
    ret

; bc - speed increase
player_walk::
    ld a, [PLAYER_VX + 1]
    ld h, a
    ld a, [PLAYER_VX]
    ld l, a
    add hl, bc

    ; apply max speed constraint
    ld a, h
    bit 7, a
    jr nz, .negative
    ld a, l
    sub low(MAX_PLAYER_VX)
    ld a, h
    sbc high(MAX_PLAYER_VX)
    jr c, .store
    ld hl, MAX_PLAYER_VX
    jr .store

.negative:
    ld a, h
    cpl
    ld h, a
    ld a, l
    cpl
    ld l, a
    inc hl

    ld a, l
    sub low(MAX_PLAYER_VX)
    ld a, h
    sbc high(MAX_PLAYER_VX)
    jr c, .store_negative
    ld hl, MAX_PLAYER_VX
    jr .store_negative

.store_negative:
    ld a, h
    cpl
    ld h, a
    ld a, l
    cpl
    ld l, a
    inc hl

.store:
    ld a, h
    ld [PLAYER_VX + 1], a
    ld a, l
    ld [PLAYER_VX], a

    ret

player_jump::
    ld a, [PLAYER_STANDING]
    or a
    ret z

    ld a, [PLAYER_VY + 1]
    ld h, a
    ld a, [PLAYER_VY]
    ld l, a
    ld bc, PLAYER_JUMP_STRENGTH
    add hl, bc

    ld a, h
    ld [PLAYER_VY + 1], a
    ld a, l
    ld [PLAYER_VY], a

    ld a, 0
    ld [PLAYER_STANDING], a

    call play_jump
    ret

apply_vx_to_x:
    ld a, [PLAYER_X + 1]
    ld h, a
    ld a, [PLAYER_X]
    ld l, a
    ld a, [PLAYER_VX + 1]
    ld b, a
    ld a, [PLAYER_VX]
    ld c, a
    add hl, bc

    ld a, h
    cp 8
    jr nc, .check_overflow
    ld h, 8
    ld l, 0
    jr .store

.check_overflow:
    cp 255-8
    jr c, .store
    ld h, 255-8
    ld l, 0

.store:
    ld a, h
    ld [PLAYER_X + 1], a
    ld a, l
    ld [PLAYER_X], a

    ret

apply_ay_to_vy:
    ; apply acceleration to speed
    ld a, [PLAYER_VY + 1]
    ld h, a
    ld a, [PLAYER_VY]
    ld l, a
    ld a, [PLAYER_AY + 1]
    ld b, a
    ld a, [PLAYER_AY]
    ld c, a
    add hl, bc

    ; apply max speed constraint
    ld a, h
    bit 7, a
    jr nz, .negative
    ld a, l
    sub low(MAX_PLAYER_VY)
    ld a, h
    sbc high(MAX_PLAYER_VY)
    jr c, .store
    ld hl, MAX_PLAYER_VY
    jr .store

.negative:
    ld a, h
    cpl
    ld h, a
    ld a, l
    cpl
    ld l, a
    inc hl

    ld a, l
    sub low(MAX_PLAYER_VY)
    ld a, h
    sbc high(MAX_PLAYER_VY)

    jr c, .store_negative
    ld hl, MAX_PLAYER_VY
    jr .store_negative

.store_negative:
    ld a, h
    cpl
    ld h, a
    ld a, l
    cpl
    ld l, a
    inc hl

.store:
    ld a, h
    ld [PLAYER_VY + 1], a
    ld a, l
    ld [PLAYER_VY], a

    ret

apply_vy_to_y:
    ld a, [PLAYER_Y + 1]
    ld h, a
    ld a, [PLAYER_Y]
    ld l, a
    ld a, [PLAYER_VY + 1]
    ld b, a
    ld a, [PLAYER_VY]
    ld c, a
    add hl, bc

    ld a, h
    sub $10
    jr nc, .store
    ld hl, $1000
    ld a, 0
    ld [PLAYER_VY + 1], a
    ld [PLAYER_VY], a
.store:
    ld a, h
    ld [PLAYER_Y + 1], a
    ld a, l
    ld [PLAYER_Y], a

    ret

move_player::
    ld a, [PLAYER_ANIMATION]
    inc a
    ld [PLAYER_ANIMATION], a

    call apply_friction
    call apply_vx_to_x

    call apply_ay_to_vy
    call apply_vy_to_y

    ld a, [PLAYER_X + 1]
    ld b, a
    ld a, [PLAYER_Y + 1]
    ld c, a
    call get_block_offset_at_position
    ld de, SCREEN
    add hl, de
    ld a, [hl]
    and %00001000
    jr z, .check_left
    ; something is underneath player
    ld a, c
    ld [PLAYER_Y + 1], a
    ld a, 0
    ld [PLAYER_Y], a
    ld a, 0
    ld [PLAYER_VY + 1], a
    ld [PLAYER_VY], a
    ld a, [PLAYER_STANDING]
    or a
    jr nz, .check_left
    ld a, 1
    ld [PLAYER_STANDING], a
    call play_step

.check_left:
    ld de, $ffdf
    add hl, de
    ld a, [hl]
    bit 7, a
    jr z, .check_right
    ld a, b
    add $8
    ld [PLAYER_X + 1], a
    ld a, 0
    ld [PLAYER_X], a
    ld a, 0
    ld [PLAYER_VX + 1], a
    ld [PLAYER_VX], a
    jr .check_top

.check_right:
    ld de, $0002
    add hl, de
    ld a, [hl]
    bit 7, a
    jr z, .check_top
    ld a, b
    ld [PLAYER_X + 1], a
    ld a, 0
    ld [PLAYER_X], a
    ld a, 0
    ld [PLAYER_VX + 1], a
    ld [PLAYER_VX], a

.check_top:
    ld de, $ffdf
    add hl, de
    ld a, [hl]
    bit 7, a
    jr z, .check_key
    ld a, c
    add $8
    ld [PLAYER_Y + 1], a
    ld a, 0
    ld [PLAYER_Y], a
    ld a, 0
    ld [PLAYER_VY + 1], a
    ld [PLAYER_VY], a

    ld a, [hl]
    cp $99
    jr z, .got_eye
    cp $98
    jr z, .got_eye
    jr .check_key
.got_eye:
    call play_eye
    ld a, PLAYER_FOUND_EYE
    ret

.check_key:
    ld a, [PLAYER_GOT_KEY]
    or a
    jr z, .collect_key
    ld hl, PLAYER_X + 1
    ld a, [hl]
    ld [KEY_X], a
    ld hl, PLAYER_Y + 1
    ld a, [hl]
    sub a, $a
    ld [KEY_Y], a

    ld a, [PLAYER_Y + 1]
    add a, $8
    ld hl, DOOR_Y
    cp [hl]
    jr c, .exit
    ld a, [PLAYER_Y + 1]
    sub a, $8
    cp [hl]
    jr nc, .exit

    ld a, [PLAYER_X + 1]
    add a, $8
    ld hl, DOOR_X
    cp [hl]
    jr c, .exit
    ld a, [PLAYER_X + 1]
    sub a, $8
    cp [hl]
    jr nc, .exit

    call play_door
    ld a, PLAYER_FOUND_DOOR
    ret

.collect_key:
    ld a, [PLAYER_Y + 1]
    add a, $8
    ld hl, KEY_Y
    cp [hl]
    jr c, .exit
    ld a, [PLAYER_Y + 1]
    sub a, $8
    cp [hl]
    jr nc, .exit

    ld a, [PLAYER_X + 1]
    add a, $8
    ld hl, KEY_X
    cp [hl]
    jr c, .exit
    ld a, [PLAYER_X + 1]
    sub a, $8
    cp [hl]
    jr nc, .exit

    call play_got_key
    ld a, 1
    ld [PLAYER_GOT_KEY], a

.exit:
    ld a, PLAYER_FOUND_NOTHING
    ret

move_camera_to_player::
    ld a, [PLAYER_X + 1]
    ld b, a
    ld a, [PLAYER_Y + 1]
    ld c, a
    jp move_camera_to
