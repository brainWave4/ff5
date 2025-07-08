; +-------------------------------------------------------------------------+
; |                                                                         |
; |                             FINAL FANTASY V                             |
; |                                                                         |
; +-------------------------------------------------------------------------+
; | file: btlgfx/btlgfx-main.asm                                            |
; |                                                                         |
; | description: battle graphics routines                                   |
; +-------------------------------------------------------------------------+

.p816

.include "macros.inc"
.include "hardware.inc"
.include "const.inc"

.export ExecBtlGfx_ext

.import ExecSound_ext

; ---------------------------------------------------------------------------

.segment "battle_gfx_code"

.a8
.i16

; ---------------------------------------------------------------------------

.proc ExecBtlGfx_ext
_0000:  jmp     ExecBtlGfx
.endproc

; ---------------------------------------------------------------------------

.proc _c10003
_0003:  jmp     $f75f
.endproc

; ---------------------------------------------------------------------------

.proc _c10006
_0006:  jmp     $e999
.endproc

; ---------------------------------------------------------------------------

.proc _c10009
_0009:  jmp     _c1003f
.endproc

; ---------------------------------------------------------------------------

; [ execute graphics function ]

.proc ExecBtlGfx
@000c:  asl
        tax
        lda     f:ExecBtlGfxTbl,x
        sta     $7a
        lda     f:ExecBtlGfxTbl+1,x
        sta     $7b
        jsr     @001e
        rtl
@001e:  jmp     ($007a)
.endproc  ; ExecBtlGfx

; ---------------------------------------------------------------------------

ExecBtlGfxTbl:
@0021:  .addr   $39f9, $3a55, $0348, _c102e0, _c102df, $422b, _c101e4, $768d
        .addr   $75d7, _c10208, $8189, _c1010b, _c100f2, _c100c6, _c10092

; ---------------------------------------------------------------------------

; [ swap character saved cursor positions ]

; called from menu

_c1003f:
        phx
        phy
        phb
        lda     #$00
        pha
        plb
        lda     #$00
        xba
        lda     #$2d
        sta     f:$000070
@004f:  lda     a:$0000
        tax
        lda     a:$0001
        tay
        lda     $042d,x
        pha
        lda     $042d,y
        sta     $042d,x
        pla
        sta     $042d,y
        inx4
        iny4
        lda     f:$000070
        dec
        sta     f:$000070
        bne     @004f
        lda     a:$0000
        tax
        lda     a:$0001
        tay
        lda     $0420,x
        pha
        lda     $0420,y
        sta     $0420,x
        pla
        sta     $0420,y
        plb
        ply
        plx
        rtl

; ---------------------------------------------------------------------------

; [ battle graphics function $0e: fade out ]

_c10092:
        jsr     _c1081c       ; update saved cursor checksums
        lda     $09c4
        and     #$01
        bne     @00a7       ; branch if defeated
        ldx     $04f0
        cpx     #$01ef
        bne     @00a7       ; branch if battle $01ef
        jsr     $73ec       ;
@00a7:  jsr     _c102f2       ; wait one frame
        jsr     _c102f2       ; wait one frame
        lda     $bc7f
        and     #$0f
        beq     @00b9
        dec     $bc7f       ; decrement screen brightness
        bra     @00a7
@00b9:  lda     #$fc        ; disable reflect sound effect r/l
        sta     $1d00
        stz     $1d01
        jsl     ExecSound_ext
        rts

; ---------------------------------------------------------------------------

; [ battle graphics function $0d:  ]

_c100c6:
        inc     $dbbb
        clr_ax
@00cb:  txa
        asl2
        tay
        lda     $7b7e,y
        and     #$c0
        bne     @00e8
        tya
        asl3
        tay
        lda     #$06
        sta     $cf4d,y
        sta     $cf58,y
        lda     #$0f
        sta     $cf4f,y
@00e8:  inc     $d1cb,x
        inx
        cpx     #$0004
        bne     @00cb
        rts

; ---------------------------------------------------------------------------

; [ battle graphics function $0c:  ]

_c100f2:
        ldx     #$3bcc      ; attack parameters
        stx     $eb
        ldx     #$384c      ; battle graphics script
        stx     $e7
        lda     #$01
        sta     $3bcf
        ldy     #$0003
        lda     #$09
        sta     ($e7),y
        jmp     $979e

; ---------------------------------------------------------------------------

; [ battle graphics function $0b:  ]

_c1010b:
        clr_ay
@010d:  lda     $d0aa,y
        jsr     $fc74
        and     $de
        bne     @011d
        iny
        cpy     #$0008
        bne     @010d
@011d:  lda     $d0aa,y
        tay
        lda     $d00e,y
        sta     $72
        stz     $70
        clr_ay
@012a:  tya
        jsr     $fc74
        sta     $74
        and     $de
        beq     @0145
        lda     $d00e,y
        clc
        adc     $cffe,y
        cmp     $72
        bcc     @0145
        lda     $74
        ora     $70
        sta     $70
@0145:  iny
        cpy     #$0008
        bne     @012a
        rts

; ---------------------------------------------------------------------------

; [  ]

_c1014c:
        phx
        stz     $d116
        stz     $d117
        jsr     _c101f6
        plx
        rts

; ---------------------------------------------------------------------------

; [  ]

_c10158:
        ldx     $e9
        phx
        jsr     _c1016c
        plx
        longa
        txa
        clc
        adc     #$0018
        sta     $e9
        shorta0
        rts

; ---------------------------------------------------------------------------

; [  ]

_c1016c:
@016c:  clr_ax
@016e:  ldy     #$0001
        lda     ($e9),y
        cmp     #$ff
        bne     @0184
        ldy     $e9
        iny2
        sty     $e9
        inx
        cpx     #$000c
        bne     @016e
        rts
@0184:  lda     ($e9),y
        bmi     @018c
        lda     #$31
        bra     @018e
@018c:  lda     #$35
@018e:  sta     $d124
        lda     ($e9),y
        and     #$40
        beq     @01ae
        lda     #$c4
        sta     $d132
        inc
        sta     $d133
        lda     #$ff
        sta     $d130
        sta     $d131
        lda     #$80
        sta     $72
        bra     @01b8
@01ae:  phx
        ldx     #$0000
        jsr     _c102ab
        plx
        stz     $72
@01b8:  phx
        ldx     #$0000
        jsr     _c10276
        plx
        lda     $d066,x
        eor     $f6
        sec
        sbc     $70
        sta     $d160
        lda     $d072,x
        sec
        sbc     #$08
        sta     $d16c
        lda     #$01
        ora     $72
        sta     $d118
        stz     $d178
        lda     #$01
        sta     $d116
        rts

; ---------------------------------------------------------------------------

; [ battle graphics function $06:  ]

_c101e4:
        lda     $cd3a
        cmp     #$0b
        bne     @01f5
        lda     $cf
        jeq     $3cc7
        jmp     $3cca
@01f5:  rts

; ---------------------------------------------------------------------------

; [ load damage numerals palette ]

_c101f6:
@01f6:  lda     #$05
        ldy     #$0140
        jmp     $aa1d       ; load attack palette (8-colors)

; ---------------------------------------------------------------------------

; [ show damage numerals (not poison/regen) ]

_c101fe:
@01fe:  lda     $d114       ; wait for previous damage numerals
        beq     _c1020d
        jsr     _c102f2       ; wait one frame
        bra     @01fe

; ---------------------------------------------------------------------------

; [ battle graphics function $09: show damage numerals (poison/regen) ]

_c10208:
        ldx     #$3a4c
        stx     $e9
; fallthrough

; ---------------------------------------------------------------------------

; [ show damage numerals ]

_c1020d:
@020d:  stz     $d114
        jsr     _c101f6       ; load damage numerals palette
        clr_ax
@0215:  ldy     #$0001
        lda     ($e9),y     ; damage value
        cmp     #$ff
        beq     @0260       ; branch if no damage for this object
        lda     ($e9),y
        bmi     @0226
        lda     #$31
        bra     @0228
@0226:  lda     #$35
@0228:  sta     $d124,x
        lda     ($e9),y
        and     #$40
        beq     @023a
        jsr     _c10293
        lda     #$80        ; numerals move in unison
        sta     $72
        bra     @023f
@023a:  jsr     _c102ab
        stz     $72
@023f:  jsr     _c10276       ; get x offset
        lda     $d066,x     ; object x position
        eor     $f6
        sec
        sbc     $70         ; subtract x offset
        sta     $d160,x     ; x position
        lda     $d072,x     ; object y position
        sec
        sbc     #$08
        sta     $d16c,x     ; y position
        lda     #$01        ; enable damage numerals
        ora     $72
        sta     $d118,x
        stz     $d178,x     ; clear frame counter
@0260:  ldy     $e9         ; next object
        iny2
        sty     $e9
        inx
        cpx     #$000c
        bne     @0215
        lda     #$01
        sta     $d114
        rts

; ---------------------------------------------------------------------------

; damage numerals x offsets (0, 1, 2, or 3 digits)
_c10272:
        .byte   $10,$14,$18,$1c

; ---------------------------------------------------------------------------

; [ get damage numerals x offset ]

_c10276:
@0276:  phx
        txa
        asl2
        tay
        clr_ax
@027d:  lda     $d130,y
        cmp     #$ff
        bne     @028b
        iny
        inx
        cpx     #$0003
        bne     @027d
@028b:  lda     $c10272,x
        sta     $70
        plx
        rts

; ---------------------------------------------------------------------------

_c10293:
@0293:  phx
        txa
        asl2
        tay
        lda     #$c4
        sta     $d132,y
        inc
        sta     $d133,y
        lda     #$ff
        sta     $d130,y
        sta     $d131,y
        plx
        rts

; ---------------------------------------------------------------------------

; [  ]

_c102ab:
@02ab:  phx
        lda     $ce
        pha
        lda     #$c6
        sta     $ce
        longa
        clr_ay
        lda     ($e9),y
        and     #$3fff
        tax
        shorta0
        jsr     $ff2e
        jsr     $ff12
        pla
        sta     $ce
        plx
        phx
        txa
        asl2
        tay
        clr_ax
@02d1:  lda     $c4,x
        sta     $d130,y
        iny
        inx
        cpx     #$0004
        bne     @02d1
        plx
        rts

; ---------------------------------------------------------------------------

; [ battle graphics function $04: no effect ]

_c102df:
        rts

; ---------------------------------------------------------------------------

; [ battle graphics function $03: wait one frame ]

_c102e0:
        jsr     $fd1d       ; wait for vblank
        jsr     $3a6e
        jsr     $aef6
        jsr     $ad64
        jsr     $ad2d
        jmp     $37ef

; ---------------------------------------------------------------------------

; [ wait one frame ]

_c102f2:
@02f2:  jsr     $fd1d       ; wait for vblank
        jsr     $3a6e
        jsr     $ad2d
        jmp     $37ef

; ---------------------------------------------------------------------------

; [  ]

_c102fe:
@02fe:  lda     $df
        sta     $74
        clr_ayx
@0305:  asl     $74
        bcc     @033d
        lda     $7b7e,y
        and     #$c0
        bne     @033d
        lda     $db4a,x
        beq     @0319
        lda     #$20
        bra     @031b
@0319:  lda     #$30
@031b:  sta     $70
        phx
        txa
        asl
        asl
        asl
        asl
        asl
        tax
        lda     $70
        sta     $cf54,x
        lda     #$02
        sta     $cf4d,x
        lda     #$01
        sta     $cf53,x
        stz     $cf55,x
        lda     #$f8
        sta     $cf45,x
        plx
@033d:  inx
        iny
        iny
        iny
        iny
        cpy     #$0010
        bne     @0305
        rts

; ---------------------------------------------------------------------------

; [ battle graphics function $02: init battle graphics ]

_c10348:
        longi
        shorta
        jsr     _c10888       ; init hardware registers
        jsr     _c104c9       ; init ram
        stz     $f9a1
        lda     #$70
        sta     $dbbd
        sta     $dbbe
        lda     #$01
        sta     $dbbc
        lda     $3eef
        and     #$0f
        cmp     #$04
        bne     @0380
        lda     #$01
        sta     $f9a1
        lda     $bc84
        ora     #$01
        sta     $bc84
        jsr     $886b
        lda     #$bf
        sta     $bc86
@0380:  ldx     #$0100
        stx     $bc77
        stx     $bc79
        lda     #$1f
        sta     f:$00212c
        sta     f:$00212e
@0393:  lda     f:$004210
        bpl     @0393
        jsr     $fcdc
        lda     #$81
        sta     f:$004200
        cli
        jmp     $8736       ; do monster entry

; ---------------------------------------------------------------------------

; [ update song tempo multiplier ]

_c103a6:
@03a6:  lda     $7c94
        cmp     #$02
        bne     @03ef
        ldx     #$0007
        longa
        lda     $7c95
        cmp     #$012c      ; 300
        bcc     @03df
        dex
        cmp     #$0258      ; 600
        bcc     @03df
        dex
        cmp     #$04b0      ; 1200
        bcc     @03df
        dex
        cmp     #$0708      ; 1800
        bcc     @03df
        dex
        cmp     #$0960      ; 2400
        bcc     @03df
        dex
        cmp     #$0bb8      ; 3000
        bcc     @03df
        dex
        cmp     #$0e10      ; 3600
        bcc     @03df
        dex
@03df:  shorta0
        txa
        sta     $1d01
        lda     #$87        ; set tempo multiplier (song only)
        sta     $1d00
        jsl     ExecSound_ext
@03ef:  rts

; ---------------------------------------------------------------------------

; [ update reflect sfx l/r ]

_c103f0:
@03f0:  lda     $f6
        beq     @0400
        lda     #$fc        ; reflect sound l/r
        sta     $1d00
        sta     $1d01
        jsl     ExecSound_ext
@0400:  rts

; ---------------------------------------------------------------------------

; [  ]

_c10401:
@0401:  clr_ax
        longa
        lda     #$0800
        sta     $70
@040a:  lda     $70
        sta     $a009,x
        sta     $a209,x
        sta     $a00b,x
        sta     $a20b,x
        sec
        sbc     #$0040
        sta     $70
        txa
        and     #$0007
        bne     @0442
        lda     $70
        bpl     @0436
        asl     $a009,x
        asl     $a209,x
        asl     $a00b,x
        asl     $a20b,x
        bra     @0442
@0436:  lsr     $a009,x
        lsr     $a209,x
        lsr     $a00b,x
        lsr     $a20b,x
@0442:  inx
        inx
        inx
        inx
        cpx     #$0100
        bne     @040a
@044b:  lda     $70
        clc
        adc     #$0040
        sta     $70
        sta     $a009,x
        sta     $a209,x
        sta     $a00b,x
        sta     $a20b,x
        txa
        and     #$0007
        bne     @0483
        lda     $70
        bpl     @0477
        asl     $a009,x
        asl     $a209,x
        asl     $a00b,x
        asl     $a20b,x
        bra     @0483
@0477:  lsr     $a009,x
        lsr     $a209,x
        lsr     $a00b,x
        lsr     $a20b,x
@0483:  inx
        inx
        inx
        inx
        cpx     #$0200
        bne     @044b
        shorta0
        rts

; ---------------------------------------------------------------------------

_c10490:
@0490:  rts

; ---------------------------------------------------------------------------

_c10491:
        clr_ax
        lda     #$ff
@0495:  sta     $b455,x
        inx
        cpx     #$0020
        bne     @0495
@049e:  sta     $b455,x
        dec
        inx
        cpx     #$0040
        bne     @049e
        lda     #$e0
@04aa:  sta     $b455,x
        inx
        cpx     #$00a0
        bne     @04aa
@04b3:  sta     $b455,x
        inc
        inx
        cpx     #$00c0
        bne     @04b3
        lda     #$ff
@04bf:  sta     $b455,x
        inx
        cpx     #$00e0
        bne     @04bf
        rts

; ---------------------------------------------------------------------------

; [ init ram ]

_c104c9:
@04c9:  stz     $fefa
        stz     $ff2e
        stz     $ff2f
        stz     $ff31
        ldx     #$8009
        jsr     _c10aea
        jsr     _c10490
        lda     #$80
        sta     $010c
        lda     $0970       ; get window/short setting
        and     #$80
        sta     $0426
        lda     $0970       ; get message speed
        lsr4
        and     #$07
        sta     $0424
        lda     $0973       ; get gauge setting
        and     #$80
        eor     #$80
        sta     $0425       ; get reset/memory setting
        lda     $0973
        and     #$04
        lsr2
        ora     $0426
        sta     $0426
        jsr     $fce9
        lda     #$09        ; mode 1
        sta     $bc81
        lda     #$01
        sta     $bc83
        lda     #$0f
        sta     $bc7f
        stz     $bc80
        stz     $ff2b
        ldx     #$5800
        ldy     #$1000
        jsr     $fdbb
        ldx     #$1000
        ldy     #$2000
        jsr     $fdbb
        ldx     #$4800
        ldy     #$2000
        jsr     $fdbb
        ldx     #$4000
        ldy     #$0200
        jsr     $fdbb
        ldx     #$0000
        ldy     #$0020
        jsr     $fdbb
        stz     $ee56
        stz     $ff33
        lda     #$13
        sta     $dbc1
        sta     $dbc2
        sta     $dbc3
        lda     #$ff
        sta     $dbe1
        sta     $dbe2
        lda     $3eef
        and     #$20
        beq     @0578
        lda     #$3f
        sta     $dbe1
@0578:  lda     #$82
        sta     $bc9e
        ldx     $04f0
        cpx     #$01bf
        bne     @058a
        lda     #$1e
        sta     $04f2
@058a:  lda     #$00
        sta     $b3ba
        inc
        sta     $b3bb
        sta     $b3b8
        lda     $3eef
        bpl     @05b7       ; branch if not credits
        lda     #$03
        sta     $b3ba
        inc
        sta     $b3bb
        inc     $dbd3
        ldx     #$0000
        lda     #$ff
@05ac:  sta     $b455,x
        inx
        cpx     #$00e0
        bne     @05ac
        bra     @05c1
@05b7:  lda     $04f2       ; battle bg
        cmp     #$1f
        bne     @05c1       ; branch if not neo exdeath
        inc     $b3bb
@05c1:  jsr     $1482
        lda     $7c19
        beq     @05d8
        lda     #$ff
        sta     $f6
        lda     #$40
        sta     $f7
        lda     #$08
        sta     $f8
        asl
        sta     $f9
@05d8:  jsr     _c103a6       ; update song tempo multiplier
        jsr     _c103f0       ; update reflect sfx l/r
        stz     $ff2c
        stz     $ff2d
        lda     #$04
        sta     $04
        lda     #$53
        sta     $ce
        ldx     #$ffff
        stx     $b444
        stx     $b446
        clr_axy
        stz     $70
@05fa:  lda     $2000,x
        and     #$40
        bne     @0612
        lda     $70
        sta     $b444,y
        iny
        phy
        lda     $70
        tay
        lda     $2000,x
        and     #$07
        bra     @0618
@0612:  phy
        lda     $70
        tay
        lda     #$ff
@0618:  sta     $cfc6,y     ; character id
        lda     $2001,x
        sta     $cfca,y     ; character job
        lda     $2021,x
        sta     $cfce,y     ; character passive abilities
        lda     $dbd3
        bne     @0631
        lda     $2000,x
        bmi     @0634
@0631:  clr_a
        bra     @0636
@0634:  lda     #$01
@0636:  sta     $db4a,y     ; character row
        ply
        inc     $70
        longa
        txa
        clc
        adc     #$0080
        tax
        shorta0
        cpx     #$0200
        bne     @05fa
        ldx     #$0000
@064f:  lda     $382c,x     ; copy damage buffer
        sta     $7cd9,x
        inx
        cpx     #$0020
        bne     @064f
        jsr     $b117
        jsr     $ae49
        ldx     #$0000
@0664:  lda     $4038,x
        sta     $7cf9,x
        inx
        cpx     #$0010
        bne     @0664
        stz     $f8c7
        lda     #$03
        sta     $cd4b
        sta     $cd4f
        sta     $cd53
        sta     $cd57
        lda     #$33
        sta     $cd5b
        sta     $cd5f
        sta     $cd63
        sta     $cd67
        lda     #$e9
        sta     $cd6d
        sta     $cd71
        lda     #$a4
        sta     $cd6e
        lda     #$ca
        sta     $cd72
        jsr     $fd22       ; clear sprite data
        lda     $3ef2
        sta     $de
        ldx     #$0000
@06ac:  lda     $7ba1,x     ; get erased monsters
        asl
        rol     $70
        inx
        inx
        inx
        inx
        cpx     #$0020
        bne     @06ac
        lda     $70
        eor     #$ff
        sta     $70
        lda     $de
        and     $70         ; remove erased monsters
        sta     $de
        jsr     $24e2       ; load character graphics
        ldx     #$2000
        stx     $70
        ldx     #$d000
        ldy     #$6000
        lda     #$7f
        jsr     $fdca       ; copy data to vram
        jsr     $242a
        jsr     $2454
        jsr     $335a       ; load battle bg
        jsr     $3cff
        jsr     $2689
        jsr     $1a57
        lda     #$03
        ldy     #$0000
        jsr     $aa3e       ; load attack palette (16-colors)
        lda     #$01
        ldy     #$0100
        jsr     $aa3e       ; load attack palette (16-colors)
        lda     #$06
        ldy     #$00e0
        jsr     $aa3e       ; load attack palette (16-colors)
        lda     #$08
        ldy     #$0120
        jsr     $aa3e       ; load attack palette (16-colors)
        jsr     _c109a7
        ldx     $0971
        stx     $7e0b
        stx     $7e13
        stx     $7e1b
        stx     $7e23
        ldx     #$5353
        stx     $7c6e
        stx     $7c70
        clr_axy
@072a:  lda     $d97d2d,x
        sta     $f9a2,y
        lda     #$20
        sta     $f9a3,y
        inx
        iny
        iny
        cpy     #$002a
        bne     @072a
        lda     $3efb       ; get monster palettes
        jsr     _c1087f
        sta     $cfd6
        lda     $3efb
        jsr     _c10881
        sta     $cfd7
        lda     $3efb
        jsr     _c10883
        sta     $cfd8
        lda     $3efb
        jsr     _c10885
        sta     $cfd9
        lda     $3efc
        jsr     _c1087f
        sta     $cfda
        lda     $3efc
        jsr     _c10881
        sta     $cfdb
        lda     $3efc
        jsr     _c10883
        sta     $cfdc
        lda     $3efc
        jsr     _c10885
        sta     $cfdd
        jsr     $20c4       ; load monster graphics
        jsr     $2202
        lda     $de
        sta     $70
        jsr     $2068       ; load monster palettes
        ldx     #$0000
@0796:  phx
        clr_a
        sta     $7e
        txa
        jsr     $7b02
        plx
        inx
        cpx     #$0008
        bne     @0796
        ldx     #$0000
