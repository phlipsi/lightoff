SECTION "UTILS", ROM0

; de = source
; hl = destination
; bc = size
copy_memory::
    ld a, [de]
    ld [hli], a
    inc de
    dec bc
    ld a, b
    or c
    jr nz, copy_memory
    ret

; hl = destination
; d = value
; bc = size
fill_memory::
    ld a, d
    ld [hli], a
    dec bc
    ld a, b
    or c
    jr nz, fill_memory
    ret
