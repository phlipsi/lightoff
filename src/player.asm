include "hardware.inc"

section "PLAYER_PRIVATE", wram0

PLAYER_X: DS 2
PLAYER_Y: DS 2
PLAYER_VX:: DS 2
PLAYER_VY:: DS 2
PLAYER_AY: DS 2
PLAYER_STANDING: DS 1

def PLAYER_GRAVITY equ $0040
def PLAYER_FRICTION equ $0020
def PLAYER_JUMP_STRENGTH equ -$0600
def MAX_PLAYER_VY equ $0800
def MAX_PLAYER_VX equ $0170

def INIT_PLAYER_X equ $6000
def INIT_PLAYER_Y equ $0f00

def INIT_PLAYER_VX equ 0 ;+32
def INIT_PLAYER_VY equ 0

section "PLAYER", rom0

; b - x coordinate
; c - y coordinate
init_player::
    ld hl, PLAYER_X
    ld [hl], low(INIT_PLAYER_X)
    ld hl, PLAYER_X + 1
    ld [hl], high(INIT_PLAYER_X)

    ld hl, PLAYER_Y
    ld [hl], low(INIT_PLAYER_Y)
    ld hl, PLAYER_Y + 1
    ld [hl], high(INIT_PLAYER_Y)

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

    ld hl, _OAMRAM
    ld a, c
    ld [hli], a
    ld a, b
    ld [hli], a
    ld a, $e0
    ld [hli], a
    ld a, 0
    ld [hli], a

    ld a, c
    ld [hli], a
    ld a, b
    add a, 8
    ld [hli], a
    ld a, $e1
    ld [hli], a
    ld a, 0
    ld [hli], a

    ld a, c
    add a, 8
    ld [hli], a
    ld a, b
    ld [hli], a
    ld a, $f0
    ld [hli], a
    ld a, 0
    ld [hli], a

    ld a, c
    add a, 8
    ld [hli], a
    ld a, b
    add a, 8
    ld [hli], a
    ld a, $f1
    ld [hli], a
    ld a, 0
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
    or a
    jr z, .check_left
    ; something is underneath player
    ld a, c
    ld [PLAYER_Y + 1], a
    ld a, 0
    ld [PLAYER_Y], a
    ld a, 0
    ld [PLAYER_VY + 1], a
    ld [PLAYER_VY], a
    ld a, 1
    ld [PLAYER_STANDING], a

.check_left:
    ld de, $ffdf
    add hl, de
    ld a, [hl]
    or a
    jr z, .check_right
    ld a, b
    add $8
    ld [PLAYER_X + 1], a
    ld a, 0
    ld [PLAYER_X], a
    ld a, 0
    ld [PLAYER_VX + 1], a
    ld [PLAYER_VX], a
    jr .exit

.check_right:
    ld de, $0002
    add hl, de
    ld a, [hl]
    or a
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
    or a
    jr z, .exit
    ld a, c
    add $8
    ld [PLAYER_Y + 1], a
    ld a, 0
    ld [PLAYER_Y], a
    ld a, 0
    ld [PLAYER_VY + 1], a
    ld [PLAYER_VY], a

.exit:
    ret

move_camera_to_player::
    ld a, [PLAYER_X + 1]
    ld b, a
    ld a, [PLAYER_Y + 1]
    ld c, a
    jp move_camera_to