@07a8:  lda     $4000,x     ; monster x position
        lsr
        lsr
        lsr
        lsr
        and     #$0f
        sta     $d00e,x
        lda     $4000,x     ; monster y position
        and     #$0f
        sta     $d016,x
        inx
        cpx     #$0008
        bne     @07a8
        jsr     $1ceb
        jsr     $1d48
        stz     $dbbb
        jsr     $2607       ; load character palettes
        jsr     $1b65
        jsr     $1b0d
        jsr     $6d5c
        jsr     $aef6
        jsr     _c102fe
        jsr     _c10401
        lda     $0426
        cmp     $0427
        beq     @07fd       ; branch if command/cursor setting didn't change
        jsr     _c10871       ; clear saved cursor positions
        lda     $0426
        sta     $0427
        clc
        adc     $0427
        inc
        eor     #$ff
        sta     $0428       ; update command/cursor checksum
        bra     @0812
@07fd:  lda     $0426
        clc
        adc     $0427
        inc
        eor     #$ff
        cmp     $0428
        beq     @0812       ; branch if command/cursor checksum is valid
        sta     $0428
        jsr     _c10871       ; clear saved cursor positions
@0812:  jsr     _c1082c       ; validate saved cursor checksums
        lda     $0426
        sta     $0427
        rts

; ---------------------------------------------------------------------------

; [ update saved cursor checksums ]

_c1081c:
@081c:  ldx     #$0000
@081f:  jsr     _c1085a
        sta     $0420,x
        inx
        cpx     #$0004
        bne     @081f
        rts

; ---------------------------------------------------------------------------

; [ validate saved cursor checksums ]

_c1082c:
@082c:  ldx     #$0000
@082f:  jsr     _c1085a
        cmp     $0420,x
        beq     @0840
        jsr     _c10847
        jsr     _c1085a
        sta     $0420,x
@0840:  inx
        cpx     #$0004
        bne     @082f
        rts

; ---------------------------------------------------------------------------

; [ reset saved cursor positions ]

_c10847:
@0847:  phx
        lda     #$2d
        sta     $70
        clr_a
@084d:  sta     $042d,x
        inx4
        dec     $70
        bne     @084d
        plx
        rts

; ---------------------------------------------------------------------------

; [ calculate saved cursor checksum ]

_c1085a:
@085a:  phx
        lda     #$2d
        sta     $70
        clr_a
@0860:  clc
        adc     $042d,x     ; add saved positions for each character
        inx4
        dec     $70
        bne     @0860
        inc
        eor     #$ff        ; increment and invert bits
        plx
        rts

; ---------------------------------------------------------------------------

; [ clear saved cursor positions ]

_c10871:
@0871:  ldx     #$042d
        clr_a
@0875:  sta     a:$0000,x
        inx
        cpx     #$04e1
        bne     @0875
        rts

; ---------------------------------------------------------------------------

; [ get monster palette ]

_c1087f:
        lsr2
_c10881:
        lsr2
_c10883:
        lsr2
_c10885:
        and     #$03
        rts

; ---------------------------------------------------------------------------

; [ init hardware registers ]

_c10888:
@0888:  lda     #$00
        pha
        plb
        sta     $4200
        ldx     #$0000
        phx
        pld
        lda     #$80
        sta     $2100
        lda     $213f
        lda     #$02        ; mode 2
        sta     $2105
        ldx     #$0300
        stx     $2102
        lda     #$03
        sta     $2101
        lda     #$00
        sta     $210b
        lda     #$44
        sta     $210c
        lda     #$13
        sta     $2108
        lda     #$59
        sta     $2107
        lda     #$4b
        sta     $2109
        lda     #$4b
        sta     $210a
        lda     #$80
        sta     $2115
        lda     #$00
        tax
        sta     $2106
        sta     $210d
        sta     $210d
        sta     $210e
        sta     $210e
        sta     $210f
        sta     $210f
        sta     $2110
        sta     $2110
        sta     $2111
        sta     $2111
        sta     $2112
        sta     $2112
        sta     $2113
        sta     $2113
        sta     $2114
        sta     $2114
        stx     $212a
        sta     $212e
        sta     $212f
        sta     $420b
        sta     $420c
        sta     $2131
        sta     $2133
        sta     $2130
        lda     #$08
        sta     $2126
        sta     $2128
        lda     #$f7
        sta     $2127
        sta     $2129
        lda     #$c1
        sta     $1f03
        ldx     #$19ea      ; c1/19ea (battle nmi)
        stx     $1f01
        lda     #$5c
        sta     $1f00
        sta     $1f04
        lda     #$c1
        sta     $1f07
        ldx     #$19e9      ; c1/19e9 (battle irq)
        stx     $1f05
        lda     #$33
        sta     $2123
        sta     $2124
        sta     $2125
        lda     #$1f
        sta     $212c
        sta     $212e
        lda     #$7e
        pha
        plb
        ldx     #$b3b7      ; clear $b3b7-$dbf5
@0965:  stz     a:$0000,x
        inx
        cpx     #$dbf6
        bne     @0965
        ldx     #$0070      ; clear $0070-$00fa
@0971:  stz     a:$0000,x
        inx
        cpx     #$00fb
        bne     @0971
        clr_ax
@097c:  sta     $7e09,x     ; clear palettes
        inx
        cpx     #$0200
        bne     @097c
        clr_ax
@0987:  sta     $dcf6,x
        inx
        cpx     #$1000
        bne     @0987
        lda     #$ff
        sta     $ff04
        rts

; ---------------------------------------------------------------------------

        pha
        clc
        adc     $ce7b,x
        sta     $ce7b,x
        pla
        clc
        adc     $cebb,x
        sta     $cebb,x
        rts

; ---------------------------------------------------------------------------

_c109a7:
@09a7:  ldx     #$0000
        lda     #$40
@09ac:  stz     $ce7b,x
        sta     $cebb,x
        inx
        cpx     #$0010
        bne     @09ac
        rts

; ---------------------------------------------------------------------------

_c109b9:
        pha
        clc
        adc     $cdfb,x
        sta     $cdfb,x
        pla
        clc
        adc     $ce3b,x
        sta     $ce3b,x
        rts

; ---------------------------------------------------------------------------

_c109ca:
        lda     $cdfb,x
        asl
        sta     $80
        lda     $ce7b,x
        jmp     _c10a00

; ---------------------------------------------------------------------------

_c109d6:
        pha
        lda     $cdfb,x
        asl
        sta     $80
        pla
        clc
        adc     $ce7b,x
        jmp     _c10a00

; ---------------------------------------------------------------------------

_c109e5:
        lda     $ce3b,x
        asl
        sta     $80
        lda     $cebb,x
        jmp     _c10a00

; ---------------------------------------------------------------------------

_c109f1:
        pha
        lda     $ce3b,x
        asl
        sta     $80
        pla
        clc
        adc     $cebb,x
        jmp     _c10a00

; ---------------------------------------------------------------------------

_c10a00:
@0a00:  tax
        lda     $cef600,x   ; sine table
        bpl     @0a1f
        eor     #$ff
        sta     f:$004202
        lda     $80
        sta     f:$004203
        nop4
        lda     f:$004217
        eor     #$ff
        inc
        rts
@0a1f:  sta     f:$004202
        lda     $80
        sta     f:$004203
        nop4
        lda     f:$004217
        rts

; ---------------------------------------------------------------------------

; [  ]

_c10a32:
        tax
        lda     $fa
        bne     @0a53
        lda     $9a
        sta     f:$00211b
        clr_a
        sta     f:$00211b
        lda     $cef600,x   ; sine table
        sta     f:$00211c
        sta     f:$00211c
        lda     f:$002135
        rts
@0a53:  lda     $cef600,x   ; sine table
        bpl     @0a66
        eor     #$ff
        sta     $98
        jsr     $fe4b
        lda     $9d
        eor     #$ff
        inc
        rts
@0a66:  sta     $98
        jsr     $fe4b
        lda     $9d
        rts

; ---------------------------------------------------------------------------

; [  ]

_c10a6e:
        lda     $a6
        sec
        sbc     $a8
        sta     $aa
        lda     #$00
        sbc     #$00
        sta     $ab
        lda     $a7
        sec
        sbc     $a9
        sta     $ac
        lda     #$00
        sbc     #$00
        sta     $ad
        lda     $aa
        eor     $ab
        sec
        sbc     $ab
        sta     $b1
        stz     $b2
        lda     $ac
        eor     $ad
        sec
        sbc     $ad
        sta     $b3
        stz     $b4
        longa
        lda     $b1
        lsr3
        sta     $af
        lda     $b3
        and     #$fff8
        asl2
        clc
        adc     $af
        sta     $b5
        asl
        tax
        lda     $7e8009,x
        sta     $af
        shorta0
        ldx     $b5
        lda     $cefb00,x
        sta     $ae
        lda     $ab
        bmi     @0ade
        lda     $ad
        bmi     @0ad6
        lda     #$80
        clc
        adc     $ae
        sta     $ae
        rts
@0ad6:  lda     #$80
        sec
        sbc     $ae
        sta     $ae
        rts
@0ade:  lda     $ad
        bmi     @0ae9
        lda     #$00
        sec
        sbc     $ae
        sta     $ae
@0ae9:  rts

; ---------------------------------------------------------------------------

; [  ]

_c10aea:
@0aea:  stx     $70
        longa
        clr_ax
@0af0:  clr_a
        sta     $72
        tay
@0af4:  lda     $cef700,x
        and     #$00ff
        clc
        adc     $72
        sta     $72
        sta     ($70),y
        iny2
        inx
        cpy     #$0040
        bne     @0af4
        lda     $70
        clc
        adc     #$0040
        sta     $70
        cpx     #$0400
        bne     @0af0
        shorta0
        rts

; ---------------------------------------------------------------------------

; [  ]

_c10b1b:
@0b1b:  shorta
        lda     $80
        sta     f:$004202
        lda     $7e
        sta     f:$004203
        nop4
        lda     f:$004216
        sta     $82
        lda     f:$004217
        sta     $83
        lda     $80
        sta     f:$004202
        lda     $7f
        sta     f:$004203
        longa
        nop2
        stz     $84
        lda     f:$004216
        clc
        adc     $83
        sta     $83
        asl     $82
        rol     $84
        rts

; ---------------------------------------------------------------------------

; [  ]

_c10b59:
        longa
        and     #$00ff
        asl
        tax
        lda     $cef400,x
        bpl     @0b78
        eor     #$ffff
        sta     $7e
        jsr     _c10b1b
        lda     $84
        eor     #$ffff
        inc
        sta     $84
        bra     @0b7d
@0b78:  sta     $7e
        jsr     _c10b1b
@0b7d:  shorta0
        rts

; ---------------------------------------------------------------------------

; [ play queued song ]

_c10b81:
        lda     $ff04
        cmp     #$ff
        beq     @0ba3
        sta     $1d01
        lda     #$01        ; spc interrupt $01 (play song)
        sta     $1d00
        lda     #$08
        sta     $1d02
        lda     #$0f
        sta     $1d03
        jsl     ExecSound_ext
        lda     #$ff
        sta     $ff04
@0ba3:  rts

; ---------------------------------------------------------------------------

; [ update battle bg hdma ??? ]

_c10ba4:
        stz     $f8c5
        stz     $f8c6
        lda     $db9a
        bne     @0bff
        lda     $ff2f
        beq     @0bbc
        jsr     $fc96       ; generate random number
        and     #$03
        sta     $bc77
@0bbc:  lda     $04f2       ; battle background id
        cmp     #$1f
        bne     @0bd1       ; branch if not neo exdeath
        lda     #$12
        sta     $dbc1
        inc     $f8c5
        inc     $f8c6
        jmp     _c10c5f
@0bd1:  cmp     #$1d
        bne     @0be1       ; branch if not underwater tower of walse
        inc     $f8c5
        jsr     $10f4
        inc     $f8c6
        jmp     _c10fc3
@0be1:  cmp     #$1a
        bne     @0beb       ; branch if not karnak castle interior
        inc     $f8c5
        jmp     $10eb
@0beb:  cmp     #$02
        bne     @0bf5       ; branch if not desert
        inc     $f8c6
        jmp     _c10fd4
@0bf5:  cmp     #$ff
        bne     @0bff
        inc     $f8c6
        jmp     $1015
@0bff:  cmp     #$fe
        bne     @0c09
        inc     $f8c6
        jmp     $105a
@0c09:  lda     $dbd3
        beq     @0c35       ; branch if not credits
        lda     $dbd4
        beq     @0c35
        stz     $dbd4
        phb
        longa
        ldx     #$a009
        ldy     #$a937
        lda     #$037f
        mvn     #$7e,#$7e
        ldx     #$a409
        ldy     #$acb7
        lda     #$037f
        mvn     #$7e,#$7e
        shorta0
        plb
@0c35:  rts

; ---------------------------------------------------------------------------

; neo exdeath battle bg data
_c10c36:
        .lobytes 1,0,1,0,0,1,0,0,0, 1,0,0,0,0,1,0
        .lobytes 0,0,0,0,-1,0,0,0,0,0,1,0,0,0,0,1
        .lobytes 0,0,0,1,0,0,1,0,1

; ---------------------------------------------------------------------------

; [ update neo exdeath battle bg ]

_c10c5f:
@0c5f:  lda     $ff2d
        beq     @0c6e
        lda     $bc9e
        ora     #$01
        sta     $bc9e
        bra     @0c76
@0c6e:  lda     $bc9e
        and     #$fe
        sta     $bc9e
@0c76:  lda     $dbe9
        bne     @0cb1

; $dbe9 = 0
        lda     #$1f
        sta     f:$00212c
        jsr     $fc96       ; generate random number
        and     #$03
        sta     $88
        jsr     $fc96       ; generate random number
        and     #$03
        sta     $8a
        stz     $89
        stz     $8b
        longa
        lda     $dbe7
        clc
        adc     $8a
        sta     $bc79       ; bg1 v-scroll
        lda     $dbe5
        clc
        adc     $88
        clc
        adc     #$0008
        sta     $bc77       ; bg1 h-scroll
        shorta0
        jmp     @0d2a

; $dbe9 = 1
@0cb1:  cmp     #$01
        bne     @0cb6
        rts
@0cb6:  ldx     #$0000
        stx     $88
        stx     $8a
        lda     $dbeb
        beq     @0cd2
        jsr     $fc96       ; generate random number
        and     $dbec
        sta     $88
        jsr     $fc96       ; generate random number
        and     $dbec
        sta     $8a
@0cd2:  lda     #$08
        sta     f:$00211b
        lda     #$00
        sta     f:$00211b
        lda     $dbea
        tax
        lda     $cef600,x   ; sine table
        sta     f:$00211c
        longa
        lda     f:$002135
        clc
        adc     #$0008
        clc
        adc     $88
        sta     $bc77       ; bg1 h-scroll
        shorta0
        lda     #$08
        sta     f:$00211b
        lda     #$00
        sta     f:$00211b
        lda     $dbea
        clc
        adc     #$20
        tax
        lda     $cef600,x   ; sine table
        sta     f:$00211c
        longa
        lda     f:$002135
        clc
        adc     $8a
        sta     $bc79       ; bg1 v-scroll
        shorta0
        inc     $dbea

;
@0d2a:  lda     $ff2c
        beq     @0d45
        lda     $a2
        and     #$01
        beq     @0d45
        jsr     $fc96       ; generate random number
        and     #$07
        sta     $bc77       ; bg1 h-scroll
        jsr     $fc96       ; generate random number
        and     #$07
        sta     $bc79       ; bg1 v-scroll
@0d45:  inc     $dba6
        lda     $dba6
        tax
        lda     $cef600,x   ; sine table
        sta     $8c
        lda     $dbc6
        beq     @0d77
        tax
        dec     $dbc6
        lda     $c10c36,x
        bpl     @0d70

; $ff
        lda     $dbc4
        bmi     @0d6a
        lda     #$ff
        bra     @0d6c
@0d6a:  lda     #$01
@0d6c:  sta     $dbc4
        clr_a
@0d70:  cmp     #$01
        beq     @0d99
        jmp     @0da3
@0d77:  lda     $dbc5
        bne     @0d96
        jsr     $fc96       ; generate random number
        ora     #$80
        sta     $dbc5
        and     #$01
        beq     @0d89
        inc
@0d89:  dec
        cmp     $dbc4
        beq     @0d96
        lda     #$27
        sta     $dbc6
        bra     @0d99
@0d96:  dec     $dbc5
@0d99:  lda     $dba5
        clc
        adc     $dbc4
        sta     $dba5
@0da3:  lda     $dba5
        longa
        asl
        tay
        asl
        sta     $88
        shorta0
        tya
        and     #$02
        bne     @0df8

;
        ldx     #$0000
@0db8:  lda     $a009,y
        sta     f:$00211b
        lda     $a00a,y
        sta     f:$00211b
        lda     $8c
        sta     f:$00211c
        longa
        lda     f:$002135
        and     #$03ff
        sta     $acb7,x
        sta     $acc7,x
        lda     $88
        sta     $acb9,x
        sta     $acc9,x
        iny
        iny
        iny
        iny
        txa
        clc
        adc     #$0020
        tax
        shorta0
        cpx     #$0280
        bne     @0db8
        jmp     @0e90

;
@0df8:  ldx     #$0000
        lda     $a009,y
        sta     f:$00211b
        lda     $a00a,y
        sta     f:$00211b
        lda     $8c
        sta     f:$00211c
        longa
        lda     f:$002135
        and     #$03ff
        sta     $acb7,x     ; bg2 h-scroll hdma data
        lda     $88
        sta     $acb9,x     ; bg2 v-scroll hdma data
        iny
        iny
        txa
        clc
        adc     #$0010
        tax
        shorta0
@0e2b:  lda     $a009,y
        sta     f:$00211b
        lda     $a00a,y
        sta     f:$00211b
        lda     $8c
        sta     f:$00211c
        longa
        lda     f:$002135
        and     #$03ff
        sta     $acb7,x
        sta     $acc7,x
        lda     $88
        sta     $acb9,x
        sta     $acc9,x
        iny4
        txa
        clc
        adc     #$0020
        tax
        shorta0
        cpx     #$0270
        bne     @0e2b
        lda     $a009,y
        sta     f:$00211b
        lda     $a00a,y
        sta     f:$00211b
        lda     $8c
        sta     f:$00211c
        longa
        lda     f:$002135
        and     #$03ff
        sta     $acb7,x
        lda     $88
        sta     $acb9,x
        shorta0

; change bg colors ??? (every 8 frames)
@0e90:  lda     a:$00a2
        and     #$07
        bne     @0f10
        lda     $dbc7
        bne     @0ecf
        lda     #$08
        sta     $dbc7
        jsr     $fc96       ; generate random number
        and     #$07
        sta     $dbc8
        sta     $88
        lsr     $88
        bcc     @0eb7
        lda     $dbc9
        eor     #$01
        sta     $dbc9
@0eb7:  lsr     $88
        bcc     @0ec3
        lda     $dbc9
        eor     #$02
        sta     $dbc9
@0ec3:  lsr     $88
        bcc     @0ecf
        lda     $dbc9
        eor     #$04
        sta     $dbc9
@0ecf:  dec     $dbc7
        lda     $dbc8
        sta     $88
        lsr     $88
        bcc     @0eea
        lda     $dbc9
        and     #$01
        bne     @0ee7
        dec     $bc9b       ; red
        bra     @0eea
@0ee7:  inc     $bc9b
@0eea:  lsr     $88
        bcc     @0efd
        lda     $dbc9
        and     #$02
        bne     @0efa
        dec     $bc9c       ; green
        bra     @0efd
@0efa:  inc     $bc9c
@0efd:  lsr     $88
        bcc     @0f10
        lda     $dbc9
        and     #$04
        bne     @0f0d
        dec     $bc9d       ; blue
        bra     @0f10
@0f0d:  inc     $bc9d
@0f10:  rts

; ---------------------------------------------------------------------------

_c10f11:
        .byte   $02,$0f,$2e,$16,$20,$38,$3c,$3d,$33,$34,$35,$1a,$36,$29,$28,$1f
        .byte   $2a,$3a,$0d,$13,$26,$30,$31,$1b,$2d,$03,$19,$06,$07,$0b,$00,$04
        .byte   $05,$17,$3e,$0c,$01,$0e,$10,$08,$11,$09,$15,$0a,$12,$2f,$27,$25
        .byte   $14,$1e,$22,$32,$2c,$21,$1d,$23,$24,$3b,$1c,$2b,$18,$3f,$37,$39

; ---------------------------------------------------------------------------

; [  ]

_c10f51:
        lda     $dbd0
        beq     @0fc2
        lda     $bc84
        ora     #$01
        sta     $bc84
        lda     $dbd2
        cmp     #$40
        beq     @0f82
        lda     $dbd1
        tax
        lda     $c10f11,x
        inc     $dbd1
        inc     $dbd2
        longa
        asl2
        tax
        lda     $a937,x
        sec
        sbc     #$0008
        sta     $a937,x
@0f82:  longa
        clr_axy
@0f87:  lda     $a937,y
        and     #$07ff
        beq     @0f99
        sec
        sbc     #$0008
        sta     $a937,y
        jmp     @0f9a
@0f99:  inx
@0f9a:  lda     $bc79
        sta     $a939,y
        iny4
        cpy     #$0100
        bne     @0f87
        shorta0
        cpx     #$0040
        bne     @0fc2
        stz     $dbd0
        stz     $b3ba
        inc     $b3b8
        lda     $bc84
        and     #$fe
        sta     $bc84
@0fc2:  rts

; ---------------------------------------------------------------------------

; [ update underwater tower of walse bg ]

_c10fc3:
@0fc3:  lda     $dba5
        clc
        adc     #$02        ; oscillation period is 256/2 = 128 frames
        sta     $dba5
        tax
        clr_ay
        lda     #$06        ; amplitude 6 pixels
        jmp     _c10fe2

; ---------------------------------------------------------------------------

; [ update desert bg ]

_c10fd4:
@0fd4:  lda     $dba5
        clc
        adc     #$02        ; oscillation period is 256/2 = 128 frames
        sta     $dba5
        tax
        clr_ay
        lda     #$03        ; amplitude 3 pixels

_c10fe2:
@0fe2:  sta     f:$00211b
        lda     #$00
        sta     f:$00211b
@0fec:  lda     $cef600,x   ; sine table
        sta     f:$00211c
        sta     f:$00211c
        lda     f:$002135
        sta     $acb9,y     ; bg2 vertical scroll hdma data
        lda     f:$002136
        sta     $acba,y
        txa
        clc
        adc     #$08
        tax
        iny4
        cpy     #$0080
        bne     @0fec
        rts

; ---------------------------------------------------------------------------

; [ update battle bg $ff ??? ]

; maybe this is how the monster and bg fade in/out during the credits ???

_c11015:
        lda     $dba5
        clc
        adc     #$02        ; oscillation period is 256/2 = 128 frames
        sta     $dba5
        tax
        clr_ay
        lda     #$06
        sta     f:$00211b
        lda     #$00
        sta     f:$00211b
@102d:  lda     $cef600,x   ; sine table
        sta     f:$00211c
        sta     f:$00211c
        longa
        lda     f:$002135
        sta     $acb9,y
        sta     $a939,y
        sta     $a9b9,y
        shorta0
        txa
        clc
        adc     #$08
        tax
        iny4
        cpy     #$0080
        bne     @102d
        rts

; ---------------------------------------------------------------------------

; [ update battle bg $fe ??? ]

