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

_007e:  cpx $2140
        bne $007e
        ldx #$0000
        lda $c40014
        sta $2142
        lda $c40015
        sta $2143
        lda #$cc
        sta $2141
        sta $2140
        cmp $2140
        bne $009c
        lda #$00
        xba
        lda $C40009,x
        sta $14
        lda $C40009,x
        sta $15
        lda #$c4
        sta $16
        ldy #$0000
        lda [$14],y
        clc
        adc #$02
        sta $10
        iny
        lda [$14],y
        adc #$00
        sta $11
        iny
        lda [$14],y
        sta $2141
        xba
        sta $2140
        cmp $2140
        bne $00cf    ; infinite loop?
        inc a
        xba
        iny
        cpy $10
        bne $00c6
        xba
        inc a
        inc a
        inc a
        bne $00e2
        inx
        inx
        cpx #$000c
        beq $0106
        xba
        lda $c40014,x
        sta $2142
        lda $c40015,x
        sta $2143
        xba
        sta $2141
        sta $2140
        cmp $2140
        bne $00ff    ; infinite loop?
        bra $00a1
        ldy #$0200
        sty $2142
        xba
        lda #$00
        sta $2141
        xba
        sta $2140
        cmp $2140
        bne $0116    ; infinite loop?
        xba
        sta $2140
        ldx #$0100
        sta $1cff,x
        dex
        bne $0122
        lda #$ff
        sta $05
        longa
        lda $c41e3f   ; $010e at that address
        clc
        adc #$4800    ; 490e is the result
        sta $f8
        sta $48
        ldx #$0800
        dex
        bne $013d
        sep #$20
        lda #$00
        sta $fa
        lda #$c4
        sta $fb
        bra $017d
_014c:  phb
        phd
        php
        longa
        longi
        pha
        phx
        phy
        sep #$20
        lda #$00
        pha
        plb
        ldx #$1d00
        phx
        pld
_0161:  sep #$20
        lda $00
        stz $00
        beq $017d
        bmi $0177
        cmp #$03
        beq $0188
        cmp #$70
        bcs $017a
        jmp _0589

; ---------------------------------------------------------------------------

_0589:  rtl

; ---------------------------------------------------------------------------
