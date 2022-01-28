include "hardware.inc"

section "PLAYER_PRIVATE", wram0

PLAYER_X: DS 2
PLAYER_Y: DS 2
PLAYER_VX: DS 2
PLAYER_VY: DS 2
PLAYER_AY: DS 2

def PLAYER_GRAVITY equ $0020
def MAX_PLAYER_VY equ $0700

def INIT_PLAYER_X equ $5800
def INIT_PLAYER_Y equ $0f00

def INIT_PLAYER_VX equ -32
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

move_player::
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

    ld a, [PLAYER_VY + 1]
    ld h, a
    ld a, [PLAYER_VY]
    ld l, a
    ld a, [PLAYER_AY + 1]
    ld b, a
    ld a, [PLAYER_AY]
    ld c, a
    add hl, bc
    ld a, h
    cp high(MAX_PLAYER_VY)
    jr c, .store_vy ; c --> h < high(MAX_PLAYER_VY)
    ; h >= high(MAX_PLAYER_VY)
    jr nz, .reset_vy ; nz --> h > high(MAX_PLAYER_VY)
    ; h == high(MAX_PLAYER_VY)
    ld a, l
    cp low(MAX_PLAYER_VY) ; c --> l < low(MAX_PLAYER_VY)
    jr c, .store_vy
    ; l >= low(MAX_PLAYER_VY)
.reset_vy:
    ld h, high(MAX_PLAYER_VY)
    ld l, low(MAX_PLAYER_VY)
.store_vy:
    ld a, h
    ld [PLAYER_VY + 1], a
    ld a, l
    ld [PLAYER_VY], a

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
    ld [PLAYER_Y + 1], a
    ld a, l
    ld [PLAYER_Y], a

    ld a, [PLAYER_X + 1]
    ld b, a
    ld a, [PLAYER_Y + 1]
    ld c, a
    ;call relative_to_level
    call get_block_at_position
    or a
    jr z, .exit
    ; something is underneath player
    ;ld a, b
    ;ld [PLAYER_X + 1], a
    ;ld a, 0
    ;ld [PLAYER_X], a
    ld a, c
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