_c1105a:
        lda     $dba5
        clc
        adc     #$02        ; oscillation period is 256/2 = 128 frames
        sta     $dba5
        tax
        clr_ay
        phx
        jsr     $fc96       ; generate random number
        and     #$03
        sta     $88
        stz     $89
        lda     $dbe7
        sta     f:$00211b
        lda     $dbe8
        sta     f:$00211b
@107e:  lda     $cef600,x   ; sine table
        sta     f:$00211c
        sta     f:$00211c
        longa
        lda     f:$002135
        sta     $acb9,y
        sta     $a939,y
        sta     $a9b9,y
        shorta0
        txa
        clc
        adc     #$08
        tax
        iny4
        cpy     #$0080
        bne     @107e
        plx
        clr_ay
        lda     $dbe5
        sta     f:$00211b
        lda     $dbe6
        sta     f:$00211b
@10bb:  lda     $cef600,x   ; sine table
        sta     f:$00211c
        sta     f:$00211c
        longa
        lda     f:$002135
        clc
        adc     $88
        sta     $acb7,y
        sta     $a937,y
        sta     $a9b7,y
        shorta0
        txa
        clc
        adc     #$08
        tax
        iny4
        cpy     #$0080
        bne     @10bb
        rts

; ---------------------------------------------------------------------------

; [ update karnak castle bg ]

_c110eb:
        lda     $dba5
        clc
        adc     #$04        ; oscillation period is 256/4 = 64 frames
        sta     $dba5
        lda     $dba5
        tax
        clr_ay
        lda     #$03        ; amplitude 3 pixels
        sta     f:$00211b
        lda     #$00
        sta     f:$00211b
@1106:  lda     $cef600,x   ; sine table
        sta     f:$00211c
        sta     f:$00211c
        lda     f:$002135
        sta     $acb7,y     ; bg2 horizontal scroll hdma data
        lda     f:$002136
        sta     $acb8,y
        txa
        clc
        adc     #$08
        tax
        iny4
        cpy     #$0080
        bne     @1106
        rts

; ---------------------------------------------------------------------------

; [  ]

_c1112f:
@112f:  ldx     $04f0
        cpx     #$01d5
        bne     @1185
        clr_axy
        stz     $7c87
@113d:  lda     $cf43,y
        bne     @117a
        lda     $cf45,y
        cmp     #$60
        bcc     @1164
        inc     $dba7,x
        lda     $dba7,x
        and     #$07
        bne     @117a
        lda     $dbaf,x
        beq     @117a
        dec     $dbaf,x
        lda     $cf45,y
        dec
        sta     $cf45,y
        bra     @117a
@1164:  lda     $cf43,y
        sta     $88
        lda     $cf58,y
        ora     $88
        bne     @117a
        txa
        jsr     $fc74
        ora     $7c87
        sta     $7c87
@117a:  inx
        tya
        clc
        adc     #$20
        tay
        cpy     #$0080
        bne     @113d
@1185:  rts

; ---------------------------------------------------------------------------

; [  ]

_c11186:
@1186:  lda     $cd3a
        asl
        tax
        lda     $c1119b,x
        sta     $88
        lda     $c1119c,x
        sta     $89
        jmp     ($0088)
        rts

_c1119b:
        .addr   $119a, $4986, $49c4, $4a86, $4b22, $11e4, $53ce, $5c88
        .addr   $5ba3, $119a, $53ce, $55d0, $4759, $4735, $11d3, $51a5
        .addr   $51e9, $11c5, $4d80, $4cef, $fd07

; ---------------------------------------------------------------------------

_c111c5:
        lda     $cd39
        bne     @11d2
        lda     #$1a
        sta     $cd39
        jmp     $fd07
@11d2:  rts

_c111d3:
        stz     $41b0
        stz     $41b7
        stz     $cd41
        lda     #$ff
        sta     $cd42
        jmp     $fd07

_c111e4:
        lda     $cd38
        ora     $cd39
        ora     $bc65
        bne     @11f4
        lda     #$14
        sta     $cd3a
@11f4:  rts

; ---------------------------------------------------------------------------

; [ update bg scroll/mosaic registers ]

_c111f5:
@11f5:  lda     $bc77
        sta     f:$00210d     ; bg scroll registers
        lda     $bc78
        sta     f:$00210d
        lda     $bc79
        sta     f:$00210e
        lda     $bc7a
        sta     f:$00210e
        lda     $bc7b
        sta     f:$00210f
        lda     $bc7c
        sta     f:$00210f
        lda     $bc7d
        sta     f:$002110
        lda     $bc7e
        sta     f:$002110
        lda     $bc80
        sta     f:$002106     ; screen mosaic register
        rts

; ---------------------------------------------------------------------------

_c11235:
@1235:  jsr     $11f5       ; update bg scroll/mosaic registers
        jsr     $12dd
        lda     $bc84
        sta     f:$00420c
        lda     $bc85
        sta     f:$002131
        rts

; ---------------------------------------------------------------------------

; [  ]

_c1124a:
@124a:  jsr     $11f5       ; update bg scroll/mosaic registers
        lda     $7edbd3
        beq     @125c

; credits
        lda     $bc85
        sta     f:$002131
        bra     @12b1

; neo-exdeath
@125c:  lda     $04f2
        cmp     #$1f
        bne     @1292       ; branch if not neo-exdeath
        lda     $bc85
        bne     @1292
        lda     $bc9b
        ora     #$20
        sta     f:$002132
        lda     $bc9c
        ora     #$40
        sta     f:$002132
        lda     $bc9d
        ora     #$80
        sta     f:$002132
        lda     $bc9e
        sta     $bc9f
        sta     $bc86
        sta     f:$002131
        bra     @12b1

; normal
@1292:  lda     $bc88
        sta     f:$002132
        lda     $bc89
        sta     f:$002132
        lda     $bc8a
        sta     f:$002132
        lda     $bc85
        sta     $bc86
        sta     f:$002131
@12b1:  lda     $bc81
        sta     $bc82
        sta     f:$002105
        jsr     $1482
        lda     $dbc1
        sta     $dbc2
        sta     f:$002108
        lda     $bc84
        sta     f:$00420c
        lda     $bc8b
        sta     f:$00212d
        lda     $bc8c
        sta     f:$002130
@12dd:  lda     $bc8d
        beq     @12e5
        jsr     $12e8
@12e5:  jmp     $fcd7

; ---------------------------------------------------------------------------

; [  ]

_c112e8:
@12e8:  lda     $bc8e
        sta     f:$00211b
        lda     $bc8f
        sta     f:$00211b
        lda     $bc90
        sta     f:$00211c
        lda     $bc91
        sta     f:$00211c
        lda     $bc92
        sta     f:$00211d
        lda     $bc93
        sta     f:$00211d
        lda     $bc94
        sta     f:$00211e
        lda     $bc95
        sta     f:$00211e
        lda     $bc96
        sta     f:$00211f
        lda     $bc97
        sta     f:$00211f
        lda     $bc98
        sta     f:$002120
        lda     $bc99
        sta     f:$002120
        rts

; ---------------------------------------------------------------------------

; [ copy battle bg graphics to vram ]

_c1133d:
@133d:  lda     $a895       ; battle bg graphics vram transfer counter
        and     #$07        ; copy $0100 bytes per frame, 8 frames to update
        asl
        tax
        lda     $c1136e,x
        sta     $8a
        lda     $c1136f,x
        sta     $8b
        lda     $c1137e,x
        sta     $8c
        lda     $c1137f,x
        sta     $8d
        ldx     #$0100
        stx     $88
        ldx     $8a
        ldy     $8c
        lda     #$7e
        jsr     $fdb6       ; copy data to vram
        inc     $a895
        rts

; ---------------------------------------------------------------------------

_c1136e:
        .word   $8809
        .word   $8909
        .word   $8a09
        .word   $8b09
        .word   $8c09
        .word   $8d09
        .word   $8e09
        .word   $8f09

_c1137e:
        .word   $0800
        .word   $0880
        .word   $0900
        .word   $0980
        .word   $0a00
        .word   $0a80
        .word   $0b00
        .word   $0b80

; ---------------------------------------------------------------------------

_c1138e:
@138e:  lda     $dbe3
        beq     @13a9
        ldx     #$0000
@1396:  lda     $b455,x
        cmp     #$ff
        beq     @13a0
        inc     $b455,x
@13a0:  inx
        cpx     #$00e0
        bne     @1396
        stz     $dbe3
@13a9:  lda     #$10
        sta     $8e
        lda     $a2
        and     #$03
        asl5
        tax
        lda     $a2
        asl3
        and     #$c0
        sta     $8c
@13c0:  lda     $a809,x
        cmp     #$ff
        beq     @13d9
        sta     $88
        and     #$c0
        cmp     $8c
        bne     @13d2
        jsr     $13da
@13d2:  inx2
        dec     $8e
        jmp     @13c0
@13d9:  rts

; ---------------------------------------------------------------------------

; [  ]

_c113da:
@13da:  phx
        lda     $a809,x
        and     #$3f
        longa
        asl5
        clc
        adc     #$8809
        sta     $88
        shorta0
        lda     $a80a,x
        and     #$3f
        longa
        asl5
        sta     $8a
        shorta0
        lda     $a80a,x
        and     #$c0
        lsr5
        tax
        lda     $c1142c,x
        clc
        adc     $8a
        sta     $8a
        lda     $c1142d,x
        adc     $8b
        sta     $8b
        ldy     #$0000
@1420:  lda     ($8a),y
        sta     ($88),y
        iny
        cpy     #$0020
        bne     @1420
        plx
        rts

; ---------------------------------------------------------------------------

; pointers to battle bg graphics buffers
_c1142c:
        .word   $9009,$9809,$a009,$a009

; ---------------------------------------------------------------------------

_c11434:
@1434:  ldy     #$0000
@1437:  tyx
        lda     $c1b126,x
        tax
        lda     $cf45,x
        clc
        adc     $cf49,x
        sta     $d01e,y
        sec
        sbc     #$10
        sta     $d056,y
        lda     $d022,y
        sta     $d062,y
        sta     $d092,y
        clc
        adc     #$0c
        sta     $d04a,y
        clc
        adc     #$0c
        sta     $d07a,y
        lda     $cf46,x
        clc
        adc     $cf4a,x
        sta     $d062,y
        lda     $d01e,y
        clc
        adc     #$08
        sta     $d03e,y
        sta     $d06e,y
        sta     $d086,y
        iny
        cpy     #$0004
        bne     @1437
        rts

; ---------------------------------------------------------------------------

; [  ]

_c11482:
@1482:  lda     $b3b8
        beq     @14e9
        lda     $b3ba
        asl
        tax
        lda     $c114ed,x
        sta     $88
        lda     $c114ee,x
        sta     $89
        lda     $b3bb
        asl
        tax
        lda     $c114ed,x
        sta     $8c
        lda     $c114ee,x
        sta     $8d
        lda     #$c1
        sta     $8a
        sta     $8e
        ldy     #$0000
@14b2:  lda     [$88],y
        sta     $a897,y     ; copy to bg1 scroll hdma table
        iny
        cpy     #$0019
        bne     @14b2
        ldy     #$0000
@14c0:  lda     [$8c],y
        sta     $a8b0,y     ; copy to bg2 scroll hdma table
        iny
        cpy     #$0080
        bne     @14c0
        longa
        lda     $b3be
        asl2
        sta     $88
        lda     $a8b1
        clc
        adc     $88
        sta     $a8b1
        lda     $a8b4
        clc
        adc     $88
        sta     $a8b4
        shorta0
@14e9:  stz     $b3b8
        rts

; ---------------------------------------------------------------------------

; pointers to bg scroll hdma data
_c114ed:
        .addr   $1596, $1507, $151a, $14f9, $1500, $1596

; credits (bg1)
_c114f9:
        .byte   $f0,$37,$a9
        .byte   $f0,$f7,$aa
        .byte   $80

; credits (bg2)
_c11500:
        .byte   $f0,$b7,$ac
        .byte   $f0,$77,$ae
        .byte   $80

; normal (bg2)
_c11507:
        .byte   $a0,$b7,$ac
        .byte   $a0,$b7,$ac
        .byte   $a0,$b7,$ac
        .byte   $a0,$b7,$ac
        .byte   $a0,$b7,$ac
        .byte   $c0,$37,$af
        .byte   $80

; neo exdeath (bg2)
_c1151a:
        .byte   $04,$b7,$ac
        .byte   $04,$c7,$ac
        .byte   $04,$d7,$ac
        .byte   $04,$e7,$ac
        .byte   $04,$f7,$ac
        .byte   $04,$07,$ad
        .byte   $04,$17,$ad
        .byte   $04,$27,$ad
        .byte   $04,$37,$ad
        .byte   $04,$47,$ad
        .byte   $04,$57,$ad
        .byte   $04,$67,$ad
        .byte   $04,$77,$ad
        .byte   $04,$87,$ad
        .byte   $04,$97,$ad
        .byte   $04,$a7,$ad
        .byte   $04,$b7,$ad
        .byte   $04,$c7,$ad
        .byte   $04,$d7,$ad
        .byte   $04,$e7,$ad
        .byte   $04,$f7,$ad
        .byte   $04,$07,$ae
        .byte   $04,$17,$ae
        .byte   $04,$27,$ae
        .byte   $04,$37,$ae
        .byte   $04,$47,$ae
        .byte   $04,$57,$ae
        .byte   $04,$67,$ae
        .byte   $04,$77,$ae
        .byte   $04,$87,$ae
        .byte   $04,$97,$ae
        .byte   $04,$a7,$ae
        .byte   $04,$b7,$ae
        .byte   $04,$c7,$ae
        .byte   $04,$d7,$ae
        .byte   $04,$e7,$ae
        .byte   $04,$f7,$ae
        .byte   $04,$07,$af
        .byte   $04,$17,$af
        .byte   $04,$27,$af
        .byte   $c0,$37,$af
        .byte   $80

; normal (bg1)
_c11596:
        .byte   $a0,$37,$a9
        .byte   $a0,$b7,$a9
        .byte   $a0,$37,$a9
        .byte   $a0,$b7,$a9
        .byte   $a0,$37,$a9
        .byte   $c0,$b7,$ab
        .byte   $80

; unused (bg1)
_c115a9:
        .byte   $a0,$37,$a9
        .byte   $a0,$b7,$a9
        .byte   $a0,$37,$aa
        .byte   $a0,$b7,$aa
        .byte   $a0,$37,$ab
        .byte   $c0,$b7,$ab
        .byte   $80

; ---------------------------------------------------------------------------

_c115bc:

.if LANG_EN
        .byte  $01,$02,$02,$02,$02,$02,$03,$04,$6f,$60,$74,$72,$64,$05,$06,$07
        .byte  $07,$07,$07,$07,$08
.else
        .byte  $01,$02,$02,$02,$02,$02,$03,$04,$dc,$d3,$f5,$dd,$d9,$05,$06,$07
        .byte  $07,$07,$07,$07,$08
.endif

; ---------------------------------------------------------------------------

; [  ]

_c115d1:
@15d1:  lda     $7c94
        cmp     #$02
        bne     @162b
        lda     $f6
        bne     @15e1
        ldx     #$4a21
        bra     @15e4
@15e1:  ldx     #$4a38
@15e4:  stx     $88
        lda     $7c6e
        sta     $f9b2
        lda     $7c6f
        sta     $f9b4
        lda     $7c70
        sta     $f9b8
        lda     $7c71
        sta     $f9ba
        ldx     #$0000
        longa
@1603:  lda     $88
        sta     f:$002116
        lda     #$0007
        sta     $8a
@160e:  lda     $f9a2,x
        sta     f:$002118
        inx2
        dec     $8a
        bne     @160e
        lda     $88
        clc
        adc     #$0020
        sta     $88
        cpx     #$002a
        bne     @1603
        shorta0
@162b:  rts

; ---------------------------------------------------------------------------

_c1162c:
@162c:  ldx     #$494d
        stx     $88
        lda     $db99
        beq     @169c
        stz     $db99
        cmp     #$01
        beq     @1669
        ldx     #$0000
        longa
@1642:  lda     $88
        sta     f:$002116
        lda     #$0007
        sta     $8a
        clr_a
@164e:  sta     f:$002118
        inx
        dec     $8a
        bne     @164e
        lda     $88
        clc
        adc     #$0020
        sta     $88
        cpx     #$0015
        bne     @1642
        shorta0
        bra     @169c
@1669:  ldx     #$0000
        longa
@166e:  lda     $88
        sta     f:$002116
        lda     #$0007
        sta     $8a
@1679:  lda     $c115bc,x
        and     #$00ff
        ora     #$2000
        sta     f:$002118
        inx
        dec     $8a
        bne     @1679
        lda     $88
        clc
        adc     #$0020
        sta     $88
        cpx     #$0015
        bne     @166e
        shorta0
@169c:  rts

; ---------------------------------------------------------------------------

_c1169d:
@169d:  lda     $db9b
        beq     @16ab
        lda     $03
        and     #$10
        bne     @16e1
        stz     $db9b
@16ab:  lda     $03
        and     #$10
        beq     @16e1
        lda     #$01
        sta     $db9b
        lda     $db98
        bne     @16ce
        lda     #$f6
        sta     $1d00
        jsl     ExecSound_ext
        lda     #$01
        sta     $db99
        inc     $db98
        bra     @16ed
@16ce:  lda     #$f7
        sta     $1d00
        jsl     ExecSound_ext
        lda     #$02
        sta     $db99
        stz     $db98
        bra     @16e6
@16e1:  lda     $db98
        beq     @16ed
@16e6:  lda     #$01
        sta     $db9a
        clc
        rts
@16ed:  stz     $db9a
        sec
        rts

; ---------------------------------------------------------------------------

; [  ]

_c116f2:
@16f2:  lda     $b3c0
        beq     @170a
        ldx     #$0080
        stx     $88
        ldx     #$b3c4
        ldy     #$4800
        lda     #$7e
        jsr     $fdb6       ; copy data to vram
        stz     $b3c0
@170a:  rts

; ---------------------------------------------------------------------------

; [  ]

_c1170b:
@170b:  lda     $7c52
        ora     $db98
        beq     @1714
@1713:  rts
@1714:  lda     $7c94
        cmp     #$02
        bne     @1713
        lda     $7c95
        ora     $7c96
        beq     @1713
        longa
        dec     $7c95
        ldx     #$0007
        lda     $7c95
        cmp     #$012c
        beq     @1758
        dex
        cmp     #$0258
        beq     @1758
        dex
        cmp     #$04b0
        beq     @1758
        dex
        cmp     #$0708
        beq     @1758
        dex
        cmp     #$0960
        beq     @1758
        dex
        cmp     #$0bb8
        beq     @1758
        dex
        cmp     #$0e10
        beq     @1758
        dex
@1758:  shorta0
        txa
        beq     @176a
        sta     $1d01
        lda     #$87        ; set tempo multiplier
        sta     $1d00
        jsl     ExecSound_ext
@176a:  lda     $a2
        and     #$1f
        bne     @17c3
        ldx     $7c95
        stx     $98
        ldx     #$003c
        stx     $9a
        jsr     $fe19
        ldx     $9c
        stx     $98
        ldx     #$003c
        stx     $9a
        jsr     $fe19
        ldx     $9e
        phx
        ldx     $9c
        stx     $98
        ldx     #$000a
        stx     $9a
        jsr     $fe19
        lda     $9c
        clc
        adc     #$53
        sta     $7c6e
        lda     $9e
        clc
        adc     #$53
        sta     $7c6f
        plx
        stx     $98
        ldx     #$000a
        stx     $9a
        jsr     $fe19
        lda     $9c
        clc
        adc     #$53
        sta     $7c70
        lda     $9e
        clc
        adc     #$53
        sta     $7c71
@17c3:  rts

; ---------------------------------------------------------------------------

_c117c4:
@17c4:  lda     $db98
        bne     @17d6
        longa
        inc     $db6e
        bne     @17d3
        inc     $db70
@17d3:  shorta0
@17d6:  rts

; ---------------------------------------------------------------------------

_c117d7:
@17d7:  lda     $ff00
        beq     @17ef
        ldx     #$0080
        stx     $88
        ldx     #$bcb1
        ldy     $ff01
        lda     #$7e
        jsr     $fdb6       ; copy data to vram
        stz     $ff00
@17ef:  rts

; ---------------------------------------------------------------------------

; [  ]

_c117f0:
@17f0:  jsr     $1235
        jsr     $fd9c
        lda     $bc81
        sta     f:$002105
        lda     $fefb
        sta     f:$00212c
        lda     $bc7f
        sta     f:$002100
        ldx     $a2
        inx
        stx     $a2
        stz     $a5
        stz     $a4
        rts

; ---------------------------------------------------------------------------

_c11815:
@1815:  jsr     $1235
        jsr     $fd9c
        jsr     $133d
        jsr     $17d7
        lda     #$09
        sta     f:$002105
        lda     #$00
        sta     f:$002125
        lda     $fefb
        sta     f:$00212c
        lda     #$08
        sta     f:$002126
        lda     #$f7
        sta     f:$002127
        lda     $fefc
        sta     f:$002111
        lda     $fefd
        sta     f:$002111
        lda     $fefe
        sta     f:$002112
        lda     $feff
        sta     f:$002112
        lda     #$5a
        sta     f:$002107
        lda     #$4a
        sta     f:$002109
        lda     $bc7f
        sta     f:$002100
        jsr     $138e
        jsr     $3309
        ldx     $a2
        inx
        stx     $a2
        stz     $a5
        stz     $a4
        rts

; ---------------------------------------------------------------------------

; [  ]

_c1187f:
@187f:  jsr     $124a
        jsr     $fd9c
        lda     $bc7f
        sta     f:$002100
        ldx     #$0000
@188f:  lda     $7f7700,x
        sta     $0200,x
        inx
        cpx     #$0100
        bne     @188f
        clr_ax
        lda     #$00
@18a0:  sta     $0400,x
        inx
        cpx     #$0010
        bne     @18a0
        stz     $a5
        stz     $a4
        rts

; ---------------------------------------------------------------------------

; [  ]

_c118ae:
@18ae:  jsr     $124a
        jsr     $fd9c
        lda     $bc7f
        sta     f:$002100
        clr_ax
@18bd:  lda     $7f7700,x
        sta     $0200,x
        stz     $0300,x
        inx
        cpx     #$0100
        bne     @18bd
        stz     $a5
        stz     $a4
        rts

; ---------------------------------------------------------------------------

; [ normal battle nmi ??? ]

_c118d2:
@18d2:  jsr     $124a
        jsr     $fd9c
        jsr     $133d
        jsr     $4a68
        jsr     $4a4f
        jsr     $555b
        jsr     $16f2
        jsr     $4a05
        jsr     $1d25
        jsr     $aca8
        jsr     $15d1
        jsr     $162c
        lda     $bc7f
        sta     f:$002100
        jsr     $fff4
        jsr     $0ba4
        lda     $dbb3
        bne     @1915
        lda     $dbd3
        bne     @1915
        jsr     $169d
        jcc     @19d4
