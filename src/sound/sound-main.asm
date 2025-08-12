; +-------------------------------------------------------------------------+
; |                                                                         |
; |                             FINAL FANTASY V                             |
; |                                                                         |
; +-------------------------------------------------------------------------+
; | file: sound/sound-main.s                                                |
; |                                                                         |
; | description: sound/music main source file                               |
; +-------------------------------------------------------------------------+

.p816

.include "macros.inc"
.include "hardware.inc"
.include "const.inc"

.export InitSound_ext, ExecSound_ext

; ---------------------------------------------------------------------------

.segment "sound_code"

; ---------------------------------------------------------------------------

.proc InitSound_ext

_0000:  jmp     _002c
        nop

.endproc

; ---------------------------------------------------------------------------

.proc ExecSound_ext

_0004:  jmp     _014c
        nop

.endproc

; ---------------------------------------------------------------------------

_002c:  phb
        phd
        php
        longa
        longi
        pha
        phx
        phy
        shorta
        lda #$00
        pha
        plb
        ldx #$1d00
        phx
        pld
        ldx #$bbaa
        ldy #$0800
        cpx $2140
        beq $007e
        dey
        bne $0047
        ldy $f8
        beq $007e
        cpy $48
        bne $007e
        lda #$f0
        cmp $00
        bne $007e
        lda #$08
        sta $2141
        lda #$00
        sta $2140
        ldy #$00f8
        sta $1cff,x
        dex
        bne $006a
        ldy $f8
        sty $48
        dec a
        sta $05
        lda #$f0
        sta $00
        jmp _0161

; ---------------------------------------------------------------------------

_014c:  rtl
_0161:  rtl

; ---------------------------------------------------------------------------
