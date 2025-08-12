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

_017a:  jmp _05c9

; ---------------------------------------------------------------------------

_017d:  longa
        longi
        ply
        plx
        pla
        plp
        pld
        plb
        rtl

; ---------------------------------------------------------------------------

_0188:  longa
        xba
        lda $01
        cmp $05
        bne $01d4
        ldx $02
        stx $06
        txa
        and #$0f
        sta $2141
        lda #$84
        cmp $2140
        beq $019d    ; infinite loop?
        sta $2140
        cmp $2140
        bne $01a5    ; infinite loop?
        lda #$00
        sta $2140
        xba
        txa
        and #$f0
        sta $02
        lda $03
        and #$0f
        ora $02
        sta $2141
        lda #$81
        cmp $2140
        beq $01c0    ; infinite loop?
        sta $2140
        cmp $2140
        bne $01c8    ; infinite loop?
        xba
        sta $2140
        jmp _017d

; ---------------------------------------------------------------------------

_01d4:  jsr _05e0
        lda $05
        bmi $01e1
        sta $09
        ldx $06
        stx $0a
        lda $01
        sta $2141
        sta $05
        ldx $02
        stx $2142
        stx $06
        xba
        cmp $2140
        beq $01f0    ; infinite loop?
        sta $2140
        cmp $2140
        bne $01f8    ; infinite loop?
        lda #$02
        sta $2141
        ldx #$1c00
        stx $2142
        sta $2140
        cmp $2140
        bne $020b    ; infinite loop?
        rep #$20
        lda $05
        and #$00ff
        pha
        asl a
        sta $e8
        pla
        clc
        adc $e8
        tax
        longa
        lda $c43b97,x ; SPC pointer, low byte
        sta $14
        lda $c43b98,x ; SPC pointer, middle byte
        sta $15
        lda $c43b99,x ; SPC pointer, high byte
        sta $16
        ldy $14
        stz $14
        stz $15
        lda [$14],y
        xba
        iny
        bne $0242
        inc $16
        lda [$14],y
        pha
        iny
        bne $024a
        xba
        pha
        plx
        lda #$05
        xba
        lda [$14],y
        sta $2142
        iny
        bne $025a
        lda [$14],y
        sta $2143
        iny
        bne $0264
        xba
        sta $2140
        cmp $2140
        bne $0268
        inc a
        bne $0271
        inc a
        xba
        dex
        dex
        bpl $0250
        inc a
        longa
        ldx #$0000
        stz $88,x
        stz $c8,x
        inx
        inx
        cpx #$0020
        bne $027b
        lda $04
        and #$ff00
        lsr a
        lsr a
        lsr a
        tax
        clc
        adc #$0020
        sta $12
        lda #$1da8
        sta $14
        lda #$1dc8
        sta $16
        lda $c43daa,x
        sta ($14)
        inc $14
        inc $14
        ldy #$0000
        cmp $1d28,y
        beq $02c0
        iny
        iny
        cpy #$0020
        bne $02ac
        sta ($16)
        inc $16
        inc $16
        bra $02c3
        inx
        inx
        cpx $12
        bne $029f
        sta $1d88,y
        lda $c8
        bne $02d0
        jmp _04ac

; ---------------------------------------------------------------------------

_02d0:  stz $17
        sep #$20
        ldx #$0000
        lda $c8,x
        beq $031c
        phx
        dec a
        longa
        and #$00ff
        pha
        asl a
        sta $e8
        pla
        clc
        adc $e8
        tax sep #$20
        lda $c43c6f,x  ; pointer, low byte
        sta $14
        lda $c43c70,x  ; pointer, middle byte
        sta $15
        lda $c43c71,x  ; pointer, high byte
        sta $16
        ldy $14
        stz $14
        stz $15
        lda [$14],y
        clc
        adc $17
        sta $17
        iny
        bne $0311
        inc $16
        lda [$14],y
        adc $18
        sta $18
        plx
        inx
        inx
        bra $02D7
        ldx #$0000
        longa
        lda $28,x
        clc
        adc $17
        bcs $0338
        cmp #$d200
        bcs $0338
        jmp _03ea

; ---------------------------------------------------------------------------

_0338:  ldx #$001e
        lda $86,x
        bne $0343
        dex
        dex
        bne $033b
        stx $24
        ldx #$0000
        lda $88,x
        beq $0353
        inx
        inx
        cpx #$0020
        bne $0348
        cpx $24
        bne $0363
        sep #$20
        lda #$07
        sta $2141
        stz $10
        ldy #$0000
        longa
        lda $1d88,y
        beq $037e
        iny
        iny
        cpy $24
        bne $0371

; ---------------------------------------------------------------------------

_037e:  tyx
        bra _0385

; ---------------------------------------------------------------------------

_0385:  inx
        inx
        cpx $24
        bne $0381
        lda $88,x
        bne $038d

; ---------------------------------------------------------------------------

_03ea:  rtl

; ---------------------------------------------------------------------------

_04ac:  rtl

; ---------------------------------------------------------------------------

_0589:  rtl

; ---------------------------------------------------------------------------

_05c9:  rtl

; ---------------------------------------------------------------------------

_05e0:  rtl

; ---------------------------------------------------------------------------