@1915:  jsr     $138e
        jsr     $3309
        jsr     $7979
        jsr     $1186
        jsr     $62d7
        jsr     $78fe       ; update screen flash
        jsr     $170b
        lda     $db60
        bne     @1941
        jsr     $70d3
        jsr     $6fd5
        jsr     $667c
        jsr     $1434
        jsr     $112f
        jsr     $0f51
@1941:  jsr     $5ff0
        lda     $db72
        bne     @195d
        jsr     $64b0
        lda     $db60
        bne     @195d
        jsr     $67e4
        jsr     $68f1
        jsr     $6c58
        jsr     $b12a
@195d:  jsr     $5fcc
        jsr     $5f92
        jsr     $6533
        jsr     $6cd4       ; update damage numeral sprites
        jsr     $61c3
        lda     $dbbb
        bne     @198d
        lda     $04
        and     #$30
        cmp     #$30
        bne     @198d       ; branch if l+r not pressed
        jsr     $706b
        lda     $7be8
        bmi     @1998       ; branch if exit spell was used
        lda     $7c52
        bne     @1995       ; branch if battle paused (menu open + wait mode)
        lda     #$01
        sta     $7be8       ; party is trying to run
        bra     @1998
@198d:  jsr     $705c
        lda     $7be8
        bmi     @1998
@1995:  stz     $7be8
@1998:  ldx     $a2
        inx
        stx     $a2
        lda     $cd3a
        bne     @19d4
        lda     $cd41
        ora     $cd35
        beq     @19d4
        lda     $cdf8
        bne     @19d4
        jsr     $486e
        lda     $0974
        bmi     @19ba       ; branch if multi-controller
        clr_a                 ; cursor sound effect 0 (player 1)
        bra     @19c5
@19ba:  lda     $cd42
        tax
        lda     $0984,x
        beq     @19c5
        lda     #$01        ; cursor sound effect 1 (player 2)
@19c5:  clc
        adc     #$18
        sta     $1d00
        lda     $dbb3
        bne     @19d4
        jsl     ExecSound_ext
@19d4:  lda     $dbb3
        bne     @19e2
        jsr     $fc05       ; play queued game sound effect/set volume
        jsr     $fc44       ; play queued system sound effect
        jsr     $0b81       ; play queued song
@19e2:  stz     $a5         ; clear vblank flag
        stz     $a4
        jmp     $17c4

; ---------------------------------------------------------------------------

; [ battle irq ]

_c119e9:
        rti

; ---------------------------------------------------------------------------

; [ battle nmi ]

_c119ea:
        php
        longai
        pha
        phx
        phy
        phb
        phd
        ldx     #$0000
        phx
        pld
        shorta0
        lda     f:$004210
        lda     #$7e
        pha
        plb
        lda     $a4
        bne     @1a4e
        inc     $a4
        lda     f:$00213f
        lda     #$00
        sta     f:$002100
        jsr     $fdc0
        jsr     $fdc5
        lda     $dbf5
        beq     @1a4b
        cmp     #$01
        beq     @1a45
        cmp     #$02
        beq     @1a3f
        cmp     #$03
        beq     @1a39
        cmp     #$04
        beq     @1a33
        jsr     $fadc
        jmp     @1a4e
@1a33:  jsr     $17f0
        jmp     @1a4e
@1a39:  jsr     $18ae
        jmp     @1a4e
@1a3f:  jsr     $187f
        jmp     @1a4e
@1a45:  jsr     $1815
        jmp     @1a4e
@1a4b:  jsr     $18d2
@1a4e:  longai
        pld
        plb
        ply
        plx
        pla
        plp
        rti
        .a8

; ---------------------------------------------------------------------------

_c11a57:
        ldx     #$0200
        stx     $70
        ldx     #$e003
        lda     #$d0
        ldy     #$0100
        jsr     $fdca       ; copy data to vram
        ldx     #$000a
        stx     $70
        ldx     #$9e50
        ldy     #$0010
        lda     #$d4
        jmp     $fca2
        phx
        phy
        sta     $81
        longa
        clr_ay
@1a7f:  lda     a:$0070,y
        pha
        iny2
        cpy     #$000c
        bne     @1a7f
        shorta0
        jsr     $1ceb
        jsr     $8b2a
        longa
        ldy     #$000c
@1a98:  pla
        sta     a:$006e,y
        dey2
        bne     @1a98
        shorta0
        ply
        plx
        rts

; ---------------------------------------------------------------------------

; [  ]

_c11aa6:
        phx
        phy
        sta     $81
        longa
        clr_ay
@1aae:  lda     $0070,y
        pha
        iny2
        cpy     #$000c
        bne     @1aae
        shorta0
        lda     $80
        tax
        lda     $d026,x
        beq     @1ade
        lda     $81
        sta     $7e
        lda     $80
        tax
        lda     $d00e,x
        sta     $70
        lda     $d016,x
        dec
        clc
        adc     $d026,x
        sta     $72
        txa
        jsr     $202f
@1ade:  lda     $81
        sta     $7e
        lda     $80
        tax
        lda     $d00e,x
        sta     $70
        lda     $d016,x
        clc
        adc     $d026,x
        sta     $72
        txa
        jsr     $1f22
        inc     $dba4
        longa
        ldy     #$000c
@1aff:  pla
        sta     $006e,y
        dey2
        bne     @1aff
        shorta0
        ply
        plx
        rts

; ---------------------------------------------------------------------------

_c11b0d:
        clr_ax
        lda     $dbd3
        beq     @1b18
        lda     #$54
        bra     @1b1a
@1b18:  lda     #$34
@1b1a:  sta     $70
@1b1c:  lda     $db4a,x
        beq     @1b25
        lda     #$d8
        bra     @1b27
@1b25:  lda     #$c8
@1b27:  sta     $d01e,x
        lda     $70
        sta     $d022,x
        clc
        adc     #$1a
        sta     $70
        lda     $d01e,x
        sec
        sbc     #$10
        sta     $d056,x
        lda     $d022,x
        sta     $d062,x
        lda     $d01e,x
        clc
        adc     #$08
        sta     $d03e,x
        sta     $d06e,x
        lda     $d022,x
        clc
        adc     #$0c
        sta     $d04a,x
        clc
        adc     #$0c
        sta     $d07a,x
        inx
        cpx     #$0004
        bne     @1b1c
        rts

; ---------------------------------------------------------------------------

_c11b65:
        stz     $74
        lda     $dbd3
        beq     @1b70
        lda     #$20
        sta     $74
@1b70:  clr_ax
@1b72:  lda     $d00e,x
        asl3
        sta     $70
        sec
        sbc     #$08
        sta     $d04e,x
        lda     $cffe,x
        and     #$fe
        asl2
        clc
        adc     $70
        sta     $d036,x
        sta     $d066,x
        sta     $d07e,x
        lda     $d016,x
        asl3
        sta     $70
        clc
        adc     $74
        sta     $d08a,x
        lda     $d006,x
        and     #$fe
        asl2
        clc
        adc     $70
        clc
        adc     $74
        sta     $d042,x
        sec
        sbc     #$08
        clc
        adc     $74
        sta     $d05a,x
        lda     $d006,x
        asl3
        clc
        adc     $70
        clc
        adc     $74
        sta     $d072,x
        inx
        cpx     #$0008
        bne     @1b72
        clr_ax
        lda     #$ff
@1bd3:  sta     $d0a2,x
        sta     $d0aa,x
        sta     $d0b2,x
        sta     $d0ba,x
        inx
        cpx     #$0008
        bne     @1bd3
        clr_axy
@1be8:  lda     $d036,x
        sta     $dbf6,y
        lda     $d042,x
        sta     $dc06,y
        txa
        sta     $dbf7,y
        sta     $dc07,y
        inx
        iny2
        cpy     #$0010
        bne     @1be8
        ldy     #$0010
@1c06:  clr_ax
@1c08:  lda     $dbf6,x
        cmp     $dbf8,x
        bcc     @1c29
        pha
        lda     $dbf8,x
        sta     $dbf6,x
        pla
        sta     $dbf8,x
        lda     $dbf7,x
        pha
        lda     $dbf9,x
        sta     $dbf7,x
        pla
        sta     $dbf9,x
@1c29:  lda     $dc06,x
        cmp     $dc08,x
        bcc     @1c4a
        pha
        lda     $dc08,x
        sta     $dc06,x
        pla
        sta     $dc08,x
        lda     $dc07,x
        pha
        lda     $dc09,x
        sta     $dc07,x
        pla
        sta     $dc09,x
@1c4a:  inx2
        cpx     #$000e
        bne     @1c08
        dey
        bne     @1c06
        clr_axy
@1c57:  lda     $dbf7,x
        sta     $d0a2,y
        lda     $dc07,x
        sta     $d0b2,y
        inx2
        iny
        cpy     #$0008
        bne     @1c57
        clr_ax
        ldy     #$0007
@1c70:  lda     $d0a2,x
        sta     $d0aa,y
        lda     $d0b2,x
        sta     $d0ba,y
        inx
        dey
        cpx     #$0008
        bne     @1c70
        rts

; ---------------------------------------------------------------------------

_c11c84:
        jsr     $1cdf
        jmp     _1c94

; ---------------------------------------------------------------------------

_c11c8a:
        jsr     $1ceb
        lda     $de
        sta     $70
        jsr     $2068       ; load monster palettes
_1c94:  jsr     $1d65
        ldx     #$0500
        stx     $70
        ldx     #$7800
        lda     $dbd3
        beq     @1ca9
        ldy     #$5c80
        bra     @1cac
@1ca9:  ldy     #$5c00
@1cac:  lda     #$7f
        jmp     $fd27

; ---------------------------------------------------------------------------

; [ load black and white monster palette ]

_c11cb1:
        sta     $7b
        jsr     $1ced
        bra     _1cc2

; ---------------------------------------------------------------------------

; [ restore monster palette ??? ]

_c11cb8:
        jsr     $1ceb
        lda     $de
        sta     $70
        jsr     $2068       ; load monster palettes
_1cc2:  jsr     $1d65
        ldx     #$0500
        stx     $70
        ldx     #$7800
        lda     $dbd3
        beq     @1cd7
        ldy     #$5880
        bra     @1cda
@1cd7:  ldy     #$5800
@1cda:  lda     #$7f
        jmp     $fd27

; ---------------------------------------------------------------------------

_c11cdf:
@1cdf:  clr_ax
@1ce1:  sta     $ee57,x
        inx
        cpx     #$0500
        bne     @1ce1
        rts

; ---------------------------------------------------------------------------

_c11ceb:
@1ceb:  stz     $7b
@1ced:  jsr     $1cdf
        lda     $de
        sta     $7a
        clr_ax
@1cf6:  asl     $7a
        bcc     @1d1c
        stz     $7e
        asl     $7b
        bcc     @1d04
        lda     #$0c
        sta     $7e
@1d04:  lda     $d00e,x
        sta     $70
        lda     $d016,x
        sec
        sbc     $d02e,x
        clc
        adc     $d026,x
        sta     $72
        txa
        jsr     $1f22
        bra     @1d1e
@1d1c:  asl     $7b
@1d1e:  inx
        cpx     #$0008
        bne     @1cf6
        rts

; ---------------------------------------------------------------------------

_c11d25:
@1d25:  lda     $db42
        beq     @1d47
        stz     $db42
        ldx     #$0500
        stx     $88
        ldx     #$7800
        lda     $dbd3
        beq     @1d3f
        ldy     #$5880
        bra     @1d42
@1d3f:  ldy     #$5800
@1d42:  lda     #$7f
        jmp     $fdb6       ; copy data to vram
@1d47:  rts

; ---------------------------------------------------------------------------

_c11d48:
        jsr     $1d65
        ldx     #$0500
        stx     $70
        ldx     #$7800
        lda     $dbd3
        beq     @1d5d
        ldy     #$5880
        bra     @1d60
@1d5d:  ldy     #$5800
@1d60:  lda     #$7f
        jmp     $fdca       ; copy data to vram

; ---------------------------------------------------------------------------

_c11d65:
@1d65:  lda     $3eef
        and     #$10
        beq     @1d9b
        longa
        lda     #$ee57
        sta     $76
        lda     #$0014
        sta     $72
@1d78:  lda     #$0009
        clc
        adc     $b3b7
        sta     $70
        clr_ay
@1d83:  clr_a
        sta     ($76),y
        iny2
        dec     $70
        bne     @1d83
        lda     $76
        clc
        adc     #$0040
        sta     $76
        dec     $72
        bne     @1d78
        shorta0
@1d9b:  lda     $f6
        beq     @1de2
        phb
        lda     #$7f
        pha
        plb
        clr_ax
        longa
@1da8:  phx
        clr_ay
@1dab:  lda     $7eee57,x
        sta     $7f00,y
        iny2
        inx2
        cpy     #$0040
        bne     @1dab
        dex2
        clr_ay
@1dbf:  lda     $7f00,y
        eor     #$4000
        sta     $7800,x
        iny2
        dex2
        cpy     #$0040
        bne     @1dbf
        plx
        txa
        clc
        adc     #$0040
        tax
        cmp     #$0500
        bne     @1da8
        shorta0
        plb
        rts
@1de2:  phb
        longa
        ldx     #$ee57
        ldy     #$7800
        lda     #$04ff
        mvn     #$7e,#$7f
        shorta0
        plb
        rts

; ---------------------------------------------------------------------------

_c11df6:
@1df6:  lda     $cffe,y
        asl
        sta     $7a
        stz     $7b
        stz     $79
        lda     $d006,y
        sec
        sbc     $d026,y
        sta     $78
        jeq     @1ed0
        longa
        asl     $70
        asl     $72
        asl     $72
        asl     $72
        asl     $72
        asl     $72
        asl     $72
        lda     $72
        clc
        adc     $70
        clc
        adc     #$ee57
        sta     $70
        lda     $74
        clc
        adc     #$dcf6
        sta     $74
        shorta0
        lda     #$10
        sta     $80
        tya
        asl2
        tax
        lda     $7b9e,x
        and     #$30
        jeq     @1ed1
        and     #$20
        beq     @1e4e
        lda     #$14
        sta     $80
@1e4e:  lda     $db9c,y
        asl6
        and     #$40
        ora     #$3c
        sta     $81
        phy
        ldy     #$0001
        lda     ($74),y
        and     #$fc
        ora     $81
        sta     $81
        ply
        clr_ax
        longa
        lda     ($74)
        and     #$fc00
@1e73:  sta     $7f7d00,x
        inx2
        cpx     #$0200
        bne     @1e73
        lda     $7a
        lsr
        and     #$fffe
        beq     @1e88
        dec
        dec
@1e88:  sta     $7a
        lda     $78
        lsr
        beq     @1e90
        dec
@1e90:  asl5
        clc
        adc     $7a
        tax
        lda     $db9c,y
        and     #$0001
        beq     @1eb8
        lda     $80
        sta     $7f7d02,x
        inc
        sta     $7f7d00,x
        inc
        sta     $7f7d22,x
        inc
        sta     $7f7d20,x
        bra     @1ecd
@1eb8:  lda     $80
        sta     $7f7d00,x
        inc
        sta     $7f7d02,x
        inc
        sta     $7f7d20,x
        inc
        sta     $7f7d22,x
@1ecd:  shorta0
@1ed0:  rts
@1ed1:  lda     $db9c,y
        and     #$01
        beq     @1f0a
        longa
        clr_ax
@1edc:  ldy     $7a
        dey2
        phx
@1ee1:  lda     ($74),y
        eor     #$4000
        sta     $7f7d00,x
        inx2
        dey2
        cpy     #$fffe
        bne     @1ee1
        plx
        txa
        clc
        adc     #$0020
        tax
        lda     $74
        clc
        adc     #$0020
        sta     $74
        dec     $78
        bne     @1edc
        shorta0
        rts
@1f0a:  clr_ayx
        longa
@1f0f:  lda     ($74),y
        sta     $7f7d00,x
        iny2
        inx2
        cpy     #$0200
        bne     @1f0f
        shorta0
        rts

; ---------------------------------------------------------------------------

; [  ]

_c11f22:
@1f22:  phx
        stz     $71
        stz     $73
        stz     $7c
        tay
        asl
        sta     $75
        stz     $74
        ldx     $7a
        phx
        phy
        jsr     $1df6
        ply
        lda     $cffe,y
        asl
        sta     $7a
        stz     $7b
        stz     $79
        lda     $d006,y
        sec
        sbc     $d026,y
        sta     $78
        jeq     @202a
        phy
        ldy     #$7d00
        sty     $74
        lda     #$7f
        sta     $76
@1f59:  ldy     $70
        iny
        sty     $72
        clr_ay
@1f60:  lda     ($72),y
        and     #$03
        sta     $86
        lda     ($70),y
        bne     @1f76
        lda     $86
        bne     @1f76
        lda     [$74],y
        sta     ($70),y
        iny
        jmp     @1f89
@1f76:  lda     [$74],y
        cmp     ($70),y
        beq     @1f80
        iny
        jmp     @1fa0
@1f80:  iny
        lda     [$74],y
        and     #$03
        cmp     $86
        bne     @1fa0
@1f89:  lda     $7e
        bne     @1f92
        lda     [$74],y
        jmp     @1f98
@1f92:  lda     [$74],y
        and     #$c3
        ora     $7e
@1f98:  sta     ($70),y
        and     #$3c
        ora     $7c
        sta     $7c
@1fa0:  iny
        cpy     $7a
        bne     @1f60
        longa
        lda     $70
        clc
        adc     #$0040
        sta     $70
        lda     $74
        clc
        adc     #$0020
        sta     $74
        shorta0
        dec     $78
        bne     @1f59
        ply
        lda     $db9c,y
        bpl     @202a
        lda     $7c
        sta     $81
        lda     $7e
        beq     @1fd4
        lda     $81
        and     #$e3
        ora     $7e
        sta     $81
@1fd4:  stz     $80
        tya
        asl2
        tay
        lda     $7b9e,y
        and     #$30
        bne     @202a
        longa
        lda     $70
        sec
        sbc     #$0040
        sta     $70
        ldy     #$0002
        lsr     $7a
        lda     $7a
        cmp     #$0004
        bcs     @2002
        dey2
        lda     #$0013
        ora     $80
        sta     ($70),y
        bra     @2020
@2002:  dec     $7a
        dec     $7a
        dec     $7a
        lda     #$0018
        ora     $80
        sta     ($70),y
        iny2
@2011:  dec     $7a
        beq     @2020
        lda     #$0019
        ora     $80
        sta     ($70),y
        iny2
        bra     @2011
@2020:  lda     #$001a
        ora     $80
        sta     ($70),y
        shorta0
@202a:  plx
        stx     $7a
        plx
        rts

; ---------------------------------------------------------------------------

; [  ]

_c1202f:
        phx
        stz     $71
        stz     $73
        tay
        lda     $cffe,y
        asl
        sta     $76
        stz     $77
        longa
        asl     $70
        asl     $72
        asl     $72
        asl     $72
        asl     $72
        asl     $72
        asl     $72
        lda     $72
        clc
        adc     $70
        clc
        adc     #$ee57
        sta     $70
        clr_ay
@205a:  clr_a
        sta     ($70),y
        iny2
        cpy     $76
        bne     @205a
        shorta0
        plx
        rts

; ---------------------------------------------------------------------------

; [ load monster palettes ]

_c12068:
        phy
        lda     $ee56
        bne     @20c2
        clr_ay
@2070:  asl     $70
        bcc     @20bc
        lda     $cfd6,y
        asl5
        sta     $72
        tya
        asl
        tax
        lda     $cfde,x
        sta     $74
        lda     $cfdf,x
        sta     $75
        ldx     $74
        lda     $3eef
        and     #$40
        beq     @2096
        clr_ax
@2096:  phy
        lda     $72
        tay
        lda     #$20
        sta     $76
@209e:  lda     $3eef
        and     #$40
        beq     @20ab
        lda     $d99755,x   ; underwater monster palette
        bra     @20af
@20ab:  lda     $ced000,x   ; monster palettes
@20af:  sta     $7e89,y
        sta     $edf6,y
        inx
        iny
        dec     $76
        bne     @209e
        ply
@20bc:  iny
        cpy     #$0008
        bne     @2070
@20c2:  ply
        rts

; ---------------------------------------------------------------------------

; [ load monster graphics ]

_c120c4:
        ldy     #$0200
        sty     $dbf6
        ldy     #$2000
        sty     $dbfe
        clr_ay
@20d2:  tya
        asl
        tax
        lda     $dbf6
        sta     $cfee,x
        lda     $dbf7
        sta     $cfef,x
        lda     $4021,x     ; monster graphics index
        cmp     #$ff
        beq     @2123       ; branch if slot is empty
        sta     $7f
        lda     $4020,x
        sta     $7e         ; +$7e = monster graphics index
        ldx     #$0005
        stx     $80
        jsr     $fe67       ; ++$82 = +$7e * +$80
        lda     $cfd6,y
        asl2
        ora     #$30
        sta     $dbf8
        ldx     $82
        tya
        jsr     $2306       ;
        lda     $dbfb
        inc
        sta     $cffe,y
        lda     $dbfc
        inc
        sta     $d006,y
        lda     $dbfd
        sta     $d0e6,y
        jsr     $2157       ;
        jsr     $2133       ; get pointer to monster palette
        bra     @212a
@2123:  clr_a
        sta     $cffe,y
        sta     $d006,y
@212a:  iny                 ; next monster
        cpy     #$0008
        bne     @20d2
        jmp     $22f2

; ---------------------------------------------------------------------------

; [ get pointer to monster palette ]

_c12133:
@2133:  phx
        phy
        lda     $d4b182,x   ; msb of palette index
        and     #$03
        sta     $71
        lda     $d4b183,x   ; palette index
        sta     $70
        tya
        asl
        tay
        longa
        lda     $70
        asl4
        sta     $cfde,y     ; pointer to monster palette
        shorta0
        ply
        plx
        rts

; ---------------------------------------------------------------------------

; [ copy monster graphics to vram ]

_c12157:
@2157:  phy
        phx
        sta     $76
        stz     $77
        lda     $d4b180,x   ; pointer to monster graphics
        sta     $70
        and     #$7f
        sta     $73
        lda     $d4b181,x
        sta     $72
        stz     $74
        asl     $72
        rol     $73
        rol     $74
        asl     $72
        rol     $73
        rol     $74
        asl     $72
        rol     $73
        rol     $74
        lda     $72
        clc
        adc     #$00
        sta     $72
        lda     $73
        adc     #$00
        sta     $73
        lda     $74
        adc     #$d5
        sta     $74
        clr_ay
        lda     $70
        and     #$80
        bne     @21c7       ; if msb is set, graphics are 3bpp
        longa
        lda     $dbfe
        sta     f:$002116
@21a5:  ldx     #$0010
@21a8:  lda     [$72],y
        sta     f:$002118
        iny2
        dex
        bne     @21a8
        lda     $dbfe
        clc
        adc     #$0010
        sta     $dbfe
        dec     $76
        bne     @21a5
        shorta0
        plx
        ply
        rts
@21c7:  longa
        lda     $dbfe
        sta     f:$002116
@21d0:  ldx     #$0008
@21d3:  lda     [$72],y
        sta     f:$002118
        iny2
        dex
        bne     @21d3
        ldx     #$0008
