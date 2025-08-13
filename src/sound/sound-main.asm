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
@0047:  cpx $2140
        beq _007e
        dey
        bne _0047
        ldy $f8
        beq _007e
        cpy $48
        bne _007e
        lda #$f0
        cmp $00
        bne _007e
        lda #$08
        sta $2141
        lda #$00
        sta $2140
        ldy #$00f8
@006a:  sta $1cff,x
        dex
        bne @006a
        ldy $f8
        sty $48
        dec a
        sta $05
        lda #$f0
        sta $00
        jmp _0161

; ---------------------------------------------------------------------------

_007e:  cpx $2140
        bne _007e
        ldx #$0000
        lda $c40014
        sta $2142
        lda $c40015
        sta $2143
        lda #$cc
        sta $2141
        sta $2140
@009c:  cmp $2140
        bne @009c
@00a1:  lda #$00
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
@00c6:  lda [$14],y
        sta $2141
        xba
        sta $2140
@00cf:  cmp $2140
        bne @00cf    ; infinite loop?
        inc a
        xba
        iny
        cpy $10
        bne @00c6
        xba
        inc a
        inc a
        inc a
        bne @00e2
@00e2:  inx
        inx
        cpx #$000c
        beq @0106
        xba
        lda $c40014,x
        sta $2142
        lda $c40015,x
        sta $2143
        xba
        sta $2141
        sta $2140
@00ff:  cmp $2140
        bne @00ff    ; infinite loop?
        bra @00a1
@0106:  ldy #$0200
        sty $2142
        xba
        lda #$00
        sta $2141
        xba
        sta $2140
@0116:  cmp $2140
        bne @0116    ; infinite loop?
        xba
        sta $2140
        ldx #$0100
@0122:  sta $1cff,x
        dex
        bne @0122
        lda #$ff
        sta $05
        longa
        lda $c41e3f   ; $010e at that address
        clc
        adc #$4800    ; 490e is the result
        sta $f8
        sta $48
        ldx #$0800
@013d:  dex
        bne @013d
        sep #$20
        lda #$00
        sta $fa
        lda #$c4
        sta $fb
        bra _017d
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
        beq _017d
        bmi @0177
        cmp #$03
        beq _0188
        cmp #$70
        bcs _017a
@0177:  jmp _0589

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
        bne _01d4
        ldx $02
        stx $06
        txa
        and #$0f
        sta $2141
        lda #$84
@019d:  cmp $2140
        beq @019d    ; infinite loop?
        sta $2140
@01a5:  cmp $2140
        bne @01a5    ; infinite loop?
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
@01c0:  cmp $2140
        beq @01c0    ; infinite loop?
        sta $2140
@01c8:  cmp $2140
        bne @01c8    ; infinite loop?
        xba
        sta $2140
        jmp _017d

; ---------------------------------------------------------------------------

_01d4:  jsr _05e0
        lda $05
        bmi @01e1
        sta $09
        ldx $06
        stx $0a
@01e1:  lda $01
        sta $2141
        sta $05
        ldx $02
        stx $2142
        stx $06
        xba
@01f0:  cmp $2140
        beq @01f0    ; infinite loop?
        sta $2140
@01f8:  cmp $2140
        bne @01f8    ; infinite loop?
        lda #$02
        sta $2141
        ldx #$1c00
        stx $2142
        sta $2140
@020b:  cmp $2140
        bne @020b    ; infinite loop?
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
        bne @0242
        inc $16
@0242:  lda [$14],y
        pha
        iny
        bne @024a
@024a:  xba
        pha
        plx
        lda #$05
        xba
@0250:  lda [$14],y
        sta $2142
        iny
        bne @025a
@025a:  lda [$14],y
        sta $2143
        iny
        bne @0264
@0264:  xba
        sta $2140
@0268:  cmp $2140
        bne @0268
        inc a
        bne @0271
        inc a
@0271:  xba
        dex
        dex
        bpl @0250
        inc a
        longa
        ldx #$0000
@027b:  stz $88,x
        stz $c8,x
        inx
        inx
        cpx #$0020
        bne @027b
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
@029f:  lda $c43daa,x
        sta ($14)
        inc $14
        inc $14
        ldy #$0000
@02ac:  cmp $1d28,y
        beq @02c0
        iny
        iny
        cpy #$0020
        bne @02ac
        sta ($16)
        inc $16
        inc $16
        bra @02c3
@02c3:  inx
        inx
        cpx $12
        bne @029f
@02c0:  sta $1d88,y
        lda $c8
        bne _02d0
        jmp _04ac

; ---------------------------------------------------------------------------

_02d0:  stz $17
        sep #$20
        ldx #$0000
@02d7:  lda $c8,x
        beq @031c
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
        bne @0311
        inc $16
@0311:  lda [$14],y
        adc $18
        sta $18
        plx
        inx
        inx
        bra @02d7
@031c:  ldx #$0000
        longa
        lda $28,x
        clc
        adc $17
        bcs _0338
        cmp #$d200
        bcs _0338
        jmp _03ea

; ---------------------------------------------------------------------------

_0338:  ldx #$001e
@033b:  lda $86,x
        bne @0343
        dex
        dex
        bne @033b
@0343:  stx $24
        ldx #$0000
@0348:  lda $88,x
        beq @0353
        inx
        inx
        cpx #$0020
        bne @0348
@0353:  cpx $24
        bne @0363
@0363:  sep #$20
        lda #$07
        sta $2141
        stz $10
        ldy #$0000
        longa
@0371:  lda $1d88,y
        beq _037e
@0376:  iny
        iny
        cpy $24
        bne @0371

; ---------------------------------------------------------------------------

_037e:  tyx
        bra _0385

; ---------------------------------------------------------------------------