@21e1:  lda     [$72],y
        and     #$00ff
        sta     f:$002118
        iny
        dex
        bne     @21e1
        lda     $dbfe
        clc
        adc     #$0010
        sta     $dbfe
        dec     $76
        bne     @21d0
        shorta0
        plx
        ply
        rts

; ---------------------------------------------------------------------------

; [  ]

_c12202:
        lda     #$00
        sta     f:$002181
        lda     #$c0
        sta     f:$002182
        lda     #$01
        sta     f:$002183
        clr_ay
@2216:  tya
        asl
        tax
        lda     $4021,x
        cmp     #$ff
        beq     @2237
        sta     $7f
        lda     $4020,x
        sta     $7e
        ldx     #$0005
        stx     $80
        jsr     $fe67       ; ++$82 = +$7e * +$80
        ldx     $82
        lda     $d0e6,y
        jsr     $2289
@2237:  iny
        cpy     #$0008
        bne     @2216
        phb
        longa
        ldx     #$c000
        ldy     #$8000
        lda     #$3fff
        mvn     #$7f,#$7f
        shorta0
        plb
        rts

; ---------------------------------------------------------------------------

; [ get pointer to monster graphics ]

_c12251:
@2251:  lda     $d4b180,x   ; pointer to monster graphics
        sta     $70
        and     #$7f
        sta     $73
        lda     $d4b181,x
        sta     $72
        stz     $74
        asl     $72
        rol     $73
        rol     $74
        asl     $72
        rol     $73
        rol     $74
        asl     $72
        rol     $73
        rol     $74
        lda     $72
        clc
        adc     #$00
        sta     $72
        lda     $73
        adc     #$00
        sta     $73
        lda     $74
        adc     #$d5
        sta     $74
        rts

; ---------------------------------------------------------------------------

; [  ]

_c12289:
@2289:  phy
        phx
        sta     $76
        stz     $77
        jsr     $2251       ; get pointer to monster graphics
        clr_ay
        lda     $70
        and     #$80
        bne     @22bd
@229a:  ldx     #$0020
@229d:  lda     [$72],y
        sta     f:$002180
        iny
        dex
        bne     @229d
        longa
        lda     $dbfe
        clc
        adc     #$0010
        sta     $dbfe
        shorta0
        dec     $76
        bne     @229a
        plx
        ply
        rts
@22bd:  ldx     #$0010
@22c0:  lda     [$72],y
        sta     f:$002180
        iny
        dex
        bne     @22c0
        ldx     #$0008
@22cd:  lda     [$72],y
        sta     f:$002180
        clr_a
        sta     f:$002180
        iny
        dex
        bne     @22cd
        longa
        lda     $dbfe
        clc
        adc     #$0010
        sta     $dbfe
        shorta0
        dec     $76
        bne     @22bd
        plx
        ply
        rts

; ---------------------------------------------------------------------------

; [  ]

_c122f2:
@22f2:  clr_ax
@22f4:  lda     $db9c,x
        bpl     @22ff
        inc     $d006,x
        inc     $d006,x
@22ff:  inx
        cpx     #$0008
        bne     @22f4
        rts

; ---------------------------------------------------------------------------

; [  ]

_c12306:
@2306:  phy
        phx
        asl
        sta     $71
        stz     $70
        stz     $76
        lda     #$d0
        sta     $74
        stz     $dbfb
        stz     $dbfc
        stz     $dbfd
        lda     $d4b182,x
        and     #$40
        beq     @232c
        lda     $db9c,y
        ora     #$80
        sta     $db9c,y
@232c:  lda     $d4b182,x
        bmi     @23ab       ; branch if monster uses large map
        lda     $d4b184,x   ; graphics map index
        longa
        asl3
        clc
        adc     $d0d000     ; pointer to small graphic maps
        sta     $72
        shorta0
        stz     $7a
@2347:  ldx     $70
        lda     [$72]
        sta     $7e
        beq     @2354
        lda     $7a
        sta     $dbfc
@2354:  clr_ay
@2356:  asl     $7e
        bcc     @237f
        tya
        cmp     $dbfb
        bcc     @2363
        sta     $dbfb
@2363:  lda     $dbf6
        sta     $dcf6,x
        lda     $dbf7
        ora     $dbf8
        sta     $dcf7,x
        longa
        inc     $dbf6
        shorta0
        inc     $dbfd
        bra     @2386
@237f:  clr_a
        sta     $dcf6,x
        sta     $dcf7,x
@2386:  inx2
        iny
        cpy     #$0008
        bne     @2356
        ldy     $72
        iny
        sty     $72
        longa
        lda     $70
        clc
        adc     #$0020
        sta     $70
        shorta0
        inc     $7a
        lda     $7a
        cmp     #$08
        bne     @2347
        plx
        ply
        rts
@23ab:  lda     $d4b184,x   ; graphics map index
        longa
        asl5
        clc
        adc     $d0d002     ; pointer to large graphic maps
        sta     $72
        shorta0
        stz     $7a
        stz     $7b
        ldx     $70
        longa
@23c8:  lda     [$72]
        sta     $7e
        beq     @23d7
        shorta
        lda     $7a
        sta     $dbfc
        longa
@23d7:  clr_ay
@23d9:  asl     $7e
        bcc     @2402
        shorta0
        tya
        cmp     $dbfb
        bcc     @23e9
        sta     $dbfb
@23e9:  lda     $dbf6
        sta     $dcf6,x
        lda     $dbf7
        ora     $dbf8
        sta     $dcf7,x
        inc     $dbfd
        longa
        inc     $dbf6
        bra     @2406
@2402:  clr_a
        sta     $dcf6,x
@2406:  inx2
        iny
        cpy     #$0010
        bne     @23d9
        lda     $70
        clc
        adc     #$0020
        sta     $70
        tax
        inc     $72
        inc     $72
        inc     $7a
        lda     $7a
        cmp     #$0010
        bne     @23c8
        shorta0
        plx
        ply
        rts

; ---------------------------------------------------------------------------

_c1242a:
        ldx     #$1000
        stx     $70
        ldx     #$f000
        ldy     #$4000
        lda     #$d1
        jsr     $fdca       ; copy data to vram
        longa
        lda     #$4080
        sta     f:$002116
        ldx     #$0200
        lda     #$00ff
@2449:  sta     f:$002118
        dex
        bne     @2449
        shorta0
        rts

; ---------------------------------------------------------------------------

_c12454:
        ldx     #$0500
        ldy     #$0600
        jsr     $fdbb
        ldx     #$0500
        stx     $74
        clr_ax
@2464:  ldy     $74
        lda     $ceff95,x
        jsr     $2481
        longa
        lda     $74
        clc
        adc     #$0010
        sta     $74
        shorta0
        inx
        cpx     #$0030
        bne     @2464
        rts

; ---------------------------------------------------------------------------

_c12481:
@2481:  phx
        sta     $7e
        lda     #$10
        sta     $80
        jsr     $feba       ; +$82 = $7e * $80
        longa
        lda     $82
        clc
        adc     #$f000
        tax
        lda     #$0010
        sta     $70
        shorta0
        lda     #$d1
        jsr     $fdca       ; copy data to vram
        plx
        rts

; ---------------------------------------------------------------------------

; pointers to character graphics
_c124a3:
        .dword  $d20000 ; bartz
        .dword  $d49400 ; bartz (dead)
        .dword  $d28400
        .dword  $d494c0
        .dword  $d30800
        .dword  $d49580
        .dword  $d38c00
        .dword  $d49640
        .dword  $d41000
        .dword  $d49700

; pointers to character palettes (+$d40000)
_c124cb:
        .addr   $a3c0
        .addr   $a680
        .addr   $a940
        .addr   $ac00
        .addr   $aec0

; ---------------------------------------------------------------------------

; [  ]

_c124d5:
        jsr     $24e2       ; load character graphics
        jsr     $28c4       ; copy character graphics to vram
        stz     $db61
        stz     $db60
        rts

; ---------------------------------------------------------------------------

; [ load character graphics ]

_c124e2:
@24e2:  ldy     #$d000      ; destination address 7f/d000
        sty     $7a
        lda     #$7f
        sta     $7c
        clr_ay
@24ed:  phy
        lda     $cfc6,y     ; character index
        cmp     #$ff
        bne     @2505
        longa
        lda     $7a
        clc
        adc     #$0800
        sta     $7a
        shorta0
        jmp     $259a
@2505:  asl3
        tax
        longa
        lda     $c124a3,x   ; pointer to character graphics
        sta     $70
        lda     $c124a5,x
        sta     $72
        lda     $c124a7,x   ; pointer to character graphics (dead)
        sta     $76
        lda     $c124a9,x
        sta     $78
        shorta0
        lda     $cfca,y
        sta     $7e
        stz     $7f
        ldx     #$0600      ; graphics for each job are $0600 bytes
        stx     $80
        jsr     $fe67       ; ++$82 = +$7e * +$80
        lda     $70
        clc
        adc     $82
        sta     $70
        lda     $71
        adc     $83
        sta     $71
        lda     $72
        adc     $84
        sta     $72
        longa
        clr_ay
@254c:  lda     [$70],y     ; copy character graphics
        sta     [$7a],y
        iny2
        cpy     #$0600
        bne     @254c
        lda     $7a
        clc
        adc     #$0600
        sta     $7a
        clr_ay
@2561:  lda     [$76],y     ; copy dead character graphics
        sta     [$7a],y
        iny2
        cpy     #$00c0
        bne     @2561
        lda     $7a
        clc
        adc     #$00c0
        sta     $7a
        shorta0
        ldy     #$03c0
@257a:  jsr     $25a5
        longa
        tya
        clc
        adc     #$0020
        tay
        shorta0
        cpy     #$0480
        bne     @257a
        longa
        lda     $7a         ; next character
        clc
        adc     #$0080
        sta     $7a
        shorta0
@259a:  ply
        iny
        cpy     #$0004
        beq     @25a4
        jmp     $24ed
@25a4:  rts

; ---------------------------------------------------------------------------

; [  ]

_c125a5:
@25a5:  phy
        ldx     #$0000
        jsr     $25e8
        iny
        ldx     #$0001
        jsr     $25e8
        longa
        tya
        clc
        adc     #$000f
        tay
        shorta0
        ldx     #$0010
        jsr     $25e8
        ldx     #$0011
        iny
        jsr     $25e8
        clr_ay
        longa
@25cf:  lda     $dbf6,y
        sta     [$7a],y
        iny2
        cpy     #$0020
        bne     @25cf
        lda     $7a
        clc
        adc     #$0020
        sta     $7a
        shorta0
        ply
        rts

; ---------------------------------------------------------------------------

; [  ]

_c125e8:
@25e8:  phy
        lda     #$08
        sta     $74
@25ed:  lda     #$08
        sta     $75
        phx
        lda     [$70],y
@25f4:  asl
        ror     $dbf6,x
        inx2
        dec     $75
        bne     @25f4
        iny2
        plx
        dec     $74
        bne     @25ed
        ply
        rts

; ---------------------------------------------------------------------------

; [ load character palettes ]

_c12607:
        clr_ay
@2609:  lda     $cfc6,y     ; character index
        cmp     #$ff
        beq     @2682
        asl
        tax
        lda     $c124cb,x   ; pointers to character palettes
        sta     $70
        sta     $74
        lda     $c124cc,x
        sta     $71
        sta     $75
        lda     $cfca,y     ; job
        longa
        asl5
        clc
        adc     $70
        sta     $70
        tya
        asl5
        tax
        lda     #$02a0      ; pointer for freelancer (for dead sprite)
        clc
        adc     $74
        sta     $74
        shorta0
        phy
        lda     #$d4
        sta     $72
        sta     $76
        clr_ay
@264c:  lda     $ff2b
        bne     @2658
        lda     [$70],y
        sta     $7f89,x
        bra     @265d
@2658:  lda     [$70],y
        sta     $7f09,x
@265d:  inx
        iny
        cpy     #$0020
        bne     @264c
        ply
        tya
        asl5
        tax
        phy
        clr_ay
@266f:  lda     [$74],y
        sta     $ecf6,x
        lda     $7f89,x
        sta     $ed76,x
        inx
        iny
        cpy     #$0020
        bne     @266f
        ply                 ; next character
@2682:  iny
        cpy     #$0004
        bne     @2609
        rts

; ---------------------------------------------------------------------------

_c12689:
        ldx     #$0080
        stx     $70
        ldx     #$97c0
        ldy     #$7800
        lda     #$d4
        jsr     $fca2
        ldy     #$7e48
        ldx     #$0960
        jsr     $26ab
        ldy     #$7f48
        ldx     #$0ae0
        jmp     $26ab
@26ab:  sty     $70
        stx     $76
        lda     #$0a
        sta     $74
@26b3:  lda     $70
        sta     f:$002116
        lda     $71
        sta     f:$002117
        lda     #$08
        sta     $72
        ldx     $76
        ldy     $76
@26c7:  lda     $d497c0,x
        ora     $d497c1,x
        phx
        tyx
        ora     $d497d0,x
        plx
        sta     f:$002119
        iny
        inx2
        dec     $72
        bne     @26c7
        longa
        lda     $76
        clc
        adc     #$0018
        sta     $76
        lda     $70
        clc
        adc     #$0010
        sta     $70
        shorta0
        dec     $74
        bne     @26b3
        rts

; ---------------------------------------------------------------------------

_c126fb:
        phx
        stx     $7e
        ldx     #$0005
        stx     $80
        jsr     $fe67       ; ++$82 = +$7e * +$80
        ldx     $82
        lda     $d4b182,x
        and     #$03
        sta     $71
        lda     $d4b183,x
        sta     $70
        longa
        lda     $70
        asl4
        tax
        clr_ay
@2721:  lda     $ced000,x
        sta     $7f89,y
        iny2
        inx2
        cpy     #$0020
        bne     @2721
        shorta0
        plx
        rts

; ---------------------------------------------------------------------------

; [  ]

_c12736:
        phy
        phx
        stx     $7e
        ldx     #$0005
        stx     $80
        jsr     $fe67       ; ++$82 = +$7e * +$80
        clr_ax
@2744:  stz     $f892,x
        inx
        cpx     #$0020
        bne     @2744
        ldx     $82
        jsr     $2251       ; get pointer to monster graphics
        lda     #$d0
        sta     $78
        lda     $70
        sta     $71
        lda     $d4b182,x
        bmi     @2784
        lda     $d4b184,x
        longa
        asl3
        clc
        adc     $d0d000
        sta     $76
        shorta0
        tax
        tay
@2775:  lda     [$76],y
        sta     $f893,x
        iny
        inx2
        cpy     #$0008
        bne     @2775
        bra     @27a3
@2784:  lda     $d4b184,x
        longa
        asl5
        clc
        adc     $d0d002
        sta     $76
        clr_ay
@2798:  lda     [$76],y
        sta     $f892,y
        iny
        cpy     #$0020
        bne     @2798
@27a3:  longa
        lda     #$f892
        sta     $76
        lda     #$0008
        sta     $7e
        clr_axy
@27b2:  lda     #$0008
        sta     $80
        lda     ($76),y
        sta     $82
        iny2
        lda     ($76),y
        ora     $82
        sta     $82
        iny2
@27c5:  clr_a
        asl     $82
        bcc     @27cb
        inc
@27cb:  sta     $7f7700,x
        clr_a
        asl     $82
        bcc     @27d5
        inc
@27d5:  ora     $7f7700,x
        sta     $7f7700,x
        inx4
        dec     $80
        bne     @27c5
        dec     $7e
        bne     @27b2
        clr_ax
        lda     $70
        bpl     @2819
        lda     #$0010
        sta     $82
@27f4:  lda     #$0010
        sta     $7e
        lda     ($76)
        sta     $80
@27fd:  asl     $80
        bcc     @2806
        jsr     $2900
        bra     @2809
@2806:  jsr     $295e
@2809:  longa
        dec     $7e
        bne     @27fd
        inc     $76
        inc     $76
        dec     $82
        bne     @27f4
        bra     @2841
@2819:  lda     #$0010
        sta     $82
@281e:  lda     #$0010
        sta     $7e
        lda     ($76)
        sta     $80
@2827:  asl     $80
        bcc     @2830
        jsr     $28d7
        bra     @2833
@2830:  jsr     $295e
@2833:  longa
        dec     $7e
        bne     @2827
        inc     $76
        inc     $76
        dec     $82
        bne     @281e
@2841:  clr_ax
        lda     #$0080
        sta     $72
@2848:  lda     #$0010
        sta     $70
@284d:  lda     $7fd000,x
        sta     $7e
        lda     $7fd020,x
        sta     $7fd000,x
        lda     $7e
        sta     $7fd020,x
        inx2
        dec     $70
        bne     @284d
        txa
        clc
        adc     #$0020
        tax
        dec     $72
        bne     @2848
        lda     #$f892
        sta     $76
        lda     #$0010
        sta     $7e
        stz     $84
        stz     $72
        clr_ay
@2881:  lda     #$0010
        sta     $80
        lda     ($76),y
        sta     $82
        stz     $70
        lda     ($76),y
        beq     @2892
        inc     $72
@2892:  asl     $82
        bcc     @289e
        lda     $70
        cmp     $84
        bcc     @289e
        sta     $84
@289e:  inc     $70
        dec     $80
        bne     @2892
        iny2
        dec     $7e
        bne     @2881
        shorta0
        lda     $72
        pha
        lda     $84
        pha
        jsr     $28c4       ; copy character graphics to vram
        pla
        inc
        sta     $74
        pla
        sta     $76
        stz     $75
        stz     $77
        plx
        ply
        rts

; ---------------------------------------------------------------------------

; [ copy character graphics to vram ]

_c128c4:
@28c4:  phx
        ldx     #$2000      ; size
        stx     $70
        ldx     #$d000      ; 7f/d000 (character graphics buffer)
        ldy     #$6000      ; vram address
        lda     #$7f
        jsr     $fd27
        plx
        rts

; ---------------------------------------------------------------------------

; [  ]

_c128d7:
@28d7:  longa
        clr_ay
@28db:  lda     [$72],y
        jsr     $293d
        sta     $7fd000,x
        inx2
        iny2
        cpy     #$0020
        bne     @28db
        lda     $72
        clc
        adc     #$0020
        sta     $72
        lda     $74
        adc     #$0000
        sta     $74
        shorta0
        rts
@2900:  longa
        clr_ay
@2904:  lda     [$72],y
        jsr     $293d
        sta     $7fd000,x
        inx2
        iny2
        cpy     #$0010
        bne     @2904
@2916:  lda     [$72],y
        and     #$00ff
        jsr     $293d
        sta     $7fd000,x
        inx2
        iny
        cpy     #$0018
        bne     @2916
        lda     $72
        clc
        adc     #$0018
        sta     $72
        lda     $74
        adc     #$0000
        sta     $74
        shorta0
        rts
@293d:  phx
        sta     $84
        shorta
        ldx     #$0008
        lda     $84
@2947:  asl
        ror     $84
        dex
        bne     @2947
        ldx     #$0008
        lda     $85
@2952:  asl
        ror     $85
        dex
        bne     @2952
        longa
        lda     $84
        plx
        rts
@295e:  longa
        ldy     #$0010
        clr_a
@2964:  sta     $7fd000,x
        inx2
        dey
        bne     @2964
        shorta0
        rts

; ---------------------------------------------------------------------------

; [ draw big text string ]

_c12971:
        ldx     $bca0
        stx     $b8
        lda     $bca2
        sta     $ba
@297b:  lda     [$b8]
        beq     @2999
        cmp     #$01
        beq     @2999
        cmp     #$20
        bcc     @2990
        jsr     $2cf1
        jsr     $299a       ; get next byte
        jmp     $297b
@2990:  jsr     $29a0       ; do big text escape code
        jsr     $299a       ; get next byte
        jmp     $297b
@2999:  rts

; ---------------------------------------------------------------------------

; [ get next byte of string ]

_c1299a:
@299a:  ldx     $b8
        inx
        stx     $b8
        rts

; ---------------------------------------------------------------------------

; [ do big text escape code ]

_c129a0:
@29a0:  asl
        tax
        lda     $c129b1,x
        sta     $70
        lda     $c129b2,x
        sta     $71
        jmp     ($0070)

; ---------------------------------------------------------------------------

; jump table for escape codes $00-$1f
_c129b1:
        .addr   $2f0f,$2f0f,$2f0f,$2f0f,$2f0f,$2c9a,$2f0f,$2f0f ; $00
        .addr   $2f0f,$2f0f,$2f0f,$2f0f,$2f0f,$2f0f,$2c81,$2c15
        .addr   $2b35,$2b13,$2af9,$2a90,$2a6e,$2a2f,$29f1,$2f0f ; $10
        .addr   $2bdb,$2b9d,$2bb6,$2f0f,$2f0f,$2f0f,$2cab,$2cb2

; ---------------------------------------------------------------------------

; [ $16: butz' name ]

_c129f1:
        clr_ax
        stz     $7e
@29f5:  lda     $0500,x
        and     #$07
        beq     @2a0e
        longa
        txa
        clc
        adc     #$0050
        tax
        shorta0
        cpx     #$0140
        bne     @29f5
        stz     $7e
@2a0e:  lda     $7e
        tax
        lda     $c12a2a,x
        tax
        lda     #$06        ; copy 6 letters
        sta     $70
@2a1a:  lda     $0990,x
        cmp     #$ff
        beq     @2a29
        jsr     $2cf1
        inx
        dec     $70
        bne     @2a1a
@2a29:  rts

; ---------------------------------------------------------------------------

; pointers to character names (+$0990)
_c12a2a:
        .byte   $00,$06,$0c,$12,$18

; ---------------------------------------------------------------------------

; [ $15: battle command name ]

_c12a2f:
        lda     ($f4)       ; message variable
        bmi     @2a4b
        jsr     $2bcf
.if LANG_EN
        lda     #$07
        sta     $70
@2a3a:  lda     $e01150,x
.else
        lda     #$05
        sta     $70
@2a3a:  lda     $d15800,x
.endif
        cmp     #$ff
        beq     @2a4a
        jsr     $2cf1
        inx
        dec     $70
        bne     @2a3a
@2a4a:  rts
@2a4b:  sec
        sbc     #$80
        sta     $7e
.if LANG_EN
        lda     #$18
.else
        lda     #$08
.endif
        sta     $80
        jsr     $feba       ; +$82 = $7e * $80
        ldx     $82
.if LANG_EN
        lda     #$18
        sta     $70
@2a5d:  lda     $e77060,x
.else
        lda     #$08
        sta     $70
@2a5d:  lda     $d16200,x
.endif
        cmp     #$ff
        beq     @2a6d
        jsr     $2cf1
        inx
        dec     $70
        bne     @2a5d
@2a6d:  rts

; ---------------------------------------------------------------------------

; [ $14: job name ]

_c12a6e:
        lda     ($f4)
        sta     $7e
        lda     #$08
        sta     $80
        jsr     $feba       ; +$82 = $7e * $80
        ldx     $82
        lda     #$08
        sta     $70
@2a7f:  lda     $d15600,x
        cmp     #$ff
        beq     @2a8f
        jsr     $2cf1
        inx
        dec     $70
        bne     @2a7f
@2a8f:  rts

; ---------------------------------------------------------------------------

; [ $13: attack name ]

_c12a90:
        lda     ($f4)
        cmp     #$57
        bcc     @2ab7
        sec
        sbc     #$57
        sta     $7e
.if LANG_EN
        lda     #$18
.else
        lda     #$09
.endif
        sta     $70
        sta     $80
        jsr     $feba       ; +$82 = $7e * $80
        ldx     $82
@2aa6:
.if LANG_EN
        lda     $e71780,x
.else
        lda     $d11e8a,x
.endif
        cmp     #$ff
        beq     @2ab6
        jsr     $2cf1
        inx
        dec     $70
        bne     @2aa6
@2ab6:  rts
@2ab7:  cmp     #$48
        bcc     @2ad9
        sta     $7e
        lda     #$06
        sta     $70
        sta     $80
        jsr     $feba       ; +$82 = $7e * $80
        ldx     $82
@2ac8:  lda     $d11c80,x
        cmp     #$ff
        beq     @2ad8
        jsr     $2cf1
        inx
        dec     $70
        bne     @2ac8
@2ad8:  rts
@2ad9:  sta     $7e
        lda     #$06
        sta     $80
        lda     #$05
        sta     $70
        jsr     $feba       ; +$82 = $7e * $80
        ldx     $82
@2ae8:  lda     $d11c81,x
        cmp     #$ff
        beq     @2af8
        jsr     $2cf1
        inx
        dec     $70
        bne     @2ae8
@2af8:  rts

; ---------------------------------------------------------------------------

; [ $12: item name ]

_c12af9:
        lda     ($f4)
        jsr     $2c75
.if LANG_EN
        lda     #$18
        sta     $70
@2b02:  lda     $e75860,x
        jml     $e02f25
.else
        lda     #$08
        sta     $70
@2b02:  lda     $d11381,x
        cmp     #$ff
        beq     @2b12
.endif
        jsr     $2cf1
        inx
        dec     $70
        bne     @2b02
@2b12:  rts

; ---------------------------------------------------------------------------

; [ $11: character name ]

_c12b13:
        lda     ($f4)
        sta     $7e
        lda     #$06
        sta     $80
        jsr     $feba       ; +$82 = $7e * $80
        ldx     $82
        lda     #$06
        sta     $76
@2b24:  lda     f:$000990,x
        cmp     #$ff
        beq     @2b34
        jsr     $2cf1
        inx
        dec     $76
        bne     @2b24
@2b34:  rts

; ---------------------------------------------------------------------------

; [  ]

_c12b35:
        phy
        jsr     $299a       ; get next byte
        lda     [$b8]
        sta     $7e
        asl
        clc
        adc     $7e
        tay
        lda     ($f4),y
        sta     $70
        iny
        lda     ($f4),y
        sta     $71
        iny
        lda     ($f4),y
        sta     $72
        lda     $70
        cmp     #$ff
        bne     @2b72
        lda     $71
        cmp     #$ff
        bne     @2b72
        lda     $72
        cmp     #$ff
        bne     @2b72
        ldx     #$0000
@2b65:  lda     #$cb
        jsr     $2cf1
        inx
        cpx     #$0004
        bne     @2b65
        ply
        rts
@2b72:  jsr     $ff88       ; convert hex to decimal digits
        jsr     $fefe
@2b78:  lda     $c4,x
        jsr     $2cf1
        inx
        cpx     #$0008
        bne     @2b78
        ply
        rts

; ---------------------------------------------------------------------------

; [  ]

_c12b85:
@2b85:  sta     $7e
        lda     #$09
        sta     $80
        jsr     $feba       ; +$82 = $7e * $80
        ldx     $82
        rts

; ---------------------------------------------------------------------------

; [  ]

_c12b91:
@2b91:  sta     $7e
.if LANG_EN
        lda     #$10
.else
        lda     #$08
.endif
        sta     $80
        jsr     $feba       ; +$82 = $7e * $80
        ldx     $82
        rts

; ---------------------------------------------------------------------------

; [ $19: special ability name (animals/conjure/combine/terrain) ]

_c12b9d:
        jsr     $299a       ; get next byte
.if LANG_EN
        jsl     $e02fb2
        nop
        lda     #$10
        sta     $70
@2ba9:  lda     $e70900,x
.else
        lda     [$b8]
        jsr     $2b85
        lda     #$09
        sta     $70
@2ba9:  lda     $d16700,x
.endif
        jsr     $2cf1
        inx
        dec     $70
        bne     @2ba9
        rts

; ---------------------------------------------------------------------------

; [ $1a: monster special attack name ]

_c12bb6:
        jsr     $299a       ; get next byte
        lda     [$b8]
        jsr     $2b91
.if LANG_EN
        lda     #$10
        sta     $70
@2bc2:  lda     $e73700,x
.else
        lda     #$08
        sta     $70
@2bc2:  lda     $d08700,x
.endif
        jsr     $2cf1
        inx
        dec     $70
        bne     @2bc2
        rts
@2bcf:  sta     $7e
.if LANG_EN
        lda     #$07
.else
        lda     #$05
.endif
        sta     $80
        jsr     $feba       ; +$82 = $7e * $80
        ldx     $82
        rts

; ---------------------------------------------------------------------------

; [ $18: ability name ]

_c12bdb:
        jsr     $299a       ; get next byte
        lda     [$b8]
        cmp     #$80
        bcc     @2c01
        sec
        sbc     #$80
        sta     $7e
.if LANG_EN
        lda     #$18
.else
        lda     #$08
.endif
        sta     $70
        sta     $80
        jsr     $feba       ; +$82 = $7e * $80
        ldx     $7e
@2bf4:
.if LANG_EN
        lda     $e77060,x
.else
        lda     $d16200,x
.endif
        jsr     $2cf1
        inx
        dec     $70
        bne     @2bf4
        rts
@2c01:  jsr     $2bcf
.if LANG_EN
        lda     #$07
        sta     $70
@2c08:  lda     $e01150,x
.else
        lda     #$05
        sta     $70
@2c08:  lda     $d15800,x
.endif
        jsr     $2cf1
        inx
        dec     $70
        bne     @2c08
        rts

; ---------------------------------------------------------------------------

; [ $0f: attack name ]

_c12c15:
        jsr     $299a       ; get next byte
        lda     [$b8]
        cmp     #$57
        bcc     @2c3b
        sec
        sbc     #$57
        sta     $7e
.if LANG_EN
        lda     #$18
.else
        lda     #$09
.endif
        sta     $70
        sta     $80
        jsr     $feba       ; +$82 = $7e * $80
        ldx     $82
@2c2e:
.if LANG_EN
        lda     $e71780,x
.else
        lda     $d11e8a,x
.endif
        jsr     $2cf1
        inx
        dec     $70
        bne     @2c2e
        rts
@2c3b:  cmp     #$48
        bcc     @2c59
        sta     $7e
        lda     #$06
        sta     $70
        sta     $80
        jsr     $feba       ; +$82 = $7e * $80
        ldx     $82
@2c4c:  lda     $d11c80,x
        jsr     $2cf1
        inx
        dec     $70
        bne     @2c4c
        rts
@2c59:  sta     $7e
        lda     #$06
        sta     $80
        lda     #$05
        sta     $70
        jsr     $feba       ; +$82 = $7e * $80
        ldx     $82
@2c68:  lda     $d11c81,x
        jsr     $2cf1
        inx
        dec     $70
        bne     @2c68
        rts
@2c75:  sta     $7e
.if LANG_EN
        lda     #$18
.else
        lda     #$09
.endif
        sta     $80
        jsr     $feba       ; +$82 = $7e * $80
        ldx     $82
        rts

; ---------------------------------------------------------------------------

; [ $0e: item name ]

_c12c81:
        jsr     $299a       ; get next byte
        lda     [$b8]
        jsr     $2c75
.if LANG_EN
        jml     $e00000
        jsr     $2cf1
        jml     $e00014
        nop5
.else
        lda     #$08
        sta     $70
@2c8d:  lda     $d11381,x
        jsr     $2cf1
        inx
        dec     $70
        bne     @2c8d
.endif
        rts

; ---------------------------------------------------------------------------

_c12c9a:
        jsr     $299a       ; get next byte
        lda     [$b8]
        sta     $70
@2ca1:  lda     #$ff
        jsr     $2cf1
        dec     $70
        bne     @2ca1
        rts

; ---------------------------------------------------------------------------

; [  ]

_c12cab:
        ldx     #$0000
        stx     $70
        bra     _2cb7

; ---------------------------------------------------------------------------

; [ $1f: kanji ]

_c12cb2:
        ldx     #$0100
        stx     $70
_2cb7:  phy
        phx
        jsr     $299a       ; get next byte
        lda     [$b8]
        longa
        clc
        adc     $70
        sta     $7e
        shorta0
        ldx     #$0018
        stx     $80
        jsr     $fe67       ; ++$82 = +$7e * +$80
        ldx     $82
        ldy     #$0000
@2cd5:  lda     $dbd000,x   ; kanji graphics
        sta     $f508,y
        lda     $dbd00c,x
        sta     $f514,y
        clr_a
        sta     $f520,y
        inx
        iny
        cpy     #$000c
        bne     @2cd5
        jmp     $2d1f

; ---------------------------------------------------------------------------

; [ draw kana ]

_c12cf1:
@2cf1:  phy
        phx
.if LANG_EN
        jml     $e02e52
.else
        sec
        sbc     #$20
        tax
.endif
        stx     $7e
        ldx     #$0018
        stx     $80
        jsr     $fe67       ; ++$82 = +$7e * +$80
        ldx     $82
        ldy     #$0000
@2d06:
.if LANG_EN
        jsl     $e03201
        sta     $f508,y
        jsl     $e03213
        sta     $f514,y
.else
        lda     $c3eb00,x   ; kana graphics
        sta     $f508,y
        lda     $c3eb0c,x
        sta     $f514,y
.endif
        clr_a
        sta     $f520,y
        inx
        iny
        cpy     #$000c
        bne     @2d06
@2d1f:  lda     $f507       ; text horizontal position
        and     #$07
        beq     @2d3e
        sta     $74
@2d28:  ldx     #$0000
@2d2b:  lsr     $f508,x     ; shift pixels right
        ror     $f514,x
        ror     $f520,x
        inx
        cpx     #$000c
        bne     @2d2b
        dec     $74
        bne     @2d28
@2d3e:  lda     $f507
        lsr3
        sta     $7e
        lda     #$10
        sta     $80
        jsr     $feba       ; +$82 = $7e * $80
        ldx     $82
        lda     $dbf1       ; $dfb1 determines which buffer to draw to
        beq     @2d7b
        ldy     #$0000
@2d57:  lda     $a937,x
        ora     $f508,y
        sta     $a937,x
        lda     $a947,x
        ora     $f514,y
        sta     $a947,x
        lda     $a957,x
        ora     $f520,y
        sta     $a957,x
        inx
        iny
        cpy     #$000c
        bne     @2d57
        bra     @2da0
@2d7b:  ldy     #$0000
@2d7e:  lda     $f357,x
        ora     $f508,y
        sta     $f357,x
        lda     $f367,x
        ora     $f514,y
        sta     $f367,x
        lda     $f377,x
        ora     $f520,y
        sta     $f377,x
        inx
        iny
        cpy     #$000c
        bne     @2d7e
@2da0:  lda     $f507
        clc
.if LANG_EN
        jml     $e02e5e
        nop
.else
        adc     #$0d        ; all characters are 13 pixels wide
        sta     $f507
.endif
        plx
        ply
        rts

; ---------------------------------------------------------------------------

; [ draw small text ]

_c12dac:
        lda     $bca5       ; tile flags
        sta     $be
        asl     $bca4
        ldx     $bca0       ; source address
        stx     $b8
        ldx     $bca2       ; destination address
        stx     $ba
        lda     $ba
        clc
        adc     $bca4       ; line width (kana line - dakuten line)
        sta     $bc
        lda     $bb
        adc     #$00
        sta     $bd
        ldy     #$0000
@2dcf:  lda     ($b8)
        beq     @2de9
        cmp     #$20
        bcc     @2de0
        jsr     $2dea       ; draw small text character
        jsr     $299a       ; get next byte
        jmp     $2dcf
@2de0:  jsr     $2f5d       ; decode small text escape code
        jsr     $299a       ; get next byte
        jmp     $2dcf
@2de9:  rts

; ---------------------------------------------------------------------------

; [ draw small text character ]

_c12dea:
@2dea:  cmp     #$53
        bcc     @2dfd
@2dee:  sta     ($bc),y
        lda     #$ff        ; no dakuten
@2df2:  sta     ($ba),y
        iny
        lda     $be         ; tile flags
        sta     ($bc),y
        sta     ($ba),y
        iny
        rts
@2dfd:  cmp     #$49
        bcc     @2e0b
        clc
        adc     #$17
        sta     ($bc),y
        lda     #$52        ; handakuten
        jmp     $2df2
@2e0b:  clc
        adc     #$40
        sta     ($bc),y
        lda     #$51        ; dakuten
        jmp     $2df2

; ---------------------------------------------------------------------------

; jump table for small text escape codes $00-$20
_c12e15:
        .addr   $2f0f,$2f10,$2f0f,$2f55,$2f0f,$2f31,$2f42,$3061 ; $00
        .addr   $306e,$307b,$3088,$3004,$303e,$2f29,$2fe3,$2fa3
        .addr   $2ebf,$2e9a,$2e9f,$2ea4,$2e55,$2f0f,$2f0f,$2f0f ; $10
        .addr   $2f0f,$2f0f,$2f0f,$2f6e,$2f0f,$2f0f,$2f0f,$2f0f

; ---------------------------------------------------------------------------

; [ small text escape code $14: average experience ]

_c12e55:
        clr_ax
        stx     $70
        stx     $72
@2e5b:  lda     $70
        clc
        adc     $0503,x
        sta     $70
        lda     $71
        adc     $0504,x
        sta     $71
        lda     $72
        adc     $0505,x
        sta     $72
        lda     $73
        adc     #$00
        sta     $73
        longa
        txa
        clc
        adc     #$0050
        tax
        shorta0
        cpx     #$0140
        bne     @2e5b
        ror     $73
        ror     $72
        ror     $71
        ror     $70
        ror     $73
        ror     $72
        ror     $71
        ror     $70
        jmp     $2eab

; ---------------------------------------------------------------------------

; [ small text escape code $11: battle count ]

_c12e9a:
        ldx     $09c0       ; battle count
        bra     _2ea7

; ---------------------------------------------------------------------------

; [ small text escape code $12: monsters slain ]

_c12e9f:
        ldx     $094e       ; monsters slain
        bra     _2ea7

; ---------------------------------------------------------------------------

; [ small text escape code $13: save count ]

_c12ea4:
        ldx     $09c2       ; save count
_2ea7:  stx     $70
        stz     $72
@2eab:  phy
        jsr     $ff88       ; convert hex to decimal digits
        jsr     $fefe
        ply
@2eb3:  lda     $c4,x
        jsr     $2dea       ; draw small text character
        inx
        cpx     #$0008
        bne     @2eb3
        rts

; ---------------------------------------------------------------------------

; [ small text escape code $10: percentage of treasures ]

_c12ebf:
        clr_ax
        stz     $7e
@2ec3:  lda     #$08
        sta     $80
        lda     $09d4,x
@2eca:  asl
        bcc     @2ecf
        inc     $7e
@2ecf:  dec     $80
        bne     @2eca
        inx
        cpx     #$0020
        bne     @2ec3
        stz     $7f
        lda     $7e
        cmp     #$fc
        bne     @2ef0       ; branch if not 100%
        lda     #$54
        jsr     $2dea       ; draw small text character
        lda     #$53
        jsr     $2dea       ; draw small text character
        lda     #$53
        jmp     $2dea       ; draw small text character
@2ef0:  ldx     #$0f80
        stx     $80
        jsr     $fe67       ; ++$82 = +$7e * +$80
        ldx     $82
        stx     $70
        ldx     $84
        stx     $72
        jsr     $ff88       ; convert hex to decimal digits
        lda     a:$00c6
        jsr     $2dea       ; draw small text character
        lda     a:$00c7
        jmp     $2dea       ; draw small text character

; ---------------------------------------------------------------------------

_c12f0f:
        rts

; ---------------------------------------------------------------------------

; [ small text escape code $01:  ]

_c12f10:
        lda     $bca4
        longa
        pha
        asl
        clc
        adc     $ba
        sta     $ba
        pla
        clc
        adc     $ba
        sta     $bc
        lda     #$0000
        tay
        shorta
        rts

; ---------------------------------------------------------------------------

; [ small text escape code $0d:  ]

_c12f29:
        jsr     $299a       ; get next byte
        lda     ($b8)
        sta     $be
        rts

; ---------------------------------------------------------------------------

; [ small text escape code $05:  ]

_c12f31:
        jsr     $299a       ; get next byte
        lda     ($b8)
        sta     $70
@2f38:  lda     #$ff
        jsr     $2dea       ; draw small text character
        dec     $70
        bne     @2f38
        rts

; ---------------------------------------------------------------------------

; [ small text escape code $06:  ]

_c12f42:
        jsr     $299a       ; get next byte
        lda     ($b8)
        sta     $70
@2f49:  lda     #$00
        sta     ($bc),y
        jsr     $2df2
        dec     $70
        bne     @2f49
        rts

; ---------------------------------------------------------------------------

; [ small text escape code $03:  ]

_c12f55:
        jsr     $299a       ; get next byte
        lda     ($b8)
        jmp     $2dee

; ---------------------------------------------------------------------------

; [ decode small text escape code ]

_c12f5d:
@2f5d:  asl
        tax
        lda     $c12e15,x
        sta     $70
        lda     $c12e16,x
        sta     $71
        jmp     ($0070)

; ---------------------------------------------------------------------------

; [ small text escape code $1b: variable ]

_c12f6e:
        jsr     $299a       ; get next byte
        stz     $70
        lda     ($b8)
@2f75:  sec
        sbc     #$0a
        bcc     @2f7f
        inc     $70
        jmp     $2f75
@2f7f:  clc
        adc     #$0a
        sta     $71
        lda     $70
        bne     @2f8a       ; branch if two digits
        lda     #$ac        ; this is a hack to draw a space ($ac + $53 = $ff)
@2f8a:  clc
        adc     #$53
        jsr     $2dee
        lda     $71
        ora     $70
        bne     @2f9b
        lda     #$ff
        jmp     $2dee
@2f9b:  lda     $71
        clc
        adc     #$53
        jmp     $2dee

; ---------------------------------------------------------------------------

; [ small text escape code $0f: attack name ]

_c12fa3:
        jsr     $299a       ; get next byte
        lda     ($b8)
        cmp     #$57
        bcc     @2fc9
        sec
        sbc     #$57
        sta     $7e
.if LANG_EN
        jml     $e02fc9
.else
        lda     #$09
        sta     $70
.endif
        sta     $80
        jsr     $feba       ; +$82 = $7e * $80
        ldx     $82
@2fbc:
.if LANG_EN
        lda     $e70f90,x   ; short attack names
.else
        lda     $d11e8a,x   ; short attack names
.endif
        jsr     $2dea       ; draw small text character
        inx
        dec     $70
        bne     @2fbc
        rts
@2fc9:  sta     $7e
        lda     #$06
        sta     $70
        sta     $80
        jsr     $feba       ; +$82 = $7e * $80
        ldx     $82
@2fd6:  lda     $d11c80,x   ; spell names
        jsr     $2dea       ; draw small text character
        inx
        dec     $70
        bne     @2fd6
        rts

; ---------------------------------------------------------------------------

; [ small text escape code $0e: item name ]

_c12fe3:
        jsr     $299a       ; get next byte
        lda     ($b8)
        sta     $7e
        lda     #$09
        sta     $80
        jsr     $feba       ; +$82 = $7e * $80
        ldx     $82
        lda     #$09
        sta     $76
@2ff7:  lda     $d11380,x   ; item names
        jsr     $2dea       ; draw small text character
        inx
        dec     $76
        bne     @2ff7
        rts

; ---------------------------------------------------------------------------

; [ small text escape code $0b: monster name ]

_c13004:
        jsr     $299a       ; get next byte
        lda     ($b8)
        asl2
        tax
        longa
        lda     $4038,x
.if LANG_EN
        jsl     $e00030
        shorta0
        lda     #$0a
.else
        asl3
        tax
        shorta0
        lda     #$08
.endif
        sta     $70
        lda     f:$0004f1
        cmp     #$02
        bne     @3031
@3024:
.if LANG_EN
        lda     $e00a50,x
.else
        lda     $d06400,x
.endif
        jsr     $2dea       ; draw small text character
        inx
        dec     $70
        bne     @3024
        rts
@3031:
.if LANG_EN
        lda     $e00050,x
.else
        lda     $d05c00,x
.endif
        jsr     $2dea       ; draw small text character
        inx
        dec     $70
        bne     @3031
        rts

; ---------------------------------------------------------------------------

; [ small text escape code $0c:  ]

_c1303e:
        jsr     $299a       ; get next byte
        ldx     $04f0
        cpx     #$01ef
        beq     @3060
        cpx     #$01e6
        beq     @3060
        lda     ($b8)
        asl2
        tax
        lda     $403a,x
        cmp     #$02
.if LANG_EN
        jsl     $e00020
        nop4
.else
        bcc     @3060
        clc
        adc     #$53
        jsr     $2dea       ; draw small text character
.endif
@3060:  rts

; ---------------------------------------------------------------------------

; [ small text escape code $07:  ]

_c13061:
        ldx     #$2000
        stx     $70
        ldx     #$382c
        stx     $78
        jmp     $3092

; ---------------------------------------------------------------------------

; [ small text escape code $08:  ]

_c1306e:
        ldx     #$2080
        stx     $70
        ldx     #$3834
        stx     $78
        jmp     $3092

; ---------------------------------------------------------------------------

; [ small text escape code $09:  ]

_c1307b:
        ldx     #$2100
        stx     $70
        ldx     #$383c
        stx     $78
        jmp     $3092

; ---------------------------------------------------------------------------

; [ small text escape code $0a:  ]

_c13088:
        ldx     #$2180
        stx     $70
        ldx     #$3844
        stx     $78
@3092:  lda     #$7e
        sta     $72
        jsr     $299a       ; get next byte
        lda     ($b8)
        asl
        tax
        lda     f:_c130ac,x
        sta     $7e
        lda     f:_c130ac+1,x
        sta     $7f
        jmp     ($007e)

_c130ac:
        .addr   $327b,$313f,$3144,$3149,$314e,$315d,$3177,$3182
        .addr   $318d,$3198,$3112,$30e5,$31a3,$31aa,$31b1,$31b8
        .addr   $31bf,$31c6,$3158,$3153,$30d6

; ---------------------------------------------------------------------------

; [  ]

_c130d6:
        lda     $08f4
        tax
        jsr     $ff2e
        jsr     $ff12
        clr_ax
        jmp     $32f0
        phy
        ldy     #$0003
        lda     [$70],y
        sta     $74
        iny
        lda     [$70],y
        sta     $75
        iny
        lda     [$70],y
        sta     $72
        lda     $74
        sta     $70
        lda     $75
        sta     $71
        jsr     $ff88       ; convert hex to decimal digits
        jsr     $fefe
        ply
@3106:  lda     $c4,x
        jsr     $2dea       ; draw small text character
        inx
        cpx     #$0008
        bne     @3106
        rts

; ---------------------------------------------------------------------------

_c13112:
        phy
        ldy     #$0001
        lda     [$70],y
        ply
        sta     $7e
        lda     #$08
        sta     $80
        jsr     $feba       ; +$82 = $7e * $80
        ldx     $82
        lda     #$08
        sta     $70
        stz     $fef5
@312b:  lda     $d15600,x
        cmp     #$ff
        beq     @313e
        inc     $fef5
        jsr     $2dea       ; draw small text character
        inx
        dec     $70
        bne     @312b
@313e:  rts

; ---------------------------------------------------------------------------

_c1313f:
        lda     #$00
        jmp     $32bc

_c13144:
        lda     #$02
        jmp     $32bc

_c13149:
        lda     #$04
        jmp     $32cb

_c1314e:
        lda     #$06
        jmp     $32cb

_c13153:
        lda     #$06
        jmp     $32ed

_c13158:
        lda     #$02
        jmp     $32da

_c1315d:
        phy
        ldy     #$0002
        lda     [$70],y
        tax
        jsr     $ff2e
        ply
        ldx     #$0000
@316b:  lda     $c6,x
        jsr     $2dea       ; draw small text character
        inx
        cpx     #$0002
        bne     @316b
        rts

; ---------------------------------------------------------------------------

_c13177:
        lda     #$16
        jsr     $3231
        lda     $72
        sta     $fef0
        rts

; ---------------------------------------------------------------------------

_c13182:
        lda     #$17
        jsr     $3231
        lda     $72
        sta     $fef1
        rts

; ---------------------------------------------------------------------------

_c1318d:
        lda     #$18
        jsr     $3231
        lda     $72
        sta     $fef2
        rts

; ---------------------------------------------------------------------------

_c13198:
        lda     #$19
        jsr     $3231
        lda     $72
        sta     $fef3
        rts

; ---------------------------------------------------------------------------

_c131a3:
        jsr     $31cd
        sta     $fef0
        rts

; ---------------------------------------------------------------------------

_c131aa:
        jsr     $31cd
        sta     $fef1
        rts

; ---------------------------------------------------------------------------

_c131b1:
        jsr     $31cd
        sta     $fef2
        rts

; ---------------------------------------------------------------------------

_c131b8:
        jsr     $31cd
        sta     $fef3
        rts

; ---------------------------------------------------------------------------

_c131bf:
        jsr     $31cd
        sta     $fef4
        rts

; ---------------------------------------------------------------------------

_c131c6:
        jsr     $31cd
        sta     $fef5
        rts

; ---------------------------------------------------------------------------

; [  ]

_c131cd:
@31cd:  jsr     $299a       ; get next byte
        lda     ($b8)
        tax
        lda     $b535,x
        pha
        jsr     $3236
        pla
        cmp     #$2c
        bcc     @31fb
        cmp     #$4c
        bcc     @31e5
        bra     @31fb
@31e5:  pha
        lda     #$2b
        jsr     $2dee
        pla
        sec
        sbc     #$2c
        tax
        lda     f:_c13211,x
        jsr     $2dee
        inc     $72
        inc     $72
@31fb:  lda     $72
@31fd:  cmp     #$08
        beq     @320e
        sta     $73
        lda     #$00
        jsr     $2dee
        inc     $73
        lda     $73
        bra     @31fd
@320e:  lda     $72
        rts

; ---------------------------------------------------------------------------

_c13211:
        .byte   $54,$55,$56,$57,$58,$59,$54,$55,$56,$57,$58,$59,$54,$55,$56,$57
        .byte   $58,$59,$54,$55,$56,$57,$58,$59,$54,$55,$56,$57,$58,$54,$55,$56

; ---------------------------------------------------------------------------

; [  ]

_c13231:
@3231:  phy
        tay
        lda     [$70],y
        ply
@3236:  cmp     #$80
        bcc     @325f
        sec
        sbc     #$80
        sta     $7e
.if LANG_EN
        lda     #$18
.else
        lda     #$08
.endif
        sta     $70
        sta     $80
        jsr     $feba       ; +$82 = $7e * $80
        ldx     $82
        stz     $72
@324c:
.if LANG_EN
        lda     $e77060,x
.else
        lda     $d16200,x
.endif
        cmp     #$ff
        beq     @325e
        inc     $72
        jsr     $2dea       ; draw small text character
        inx
        dec     $70
        bne     @324c
@325e:  rts
@325f:  jsr     $2bcf
.if LANG_EN
        lda     #$07
.else
        lda     #$05
.endif
        sta     $70
        stz     $72
@3268:
.if LANG_EN
        lda     $e01150,x
.else
        lda     $d15800,x
.endif
        cmp     #$ff
        beq     @327a
        inc     $72
        jsr     $2dea       ; draw small text character
        inx
        dec     $70
        bne     @3268
@327a:  rts

; ---------------------------------------------------------------------------

_c1327b:
        lda     [$70]
        and     #$07
        sta     $7e
        lda     #$06
        sta     $80
        jsr     $feba       ; +$82 = $7e * $80
        ldx     $82
        lda     #$06
        sta     $76
        stz     $fef4
@3291:  lda     f:$000990,x   ; character names
        cmp     #$ff
        beq     @329c
        inc     $fef4
@329c:  jsr     $2dea       ; draw small text character
        inx
        dec     $76
        bne     @3291
        rts

; ---------------------------------------------------------------------------

_c132a5:
@32a5:  phy
        tay
        lda     ($78),y
        sta     $74
        iny
        lda     ($78),y
        sta     $75
        ply
        ldx     $74
        jsr     $ff2e
        jsr     $ff12
        clr_ax
        rts

; ---------------------------------------------------------------------------

_c132bc:
@32bc:  jsr     $32a5
@32bf:  lda     $c4,x
        jsr     $2dea       ; draw small text character
        inx
        cpx     #$0004
        bne     @32bf
        rts

; ---------------------------------------------------------------------------

_c132cb:
@32cb:  jsr     $32a5
@32ce:  lda     $c5,x
        jsr     $2dea       ; draw small text character
        inx
        cpx     #$0003
        bne     @32ce
        rts

; ---------------------------------------------------------------------------

_c132da:
@32da:  jsr     $32a5
@32dd:  lda     $c4,x
        cmp     #$ff
        beq     @32e6
        jsr     $2dea       ; draw small text character
@32e6:  inx
        cpx     #$0004
        bne     @32dd
        rts

; ---------------------------------------------------------------------------

_c132ed:
@32ed:  jsr     $32a5
@32f0:  lda     $c5,x
        cmp     #$ff
        beq     @32f9
        jsr     $2dea       ; draw small text character
@32f9:  inx
        cpx     #$0003
        bne     @32f0
        rts

; ---------------------------------------------------------------------------

_c13300:
@3300:  lda     #$ff
        jsr     $2dee
        dex
        bne     @3300
        rts

; ---------------------------------------------------------------------------

_c13309:
        lda     $f8bd
        cmp     #$ff
        beq     @3359
        inc     $f8c2
        ldx     $f8be
        stx     $88
        lda     #$d4
        sta     $8a
        ldy     $f8c0
        lda     [$88],y
        cmp     #$ff
        bne     @3327
        clr_ay
@3327:  lda     [$88],y
        bmi     @3330
        ldx     #$0000
        bra     @3333
@3330:  ldx     #$0020
@3333:  iny
        sty     $f8c0
        and     #$7f
        longa
        asl5
        txy
        tax
        lda     #$0010
        sta     $88
@3347:  lda     $d4bb31,x
        sta     $7e29,y
        inx2
        iny2
        dec     $88
        bne     @3347
        shorta0
@3359:  rts

; ---------------------------------------------------------------------------

; [ load battle bg ]

_c1335a:
        lda     $04f2       ; battle bg
        longa
        asl3
        tax
        stx     $bca6       ; pointer to battle bg properties (+$d4ba21)
        shorta0
        jsr     $33cc       ; load battle bg tile layout
        jsr     $3725       ; load battle bg graphics
        jsr     $36a5       ; load battle bg palette
        ldx     $bca6
        lda     $d4ba28,x   ; palette animation
        sta     $f8bd
        asl
        tax
        lda     $d4c6cd,x
        sta     $f8be
        lda     $d4c6ce,x
        sta     $f8bf
        clr_ax
        stx     $f8c0
        stz     $f8c2
        ldx     $bca6
        lda     $d4ba27,x   ; bg animation
        asl
        tax
        lda     $d4c5b1,x   ; pointer to bg animation
        sta     $70
        lda     $d4c5b2,x
        sta     $71
        lda     #$d4
        sta     $72
        clr_ay
        lda     #$ff
@33b1:  sta     $a809,y
        iny
        cpy     #$008c
        bne     @33b1
        clr_ay
@33bc:  lda     [$70],y
        sta     $a809,y
        cmp     #$ff
        beq     @33cb
        iny
        cpy     #$0080
        bne     @33bc
@33cb:  rts

; ---------------------------------------------------------------------------

; [ load battle bg tile layout ]

_c133cc:
@33cc:  clr_ax
@33ce:  sta     $7f7000,x   ; clear buffer
        inx
        cpx     #$0500
        bne     @33ce
        ldx     $bca6
        lda     $d4ba24,x   ; tile layout
        asl
        tax
        lda     $d4c86d,x   ; pointer to tile layout
        sta     $70
        lda     $d4c86e,x
        sta     $71
        lda     #$d4
        sta     $72
        clr_ayx
@33f4:  lda     [$70],y
        cmp     #$ff
        bne     @3459
        iny
        lda     [$70],y
        bmi     @3435
        pha
        and     #$3f
        sta     $76
        iny
        lda     [$70],y
        sta     $78
        iny
        lda     [$70],y
        sta     $7a
        pla
        and     #$40
        beq     @3424
        lda     $78         ; repeat tile with auto-decrement
@3415:  sta     $7f7000,x
        sec
        sbc     $7a
        inx2
        dec     $76
        bne     @3415
        bra     @345f
@3424:  lda     $78         ; repeat tile with auto-increment
@3426:  sta     $7f7000,x
        clc
        adc     $7a
        inx2
        dec     $76
        bne     @3426
        bra     @345f
@3435:  and     #$3f
        sta     $76         ; repeat two tiles
        iny
        lda     [$70],y
        sta     $78
        iny
        lda     [$70],y
        sta     $7a
@3443:  lda     $78
        sta     $7f7000,x
        inx2
        lda     $7a
        sta     $7f7000,x
        inx2
        dec     $76
        bne     @3443
        bra     @345f
@3459:  sta     $7f7000,x   ; single tile
        inx2
@345f:  iny
        cpx     #$0500
        bne     @33f4
        clr_ax
@3467:  lda     $7f7001,x   ; i don't think this has any effect
        and     #$df
        sta     $7f7001,x
        inx2
        cpx     #$0500
        bne     @3467
        clr_ax
        stx     $bca8
        stx     $bcaa
        ldx     $bca6
        lda     $d4ba25,x   ; h-flip
        cmp     #$ff
        bne     @3490
        inc     $bca8
        bra     @349e
@3490:  asl
        tax
        lda     $d4c736,x   ; ++$7e = pointer to h-flip data
        sta     $7e
        lda     $d4c737,x
        sta     $7f
@349e:  ldx     $bca6
        lda     $d4ba26,x   ; v-flip
        cmp     #$ff
        bne     @34ae
        inc     $bca9
        bra     @34bc
@34ae:  asl
        tax
        lda     $d4c736,x   ; ++$82 = pointer to v-flip data
        sta     $82
        lda     $d4c737,x
        sta     $83
@34bc:  lda     #$d4
        sta     $80
        sta     $84
        stz     $bcad
        stz     $bcae
        clr_ax
@34ca:  lda     $7f7000,x   ; tile index
        bmi     @34da
        ora     #$80
        sta     $7f7000,x
        lda     #$04        ; use palette 1
        bra     @34e2
@34da:  ora     #$80
        sta     $7f7000,x
        lda     #$08        ; use palette 2
@34e2:  sta     $70
        lda     $7f7001,x
        ora     $70
        sta     $70
        jsr     $3670       ; get battle bg tile flip
        ora     $70
        and     #$df        ; clear priority bit
        sta     $7f7001,x
        inx2
        cpx     #$0500
        bne     @34ca
        jsr     $3599       ; flip battle bg horizontally
        lda     $dbe4
        beq     @3522
        lda     #$d8        ; d8/35b2 (tile layout for ???)
        sta     $74
        ldx     #$35b2
        stx     $72
        jsr     $fb77       ; decompress
        ldx     #$1000
        stx     $70
        ldx     #$c000
        ldy     #$1000
        lda     #$7f
        jmp     $fd27
@3522:  lda     $dbd3
        beq     @3537
        ldy     #$1080
        ldx     #$0500
        stx     $70
        ldx     #$7000
        lda     #$7f
        jmp     $fdca       ; copy data to vram
@3537:  ldx     #$0500
        stx     $70
        ldx     #$7000
        lda     #$7f
        ldy     #$1000
        jsr     $fdca       ; copy data to vram
        ldx     #$0500
        stx     $70
        ldx     #$7000
        lda     #$7f
        ldy     #$1400
        jsr     $fdca       ; copy data to vram
        ldx     #$0040
        stx     $70
        ldx     #$74c0
        lda     #$7f
        ldy     #$1280
        jsr     $fdca       ; copy data to vram
        ldx     #$0040
        stx     $70
        ldx     #$74c0
        lda     #$7f
        ldy     #$1680
        jmp     $fdca       ; copy data to vram

; ---------------------------------------------------------------------------

; [  ]

_c13577:
@3577:  lda     $04f2
        cmp     #$1f
        beq     @3598       ; return if neo exdeath
        lda     $dbd3
        beq     @3588
        ldy     #$1080
        bra     @358b
@3588:  ldy     #$1000
@358b:  ldx     #$0500
        stx     $70
        ldx     #$7000
        lda     #$7f
        jsr     $fd27
@3598:  rts

; ---------------------------------------------------------------------------

; [ flip battle bg horizontally ]

_c13599:
@3599:  lda     $f6
        beq     @35e0
        phb
        lda     #$7f
        pha
        plb
        clr_ax
        longa
@35a6:  phx
        ldy     #$0000
@35aa:  lda     $7000,x
        sta     $7f00,y
        iny2
        inx2
        cpy     #$0040
        bne     @35aa
        dex2
        ldy     #$0000
@35be:  lda     $7f00,y
        eor     #$4000
        sta     $7000,x
        iny2
        dex2
        cpy     #$0040
        bne     @35be
        plx
        txa
        clc
        adc     #$0040
        tax
        cmp     #$0500
        bne     @35a6
        shorta0
        plb
@35e0:  rts

; ---------------------------------------------------------------------------

; [ set priority bit for battle bg tiles ]

_c135e1:
        lda     $70
        pha
        clr_ax
@35e6:  lda     $7f7001,x
        ora     #$20
        sta     $7f7001,x
        inx2
        cpx     #$0500
        bne     @35e6
        jsr     $3577
        pla
        sta     $70
        rts

; ---------------------------------------------------------------------------

; [ clear priority bit for battle bg tiles ]

_c135fe:
        lda     $70
        pha
        clr_ax
@3603:  lda     $7f7001,x
        and     #$df
        sta     $7f7001,x
        inx2
        cpx     #$0500
        bne     @3603
        jsr     $3577
        pla
        sta     $70
        rts

; ---------------------------------------------------------------------------

; [ get next byte of battle bg tile flip data ]

_c1361b:
@361b:  lda     $bcad       ; h-flip repeat count
        beq     @3625
        dec     $bcad
        bra     @363f
@3625:  lda     [$7e]       ; h-flip data
        sta     $bcaf
        bne     @363a
        ldy     #$0001
        lda     [$7e],y     ; if the first byte is zero, the next byte is the
        dec                 ; new repeat count
        sta     $bcad
        ldy     $7e
        iny
        sty     $7e
@363a:  ldy     $7e
        iny
        sty     $7e
@363f:  lda     $bcaf
        sta     $bcab       ; h-flip bits
        lda     $bcae
        beq     @364f
        dec     $bcae
        bra     @3669
@364f:  lda     [$82]
        sta     $bcb0
        bne     @3664
        ldy     #$0001
        lda     [$82],y
        dec
        sta     $bcae
        ldy     $82
        iny
        sty     $82
@3664:  ldy     $82
        iny
        sty     $82
@3669:  lda     $bcb0
        sta     $bcac       ; v-flip bits
        rts

; ---------------------------------------------------------------------------

; [ get battle bg tile flip ]

_c13670:
@3670:  stz     $72
        lda     $bcaa       ; bit index
        and     #$07
        bne     @367c
        jsr     $361b       ; get next byte of battle bg tile flip data
@367c:  lda     $bca8
        beq     @3684       ; branch if there is no h-flip data
        stz     $bcab
@3684:  lda     $bca9
        beq     @368c       ; branch if there is no v-flip data
        stz     $bcac
@368c:  asl     $bcab       ; h-flip bits
        ror2
        and     #$40
        ora     $72
        sta     $72
        asl     $bcac       ; v-flip bits
        ror
        and     #$80
        ora     $72
        sta     $72
        inc     $bcaa
        rts

; ---------------------------------------------------------------------------

; [ load battle bg palette ]

_c136a5:
@36a5:  ldx     $bca6
        lda     $d4ba22,x   ; palette 1
        jsr     $36dc
@36af:  lda     $d4bb31,x
        sta     $7e29,y
        sta     $f540,y
        inx
        iny
        cpy     #$0020
        bne     @36af
        ldx     $bca6
        lda     $d4ba23,x   ; palette 2
        jsr     $36dc
@36ca:  lda     $d4bb31,x
        sta     $7e49,y
        sta     $f560,y
        inx
        iny
        cpy     #$0020
        bne     @36ca
        rts

; ---------------------------------------------------------------------------

; [ get pointer to battle bg palette ]

_c136dc:
@36dc:  sta     $7e
        lda     #$20
        sta     $80
        jsr     $feba       ; +$82 = $7e * $80
        ldx     $82
        ldy     #$0000
        rts

; ---------------------------------------------------------------------------

; [ decompress battle bg graphics ]

_c136eb:
@36eb:  ldx     $bca6
        lda     $d4ba21,x   ; graphics
        sta     $7e
        lda     #$03
        sta     $80
        jsr     $feba       ; +$82 = $7e * $80
        ldx     $82
        lda     $d84196,x   ; pointer to battle bg graphics
        sta     $72
        lda     $d84197,x
        sta     $73
        lda     $d84198,x
        sta     $74
        jsr     $fb77       ; decompress
        lda     $d84157,x   ; destination address for battle bg graphics
        sta     $72
        lda     $d84158,x
        sta     $73
        lda     $d84159,x
        sta     $74
        rts

; ---------------------------------------------------------------------------

; [ load battle bg graphics ]

_c13725:
@3725:  jsr     $36eb       ; decompress battle bg graphics
        clr_ay
@372a:  lda     [$72],y
        sta     $9009,y
        sta     $8809,y
        iny
        cpy     #$0800
        bne     @372a
        ldx     #$1000
        stx     $70
        ldx     $72
        ldy     #$0800
        lda     $fefa       ;
        bne     @374c
        lda     $dbe4
        beq     @3753
@374c:  lda     $74
        jsr     $fd27
        bra     @3758
@3753:  lda     $74
        jsr     $fdca       ; copy data to vram
@3758:  clr_ay
@375a:  lda     $9009,y     ; flip tiles vertically
        sta     $a010,y
        lda     $900a,y
        sta     $a00f,y
        lda     $900b,y
        sta     $a00e,y
        lda     $900c,y
        sta     $a00d,y
        lda     $900d,y
        sta     $a00c,y
        lda     $900e,y
        sta     $a00b,y
        lda     $900f,y
        sta     $a00a,y
        lda     $9010,y
        sta     $a009,y
        iny8
        cpy     #$0800
        bne     @375a
        clr_ay
@3799:  lda     $9009,y
        jsr     $37ac       ; reverse bit order
        sta     $9809,y
        lda     $a009,y     ; i don't think this does anything
        iny
        cpy     #$0800
        bne     @3799
        rts

; ---------------------------------------------------------------------------

; [ reverse bit order ]

_c137ac:
@37ac:  ldx     #$0008
@37af:  asl
        ror     $70
        dex
        bne     @37af
        rts

; ---------------------------------------------------------------------------

; [  ]

; 0: spellblade
; 1: white
; 2: black
; 3: time
; 4: summon
; 5: blue
; 6: song
; 7: red
; 8: x-magic

_c137b6:
        asl3
        tax
        lda     $d83316,x   ; first spell
        sta     $db
        lda     $d83317,x   ; last spell
        sta     $dc
        lda     $d8331a,x
        sta     $dd
        longa
        lda     $d83318,x
        sta     $d3
        clc
        adc     #$0004
        sta     $d5
        clc
        adc     #$0004
        sta     $d7
        clc
        adc     #$0004
        sta     $d9
        shorta0
        ldx     #$0020
        jmp     _c13f95

; ---------------------------------------------------------------------------

; [  ]

_c137ef:
        lda     $bc65
        ora     $cd38
        ora     $cd39
        ora     $d110
        ora     $dbd3
        bne     @3819
        lda     $cd47
        and     #$07
        asl
        tax
        lda     f:_c1381d,x
        sta     $70
        lda     f:_c1381d+1,x
        sta     $71
        jsr     $381a
        inc     $cd47
@3819:  rts
@381a:  jmp     ($0070)

_c1381d:
        .addr   $38fe,$3940,$3954,$382d,$397e,$38c2,$3835,$382d

; ---------------------------------------------------------------------------

_c1382d:
        rts

; ---------------------------------------------------------------------------

_c1382e:
        jsr     $3835
        stz     $cd38
        rts

; ---------------------------------------------------------------------------

_c13835:
@3835:  ldx     #$bd0d
        ldy     #$caf5
        lda     #$08
        sta     $76
        lda     #$22
        jsr     $39b2
        clr_ay
        lda     #$ff
@3848:  sta     $dbf6,y
        iny
        cpy     #$0024
        bne     @3848
        lda     #$01
        sta     $dbfe
        sta     $dc07
        sta     $dc10
        stz     $dc19
        clr_axy
@3862:  lda     $b444,x
        cmp     #$ff
        beq     @38af
        phx
        asl2
        tax
        lda     $7b8e,x
        sta     $70
        lda     $7b8f,x
        sta     $71
        lda     $7b90,x
        sta     $72
        stz     $7e
@387e:  asl     $72
        rol     $71
        rol     $70
        bcs     @3896
        inc     $7e
        lda     $7e
        cmp     #$18
        bne     @387e
        tya
        clc
        adc     #$09
        tay
        plx
        bra     @38af
@3896:  lda     $7e
        asl3
        tax
        lda     #$08
        sta     $76
@38a0:  lda     $d128b6,x
        sta     $dbf6,y
        iny
        inx
        dec     $76
        bne     @38a0
        plx
        iny
@38af:  inx
        cpx     #$0004
        bne     @3862
        lda     #$07
        jsr     $4641
        jsr     $2dac
        lda     #$07
        jmp     $4622
        ldx     #$0004
@38c5:  jsr     $38dc
        bcs     @38d4
        inx4
        cpx     #$0024
        bne     @38c5
        rts
@38d4:  jsr     $40e4
        lda     #$05
        jmp     $4622
@38dc:  lda     #$04
        sta     $71
        stz     $70
@38e2:  lda     $382c,x
        cmp     $7cd9,x
        bne     @38ec
        inc     $70
@38ec:  sta     $7cd9,x
        inx
        dec     $71
        bne     @38e2
        lda     $70
        cmp     #$04
        bne     @38fc
        clc
        rts
@38fc:  sec
        rts

; ---------------------------------------------------------------------------

_c138fe:
        stz     $db49
        clr_ax
@3903:  jsr     $38dc
        bcs     @3913
        inx4
        cpx     #$0020
        bne     @3903
        bra     @3919
@3913:  inc     $db49
        jsr     $405b
@3919:  lda     $0425
        beq     @3936
        clr_ax
@3920:  lda     $3ed0,x
        cmp     $f53c,x
        bne     @3930
        inx
        cpx     #$0004
        bne     @3920
        bra     @3936
@3930:  jsr     $3ff4
        inc     $db49
@3936:  lda     $db49
        beq     @393f
        clr_a
        jsr     $4622
@393f:  rts

; ---------------------------------------------------------------------------

_c13940:
        ldx     #$bd1b
        ldy     #$bf9b
        lda     #$08
        sta     $76
        lda     #$12
        jsr     $39b2
        lda     #$01
        jmp     $4622

; ---------------------------------------------------------------------------

_c13954:
        stz     $70
        clr_ax
@3958:  lda     $4038,x
        cmp     $7cf9,x
        bne     @3962
        inc     $70
@3962:  lda     $4038,x
        sta     $7cf9,x
        inx4
        cpx     #$0010
        bne     @3958
        txa
        cmp     $70
        beq     @397d
        jsr     $3fa8
        clr_a
        jsr     $4622
@397d:  rts

; ---------------------------------------------------------------------------

_c1397e:
        ldx     #$bcf5
        ldy     #$bf75
        lda     #$08
        sta     $76
        lda     $cd40
        bne     @39a8
        lda     $0426
        bpl     @39a8
        lda     #$02
        jsr     $39b2
        ldx     #$beb5
        ldy     #$c135
        lda     #$01
        sta     $76
        lda     #$0a
        jsr     $39b2
        bra     @39ad
@39a8:  lda     #$0a
        jsr     $39b2
@39ad:  lda     #$01
        jmp     $4622

; ---------------------------------------------------------------------------

_c139b2:
@39b2:  stx     $70
        sty     $72
        sta     $74
        stz     $75
        stz     $77
        longa
@39be:  clr_ay
@39c0:  lda     ($70),y
        sta     ($72),y
        iny2
        cpy     $74
        bne     @39c0
        lda     $70
        clc
        adc     #$0040
        sta     $70
        lda     $72
        clc
        adc     #$0040
        sta     $72
        dec     $76
        bne     @39be
        shorta0
        rts

; ---------------------------------------------------------------------------

_c139e2:
@39e2:  clr_ax
@39e4:  lda     $2734,x
        beq     @39f5
        inx
        cpx     #$0100
        bne     @39e4
        lda     #$01
        sta     $cfd5
        rts
@39f5:  stz     $cfd5
        rts

; ---------------------------------------------------------------------------

; [ battle graphics function $00: open menu ]

_c139f9:
        lda     $7c42
        sta     $cd40
        lda     $71
        bne     @3a54
        lda     $70
        asl2
        tax
        lda     $0980,x
        sta     $fef6
        lda     $0981,x
        sta     $fef7
        lda     $0982,x
        sta     $fef8
        lda     $0983,x
        sta     $fef9
        ldx     $70
        phx
@3a23:  jsr     $02f2       ; wait one frame
        lda     $cd41
        bne     @3a23
        plx
        stx     $70
        stz     $cdf8
        stz     $cdf9
        lda     $0426
        and     #$01
        bne     @3a3e
        jsr     $0871
@3a3e:  jsr     $39e2
        lda     $70
        sta     $cd42
        sta     $010d       ; selected character (for multi controller)
        lda     #$01
        sta     $41b0
        sta     $41b7
        inc     $cd41
@3a54:  rts

; ---------------------------------------------------------------------------

; [ battle graphics function $01: close menu ]

_c13a55:
        lda     $cd42
        cmp     $70
        bne     @3a6d
        inc     $cdf9
        inc     $cdf8
@3a62:  jsr     $02f2       ; wait one frame
        lda     $cd41
        bne     @3a62
        jsr     $02f2       ; wait one frame
@3a6d:  rts

; ---------------------------------------------------------------------------

; [  ]

_c13a6e:
        lda     $bc65
        bne     @3a95
        lda     $cd38
        bne     @3a81
        lda     $cd39
        sta     $cd38
        stz     $cd39
@3a81:  lda     $cd38
        asl
        tax
        lda     $c13a96,x
        sta     $70
        lda     $c13a97,x
        sta     $71
        jmp     ($0070)
@3a95:  rts

; ---------------------------------------------------------------------------

; battle menu jump table
_c13a96:
        .addr   $3a95,$416b,$422b,$455b,$43ce,$4176,$3a95,$422b
        .addr   $4552,$3cd3,$3cd7,$3cdc,$3ce1,$3ce6,$3ceb,$3cf0
        .addr   $3cf5,$3cfa,$414b,$421d,$4224,$609d,$60cc,$605c
        .addr   $60bb,$3ccd,$3cd0,$3cc7,$3cca,$382e

; 08: item
; 09: spellblade
; 0a: white magic
; 0b: black magic
; 0c: time magic
; 0d: summon
; 0e: blue magic
; 0f: red magic
; 10: song
; 11: x-magic

; ---------------------------------------------------------------------------

; [  ]

_c13ad2:
@3ad2:  clr_ax
@3ad4:  sta     $c9b1,x
        inx
        cpx     #$0100
        bne     @3ad4
        rts

; ---------------------------------------------------------------------------

; [  ]

_c13ade:
@3ade:  clr_ax
@3ae0:  sta     $f357,x
        inx
        cpx     #$01a0
        bne     @3ae0
        rts

; ---------------------------------------------------------------------------

; [  ]

_c13aea:
@3aea:  longa
        ldx     #$0038
@3aef:  lda     #$0002
        sta     $b035,x
        inx4
        cpx     #$0070
        bne     @3aef
        lda     #$0007
@3b01:  sta     $b035,x
        inx4
        cpx     #$00b0
        bne     @3b01
        shorta0
        rts

; ---------------------------------------------------------------------------

; [  ]

_c13b11:
@3b11:  ldx     #$0038
        clr_a
@3b15:  sta     $b035,x
        inx
        cpx     #$00b0
        bne     @3b15
        rts

; ---------------------------------------------------------------------------

; [  ]

_c13b1f:
        jsr     $3ad2
        jsr     $3ade
        ldx     #$0060
        jsr     _c13f95
        ldx     $bca0
        stx     $70
        lda     $bca2
        sta     $72
        clr_ax
        lda     #$10
        sta     $70
@3b3b:  lda     $70
        sta     $ca01,x
        inc
        sta     $ca41,x
        inc     $70
        inc     $70
        inx2
        cpx     #$001e
        bne     @3b3b
        jsr     $3b5c
        jsr     $2971       ; draw big text string
        jsr     $3aea
        inc     $bc76
        rts

; ---------------------------------------------------------------------------

; [  ]

_c13b5c:
@3b5c:  lda     $dbf6
        cmp     #$0f
        beq     @3b78
        cmp     #$18
        beq     @3b7b
        cmp     #$19
        beq     @3b7e
        cmp     #$0e
        beq     @3b81
        cmp     #$1a
        beq     @3b84
        lda     #$09
        jmp     _c13c7f
@3b78:  jmp     _c13b87
@3b7b:  jmp     _c13c02
@3b7e:  jmp     _c13c22
@3b81:  jmp     _c13c62
@3b84:  jmp     _c13c42

; ---------------------------------------------------------------------------

; [  ]

_c13b87:
@3b87:  lda     $dbf7
        cmp     #$57
        bcc     @3bb6
        sec
        sbc     #$57
        sta     $7e
.if LANG_EN
        lda     #$18
.else
        lda     #$09
.endif
        sta     $80
        jsr     $feba       ; +$82 = $7e * $80
        ldx     $82
.if LANG_EN
        lda     #$18
.else
        lda     #$09
.endif
        sta     $7e
        stz     $80
@3ba2:
.if LANG_EN
        jml     $e02f39
.else
        lda     $d11e8a,x   ; short attack names
.endif
        cmp     #$ff
        beq     @3bac
        inc     $80
@3bac:  inx
        dec     $7e
        bne     @3ba2
        lda     $80
        jmp     _c13c7f
@3bb6:  sta     $7e
        cmp     #$48
        bcc     @3bdf
        lda     #$06
        sta     $80
        jsr     $feba       ; +$82 = $7e * $80
        ldx     $82
        lda     #$06
        sta     $7e
        stz     $80
@3bcb:
.if LANG_EN
        jml     $e02f40
.else
        lda     $d11c80,x   ; spell type
.endif
        cmp     #$ff
        beq     @3bd5
        inc     $80
@3bd5:  inx
        dec     $7e
        bne     @3bcb
        lda     $80
        jmp     _c13c7f
@3bdf:  lda     #$06
        sta     $80
        jsr     $feba       ; +$82 = $7e * $80
        ldx     $82
        lda     #$05
        sta     $7e
        stz     $80
@3bee:
.if LANG_EN
        jml     $e02f47
.else
        lda     $d11c81,x   ; spell names
.endif
        cmp     #$ff
        beq     @3bf8
        inc     $80
@3bf8:  inx
        dec     $7e
        bne     @3bee
        lda     $80
        jmp     _c13c7f

; ---------------------------------------------------------------------------

; [  ]

_c13c02:
@3c02:  lda     $dbf7
        jsr     $2bcf
.if LANG_EN
        lda     #$07
.else
        lda     #$05
.endif
        sta     $7e
        stz     $80
@3c0e:
.if LANG_EN
        jml     $e02f4e
.else
        lda     $d15800,x
.endif
        cmp     #$ff
        beq     @3c18
        inc     $80
@3c18:  inx
        dec     $7e
        bne     @3c0e
        lda     $80
        jmp     _c13c7f

; ---------------------------------------------------------------------------

_c13c22:
.if LANG_EN
        jsl     $e02fb6
        nop2
        lda     #$10
.else
@3c22:  lda     $dbf7
        jsr     $2b85
        lda     #$09
.endif
        sta     $7e
        stz     $80
@3c2e:
.if LANG_EN
        jml     $e02f55
.else
        lda     $d16700,x
.endif
        cmp     #$ff
        beq     @3c38
        inc     $80
@3c38:  inx
        dec     $7e
        bne     @3c2e
        lda     $80
        jmp     _c13c7f

; ---------------------------------------------------------------------------

_c13c42:
@3c42:  lda     $dbf7
        jsr     $2b91
.if LANG_EN
        lda     #$10
.else
        lda     #$08
.endif
        sta     $7e
        stz     $80
@3c4e:
.if LANG_EN
        jml     $e02f5c
.else
        lda     $d08700,x
.endif
        cmp     #$ff
        beq     @3c58
        inc     $80
@3c58:  inx
        dec     $7e
        bne     @3c4e
        lda     $80
        jmp     _c13c7f

; ---------------------------------------------------------------------------

_c13c62:
@3c62:  lda     $dbf7
        jsr     $2c75
.if LANG_EN
        lda     #$18
.else
        lda     #$08
.endif
        sta     $7e
        stz     $80
@3c6e:
.if LANG_EN
        jml     $e02f63
.else
        lda     $d11381,x
.endif
        cmp     #$ff
        beq     @3c78
        inc     $80
@3c78:  inx
        dec     $7e
        bne     @3c6e
        lda     $80

_c13c7f:
@3c7f:  tax
        lda     $d83302,x
        sta     $f507
        rts

; ---------------------------------------------------------------------------

; [ draw battle message/dialogue ]

_c13c88:
        jsr     $3ad2
        jsr     $3ade
        ldx     #$0050
        jsr     _c13f95
        clr_ax
        lda     #$10
        sta     $70
@3c9a:  lda     $70
        sta     $c9f7,x
        inc
        sta     $ca37,x
        inc     $70
        inc     $70
        inx2
        cpx     #$0034
        bne     @3c9a
        stz     $f507
        jsr     $2971       ; draw big text string
        jsr     $3aea
        inc     $bc76
        rts

; ---------------------------------------------------------------------------

; [ close message window ]

; or maybe just clear text ???

_c13cbb:
        jsr     $3ad2
        inc     $bc76
        jsr     $02f2       ; wait one frame
        jmp     _c13b11

; ---------------------------------------------------------------------------

_c13cc7:
        jmp     $44d1

_c13cca:
        jmp     $445a

_c13ccd:
        jmp     $455e

_c13cd0:
        jmp     $43ce

; ---------------------------------------------------------------------------

; [ battle menu $09: spellblade ]

_c13cd3:
        clr_a
        jmp     $44c8

; ---------------------------------------------------------------------------

; [ battle menu $0a: white magic ]

_c13cd7:
        lda     #$01
        jmp     $44c8

; ---------------------------------------------------------------------------

; [ battle menu $0b: black magic ]

_c13cdc:
        lda     #$02
        jmp     $44c8

; ---------------------------------------------------------------------------

; [ battle menu $0c: time magic ]

_c13ce1:
        lda     #$03
        jmp     $44c8

; ---------------------------------------------------------------------------

; [ battle menu $0d: summon magic ]

_c13ce6:
        lda     #$04
        jmp     $44c8

; ---------------------------------------------------------------------------

; [ battle menu $0e: blue magic ]

_c13ceb:
        lda     #$05
        jmp     $4451

; ---------------------------------------------------------------------------

; [ battle menu $0f: songs ]

_c13cf0:
        lda     #$06
        jmp     $4451

; ---------------------------------------------------------------------------

; [ battle menu $10: red magic ]

_c13cf5:
        lda     #$07
        jmp     $44c8

; ---------------------------------------------------------------------------

; [ battle menu $11: x-magic ]

_c13cfa:
        lda     #$08
        jmp     $44c8

; ---------------------------------------------------------------------------

; [  ]

_c13cff:
        jsr     $3dc5
        jsr     $3f71
        jsr     $3d8c
        ldx     #$00ff
        stx     $70
        ldx     #$b535
        ldy     #$b2b3
        lda     #$7e
        jsr     $fce1       ; move data
        lda     $b3b5
        sec
        sbc     #$e0
        sta     $b3b5
        lda     #$73
        sta     $c221
        lda     #$75
        sta     $c223
        clr_axy
@3d2e:  lda     $d832eb,x
        sta     $c2df,y
        iny2
        inx
        cpx     #$0007
        bne     @3d2e
        clr_ayx
@3d40:  lda     $d832f2,x
        sta     $c8f3,y
        lda     $d832f6,x
        sta     $c933,y
        lda     $d832fa,x
        sta     $c927,y
        lda     $d832fe,x
        sta     $c967,y
        iny2
        inx
        cpx     #$0004
        bne     @3d40
        jsr     $40a0
        lda     $dbd3
        bne     @3d7c
        ldx     #$0280
        stx     $70
        ldy     #$4a80
        ldx     #$bcb1
        lda     #$7e
        jsr     $fdca       ; copy data to vram
@3d7c:  ldx     #$0100
        stx     $70
        ldy     #$1f80
        ldx     #$c8b1
        lda     #$7e
        jmp     $fdca       ; copy data to vram

; ---------------------------------------------------------------------------

; [  ]

_c13d8c:
@3d8c:  ldx     #$0000
        jsr     _c13f95
        jsr     $3fa8
        jsr     $405b
        jsr     $416b
        lda     $cd40
        beq     @3da3
        jmp     $4176
@3da3:  ldx     #$027f
        stx     $70
        ldx     #$bcb1
        ldy     #$bf31
        lda     #$7e
        jsr     $fce1       ; move data
        ldx     #$0010
        jsr     _c13f95
        ldx     #$0040
        jsr     _c13f95
        ldx     #$0048
        jmp     _c13f95

; ---------------------------------------------------------------------------

; [ init hdma data ]

_c13dc5:
@3dc5:  clr_ax
@3dc7:  lda     $d832e4,x   ; load bg3 scroll hdma table
        sta     $a930,x
        inx
        cpx     #$0007
        bne     @3dc7
        clr_ax
@3dd6:  sta     $a937,x     ; clear bg1 and bg2 scroll hdma data
        inx
        cpx     #$0a80
        bne     @3dd6
        lda     $dbd3
        bne     @3df7
        clr_ax
@3de6:  lda     #$01        ; set bg2 v-scroll for menu region to $0101
        sta     $af36,x
        sta     $af35,x
        inx4
        cpx     #$0100
        bne     @3de6
@3df7:  clr_ax
        lda     #$01
@3dfb:  sta     $bb27,x
        sta     $bb28,x
        inx4
        cpx     #$0060
        bne     @3dfb
        clr_axy
@3e0d:  lda     #$04
        sta     $70
@3e11:  lda     $d832c6,x
        sta     $b537,y
        iny4
        dec     $70
        bne     @3e11
        inx
        cpy     #$0100
        bne     @3e0d
        clr_ax
        longa
@3e2a:  dec     $b537,x
        lda     $b537,x
        sta     $b717,x
        pha
        sec
        sbc     #$0050
        clc
        adc     #$0100
        sta     $b637,x
        pla
        sec
        sbc     #$000a
        clc
        adc     #$0100
        sta     $b957,x
        inc     $b956,x
        inc     $b716,x
        lda     $b535,x
        clc
        adc     #$0100
        sta     $bb85,x
        lda     $b537,x
        clc
        adc     #$00f8
        sta     $bb87,x
        inx4
        cpx     #$00e0
        bne     @3e2a
        clr_ax
@3e70:  lda     $afe7,x
        inc
        sta     $ba05,x
        lda     $afe9,x
        inc
        sta     $ba07,x
        inx4
        cpx     #$0010
        bne     @3e70
        shorta0
        clr_ax
        longa
@3e8e:  lda     $b537,x
        sec
        sbc     #$0080
        clc
        adc     #$00f8
        sta     $b8d7,x
        inx4
        cpx     #$0080
        bne     @3e8e
        shorta0
        clr_axy
@3eab:  lda     #$04
        sta     $70
@3eaf:  lda     #$01
        sta     $b7f6,y
        lda     $d832d6,x
        longa
        sec
        sbc     #$00a4
        sta     $b7f7,y
        shorta0
        iny4
        dec     $70
        bne     @3eaf
        inx
        cpy     #$00e0
        bne     @3eab
        rts

; ---------------------------------------------------------------------------

; [  ]

_c13ed3:
@3ed3:  phx
        phy
        lda     $bc70
        sta     $7e
        lda     #$40
        sta     $80
        jsr     $feba       ; +$82 = $7e * $80
        lda     $bc6f
        longa
        asl
        clc
        adc     $82
        clc
        adc     $bc6d
        sta     $70
        shorta0
        lda     $bc74
        sta     $74
        lda     $bc73
        tax
        clr_ay
        dec     $bc71
        dec     $bc72
        dec     $bc72
        asl     $bc71
        jsr     $3f53
        inx
@3f0e:  jsr     $3f53
        tya
        cmp     $bc71
        bne     @3f0e
        inx
        jsr     $3f53
        jsr     $3f60
@3f1e:  lda     $bc73
        clc
        adc     #$03
        tax
        jsr     $3f53
        inx
@3f29:  jsr     $3f53
        tya
        cmp     $bc71
        bne     @3f29
        inx
        jsr     $3f53
        jsr     $3f60
        dec     $bc72
        bne     @3f1e
        inx
        jsr     $3f53
        inx
@3f43:  jsr     $3f53
        tya
        cmp     $bc71
        bne     @3f43
        inx
        jsr     $3f53
        ply
        plx
        rts

; ---------------------------------------------------------------------------

; [  ]

_c13f53:
@3f53:  lda     $d4b957,x
        sta     ($70),y
        iny
        lda     $74
        sta     ($70),y
        iny
        rts

; ---------------------------------------------------------------------------

; [  ]

_c13f60:
@3f60:  lda     $70
        clc
        adc     #$40
        sta     $70
        lda     $71
        adc     #$00
        sta     $71
        ldy     #$0000
        rts

; ---------------------------------------------------------------------------

; [  ]

_c13f71:
@3f71:  ldx     #$0000
        jsr     _c13f95
        ldx     #$0008
        jsr     _c13f95
        ldx     #$0020
        jsr     _c13f95
        ldx     #$0038
        jsr     _c13f95
        ldx     #$0068
        jsr     _c13f95
        ldx     #$0070
        jmp     _c13f95

; ---------------------------------------------------------------------------

; [  ]

_c13f95:
@3f95:  clr_ay
@3f97:  lda     $d83196,x
        sta     $bc6d,y
        iny
        inx
        cpy     #$0008
        bne     @3f97
        jmp     $3ed3

; ---------------------------------------------------------------------------

; [  ]

_c13fa8:
@3fa8:  ldx     #$0000
        jsr     _c13f95
        lda     $3eef
        and     #$40
        bne     @3ff3
        clr_a
        jsr     $4641
        clr_ayx
@3fbc:  lda     $403a,x
        beq     @3fe3
        lda     #$0b
        sta     $dbf6,y
        txa
        lsr2
        sta     $dbf7,y
        sta     $dbfa,y
        lda     #$0c
        sta     $dbf9,y
        lda     #$ff
        sta     $dbf8,y
        lda     #$01
        sta     $dbfb,y
        tya
        clc
        adc     #$06
        tay
@3fe3:  inx4
        cpx     #$0010
        bne     @3fbc
        clr_a
        sta     $dbf6,y
        jsr     $2dac
@3ff3:  rts

; ---------------------------------------------------------------------------

; [  ]

_c13ff4:
@3ff4:  clr_ax
@3ff6:  lda     $3ed0,x
        sta     $f53c,x
        inx
        cpx     #$0004
        bne     @3ff6
        ldx     #$bd63
        stx     $70
        clr_ay
@4009:  lda     $b444,y
        cmp     #$ff
        beq     @4054
        tax
        stz     $74
        lda     $3ed0,x
        bne     @401c
        lda     #$08
        sta     $74
@401c:  lda     $3ed0,x
        cmp     #$80
        bcc     @4025
        lda     #$7f
@4025:  and     #$fc
        tax
        phy
        ldy     #$0002
        lda     #$0a
        sta     ($70)
@4030:  lda     $d83246,x
        sta     ($70),y
        iny
        lda     $74
        sta     ($70),y
        iny
        inx
        cpy     #$000a
        bne     @4030
        lda     #$0b
        sta     ($70),y
        longa
        lda     $70
        clc
        adc     #$0080
        sta     $70
        shorta0
        ply
@4054:  iny
        cpy     #$0004
        bne     @4009
        rts

; ---------------------------------------------------------------------------