_0385:  inx
        inx
        cpx $24
        bne @0381
@0381:  lda $88,x
        bne @038d

; ---------------------------------------------------------------------------

_038b:  bra _03e0
@038d:  stz $28,x
        stz $88,x
        sta $1d28,y
        lda $48,x
        sta $2142
        sep #$20
        lda $10
        sta $2140
@03a0:  cmp $2140
        bne @03a0
        inc $10
        longa
        lda $1d48,y
        sta $2142
        srp #$20
        lda $10
        sta $2140
@03b6   cmp $2140
        bne @03b6
        inc $10
        longa
        lda $68,x
        sta $2142
        sta $1d68,y
        clc
        adc $1d48,y
        sta $1d4a,y
        sep #$20
        lda $10
        sta $2140
@03d5   cmp $2140
        bne @03d5
        inc $10
        longa
        bra @0376

; ---------------------------------------------------------------------------

_03e0:  tyx
@03e1:  stz $28,x
        inx
        inx
        cpx #$0020
        bne @03e1

; ---------------------------------------------------------------------------

_03ea:  sep #$20
        lda #$03
        sta $2141
        ldx #$0000
@03f4:  lda $28,x
        beq @03fc
        inx
        inx
        bra @03f4
@03fc:  stx $24
        lda $48,x
        sta $2142
        lda $49,x
        sta $2143
        lda #$00
        sta $2140
@040d:  cmp $2140
        bne @040d
        inc a
        sta $10
        ldx #$0000
@0418:  sep #$20
        lda $c8,x
        bne _0421
        jmp @04ac

; ---------------------------------------------------------------------------

_0421:  ldy $24
        sta $1d28,y
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
        tax
        sep #$20
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
        xba
        iny
        bne @0458
@0458:  lda [$14],y
        iny
        bne @045f
@045f:  xba
        longa
        pha
        ldx $24
        sta $68,x
        clc
        adc $48,x
        sta $4a,x
        inx
        inx
        stx $24
        plx
        sep #$20
@0473:  lda [$14],y
        sta $2141
        iny
        bne @047d
@047d:  lda [$14],y
        sta $2142
        iny
        bne @0487
@0487:  lda [$14],y
        sta $2143
        iny
        bne @0491
        inc $16
@0491:  lda $10
        sta $2140
@0496:  cmp $2140
        bne @0496
        inc $10
        bne @04a1
        inc $10
@04a1:  dex
        dex
        dex
        bne @0473
        plx
        inx
        inx
        bel @0418
@04ac:  longa
        lda $a8
        bne _04b5
        jmp @057c

; ---------------------------------------------------------------------------

_04b5:  lda #$1da8
        sta $14
        lda #$1e00
        sta $16
        lda #$1e40
        sta $18
        lda #$1ec0
        sta $1a
@04c9:  lda ($14)
        beq @050a
        inc $14
        inc $14
        ldy #$0000
@04d4:  cmp $1d28,y
        beq @04dd
        iny
        iny
        bra @04d4
@04dd:  dec a
        asl a
        tax
        lda $c43d1e,x
        sta ($16)
        inc $16
        inc $16
        lda $1d48,y
        sta ($18)
        inc $18
        inc $18
        clc
        adc $c43cd8,x
        sta ($18)
        inc $18
        inc $18
        lda $c43d64,x  ; ADSR data?
        sta ($1a)
        inc $1a
        inc $1a
        bra @04c9
@050a:  sep #$20
        lda #$20
        sta $2141
        ldx #$1e00
        phx
        pld
        ldx #$1a40
        stx $2142
        lda #$00
        ldx #$fffe
        bra @0528
@0528:  sta $2140
@052b:  cmp $2140
        bne @052b
        inc a
        inx
        inx
        cpx #$0040
        bne @0523
@0523:  ldy $00,x
        sty $2142
        ldx #$1b80
        stx $2142
        lda #$00
        ldx #$fffe
        bra @054a
@054a:  sta $2140
@054d:  cmp $2140
        bne @054d
        inc a
        inx
        inx
        cpx #$0080
        bne @0545
@0545:  ldy $40,x
        sty $2142
        ldx #$1ac0
        stx $2142
        lda #$00
        ldx #$fffe
        bra @056c
@056c:  sta $2140
@056f:  cmp $2140
        bne @056f
        inc a
        inx
        inx
        cpx #$0040
        bne @0567
@0567:  ldy $c0,x
        sty $2142
@057c:  sep #$20
        lda #$00
        sta $2141
        sta $2140
        jmp _017d

; ---------------------------------------------------------------------------

_0589:  sep #$20
        xba
        lda $03
        sta $2143
        lda $02
        sta $2142
        lda $01
        sta $2141
        xba
@059c:  cmp $2140
        beq @059c
        sta $2140
        cmp #$f0
        bcc $05bc
        cmp #$f2
        bcs $05bc
        xba
        lda $05
        bmi $05b7
        sta $09
        ldx $06
        stx $0a
        lda #$ff
        sta $05
        xba
@05bc:  cmp $2140
        bne @05bc
        lda #$00
        sta $2140
        jmp _017d

; ---------------------------------------------------------------------------

_05c9:  longa
        and #$000f
        asl a
        asl a
        tax
        lda $c40603,x
        sta $02
        lda $c40601,x
        sta $00
        jmp _0161

; ---------------------------------------------------------------------------

_05e0:  php
        sep #$20
        xba
        cmp #$03
        beq @05fe
        ldx #$0000
@05eb:  lda $c40641,x
        bmi @05fc
        cmp $01
        beq @05f8
        inx
        bra @05eb
@05f8:  lda #$03
        bra @05fe
@05fc:  lda #$01
@05fe:  xba
        plp
        rts

; ---------------------------------------------------------------------------
