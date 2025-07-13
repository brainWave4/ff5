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

.export ExecBtlGfx_ext, _c10003, _c10006, _c10009

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
_0003:  jmp     _c1f75f
.endproc

; ---------------------------------------------------------------------------

.proc _c10006
_0006:  jmp     _c1e999
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
@0021:  .addr   _c139f9, _c13a55, _c10348, _c102e0, _c102df, _c1422b, _c101e4, _c1768d
        .addr   _c175d7, _c10208, _c18189, _c1010b, _c100f2, _c100c6, _c10092

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
        jsr     _c173ec       ;
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
        jmp     _c1979e

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
        jeq     _c13cc7
        jmp     _c13cca
@01f5:  rts

; ---------------------------------------------------------------------------

; [ load damage numerals palette ]

_c101f6:
@01f6:  lda     #$05
        ldy     #$0140
        jmp     _c1aa1d       ; load attack palette (8-colors)

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
@028b:  lda     f:_c10272,x
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
        jsr     _c13a6e
        jsr     $aef6
        jsr     $ad64
        jsr     $ad2d
        jmp     _c137ef

; ---------------------------------------------------------------------------

; [ wait one frame ]

_c102f2:
@02f2:  jsr     $fd1d       ; wait for vblank
        jsr     $3a6e
        jsr     $ad2d
        jmp     _c137ef

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
        asl5
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
        iny4
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
        jmp     _c18736       ; do monster entry

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
@0442:  inx4
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
@0483:  inx4
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
        inx4
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
        iny2
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
        lsr4
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
        jmp     _c110eb
@0beb:  cmp     #$02
        bne     @0bf5       ; branch if not desert
        inc     $f8c6
        jmp     _c10fd4
@0bf5:  cmp     #$ff
        bne     @0bff
        inc     $f8c6
        jmp     _c11015
@0bff:  cmp     #$fe
        bne     @0c09
        inc     $f8c6
        jmp     _c1105a
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
        lda     f:_c10c36,x
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
        iny4
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
        iny2
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
        lda     f:_c10f11,x
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
        lda     f:_c1119b,x
        sta     $88
        lda     f:_c1119b+1,x
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
        jmp     _c1fd07
@11d2:  rts

_c111d3:
        stz     $41b0
        stz     $41b7
        stz     $cd41
        lda     #$ff
        sta     $cd42
        jmp     _c1fd07

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
@12e5:  jmp     _c1fcd7

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
        lda     f:_c1136e,x
        sta     $8a
        lda     f:_c1136e+1,x
        sta     $8b
        lda     f:_c1137e,x
        sta     $8c
        lda     f:_c1137e+1,x
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
        lda     f:_c1142c,x
        clc
        adc     $8a
        sta     $8a
        lda     f:_c1142c+1,x
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
        lda     f:_c1b126,x
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
        lda     f:_c114ed,x
        sta     $88
        lda     f:_c114ed+1,x
        sta     $89
        lda     $b3bb
        asl
        tax
        lda     f:_c114ed,x
        sta     $8c
        lda     f:_c114ed+1,x
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
@1679:  lda     f:_c115bc,x
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
        jmp     _c117c4

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
        jmp     _c1fca2
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
        jsr     _c18b2a
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
        jmp     _c1fd27

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
        jmp     _c1fd27

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
        jmp     _c1fdb6       ; copy data to vram
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
        jmp     _c1fdca       ; copy data to vram

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
        dec2
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
        jmp     _c122f2

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
        jmp     @259a
@2505:  asl3
        tax
        longa
        lda     f:_c124a3,x   ; pointer to character graphics
        sta     $70
        lda     f:_c124a3+2,x
        sta     $72
        lda     f:_c124a3+4,x   ; pointer to character graphics (dead)
        sta     $76
        lda     f:_c124a3+6,x
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
        jne     $24ed
        rts

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
        lda     f:_c124cb,x   ; pointers to character palettes
        sta     $70
        sta     $74
        lda     f:_c124cb+1,x
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
        jmp     @26ab
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
        jmp     @297b
@2990:  jsr     $29a0       ; do big text escape code
        jsr     $299a       ; get next byte
        jmp     @297b
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
        lda     f:_c129b1,x
        sta     $70
        lda     f:_c129b1+1,x
        sta     $71
        jmp     ($0070)

; ---------------------------------------------------------------------------

; jump table for escape codes $00-$1f
_c129b1:
        .addr   _c12f0f,_c12f0f,_c12f0f,_c12f0f,_c12f0f,_c12c9a,_c12f0f,_c12f0f ; $00
        .addr   _c12f0f,_c12f0f,_c12f0f,_c12f0f,_c12f0f,_c12f0f,_c12c81,_c12c15
        .addr   _c12b35,_c12b13,_c12af9,_c12a90,_c12a6e,_c12a2f,_c129f1,_c12f0f ; $10
        .addr   _c12bdb,_c12b9d,_c12bb6,_c12f0f,_c12f0f,_c12f0f,_c12cab,_c12cb2

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
        lda     f:_c12a2a,x
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
        jmp     _2d1f

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
_2d1f:  lda     $f507       ; text horizontal position
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
        jmp     @2dcf
@2de0:  jsr     $2f5d       ; decode small text escape code
        jsr     $299a       ; get next byte
        jmp     @2dcf
@2de9:  rts

; ---------------------------------------------------------------------------

; [ draw small text character ]

_c12dea:
@2dea:  cmp     #$53
        bcc     _2dfd

_c12dee:
@2dee:  sta     ($bc),y
        lda     #$ff        ; no dakuten
_2df2:  sta     ($ba),y
        iny
        lda     $be         ; tile flags
        sta     ($bc),y
        sta     ($ba),y
        iny
        rts
_2dfd:  cmp     #$49
        bcc     @2e0b
        clc
        adc     #$17
        sta     ($bc),y
        lda     #$52        ; handakuten
        jmp     _2df2
@2e0b:  clc
        adc     #$40
        sta     ($bc),y
        lda     #$51        ; dakuten
        jmp     _2df2

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
        jmp     _2eab

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
_2eab:  phy
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
        jsr     _c12dea       ; draw small text character
        lda     #$53
        jsr     _c12dea       ; draw small text character
        lda     #$53
        jmp     _c12dea       ; draw small text character
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
        jmp     _c12dea       ; draw small text character

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
        jmp     _c12dee

; ---------------------------------------------------------------------------

; [ decode small text escape code ]

_c12f5d:
@2f5d:  asl
        tax
        lda     f:_c12e15,x
        sta     $70
        lda     f:_c12e15+1,x
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
        jmp     @2f75
@2f7f:  clc
        adc     #$0a
        sta     $71
        lda     $70
        bne     @2f8a       ; branch if two digits
        lda     #$ac        ; this is a hack to draw a space ($ac + $53 = $ff)
@2f8a:  clc
        adc     #$53
        jsr     _c12dee
        lda     $71
        ora     $70
        bne     @2f9b
        lda     #$ff
        jmp     _c12dee
@2f9b:  lda     $71
        clc
        adc     #$53
        jmp     _c12dee

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
        jmp     _3092

; ---------------------------------------------------------------------------

; [ small text escape code $08:  ]

_c1306e:
        ldx     #$2080
        stx     $70
        ldx     #$3834
        stx     $78
        jmp     _3092

; ---------------------------------------------------------------------------

; [ small text escape code $09:  ]

_c1307b:
        ldx     #$2100
        stx     $70
        ldx     #$383c
        stx     $78
        jmp     _3092

; ---------------------------------------------------------------------------

; [ small text escape code $0a:  ]

_c13088:
        ldx     #$2180
        stx     $70
        ldx     #$3844
        stx     $78
_3092:  lda     #$7e
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
        jmp     _c132f0
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
        jmp     _c132bc

_c13144:
        lda     #$02
        jmp     _c132bc

_c13149:
        lda     #$04
        jmp     _c132cb

_c1314e:
        lda     #$06
        jmp     _c132cb

_c13153:
        lda     #$06
        jmp     _c132ed

_c13158:
        lda     #$02
        jmp     _c132da

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

_c132f0:
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
        jmp     _c1fd27
@3522:  lda     $dbd3
        beq     @3537
        ldy     #$1080
        ldx     #$0500
        stx     $70
        ldx     #$7000
        lda     #$7f
        jmp     _c1fdca       ; copy data to vram
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
        jmp     _c1fdca       ; copy data to vram

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
        jsr     _c12dac
        lda     #$07
        jmp     _c14622
        ldx     #$0004
@38c5:  jsr     $38dc
        bcs     @38d4
        inx4
        cpx     #$0024
        bne     @38c5
        rts
@38d4:  jsr     $40e4
        lda     #$05
        jmp     _c14622
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
        jsr     _c14622
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
        jmp     _c14622

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
        jsr     _c14622
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
        jmp     _c14622

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
@3a23:  jsr     _c102f2       ; wait one frame
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
@3a62:  jsr     _c102f2       ; wait one frame
        lda     $cd41
        bne     @3a62
        jsr     _c102f2       ; wait one frame
@3a6d:  rts

; ---------------------------------------------------------------------------

; [  ]

_c13a6e:
        lda     $bc65
        bne     _c13a95
        lda     $cd38
        bne     @3a81
        lda     $cd39
        sta     $cd38
        stz     $cd39
@3a81:  lda     $cd38
        asl
        tax
        lda     f:_c13a96,x
        sta     $70
        lda     f:_c13a96+1,x
        sta     $71
        jmp     ($0070)

; ---------------------------------------------------------------------------

_c13a95:
        rts

; ---------------------------------------------------------------------------

; battle menu jump table
_c13a96:
        .addr   _c13a95,_c1416b,_c1422b,_c1455b,_c143ce,_c14176,_c13a95,_c1422b
        .addr   _c14552,_c13cd3,_c13cd7,_c13cdc,_c13ce1,_c13ce6,_c13ceb,_c13cf0
        .addr   _c13cf5,_c13cfa,_c1414b,_c1421d,_c14224,_c1609d,_c160cc,_c1605c
        .addr   _c160bb,_c13ccd,_c13cd0,_c13cc7,_c13cca,_c1382e

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
        jsr     _c102f2       ; wait one frame
        jmp     _c13b11

; ---------------------------------------------------------------------------

_c13cc7:
        jmp     _c144d1

_c13cca:
        jmp     _c1445a

_c13ccd:
        jmp     _c1455e

_c13cd0:
        jmp     _c143ce

; ---------------------------------------------------------------------------

; [ battle menu $09: spellblade ]

_c13cd3:
        clr_a
        jmp     _c144c8

; ---------------------------------------------------------------------------

; [ battle menu $0a: white magic ]

_c13cd7:
        lda     #$01
        jmp     _c144c8

; ---------------------------------------------------------------------------

; [ battle menu $0b: black magic ]

_c13cdc:
        lda     #$02
        jmp     _c144c8

; ---------------------------------------------------------------------------

; [ battle menu $0c: time magic ]

_c13ce1:
        lda     #$03
        jmp     _c144c8

; ---------------------------------------------------------------------------

; [ battle menu $0d: summon magic ]

_c13ce6:
        lda     #$04
        jmp     _c144c8

; ---------------------------------------------------------------------------

; [ battle menu $0e: blue magic ]

_c13ceb:
        lda     #$05
        jmp     _c14451

; ---------------------------------------------------------------------------

; [ battle menu $0f: songs ]

_c13cf0:
        lda     #$06
        jmp     _c14451

; ---------------------------------------------------------------------------

; [ battle menu $10: red magic ]

_c13cf5:
        lda     #$07
        jmp     _c144c8

; ---------------------------------------------------------------------------

; [ battle menu $11: x-magic ]

_c13cfa:
        lda     #$08
        jmp     _c144c8

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
        jmp     _c1fdca       ; copy data to vram

; ---------------------------------------------------------------------------

; [  ]

_c13d8c:
@3d8c:  ldx     #$0000
        jsr     _c13f95
        jsr     $3fa8
        jsr     $405b
        jsr     _c1416b
        lda     $cd40
        jne     _c14176
        ldx     #$027f
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
        jmp     _c13ed3

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
        jsr     _c12dac
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

; [  ]

_c1405b:
        lda     #$04
        jsr     $4641
        lda     #$02
        jsr     $4656
        clr_axy
@4068:  lda     $b444,x
        cmp     #$ff
        beq     @4081
        lda     $dbf6,y
        clc
        adc     $b444,x
        sta     $dbf6,y
        sta     $dbf9,y
        tya
        clc
        adc     #$06
        tay
@4081:  inx
        cpx     #$0004
        bne     @4068
        clr_a
        sta     $dbf6,y
        jsr     _c12dac
        lda     #$5e
        sta     $bd1f
        inc
        sta     $bd21
        lda     $0425
        beq     @409f
        jsr     $3ff4
@409f:  rts

; ---------------------------------------------------------------------------

; [  ]

_c140a0:
@40a0:  lda     #$01
        jsr     $4641
        lda     #$01
        jsr     $4656
        clr_axy
@40ad:  lda     $b444,x
        cmp     #$ff
        beq     @40d7
        lda     $dbf8,y
        clc
        adc     $b444,x
        sta     $dbf8,y
        lda     $41b0
        and     #$01
        beq     @40d2
        lda     $b444,x
        cmp     $cd42
        bne     @40d2
        lda     #$08
        sta     $dbf7,y
@40d2:  tya
        clc
        adc     #$05
        tay
@40d7:  inx
        cpx     #$0004
        bne     @40ad
        clr_a
        sta     $dbf6,y
        jmp     _c12dac

; ---------------------------------------------------------------------------

; [  ]

_c140e4:
@40e4:  lda     $cd42
        asl3
        tax
        longa
        lda     $3830,x
        sta     $70
        lda     $3832,x
        sta     $72
        shorta0
        lda     $ce
        pha
        lda     #$69
        sta     $ce
        ldx     $70
        ldy     #$00ae
        jsr     $412f
        lda     #$76
        sta     $c265
        iny2
        ldx     $72
        jsr     $412f
        lda     $cd42
        tay
        asl
        tax
        lda     $db
        clc
        adc     ($d3),y
        longa
        clc
        adc     $ceff8d,x
        tax
        shorta0
        pla
        sta     $ce
        rts

; ---------------------------------------------------------------------------

; [  ]

_c1412f:
@412f:  jsr     $ff2e
        jsr     $ff0e
        lda     $c5
        sta     $c1b1,y
        iny2
        lda     $c6
        sta     $c1b1,y
        iny2
        lda     $c7
        sta     $c1b1,y
        iny2
        rts

; ---------------------------------------------------------------------------

_c1414b:
        jsr     $40e4
        lda     $ce
        pha
        lda     #$69
        sta     $ce
        lda     $2e38,x
        tax
        ldy     #$01b2
        jsr     $412f
        pla
        sta     $ce
        lda     #$05
        jsr     _c14622
        stz     $cd38
        rts

; ---------------------------------------------------------------------------

_c1416b:
        jsr     $40a0
        clr_a
        jsr     _c14622
        stz     $cd38
        rts

; ---------------------------------------------------------------------------

_c14176:
@4176:  ldx     #$027f
        stx     $70
        ldx     #$bcb1
        lda     #$7e
        ldy     #$bf31
        jsr     $fce1       ; move data
        ldx     #$0028
        jsr     $3f95
        jsr     $41a7
        lda     #$04
        sta     $75
        jsr     $427f
        lda     #$03
        jsr     $4641
        jsr     _c12dac
        lda     #$01
        jsr     _c14622
        stz     $cd38
        rts

; ---------------------------------------------------------------------------

_c141a7:
@41a7:  lda     $cd42
        asl
        tax
        longa
        lda     $ceff10,x
        sta     $70
        lda     $ceff18,x
        sta     $72
        shorta0
        rts

; ---------------------------------------------------------------------------

_c141be:
@41be:  lda     $cd42
        asl
        tax
        longa
        lda     $ceff00,x
        sta     $70
        lda     $ceff08,x
        sta     $72
        shorta0
        rts

; ---------------------------------------------------------------------------

; [  ]

_c141d5:
@41d5:  ldx     #$0098
        bra     _41dd

_c141da:
@41da:  ldx     #$01c0
_41dd:  stx     $72
        lda     $0426
        bpl     @41e7       ; branch if memory cursor setting
        clr_a
        bra     @41ef
@41e7:  lda     $cd42
        tax
        lda     $042d,x
        asl
@41ef:  tax
        longa
        lda     $d83000,x   ; battle menu cursor positions
        sta     $70
        clr_ax
@41fa:  lda     $72
        sta     $bb25,x
        lda     $b537,x
        clc
        adc     $70
        clc
        adc     #$0040
        clc
        adc     #$0100
        sta     $bb27,x
        inx4
        cpx     #$0050
        bne     @41fa
        shorta0
        rts

; ---------------------------------------------------------------------------

_c1421d:
        jsr     $41da
        stz     $cd38
        rts

; ---------------------------------------------------------------------------

_c14224:
        jsr     $41d5
        stz     $cd38
        rts

; ---------------------------------------------------------------------------

; [ battle graphics function $05:  ]

_c1422b:
        jsr     $40a0
        lda     $cd40
        jne     _c14176
        ldx     #$027f
        stx     $70
        ldx     #$bcb1
        lda     #$7e
        ldy     #$bf31
        jsr     $fce1       ; move data
        lda     $0426
        bpl     @425e
        ldx     #$0078
        jsr     $3f95
        jsr     $41be
        jsr     $4365
        lda     #$08
        jsr     $4641
        bra     @4273
@425e:  ldx     #$0010
        jsr     $3f95
        jsr     $41be
        lda     #$04
        sta     $75
        jsr     $42f3
        lda     #$03
        jsr     $4641
@4273:  jsr     _c12dac
        lda     #$01
        jsr     _c14622
        stz     $cd38
        rts

; ---------------------------------------------------------------------------

_c1427f:
@427f:  clr_ay
@4281:  lda     #$0d
        sta     $dbf6,y
        iny
        lda     ($72)
        bmi     @428f
        lda     #$00
        bra     @4291
@428f:  lda     #$04
@4291:  sta     $dbf6,y
        iny
        lda     ($70)
        cmp     #$57
        bcc     @42bc
        sec
        sbc     #$57
        sta     $7e
.if LANG_EN
        lda     #$0c
.else
        lda     #$09
.endif
        sta     $80
        jsr     $feba       ; +$82 = $7e * $80
        ldx     $82
.if LANG_EN
        lda     #$0c
        sta     $74
@42ad:  lda     $e70f90,x
.else
        lda     #$09
        sta     $74
@42ad:  lda     $d11e8a,x
.endif
        sta     $dbf6,y
        inx
        iny
        dec     $74
        bne     @42ad
        bra     @42d8
@42bc:  sta     $7e
        lda     #$06
        sta     $80
        jsr     $feba       ; +$82 = $7e * $80
        ldx     $82
        lda     #$06
        sta     $74
@42cb:  lda     $d11c80,x
        sta     $dbf6,y
        inx
        iny
        dec     $74
        bne     @42cb
@42d8:  lda     #$01
        sta     $dbf6,y
        iny
        phx
        ldx     $70
        inx
        stx     $70
        ldx     $72
        inx
        stx     $72
        plx
        dec     $75
        bne     @4281
        clr_a
        sta     $dbf6,y
        rts

; ---------------------------------------------------------------------------

_c142f3:
@42f3:  clr_ay
@42f5:  jsr     $4316
        jsr     $4336
        lda     #$01
        sta     $dbf6,y
        iny
        phx
        ldx     $70
        inx
        stx     $70
        ldx     $72
        inx
        stx     $72
        plx
        dec     $75
        bne     @42f5
        clr_a
        sta     $dbf6,y
        rts

; ---------------------------------------------------------------------------

_c14316:
@4316:  lda     ($70)
        sta     $7e
.if LANG_EN
        lda     #$07
.else
        lda     #$05
.endif
        sta     $80
        jsr     $feba       ; +$82 = $7e * $80
        lda     #$0d
        sta     $dbf6,y
        iny
        lda     ($72)
        bmi     @432f
        lda     #$00
        bra     @4331
@432f:  lda     #$04
@4331:  sta     $dbf6,y
        iny
        rts

; ---------------------------------------------------------------------------

_c14336:
@4336:  ldx     $82
.if LANG_EN
        lda     #$07
        sta     $74
@433c:  lda     $e01150,x
.else
        lda     #$05
        sta     $74
@433c:  lda     $d15800,x
.endif
        sta     $dbf6,y
        inx
        iny
        dec     $74
        bne     @433c
        rts

; ---------------------------------------------------------------------------

_c1434a:
@434a:  sta     $dbf6,y
        iny
        rts

; ---------------------------------------------------------------------------

_c1434f:
@434f:  tax
        lda     $fef6,x
        longa
        pha
        clc
        adc     $78
        sta     $70
        pla
        clc
        adc     $7a
        sta     $72
        shorta0
        rts

; ---------------------------------------------------------------------------

_c14365:
@4365:  ldx     $70
        stx     $78
        ldx     $72
        stx     $7a
        clr_ay
        clr_a
        jsr     $434f
        jsr     $4316
        lda     #$ff
        jsr     $434a
        jsr     $434a
        jsr     $434a
        jsr     $434a
        jsr     $4336
        lda     #$01
        jsr     $434a
        lda     #$01
        jsr     $434f
        jsr     $4316
        jsr     $4336
        lda     #$ff
        jsr     $434a
        lda     #$02
        jsr     $434f
        jsr     $4316
        lda     #$ff
        jsr     $434a
        jsr     $4336
        lda     #$01
        jsr     $434a
        lda     #$03
        jsr     $434f
        jsr     $4316
        lda     #$ff
        jsr     $434a
        jsr     $434a
        jsr     $434a
        jsr     $434a
        jsr     $4336
        clr_a
        jmp     _c1434a

; ---------------------------------------------------------------------------

_c143ce:
        ldx     #$0018
        jsr     $3f95
        lda     #$04
        jsr     $4656
        lda     #$06
        jsr     $4641
        lda     $cd42
        tax
        lda     $ceff80,x
        sta     $7a
        stz     $70
        lda     $ceff84,x
        tax
        lda     $37ac,x
        ora     $37ad,x
        bne     @43fb
        inc     $70
        bra     @4415
@43fb:  lda     $37ac,x
        bne     @4409
        lda     $37ad,x
        bpl     @4409
        inc     $70
        bra     @4415
@4409:  lda     $37ad,x
        bne     @4415
        lda     $37ac,x
        bpl     @4415
        inc     $70
@4415:  ldy     #$000a
        jsr     $442e
        inx
        ldy     #$0013
        jsr     $442e
        jsr     _c12dac
        lda     #$02
        jsr     _c14622
        stz     $cd38
        rts

; ---------------------------------------------------------------------------

_c1442e:
@442e:  lda     #$00
        ora     #$20
        sta     $dbf7,y
        lda     $37ac,x
        bne     @443d
        clc
        adc     $70
@443d:  sta     $dbf9,y
        lda     $37ae,x
        sta     $dbfc,y
        lda     $37ac,x
        bne     @4450
        lda     #$ff
        sta     $dbfa,y
@4450:  rts

; ---------------------------------------------------------------------------

; [  ]

_c14451:
        jsr     $37b6
        jsr     $45f1
        jsr     $3ea8

_c1445a:
        lda     #$06
        jsr     $4656
        lda     $cdfa
        tax
        lda     $ceff67,x
        sta     $72
        lda     $cd42
        tay
        asl
        tax
        lda     ($d9),y
        asl
        clc
        adc     $db
        sta     $70
        stz     $71
        longa
        lda     $ceff8d,x
        clc
        adc     $70
        sta     $70
        shorta0
        ldx     $70
        lda     #$0a
        sta     $74
@448d:  phx
        lda     $72
        tax
        lda     $ceff6c,x
        tay
        inc     $72
        plx
        lda     $2f3c,x
        bmi     @44a2
        lda     #$00
        bra     @44a4
@44a2:  lda     #$04
@44a4:  sta     $dbf7,y
        lda     $2d34,x
        sta     $dbf9,y
        inx
        cpx     #$0082
        beq     @44b7
        dec     $74
        bne     @448d
@44b7:  lda     #$05
        jsr     $4641
        jsr     _c12dac
        lda     #$03
        jsr     _c14622
        stz     $cd38
        rts

; ---------------------------------------------------------------------------

_c144c8:
        jsr     $37b6
        jsr     $45f1
        jsr     $3ea8

_c144d1:
        lda     #$05
        jsr     $4656
        lda     $cdfa
        tax
        lda     $ceff62,x
        sta     $72
        lda     $cd42
        tay
        asl
        tax
        lda     ($d9),y
        asl
        clc
        adc     ($d9),y
        clc
        adc     $db
        sta     $70
        stz     $71
        longa
        lda     $ceff8d,x
        clc
        adc     $70
        sta     $70
        shorta0
        ldx     $70
        lda     #$0f
        sta     $74
@4507:  phx
        lda     $72
        tax
        lda     $ceff44,x
        tay
        inc     $72
        plx
        lda     $2f3c,x
        bmi     @451c
        lda     #$00
        bra     @451e
@451c:  lda     #$04
@451e:  sta     $dbf7,y
        lda     $2d34,x
        cmp     #$ff
        bne     @452f
        lda     #$05
        sta     $dbf8,y
        lda     #$06
@452f:  cmp     #$57
        bcc     @4534
        clr_a
@4534:  sta     $dbf9,y
        inx
        cpx     #$0082
        beq     @4541
        dec     $74
        bne     @4507
@4541:  lda     #$05
        jsr     $4641
        jsr     _c12dac
        lda     #$03
        jsr     _c14622
        stz     $cd38
        rts

; ---------------------------------------------------------------------------

_c14552:
        jsr     $45f1
        jsr     $3ea8
        jmp     _c1455e

_c1455b:
        jsr     $45f1

_c1455e:
        lda     #$03
        jsr     $4656
        lda     $cdfa
        tax
        lda     $ceff88,x
        sta     $70
        lda     $cd42
        tax
        lda     $db4f
        beq     @457a
        lda     #$40
        bra     @458f
@457a:  lda     $db4e
        beq     @458b
        cmp     #$01
        beq     @4587
        lda     #$02
        bra     @458f
@4587:  lda     #$10
        bra     @458f
@458b:  lda     $ceff80,x
@458f:  sta     $7a
        lda     $044d,x
        asl
        tax
        lda     #$0a
        sta     $72
@459a:  phx
        lda     $70
        tax
        lda     $ceff30,x
        tay
        inc     $70
        plx
        lda     $db4e
        ora     $db4f
        beq     @45b3
        lda     $2b34,x
        bra     @45b6
@45b3:  lda     $2c34,x
@45b6:  and     $7a
        beq     @45be
        lda     #$04
        bra     @45c0
@45be:  lda     #$00
@45c0:  sta     $dbf7,y
        lda     $2834,x
        sta     $dbfe,y
        lda     $2734,x
        sta     $dbfb,y
        bne     @45d6
        lda     #$ff
        sta     $dbfc,y
@45d6:  inx
        cpx     #$0100
        beq     @45e0
        dec     $72
        bne     @459a
@45e0:  lda     #$05
        jsr     $4641
        jsr     _c12dac
        lda     #$03
        jsr     _c14622
        stz     $cd38
        rts

; ---------------------------------------------------------------------------

; [  ]

_c145f1:
@45f1:  lda     #$04
        sta     $cdfa
        clr_axy
@45f9:  lda     #$0c
        sta     $70
@45fd:  lda     $d4b952,x
        longa
        sec
        sbc     #$00a4
        sta     $ba37,y
        lda     #$0001
        sta     $ba35,y
        shorta0
        iny4
        dec     $70
        bne     @45fd
        inx
        cpy     #$00f0
        bne     @45f9
        rts

; ---------------------------------------------------------------------------

; [  ]

_c14622:
@4622:  sta     $7e
        lda     #$06
        sta     $80
        jsr     $feba       ; +$82 = $7e * $80
        ldx     $82
        clr_ay
@462f:  lda     $d83216,x
        sta     $bc66,y
        iny
        inx
        cpy     #$0006
        bne     @462f
        inc     $bc65
        rts

; ---------------------------------------------------------------------------

; [  ]

_c14641:
@4641:  asl3
        tax
        clr_ay
@4647:  lda     $d8314e,x
        sta     $bca0,y
        iny
        inx
        cpy     #$0006
        bne     @4647
        rts

; ---------------------------------------------------------------------------

; [  ]

_c14656:
@4656:  asl
        tax
        lda     $d83008,x
        sta     $70
        lda     $d83009,x
        sta     $71
        lda     #$d8
        sta     $72
        clr_ay
@466a:  lda     [$70],y
        sta     $dbf6,y
        iny
        cpy     #$0080
        bne     @466a
        rts

; ---------------------------------------------------------------------------

; [ battle command menu $00/$0a: no menu ]

_c14676:
        lda     $cd42
        tax
        jsr     $5270
        lda     ($88)
        pha
        lda     #$09
        clc
        adc     $cdf7
        sta     $88
        pla
        jmp     _c1510e

; ---------------------------------------------------------------------------

; [ battle command menu $0b: ??? ]

_c1468c:
        rts

; ---------------------------------------------------------------------------

; [ battle command menu $0d: combine ]

_c1468d:
        jsr     $47b6
        lda     #$08
        sta     $f891
        lda     #$01
        sta     $cfc3
        inc
        sta     $db4e
        rts

; ---------------------------------------------------------------------------

; [ battle command menu $0e: drink ]

_c1469f:
        jsr     $47b6
        lda     #$01
        sta     $cfc3
        sta     $db4e
        rts

; ---------------------------------------------------------------------------

; [ battle command menu $0f: throw ]

_c146ab:
        jsr     $47b6
        lda     #$01
        sta     $cfc3
        sta     $db4f
        rts

; ---------------------------------------------------------------------------

; [ battle command menu $01: spellblade ]

_c146b7:
        lda     #$09
        jmp     _c146fd

; ---------------------------------------------------------------------------

; [ battle command menu $02: white magic ]

_c146bc:
        lda     #$0a
        jmp     _c146fd

; ---------------------------------------------------------------------------

; [ battle command menu $03: black magic ]

_c146c1:
        lda     #$0b
        jmp     _c146fd

; ---------------------------------------------------------------------------

; [ battle command menu $04: time magic ]

_c146c6:
        lda     #$0c
        jmp     _c146fd

; ---------------------------------------------------------------------------

; [ battle command menu $05: summon ]

_c146cb:
        lda     #$0d
        jmp     _c146fd

; ---------------------------------------------------------------------------

; [ battle command menu $06: blue magic ]

_c146d0:
        lda     #$0e
        jmp     _c146e9

; ---------------------------------------------------------------------------

; [ battle command menu $09: red magic ]

_c146d5:
        lda     #$0f
        jmp     _c146e9

; ---------------------------------------------------------------------------

; [ battle command menu $07: song ??? ]

_c146da:
        lda     #$10
        jmp     _c146fd

; ---------------------------------------------------------------------------

; [ battle command menu $08: x-magic ]

_c146df:
        lda     #$08
        sta     $f891
        lda     #$11
        jmp     _c146fd

; ---------------------------------------------------------------------------

; [  ]

_c146e9:
@46e9:  pha
        lda     #$01
        sta     $cf
        lda     #$03
        sta     $d0
        lda     #$01
        sta     $d1
        lda     #$02
        sta     $d2
        pla
        bra     _470b

_c146fd:
@46fd:  pha
        stz     $cf
        stz     $d0
        lda     #$02
        sta     $d1
        lda     #$03
        sta     $d2
        pla
_470b:  sta     $cd39       ; menu id ???
        stz     $cfc3
        lda     #$04
        sta     $cdfa
        lda     #$04
        jsr     $496a
        lda     #$05
        sta     $cd3a
        lda     #$01
        sta     $cd3b
        lda     #$0c
        sta     $cd3c
        lda     #$20
        jsr     $5318
        jsr     $47ef
        jmp     _c15494

; ---------------------------------------------------------------------------

; [  ]

_c14735:
        stz     $cd6c
        stz     $cd70
        lda     #$05
        jsr     $496a
        lda     #$07
        sta     $cd39
        lda     #$05
        sta     $cd3a
        lda     #$02
        sta     $cd3b
        lda     #$09
        clc
        adc     $cdf7
        sta     $cd3c
        rts

; ---------------------------------------------------------------------------

; [  ]

_c14759:
        lda     #$12
        sta     $cd39
        lda     #$0a
        jsr     $496a
        lda     #$05
        sta     $cd3a
        lda     #$01
        sta     $cd3b
        lda     #$0b
        sta     $cd3c
        rts

; ---------------------------------------------------------------------------

; [  ]

_c14773:
        stz     $cd6c
        stz     $cd70
        lda     #$0b
        jsr     $496a
        lda     #$02
        sta     $cd3a
        lda     #$0d
        sta     $cd3b
        rts

; ---------------------------------------------------------------------------

; [  ]

_c14789:
        lda     #$06
        jsr     $496a
        lda     #$04
        sta     $cd39
        lda     #$05
        sta     $cd3a
        lda     #$01
        sta     $cd3b
        lda     #$08
        sta     $cd3c
        rts

; ---------------------------------------------------------------------------

; [  ]

_c147a3:
        lda     #$07
        jsr     $496a
        lda     #$02
        sta     $cd3a
        lda     #$07
        sta     $cd3b
        stz     $cd50
        rts

; ---------------------------------------------------------------------------

; [ battle command menu $0c: item ]

_c147b6:
@47b6:  stz     $cfc3
        stz     $db4e
        stz     $db4f
        lda     #$04
        sta     $cdfa
        lda     #$04
        jsr     $496a
        lda     #$08
        sta     $cd39
        lda     #$05
        sta     $cd3a
        lda     #$01
        sta     $cd3b
        lda     #$07
        sta     $cd3c
        jsr     $47ef
        stz     $f891
        stz     $f88c
        stz     $f88e
        stz     $cf3b
        jmp     _c15494

; ---------------------------------------------------------------------------

; [  ]

_c147ef:
@47ef:  clr_ax
@47f1:  lda     $c5f1,x
        sta     $cd77,x
        inx
        cpx     #$0080
        bne     @47f1
        rts

; ---------------------------------------------------------------------------

; [  ]

_c147fe:
        lda     #$05
        jsr     $496a
        lda     #$06
        clc
        adc     $cdf7
        sta     $cd39
        lda     #$05
        sta     $cd3a
        lda     #$02
        sta     $cd3b
        lda     #$09
        clc
        adc     $cdf7
        sta     $cd3c
        stz     $cfc3
        stz     $cdf7
        stz     $cf3b
        stz     $cd4c
        stz     $cd48
        stz     $f88c
        stz     $f88e
        stz     $cd6c
        stz     $cd70
        rts

; ---------------------------------------------------------------------------

; [  ]

_c1483b:
        lda     #$09
        sta     $bc83
        lda     #$0e
        jsr     $496a
        lda     #$1d
        sta     $cd39
        lda     #$05
        sta     $cd3a
        lda     #$01
        sta     $cd3b
        lda     #$12
        sta     $cd3c
        jmp     _c15494

; ---------------------------------------------------------------------------

; [  ]

_c1485c:
@485c:  pha
        lda     #$0f
        jsr     $496a
        lda     #$02
        sta     $cd3a
        pla
        sta     $cd3b
        jmp     _c15494

; ---------------------------------------------------------------------------

; [  ]

_c1486e:
        lda     $cd42
        asl5
        tax
        stz     $cf58,x
        lda     $cf56,x
        and     #$fe
        sta     $cf56,x
        lda     #$02
        jsr     $496a
        lda     #$02
        sta     $cd39
        lda     #$05
        sta     $cd3a
        lda     #$01
        sta     $cd3b
        lda     #$06
        sta     $cd3c
        stz     $cfd2
        stz     $cfc3
        rts

; ---------------------------------------------------------------------------

; [  ]

_c148a2:
        lda     #$03
        jsr     $496a
        lda     #$01
        sta     $cd39
        lda     #$05
        sta     $cd3a
        lda     #$02
        sta     $cd3b
        lda     #$0e
        sta     $cd3c
        lda     $cdf9
        bne     @48f6
        lda     $cd42
        asl5
        tax
        lda     $41b1
        bmi     @48da
        and     #$20
        beq     @48d6
        lda     #$09
        bra     @48eb
@48d6:  lda     #$01
        bra     @48eb
@48da:  lda     $cf4d,x
        cmp     #$03
        beq     @48eb
        phx
        lda     $41b6
        tax
        lda     $d83366,x
        plx
@48eb:  sta     $cf58,x
        lda     $cf56,x
        ora     #$01
        sta     $cf56,x
@48f6:  rts

; ---------------------------------------------------------------------------

_c148f7:
@48f7:  lda     $0426
        bpl     @48ff
        clr_a
        bra     @4907
@48ff:  lda     $cd42
        tax
        lda     $042d,x
        asl
@4907:  tax
        longa
        lda     $d8335e,x
        sta     $88
        lda     $cd33
        clc
        adc     $88
        sta     $cd33
        shorta0
        rts

; ---------------------------------------------------------------------------

_c1491d:
        lda     #$0d
        jsr     $496a
        jsr     $48f7
        lda     #$02
        sta     $cd3a
        lda     #$06
        sta     $cd3b
        rts

; ---------------------------------------------------------------------------

_c14930:
        lda     #$0c
        jsr     $496a
        jsr     $48f7
        lda     #$14
        sta     $cd39
        lda     #$05
        sta     $cd3a
        lda     #$01
        sta     $cd3b
        lda     #$10
        sta     $cd3c
        rts

; ---------------------------------------------------------------------------

_c1494d:
        lda     #$0c
        jsr     $496a
        jsr     $48f7
        lda     #$13
        sta     $cd39
        lda     #$05
        sta     $cd3a
        lda     #$01
        sta     $cd3b
        lda     #$0f
        sta     $cd3c
        rts

; ---------------------------------------------------------------------------

_c1496a:
@496a:  sta     $98
        lda     #$05
        sta     $9a
        jsr     $fe4b
        ldx     $9c
        clr_ay
@4977:  lda     $d83392,x
        sta     $cd31,y
        inx
        iny
        cpy     #$0005
        bne     @4977
        rts

; ---------------------------------------------------------------------------

_c14986:
        ldx     $cd31
        stx     $88
        ldx     $cd33
        stx     $8a
        clr_ay
@4992:  lda     ($88),y
        sta     $8c
        lda     ($8a),y
        sta     ($88),y
        lda     $8c
        sta     ($8a),y
        iny
        cpy     #$0020
        bne     @4992
        longa
        lda     $88
        clc
        adc     #$0020
        sta     $cd31
        lda     $8a
        clc
        adc     #$0020
        sta     $cd33
        shorta0
        dec     $cd35
        bne     @49c3
        jsr     $fd07
@49c3:  rts

; ---------------------------------------------------------------------------

_c149c4:
        ldx     $cd31
        stx     $88
        ldx     $cd33
        stx     $8a
        clr_ay
@49d0:  lda     ($88),y
        pha
        lda     ($8a),y
        sta     ($88),y
        pla
        sta     ($8a),y
        iny
        cpy     #$0020
        bne     @49d0
        longa
        lda     $88
        sec
        sbc     #$0020
        sta     $cd31
        lda     $8a
        sec
        sbc     #$0020
        sta     $cd33
        shorta0
        dec     $cd35
        bne     @4a04
        jsr     $fd07
        lda     #$01
        sta     $bc83
@4a04:  rts

; ---------------------------------------------------------------------------

_c14a05:
        lda     $bc76
        beq     @4a4e
        ldx     #$0100
        stx     $88
        ldx     #$c9b1
        lda     #$7e
        ldy     #$4820
        jsr     $fdb6       ; copy data to vram
        stz     $bc76
        longa
        lda     #$4080
        sta     f:$002116
        lda     #$f357
        sta     f:$004342
        lda     #$01a0
        sta     f:$004345
        shorta0
        lda     #$7e
        sta     f:$004344
        clr_a
        sta     f:$004340
        lda     #$19
        sta     f:$004341
        lda     #$10
        sta     f:$00420b
@4a4e:  rts

; ---------------------------------------------------------------------------

_c14a4f:
        lda     $cd74
        beq     @4a67
        ldx     #$0080
        stx     $88
        ldy     $cd75
        ldx     #$cd77
        lda     #$7e
        jsr     $fdb6       ; copy data to vram
        stz     $cd74
@4a67:  rts

; ---------------------------------------------------------------------------

_c14a68:
        lda     $dbd3
        bne     @4a85
        lda     $bc65
        beq     @4a85
        ldx     $bc66
        stx     $88
        ldy     $bc68
        ldx     $bc6a
        lda     #$7e
        jsr     $fdb6       ; copy data to vram
        stz     $bc65
@4a85:  rts

; ---------------------------------------------------------------------------

_c14a86:
        clr_ax
        longa
        lda     $ba37,x
        sta     $88
        lda     $ba3b,x
        sta     $8a
        lda     $ba3f,x
        sta     $8c
        lda     $ba43,x
        sta     $8e
@4a9e:  lda     $ba47,x
        clc
        adc     #$0004
        sta     $ba37,x
        lda     $ba4b,x
        clc
        adc     #$0004
        sta     $ba3b,x
        lda     $ba4f,x
        clc
        adc     #$0004
        sta     $ba3f,x
        lda     $ba53,x
        clc
        adc     #$0004
        sta     $ba43,x
        txa
        clc
        adc     #$0010
        tax
        cpx     #$00e0
        bne     @4a9e
        lda     $8e
        sec
        sbc     #$0038
        sta     $ba43,x
        lda     $8c
        sec
        sbc     #$0038
        sta     $ba3f,x
        lda     $8a
        sec
        sbc     #$0038
        sta     $ba3b,x
        lda     $88
        sec
        sbc     #$0038
        sta     $ba37,x
        clr_ax
@4af7:  lda     $ba37,x
        sta     $b2d5,x
        inx4
        cpx     #$00c0
        bne     @4af7
        lda     $cf3e
        sec
        sbc     #$0004
        sta     $cf3e
        shorta0
        jsr     $4bbc
        dec     $cd37
        bne     @4b21
        jsr     $fd07
        jsr     $1186
@4b21:  rts

; ---------------------------------------------------------------------------

_c14b22:
        ldx     #$00e0
        longa
        lda     $ba37,x
        sta     $88
        lda     $ba3b,x
        sta     $8a
        lda     $ba3f,x
        sta     $8c
        lda     $ba43,x
        sta     $8e
@4b3b:  lda     $ba33,x
        sec
        sbc     #$0004
        sta     $ba43,x
        lda     $ba2f,x
        sec
        sbc     #$0004
        sta     $ba3f,x
        lda     $ba2b,x
        sec
        sbc     #$0004
        sta     $ba3b,x
        lda     $ba27,x
        sec
        sbc     #$0004
        sta     $ba37,x
        txa
        sec
        sbc     #$0010
        tax
        bne     @4b3b
        lda     $8e
        clc
        adc     #$0038
        sta     $ba43,x
        lda     $8c
        clc
        adc     #$0038
        sta     $ba3f,x
        lda     $8a
        clc
        adc     #$0038
        sta     $ba3b,x
        lda     $88
        clc
        adc     #$0038
        sta     $ba37,x
        clr_ax
@4b91:  lda     $ba37,x
        sta     $b2d5,x
        inx4
        cpx     #$00c0
        bne     @4b91
        lda     $cf3e
        clc
        adc     #$0004
        sta     $cf3e
        shorta0
        jsr     $4bbc
        dec     $cd37
        bne     @4bbb
        jsr     $fd07
        jsr     $1186
@4bbb:  rts

; ---------------------------------------------------------------------------

_c14bbc:
@4bbc:  stz     $cd4c
        lda     $cf3b
        beq     @4be8
        longa
        lda     $cf3e
        cmp     #$00a8
        bcc     @4be5
        cmp     #$00d0
        bcs     @4be5
        shorta0
        lda     $cf3c
        sta     $cd4d
        lda     $cf3e
        sta     $cd4e
        inc     $cd4c
@4be5:  shorta0
@4be8:  rts

; ---------------------------------------------------------------------------

_c14be9:
@4be9:  stz     $cd58
        stz     $cd5c
        stz     $cd60
        stz     $cd64
        rts

; ---------------------------------------------------------------------------

_c14bf6:
@4bf6:  tax
        clr_ay
@4bf9:  asl     $88
        bcc     @4c12
        lda     $d04e,x
        clc
        adc     $d096,x
        sta     $cd59,y
        lda     $d05a,x
        sta     $cd5a,y
        lda     #$01
        sta     $cd58,y
@4c12:  inx
        iny4
        cpy     #$0010
        bne     @4bf9
        rts

; ---------------------------------------------------------------------------

_c14c1d:
@4c1d:  jsr     $4be9
        lda     $d0c5
        beq     @4c59
        cmp     #$01
        beq     @4c38
        lda     $a2
        and     #$01
        bne     @4c72
        lda     $df
        sta     $88
        lda     #$08
        jmp     _c14bf6
@4c38:  lda     $a2
        and     #$01
        beq     @4c49
        lda     $de
        and     $dbe1
        sta     $88
        clr_a
        jmp     _c14bf6
@4c49:  lda     $de
        and     $dbe1
        asl4
        sta     $88
        lda     #$04
        jmp     _c14bf6
@4c59:  lda     $d0c4
        tax
        lda     $d04e,x
        clc
        adc     $d096,x
        sta     $cd59
        lda     $d05a,x
        sta     $cd5a
        lda     #$01
        sta     $cd58
@4c72:  rts

; ---------------------------------------------------------------------------

_c14c73:
@4c73:  jsr     $fc96       ; generate random number
        and     #$0f
        sta     $88
        asl
        tax
        longa
        lda     $de
        and     $dbe1
        and     $ceffd5,x
        bne     @4c8e
        shorta0
        bra     @4c73
@4c8e:  shorta0
        lda     $88
        sta     $d0c4
        rts

; ---------------------------------------------------------------------------

_c14c97:
@4c97:  jsr     $fbad       ; play system sound effect $10
        lda     $d0c4
        sta     $88
@4c9f:  inc     $88
        lda     $88
        and     #$0f
        sta     $88
        asl
        tax
        longa
        lda     $de
        and     $dbe1
        and     $ceffd5,x
        bne     @4cbb
        shorta0
        bra     @4c9f
@4cbb:  shorta0
        lda     $88
        sta     $d0c4
        rts

; ---------------------------------------------------------------------------

_c14cc4:
@4cc4:  lda     $d0c5
        beq     @4cde
        cmp     #$01
        beq     @4cd4
        stz     $88
        lda     $df
        sta     $89
        rts
@4cd4:  stz     $89
        lda     $de
        and     $dbe1
        sta     $88
        rts
@4cde:  lda     $d0c4
        asl
        longa
        tax
        lda     $ceffd5,x
        sta     $88
        shorta0
        rts

; ---------------------------------------------------------------------------

_c14cef:
        lda     $db47
        bne     @4d12
        lda     $db48
        and     #$02
        beq     @4d00
        jsr     $4be9
        bra     @4d03
@4d00:  jsr     _c14c1d
@4d03:  dec     $db48
        bne     @4d11
        jsr     $4d3c
        jsr     $4be9
        jsr     $4d28
@4d11:  rts
@4d12:  dec     $db47
        bne     @4d1c
        lda     #$10
        sta     $db48
@4d1c:  lda     $a2
        and     #$0f
        bne     @4d25
        jsr     $4c97
@4d25:  jmp     _c14c1d

; ---------------------------------------------------------------------------

_c14d28:
@4d28:  lda     $d0c2
        and     #$08
        bne     @4d35
        lda     $d0c3
        jmp     _c1485c
@4d35:  lda     $d0c3
        sta     $cd3a
        rts

; ---------------------------------------------------------------------------

_c14d3c:
@4d3c:  jsr     $4cc4
        lda     $f890
        tax
        lda     $88
        sta     $41b4,x
        lda     $89
        sta     $41b5,x
        lda     $d0c2
        and     #$04
        bne     @4d57
        jsr     $4be9
@4d57:  lda     $db4e
        cmp     #$02
        bne     @4d69
        lda     $41b2
        sta     $41b9
        ldx     $88
        stx     $41b4
@4d69:  lda     $f891
        beq     @4d79
        lda     $f890
        bne     @4d79
        lda     #$07
        sta     $f890
        rts
@4d79:  stz     $f890
        inc     $cdf8
        rts

; ---------------------------------------------------------------------------

_c14d80:
        lda     $01
        and     #$0f
        beq     @4d89
        jsr     $fbad       ; play system sound effect $10
@4d89:  lda     $d0c2
        cmp     #$08
        beq     @4d97
        lda     $00
        bpl     @4db9
        jsr     $fbb8       ; play system sound effect $11
@4d97:  lda     $d0c2
        and     #$04
        beq     @4db3
        jsr     _c15494
        jsr     $fc96       ; generate random number
        and     #$3f
        clc
        adc     #$20
        sta     $db47
        lda     #$13
        sta     $cd3a
        bra     @4db6
@4db3:  jsr     $4d28
@4db6:  jmp     _c14d3c
@4db9:  lda     $cdf8
        bne     @4dc8
        lda     $01
        bpl     @4de4
        jsr     $fbc3       ; play system sound effect $11
        jsr     _c15494
@4dc8:  lda     $d0c2
        and     #$08
        bne     @4dd7
        lda     $d0c3
        jsr     $485c
        bra     @4ddd
@4dd7:  lda     $d0c3
        sta     $cd3a
@4ddd:  jsr     $4be9
        stz     $f890
        rts
@4de4:  lda     $d0c2
        and     #$20
        beq     @4e2d
        lda     $d0c2
        and     #$04
        beq     @4dfd
        lda     $a2
        and     #$03
        bne     @4e2d
        jsr     $4c97
        bra     @4e2d
@4dfd:  lda     $01
        and     #$0f
        cmp     #$08
        bne     @4e0a
        jsr     $4ea3
        bra     @4e2d
@4e0a:  cmp     #$04
        bne     @4e13
        jsr     $4ec6
        bra     @4e2d
@4e13:  cmp     #$02
        bne     @4e20
        lda     $f6
        bne     @4e28
@4e1b:  jsr     $4f28
        bra     @4e2d
@4e20:  cmp     #$01
        bne     @4e2d
        lda     $f6
        bne     @4e1b
@4e28:  jsr     $4ee9
        bra     @4e2d
@4e2d:  jsr     $4e5e
        bcc     @4dc8
        jmp     _c14c1d

; ---------------------------------------------------------------------------

_c14e35:
@4e35:  sec
        sbc     #$08
        sta     $88
@4e3a:  lda     $88
        and     #$03
        asl5
        tax
        lda     $cf43,x
        beq     @4e53
        lda     $88
        clc
        adc     $8a
        sta     $88
        jmp     @4e3a
@4e53:  lda     $88
        and     #$03
        clc
        adc     #$08
        sta     $d0c4
        rts

; ---------------------------------------------------------------------------

_c14e5e:
@4e5e:  lda     $d0c5
        bne     @4e9e
        lda     $d0c4
        asl
        tax
        longa
        lda     $de
        and     $dbe1
        and     $ceffd5,x
        bne     @4e9e
        shorta0
        lda     $d0c4
        cmp     #$08
        bcc     @4e81
@4e7f:  clc
        rts
@4e81:  lda     $de
        beq     @4e7f
        clr_ay
@4e87:  lda     $d0aa,y
        jsr     $5195
        bcs     @4e98
        iny
        cpy     #$0008
        bne     @4e87
        jmp     @4e7f
@4e98:  lda     $d0aa,y
        sta     $d0c4
@4e9e:  shorta0
        sec
        rts

; ---------------------------------------------------------------------------

_c14ea3:
@4ea3:  lda     $d0c5
        bne     @4ec5
        lda     $d0c4
        cmp     #$08
        bcc     @4eb9
        pha
        lda     #$ff
        sta     $8a
        pla
        dec
        jmp     _c14e35
@4eb9:  jsr     _c14ffe
        lda     $e2
        cmp     #$ff
        beq     @4ec5
        sta     $d0c4
@4ec5:  rts

; ---------------------------------------------------------------------------

_c14ec6:
@4ec6:  lda     $d0c5
        bne     @4ee8
        lda     $d0c4
        cmp     #$08
        bcc     @4edc
        pha
        lda     #$01
        sta     $8a
        pla
        inc
        jmp     _c14e35
@4edc:  jsr     $5041
        lda     $e2
        cmp     #$ff
        beq     @4ee8
        sta     $d0c4
@4ee8:  rts

; ---------------------------------------------------------------------------

_c14ee9:
@4ee9:  lda     $d0c4
        cmp     #$08
        bcc     @4f00
        lda     $d0c5
        bne     @4eff
        lda     $d0c2
        bpl     @4eff
        lda     #$02
        sta     $d0c5
@4eff:  rts
@4f00:  lda     $d0c5
        cmp     #$01
        bne     @4f0b
        stz     $d0c5
        rts
@4f0b:  jsr     $50c9
        lda     $e2
        cmp     #$ff
        bne     @4f24
        lda     $d0c2
        and     #$10
        beq     @4eff
        lda     #$01
        sta     $8a
        lda     #$08
        jmp     _c14e35
@4f24:  sta     $d0c4
        rts

; ---------------------------------------------------------------------------

_c14f28:
@4f28:  lda     $d0c4
        cmp     #$08
        bcc     @4f59
        lda     $d0c5
        cmp     #$02
        bne     @4f3a
        stz     $d0c5
        rts
@4f3a:  lda     $d0c2
        and     #$10
        beq     @4f58
        clr_ay
@4f43:  lda     $d0aa,y
        jsr     $5195
        bcs     @4f52
        iny
        cpy     #$0008
        bne     @4f43
        rts
@4f52:  lda     $d0aa,y
        sta     $d0c4
@4f58:  rts
@4f59:  jsr     $5086
        lda     $e2
        cmp     #$ff
        bne     @4f6d
        lda     $d0c2
        bpl     @4f58
        lda     #$01
        sta     $d0c5
        rts
@4f6d:  sta     $d0c4
        rts

; ---------------------------------------------------------------------------

_c14f71:
        lda     #$ff
        sta     $e0
        sta     $e1
        sta     $e2
        lda     $d0c4
        tax
        lda     $d036,x
        lsr3
        sta     $88
        stz     $89
        lda     $d042,x
        lsr3
        sta     $8a
        stz     $8b
        rts

; ---------------------------------------------------------------------------

_c14f92:
        lda     $d036,y
        lsr3
        sta     $8c
        stz     $8d
        lda     $d042,y
        lsr3
        sta     $8e
        stz     $8f
        longa
        lda     $8c
        sec
        sbc     $88
        sta     $90
        lda     $8e
        sec
        sbc     $8a
        sta     $92
        shorta0
        rts

; ---------------------------------------------------------------------------

_c14fba:
        longa
        lda     $90
        bpl     @4fc6
        eor     #$ffff
        inc
        sta     $90
@4fc6:  lda     $92
        bpl     @4fd0
        eor     #$ffff
        inc
        sta     $92
@4fd0:  shorta0
        lda     $90
        sta     $98
        sta     $9a
        jsr     $fe4b
        ldx     $9c
        lda     $92
        sta     $98
        sta     $9a
        jsr     $fe4b
        longa
        txa
        clc
        adc     $9c
        cmp     $e0
        bcs     @4ffa
        sta     $e0
        shorta0
        tya
        sta     $e2
        rts
@4ffa:  shorta0
        rts

; ---------------------------------------------------------------------------

_c14ffe:
        jsr     $4f71
        clr_ay
@5003:  tya
        cmp     $d0c4
        beq     @500e
        jsr     $5195
        bcs     @5018
@500e:  shorta0
        iny
        cpy     #$0008
        bne     @5003
        rts
@5018:  jsr     $4f92
        longa
        lda     $92
        bpl     @500e
        lda     $90
        bpl     @502f
        lda     $92
        cmp     $90
        beq     @5038
        bcc     @5038
        bra     @500e
@502f:  lda     $92
        clc
        adc     $90
        beq     @5038
        bpl     @500e
@5038:  shorta0
        jsr     $4fba
        jmp     @500e

; ---------------------------------------------------------------------------

_c15041:
        jsr     $4f71
        clr_ay
@5046:  tya
        cmp     $d0c4
        beq     @5051
        jsr     $5195
        bcs     @505b
@5051:  shorta0
        iny
        cpy     #$0008
        bne     @5046
        rts
@505b:  jsr     $4f92
        longa
        lda     $92
        beq     @5051
        bmi     @5051
        lda     $90
        bmi     @5074
        lda     $90
        cmp     $92
        bcc     @507d
        beq     @507d
        bra     @5051
@5074:  lda     $92
        clc
        adc     $90
        beq     @507d
        bmi     @5051
@507d:  shorta0
        jsr     $4fba
        jmp     @5051

; ---------------------------------------------------------------------------

_c15086:
        jsr     $4f71
        clr_ay
@508b:  tya
        cmp     $d0c4
        beq     @5096
        jsr     $5195
        bcs     @50a0
@5096:  shorta0
        iny
        cpy     #$0008
        bne     @508b
        rts
@50a0:  jsr     $4f92
        longa
        lda     $90
        bpl     @5096
        lda     $92
        bpl     @50b7
        lda     $90
        cmp     $92
        bcc     @50c0
        beq     @50c0
        bra     @5096
@50b7:  lda     $92
        clc
        adc     $90
        beq     @50c0
        bpl     @5096
@50c0:  shorta0
        jsr     $4fba
        jmp     @5096

; ---------------------------------------------------------------------------

_c150c9:
        jsr     $4f71
        clr_ay
@50ce:  tya
        cmp     $d0c4
        beq     @50d9
        jsr     $5195
        bcs     @50e3
@50d9:  shorta0
        iny
        cpy     #$0008
        bne     @50ce
        rts
@50e3:  jsr     $4f92
        longa
        lda     $90
        beq     @50d9
        bmi     @50d9
        lda     $92
        bmi     @50fc
        lda     $92
        cmp     $90
        beq     @5105
        bcc     @5105
        bra     @50d9
@50fc:  lda     $92
        clc
        adc     $90
        beq     @5105
        bmi     @50d9
@5105:  shorta0
        jsr     $4fba
        jmp     @50d9

; ---------------------------------------------------------------------------

_c1510e:
@510e:  stz     $d0c5
        sta     $d0c2
        sta     $8a
        lda     $88
        sta     $d0c3
        lda     $8a
        bne     @5124
        lda     $cd42
        bra     @5129
@5124:  and     #$08
        bne     @514a
        clr_a
@5129:  sta     $8c
@512b:  lda     $8c
        and     #$03
        asl5
        tax
        lda     $cf43,x
        beq     @513f
        inc     $8c
        jmp     @512b
@513f:  lda     $8c
        clc
        adc     #$08
        sta     $d0c4
        jmp     @5160
@514a:  clr_ay
@514c:  lda     $d0aa,y
        jsr     $5195
        bcs     @515a
        iny
        cpy     #$0008
        bne     @514c
@515a:  lda     $d0aa,y
        sta     $d0c4
@5160:  lda     $d0c2
        and     #$04
        beq     @516c
        jsr     $4c73
        bra     @5185
@516c:  lda     $d0c2
        and     #$48
        cmp     #$40
        bne     @517c
        lda     #$02
        sta     $d0c5
        bra     @5185
@517c:  cmp     #$48
        bne     @5185
        lda     #$01
        sta     $d0c5
@5185:  lda     $d0c2
        and     #$08
        jeq     $483b
        lda     #$12
        sta     $cd3a
        rts

; ---------------------------------------------------------------------------

_c15195:
@5195:  tax
        lda     $de
        and     $dbe1
        and     $ceffcd,x
        beq     @51a3
        sec
        rts
@51a3:  clc
        rts

; ---------------------------------------------------------------------------

_c151a5:
        stz     $cd48
        lda     $cdf8
        jne     _c1491d
        lda     $00
        bpl     @51c2
        jsr     $fbb8       ; play system sound effect $11
        lda     #$03
        sta     $41b2
        inc     $cdf8
        jmp     _c1491d
@51c2:  lda     $01
        and     #$01
        beq     @51cd
        jsr     $fbad       ; play system sound effect $10
        bra     @51e1
@51cd:  lda     $0426
        bpl     @51da
        lda     $02
        and     #$30
        cmp     #$20
        bne     @51e1
@51da:  lda     $01
        bpl     @51e4
        jsr     $fbc3       ; play system sound effect $11
@51e1:  jmp     _c1491d
@51e4:  lda     #$08
        jmp     _c1522f

_c151e9:
        stz     $cd48
        lda     #$03
        sta     $cd4b
        lda     $cdf8
        jne     _c1491d
        lda     $00
        bpl     @520b
        jsr     $fbb8       ; play system sound effect $11
        lda     #$04
        sta     $41b2
        inc     $cdf8
        jmp     _c1491d
@520b:  lda     $01
        and     #$02
        beq     @5216
        jsr     $fbad       ; play system sound effect $10
        bra     @522a
@5216:  lda     $0426
        bpl     @5223
        lda     $02
        and     #$30
        cmp     #$10
        bne     @522a
@5223:  lda     $01
        bpl     @522d
        jsr     $fbc3       ; play system sound effect $11
@522a:  jmp     _c1491d
@522d:  lda     #$60

_c1522f:
@522f:  sta     $cd49
        lda     $0426
        bpl     @523a
        clr_a
        bra     @5242
@523a:  lda     $cd42
        tax
        lda     $042d,x
        asl
@5242:  tax
        lda     $ceffc6,x
        sta     $cd4a
        inc     $cd48
        lda     #$33
        sta     $cd4b
        rts

; ---------------------------------------------------------------------------

_c15253:
        .addr   $a630,$b210,$b248,$be30

_c1525b:
        .addr   $ba10,$ba80,$a630,$b230,$be30

_c15265:
        .byte   $04,$3c,$74,$04,$54

_c1526a:
        .byte   $10,$80

_c1526c:
        .byte   $aa,$b6,$c2,$ce

; ---------------------------------------------------------------------------

_c15270:
        phx
        lda     $042d,x
        and     #$03
        sta     $042d,x
        sta     $88
        stz     $89
        lda     $cd42
        asl
        tax
        lda     $cd40
        beq     @5297
        longa
        lda     $ceff28,x
        clc
        adc     $88
        sta     $88
        shorta0
        bra     @52a5
@5297:  longa
        lda     $ceff20,x
        clc
        adc     $88
        sta     $88
        shorta0
@52a5:  plx
        rts

; ---------------------------------------------------------------------------

; [ get menu id for battle command ]

_c152a7:
@52a7:  tax
        lda     f:_c15f17,x
        rts

; ---------------------------------------------------------------------------

_c152ad:
@52ad:  lda     $cd40
        beq     @52d4
        phx
        lda     $042d,x
        and     #$03
        sta     $042d,x
        sta     $88
        stz     $89
        lda     $cd42
        asl
        tax
        longa
        lda     $ceff18,x
        clc
        adc     $88
        sta     $88
        shorta0
        plx
        rts
@52d4:  phx
        lda     $042d,x
        and     #$03
        sta     $042d,x
        sta     $88
        stz     $89
        lda     $cd42
        asl
        tax
        longa
        lda     $ceff08,x
        clc
        adc     $88
        sta     $88
        shorta0
        plx
        rts

; ---------------------------------------------------------------------------

_c152f6:
        phx
        lda     $042d,x
        and     #$03
        sta     $042d,x
        sta     $88
        stz     $89
        lda     $cd42
        asl
        tax
        longa
        lda     $ceff00,x
        clc
        adc     $88
        sta     $88
        shorta0
        plx
        rts

; ---------------------------------------------------------------------------

_c15318:
@5318:  sta     $41b1
        sta     $41b8
        rts

; ---------------------------------------------------------------------------

_c1531f:
@531f:  lda     $042d,x
        sta     $98
        jsr     $52ad
        lda     ($88)
        bpl     @5332
        lda     #$03
        sta     $042d,x
        sta     $98
@5332:  lda     $01
        and     #$0f
        beq     @536d
        and     #$08
        beq     @533f
        clr_a
        bra     @5355
@533f:  lda     $01
        and     #$04
        beq     @5349
        lda     #$03
        bra     @5355
@5349:  lda     $01
        and     #$02
        beq     @5353
        lda     #$01
        bra     @5355
@5353:  lda     #$02
@5355:  tay
        lda     $fef6,y
        sta     $042d,x
        jsr     $52ad
        lda     ($88)
        bpl     @536a
        lda     $98
        sta     $042d,x
        bra     @536d
@536a:  jsr     $fbad       ; play system sound effect $10
@536d:  lda     $cd40
        bne     @5394
        lda     $02
        and     #$30
        cmp     #$20
        bne     @5383
        stz     $cd48
        jsr     $fbad       ; play system sound effect $10
        jmp     _c1494d
@5383:  lda     $02
        and     #$30
        cmp     #$10
        bne     @5394
        stz     $cd48
        jsr     $fbad       ; play system sound effect $10
        jmp     _c14930
@5394:  phx
        lda     $042d,x
        sta     $98
        clr_ax
@539c:  lda     $fef6,x
        cmp     $98
        beq     @53a9
        inx
        cpx     #$0004
        bne     @539c
@53a9:  txa
        asl
        tax
        lda     f:_c15253,x
        sta     $cd49
        lda     f:_c15253+1,x
        sta     $cd4a
        lda     #$01
        sta     $cd48
        plx
        lda     $00
        bpl     @53cd
        jsr     $fbb8       ; play system sound effect $11
        stz     $cd48
        jsr     $54a1
@53cd:  rts

; ---------------------------------------------------------------------------

_c153ce:
        stz     $7c52       ; unpause battle (wait mode)
        lda     $cdf8
        beq     @53df
        stz     $cdf8
        stz     $cd48
        jmp     _c148a2
@53df:  lda     $cd42
        sta     $41b3
        sta     $41ba
        stz     $41b4
        stz     $41b5
        stz     $41b6
        stz     $41bb
        stz     $41bc
        stz     $41bd
        stz     $f891
        stz     $f890
        lda     #$80
        jsr     $5318
        lda     #$01
        sta     $cdf7
        lda     $cd42
        tax
        lda     $cd40
        bne     @541b
        lda     $0426
        jmi     $531f
@541b:  lda     $01
        and     #$0c
        beq     @5442
        jsr     $fbad       ; play system sound effect $10
        cmp     #$08
        beq     @5438
        cmp     #$04
        bne     @5442
@542c:  inc     $042d,x
        jsr     $52ad
        lda     ($88)
        bmi     @542c
        bra     @5442
@5438:  dec     $042d,x
        jsr     $52ad
        lda     ($88)
        bmi     @5438
@5442:  jsr     $52ad
        lda     ($88)
        bmi     @542c
        phx
        lda     $042d,x
        asl
        tax
        lda     $ceffc5,x
        sta     $cd49
        lda     $ceffc6,x
        sta     $cd4a
        lda     #$01
        sta     $cd48
        plx
        lda     $cd40
        bne     @5486
        lda     $01
        and     #$02
        beq     @5477
        stz     $cd48
        jsr     $fbad       ; play system sound effect $10
        jmp     _c1494d
@5477:  lda     $01
        and     #$01
        beq     @5486
        stz     $cd48
        jsr     $fbad       ; play system sound effect $10
        jmp     _c14930
@5486:  lda     $00
        bpl     @5493
        jsr     $fbb8       ; play system sound effect $11
        stz     $cd48
        jsr     $54a1
@5493:  rts

; ---------------------------------------------------------------------------

_c15494:
        lda     $0970
        and     #$08
        beq     @54a0       ; branch if not wait mode
        lda     #$01
        sta     $7c52       ; pause battle while menu is open
@54a0:  rts

; ---------------------------------------------------------------------------

; [  ]

_c154a1:
@54a1:  lda     $042d,x     ; cursor position
        tay
        lda     $cd42
        asl
        tax
        lda     $cd40
        beq     @54ca
        lda     $ceff10,x
        sta     $88
        lda     $ceff11,x
        sta     $89
        lda     ($88),y
        sta     $41b2
        tya
        sta     $41b6
        sta     $41bd
        jmp     _c14676
@54ca:  lda     $ceff00,x
        sta     $88
        lda     $ceff01,x
        sta     $89
        lda     ($88),y
        sta     $41b2
        lda     ($88),y
        jsr     $52a7       ; get menu id for battle command
        asl
        tax
        lda     f:_c154f1,x
        sta     $88
        lda     f:_c154f1+1,x
        sta     $89
        jmp     ($0088)

; ---------------------------------------------------------------------------

; battle command menu jump table
_c154f1:
        .addr   $4676,$46b7,$46bc,$46c1,$46c6,$46cb,$46d0,$46da
        .addr   $46df,$46d5,$4676,$468c,$47b6,$468d,$469f,$46ab

; ---------------------------------------------------------------------------

_c15511:
@5511:  phx
        lda     $cd42
        tay
        lda     $0445,y
        tax
        lda     f:_c1526a,x
        sta     $cd49
        lda     $0449,y
        tax
        lda     f:_c1526c,x
        sta     $cd4a
        lda     #$01
        sta     $cd48
        jsr     $4bbc
        plx
        rts

; ---------------------------------------------------------------------------

_c15536:
@5536:  phx
        phy
        lda     $cd42
        tay
        lda     ($d5),y
        clc
        adc     $d0
        tax
        lda     f:_c15265,x
        sta     $cd49
        lda     ($d7),y
        tax
        lda     f:_c1526c,x
        sta     $cd4a
        lda     #$01
        sta     $cd48
        ply
        plx
        rts

; ---------------------------------------------------------------------------

; [  ]

_c1555b:
        lda     $cd44
        beq     @5573
        ldx     #$0006
        stx     $88
        ldx     #$c363
        ldy     #$1f59
        lda     #$7e
        jsr     $fdb6       ; copy data to vram
        stz     $cd44
@5573:  rts

; ---------------------------------------------------------------------------

_c15574:
@5574:  lda     $db
        clc
        adc     ($d3),y
        longa
        clc
        adc     $ceff8d,x
        tax
        shorta0
        stz     $88
        stz     $89
        lda     $2e38,x
@558b:  sec
        sbc     #$64
        bcc     @5594
        inc     $88
        bra     @558b
@5594:  clc
        adc     #$64
@5597:  sec
        sbc     #$0a
        bcc     @55a0
        inc     $89
        bra     @5597
@55a0:  clc
        adc     #$73
        sta     $c367
        lda     $88
        bne     @55b6
        lda     #$68
        sta     $88
        lda     $89
        bne     @55bd
        lda     #$68
        bra     @55c0
@55b6:  clc
        adc     #$69
        sta     $88
        lda     $89
@55bd:  clc
        adc     #$69
@55c0:  sta     $89
        lda     $88
        sta     $c363
        lda     $89
        sta     $c365
        inc     $cd44
        rts

; ---------------------------------------------------------------------------

_c155d0:
        lda     $cd42
        tay
        asl
        tax
        stz     $cd6c
        stz     $cd70
        lda     $cdf8
        bne     @5646
        inc     $cd6c
        inc     $cd70
        lda     #$33
        sta     $cd6f
        lda     #$b3
        sta     $cd73
        lda     ($d9),y
        bne     @55fa
        stz     $cd6c
        bra     @5601
@55fa:  cmp     $dd
        bne     @5601
        stz     $cd70
@5601:  lda     $00
        bpl     @564c
        jsr     $fbb8       ; play system sound effect $11
        lda     ($d3),y
        clc
        adc     $db
        longa
        clc
        adc     $ceff8d,x
        tax
        shorta0
        lda     $2f3c,x
        bpl     @5623
        jsr     $fbce       ; play system sound effect $12
        jmp     @5683
@5623:  stz     $cd48
        phx
        lda     $f890
        tax
        lda     ($d3),y
        clc
        adc     $db
        sta     $41b6,x
        lda     #$20
        ora     $f891
        sta     $41b1,x
        plx
        lda     #$0b
        sta     $88
        lda     $2eba,x
        jmp     _c1510e
@5646:  stz     $cd48
        jmp     _c14773
@564c:  lda     $01
        bpl     @5659
        jsr     $fbc3       ; play system sound effect $11
        stz     $cd48
        jmp     _c14773
@5659:  jsr     $5574
        jsr     $5536
        lda     $01
        and     #$02
        jne     $56b5
        lda     $01
        and     #$01
        jne     $5684
        lda     $01
        and     #$04
        jne     $56e0
        lda     $01
        and     #$08
        jne     $571a
@5683:  rts
@5684:  lda     ($d5),y
        cmp     $d1
        beq     @5699
        jsr     $fbad       ; play system sound effect $10
        lda     ($d3),y
        inc
        sta     ($d3),y
        lda     ($d5),y
        inc
        sta     ($d5),y
        bra     @56b2
@5699:  lda     $dc
        sec
        sbc     $db
        cmp     ($d3),y
        beq     @56b2
        jsr     $fbad       ; play system sound effect $10
        lda     ($d3),y
        sec
        sbc     $d1
        sta     ($d3),y
        clr_a
        sta     ($d5),y
        jsr     $56e0
@56b2:  jmp     _c15536
@56b5:  lda     ($d5),y
        beq     @56c8
        jsr     $fbad       ; play system sound effect $10
        lda     ($d5),y
        dec
        sta     ($d5),y
        lda     ($d3),y
        dec
        sta     ($d3),y
        bra     @56dd
@56c8:  lda     ($d3),y
        beq     @56dd
        jsr     $fbad       ; play system sound effect $10
        lda     ($d3),y
        clc
        adc     $d1
        sta     ($d3),y
        lda     $d1
        sta     ($d5),y
        jsr     $571a
@56dd:  jmp     _c15536

; ---------------------------------------------------------------------------

_c156e0:
@56e0:  lda     ($d7),y
        cmp     #$03
        beq     @56f6
        jsr     $fbad       ; play system sound effect $10
        lda     ($d3),y
        clc
        adc     $d2
        sta     ($d3),y
        lda     ($d7),y
        inc
        sta     ($d7),y
        rts
@56f6:  lda     ($d9),y
        cmp     $dd
        bne     @56fd
        rts
@56fd:  jsr     $fbad       ; play system sound effect $10
        lda     ($d3),y
        clc
        adc     $d2
        sta     ($d3),y
        jsr     $5750
        lda     #$03
        sta     $cd37
        lda     #$03
        sta     $cd3a
        lda     #$0b
        sta     $cd3b
        rts

; ---------------------------------------------------------------------------

_c1571a:
@571a:  lda     ($d7),y
        beq     @572e
        jsr     $fbad       ; play system sound effect $10
        lda     ($d3),y
        sec
        sbc     $d2
        sta     ($d3),y
        lda     ($d7),y
        dec
        sta     ($d7),y
        rts
@572e:  lda     ($d9),y
        bne     @5733
        rts
@5733:  jsr     $fbad       ; play system sound effect $10
        lda     ($d3),y
        sec
        sbc     $d2
        sta     ($d3),y
        jsr     $576c
        lda     #$03
        sta     $cd37
        lda     #$04
        sta     $cd3a
        lda     #$0b
        sta     $cd3b
        rts

; ---------------------------------------------------------------------------

_c15750:
@5750:  lda     #$03
        sta     $88
        lda     ($d9),y
        inc
        sta     ($d9),y
        jsr     $57b1
        lda     $cdfa
        cmp     #$04
        bne     @5768
        lda     #$ff
        sta     $cdfa
@5768:  inc     $cdfa
        rts

; ---------------------------------------------------------------------------

_c1576c:
@576c:  stz     $88
        lda     ($d9),y
        dec
        sta     ($d9),y
        jsr     $57b1
        lda     $cdfa
        bne     @5780
        lda     #$05
        sta     $cdfa
@5780:  dec     $cdfa
        rts

; ---------------------------------------------------------------------------

; [  ]

_c15784:
@5784:  lda     $cf
        beq     @5790
        lda     ($d9),y
        clc
        adc     $88
        asl
        bra     @579b
@5790:  lda     ($d9),y
        clc
        adc     $88
        sta     $88
        asl
        clc
        adc     $88
@579b:  adc     $db
        sta     $88
        stz     $89
        longa
        lda     $ceff8d,x   ; pointers to character battle lists
        clc
        adc     $88
        sta     $88
        tax
        shorta0
        rts

; ---------------------------------------------------------------------------

; [  ]

_c157b1:
@57b1:  phy
        ldx     #$cd7b
        stx     $bf
        ldx     #$cdbb
        stx     $c1
        tya                 ; y = character index
        asl
        tax
        jsr     $5784
        lda     $cf
        beq     @57d5
        ldy     #$0000
        jsr     $584b
        inx
        jsr     $584b
        ldx     #$0008
        bra     @57e6
@57d5:  ldy     #$0000
        jsr     $5806
        inx
        jsr     $5806
        inx
        jsr     $5806
        ldx     #$0007
@57e6:  lda     #$ff
        jsr     $5f6b
        dex
        bne     @57e6
        lda     $cdfa
        asl
        tax
        lda     $cefff5,x
        sta     $cd75
        lda     $cefff6,x
        sta     $cd76
        inc     $cd74
        ply
        rts

; ---------------------------------------------------------------------------

; [  ]

_c15806:
@5806:  lda     $2f3c,x
        bmi     @580f
        lda     #$00
        bra     @5811
@580f:  lda     #$04
@5811:  sta     $c3
        lda     $2d34,x
        cmp     #$ff
        bne     @5829
        phx
        ldx     #$0006
@581e:  lda     #$ff
        jsr     $5f6b
        dex
        bne     @581e
        jmp     @5845
@5829:  sta     $98
        lda     #$06
        sta     $9a
        jsr     $fe4b
        phx
        ldx     $9c
        lda     #$06
        sta     $88
@5839:  lda     $d11c80,x   ; spell names
        jsr     $5f67
        inx
        dec     $88
        bne     @5839
@5845:  plx
        lda     #$ff
        jmp     _c15f6b

; ---------------------------------------------------------------------------

; [  ]

_c1584b:
@584b:  lda     $2f3c,x
        bmi     @5854
        lda     #$00
        bra     @5856
@5854:  lda     #$04
@5856:  sta     $c3
        lda     $2d34,x
        sec
        sbc     #$57
        sta     $98
.if LANG_EN
        lda     #$0c
.else
        lda     #$09
.endif
        sta     $9a
        jsr     $fe4b
        phx
        ldx     $9c
        lda     #$09
        sta     $88
.if LANG_EN
@586e:  lda     $e70f90,x   ; short attack names
.else
@586e:  lda     $d11e8a,x   ; short attack names
.endif
        jsr     $5f67
        inx
        dec     $88
        bne     @586e
        plx
        lda     #$ff
        jmp     _c15f6b

; ---------------------------------------------------------------------------

; [  ]

_c15880:
@5880:  lda     $cd42
        tax
        lda     $ceff84,x
        clc
        adc     $88
        tax
        rts

; ---------------------------------------------------------------------------

; [  ]

_c1588d:
@588d:  phx
        sta     $88
        sta     $cfd4
        lda     $f88d
        sta     $cfd3
        lda     $f88c
        bmi     @58ab
        lda     $88
        sta     $f88d
        lda     #$c0
        sta     $f88c
        plx
        clc
        rts
@58ab:  and     #$40
        bne     @58f1
        jsr     $5880
        lda     $cfd3
        tay
        lda     $37ac,x
        beq     @58d1
        cmp     $2734,y
        beq     @58d1
        lda     $2734,y
        beq     @58d1
        lda     $2834,y
        cmp     #$01
        beq     @58d1
        lda     $cfd5
        bne     @5929
@58d1:  lda     $88
        jsr     $5ad0
        lda     $2734,y
        sta     $d0d0
        lda     $2b34,y
        sta     $d0d1
        lda     $2c34,y
        sta     $d0d2
        jsr     $5af9
        bcc     @5929
        lda     #$18
        bra     @58fa
@58f1:  lda     $f88d
        cmp     $88
        beq     @5917
        lda     #$15
@58fa:  sta     $cd39
        lda     #$05
        sta     $cd3a
        lda     #$11
        sta     $cd3b
        lda     #$05
        sta     $cd3c
        lda     #$08
        sta     $cd3d
        jsr     $5b93
        plx
        clc
        rts
@5917:  jsr     $5880
        jsr     $5b86
        lda     $37b6,x
        and     $92
        bne     @5929
        lda     $37ac,x
        bpl     @5932
@5929:  jsr     $fbce       ; play system sound effect $12
        jsr     $5b93
        plx
        clc
        rts
@5932:  phy
        lda     $f890
        tay
        lda     $cfd4
        sta     $41b6,y
        ply
        lda     #$08
        sta     $88
        lda     $37b2,x
        jsr     _c1510e
        jsr     $5b99
        plx
        sec
        rts

; ---------------------------------------------------------------------------

_c1594e:
@594e:  phx
        sta     $88
        sta     $cfd4
        lda     $f88d
        sta     $cfd3
        lda     $db4f
        bne     @5968
        lda     $db4e
        beq     @5982
        cmp     #$01
        bne     @596d
@5968:  lda     $88
        jmp     @5a47
@596d:  lda     $f88c
        bmi     @59ac
        phx
        lda     $cfd4
        tax
        lda     $2b34,x
        plx
        and     #$02
        jne     $5a97
@5982:  lda     $f88c
        bmi     @59ac
        lda     $88
        sta     $f88d
        lda     #$80
        sta     $f88c
        lda     $cd49
        clc
        adc     #$04
        sta     $cf3c
        stz     $cf3d
        lda     $cd4a
        sta     $cf3e
        stz     $cf3f
        inc     $cf3b
        plx
        clc
        rts
@59ac:  and     #$40
        beq     @59ff
        lda     $cd42
        tax
        lda     $ceff84,x
        clc
        adc     $cfd3
        tay
        lda     $88
        tax
        lda     $37ac,y
        beq     @59db
        cmp     $2734,x
        beq     @59db
        lda     $2834,x
        beq     @59db
        cmp     #$01
        beq     @59db
        lda     $cfd5
        jne     $5a91
@59db:  lda     $cfd3
        jsr     $5ad0
        lda     $2734,x
        sta     $d0d0
        lda     $2b34,x
        sta     $d0d1
        lda     $2c34,x
        sta     $d0d2
        jsr     $5af9
        jcc     $5a91
        lda     #$16
        bra     @5a2a
@59ff:  lda     $db4e
        cmp     #$02
        bne     @5a21
        lda     $f890
        tax
        lda     #$40
        ora     $f891
        sta     $41b1,x
        lda     $cfd3
        sta     $41b6,x
        lda     #$07
        sta     $f890
        lda     $88
        bra     @5a47
@5a21:  lda     $f88d
        cmp     $88
        beq     @5a47
        lda     #$17
@5a2a:  sta     $cd39
        lda     #$05
        sta     $cd3a
        lda     #$11
        sta     $cd3b
        lda     #$05
        sta     $cd3c
        lda     #$07
        sta     $cd3d
        jsr     $5b93
        plx
        clc
        rts
@5a47:  tax
        lda     $db4f
        beq     @5a51
        lda     #$40
        bra     @5a6f
@5a51:  lda     $db4e
        beq     @5a7a
        cmp     #$01
        beq     @5a6d
        lda     $cfd3
        cmp     $cfd4
        bne     @5a69
        lda     $2834,x
        cmp     #$02
        bcc     @5a97
@5a69:  lda     #$02
        bra     @5a6f
@5a6d:  lda     #$10
@5a6f:  sta     $92
        lda     $2b34,x
        and     $92
        beq     @5a9a
        bra     @5a97
@5a7a:  jsr     $5b86
        lda     $2c34,x
        and     $92
        bne     @5a91
        lda     $2734,x
        cmp     #$e0
        bcc     @5a91
        bra     @5a9a
        and     $92
        beq     @5a9a
@5a91:  jsr     $fbce       ; play system sound effect $12
        jsr     $5b93
@5a97:  plx
        clc
        rts
@5a9a:  phy
        lda     $f890
        tay
        lda     $cfd4
        sta     $41b6,y
        ply
        lda     #$07
        sta     $88
        lda     $db4f
        beq     @5ab3
        lda     #$28
        bra     @5ac7
@5ab3:  lda     $db4e
        beq     @5ac4
        cmp     #$01
        beq     @5ac0
        lda     #$30
        bra     @5ac7
@5ac0:  lda     #$00
        bra     @5ac7
@5ac4:  lda     $2a34,x
@5ac7:  jsr     _c1510e
        jsr     $5b99
        plx
        sec
        rts

; ---------------------------------------------------------------------------

_c1ad0:
@5ad0:  phx
        phy
        and     #$01
        eor     #$01
        sta     $8c
        lda     $cd42
        tax
        lda     $ceff84,x
        clc
        adc     $8c
        tay
        lda     $37ac,y
        sta     $d0ca
        lda     $37b4,y
        sta     $d0cb
        lda     $37b6,y
        sta     $d0cc
        ply
        plx
        rts

; ---------------------------------------------------------------------------

_c15af9:
@5af9:  phx
        jsr     $5b86
        lda     $d0ca
        bne     @5b05
        stz     $d0cc
@5b05:  lda     $d0d0
        bne     @5b0d
        stz     $d0d2
@5b0d:  lda     $d0cc
        ora     $d0d2
        and     $92
        beq     @5b1a
@5b17:  plx
        clc
        rts
@5b1a:  lda     $d0ca
        sta     $88
        lda     $d0cb
        sta     $8a
        jsr     $5b65
        sta     $8c
        lda     $d0d0
        sta     $88
        lda     $d0d1
        sta     $8a
        jsr     $5b65
        sta     $8d
        lda     $8c
        ora     $8d
        cmp     #$ff
        beq     @5b17
        and     #$01
        bne     @5b62
        ldx     $8c
        cpx     #$0802
        beq     @5b62
        cpx     #$0208
        beq     @5b62
        lda     $cd42
        tax
        lda     $cfce,x
        and     #$01
        beq     @5b17
        ldx     $8c
        cpx     #$0202
        bne     @5b17
@5b62:  plx
        sec
        rts

; ---------------------------------------------------------------------------

_c15b65:
@5b65:  lda     $88
        bne     @5b6c
        lda     #$01
        rts
@5b6c:  lda     $88
        bmi     @5b7c
        lda     $8a
        and     #$04
        bne     @5b79
        lda     #$02
        rts
@5b79:  lda     #$04
        rts
@5b7c:  cmp     #$e0
        bcc     @5b83
        lda     #$ff
        rts
@5b83:  lda     #$08
        rts

; ---------------------------------------------------------------------------

_c15bb8:
@5b86:  phx
        lda     $cd42
        tax
        lda     $ceff80,x
        sta     $92
        plx
        rts

; ---------------------------------------------------------------------------

_c15b93:
@5b93:  stz     $f88c
        stz     $f88e
@5b99:  stz     $cf3b
        stz     $cd4c
        stz     $cd50
        rts

; ---------------------------------------------------------------------------

_c15ba3:
        lda     #$03
        sta     $cd4b
        lda     $cd42
        tax
        lda     $cdf8
        bne     @5c09
        lda     #$01
        sta     $043d,x
        lda     $00
        bpl     @5bda
        jsr     $fbb8       ; play system sound effect $11
        lda     $0435,x
        jsr     $588d
        bcc     @5c44
        phx
        lda     $f890
        tax
        lda     #$10
        ora     $f891
        sta     $41b1,x
        plx
        jsr     $5b93
        stz     $cd48
        rts
@5bda:  lda     $01
        bpl     @5bf4
        jsr     $fbc3       ; play system sound effect $11
        lda     $f88c
        bpl     @5bec
        jsr     $5b93
        jmp     @5c44
@5bec:  lda     #$01
        sta     $0439,x
        jmp     @5c09
@5bf4:  lda     $01
        and     #$04
        beq     @5c0f
        jsr     $fbad       ; play system sound effect $10
        lda     $0435,x
        sta     $0445,x
        sta     $0441,x
        stz     $043d,x
@5c09:  stz     $cd48
        jmp     _c147a3
@5c0f:  lda     $01
        and     #$02
        beq     @5c22
        lda     $0435,x
        beq     @5c44
        jsr     $fbad       ; play system sound effect $10
        dec     $0435,x
        bra     @5c44
@5c22:  lda     $01
        and     #$01
        beq     @5c44
        jsr     $fbad       ; play system sound effect $10
        lda     $0435,x
        beq     @5c41
        lda     #$00
        sta     $0445,x
        sta     $0441,x
        stz     $cd48
        stz     $043d,x
        jmp     _c147a3
@5c41:  inc     $0435,x
@5c44:  lda     $0435,x
        asl
        tax
        lda     f:_c1525b,x
        sta     $cd49
        lda     f:_c1525b+1,x
        sta     $cd4a
        lda     #$01
        sta     $cd48
        lda     #$33
        sta     $cd4b
        sta     $cd53
        stz     $cd50
        lda     $f88c
        and     #$40
        beq     @5c87
        lda     $f88d
        asl
        tax
        lda     f:_c1525b,x
        clc
        adc     #$04
        sta     $cd51
        lda     f:_c1525b+1,x
        sta     $cd52
        inc     $cd50
@5c87:  rts

; ---------------------------------------------------------------------------

_c15c88:
        lda     $cd42
        tax
        stz     $cd6c
        stz     $cd70
        lda     $cdf8
        bne     @5d03
        lda     $0439,x
        bne     @5d03
        inc     $cd6c
        inc     $cd70
        lda     #$03
        sta     $cd6f
        lda     #$83
        sta     $cd73
        lda     $044d,x
        cmp     #$7c
        bne     @5cb6
        stz     $cd70
@5cb6:  lda     $cfc3
        beq     @5cc1
        clr_a
        sta     $043d,x
        bra     @5ccc
@5cc1:  lda     $043d,x
        beq     @5ccc
        stz     $cd48
        jmp     _c14789
@5ccc:  jsr     $5511
        lda     $00
        bpl     @5cf4
        jsr     $fbb8       ; play system sound effect $11
        lda     $0441,x
        jsr     $594e
        bcc     @5cf3
        phx
        lda     $f890
        tax
        lda     #$40
        ora     $f891
        sta     $41b1,x
        plx
        jsr     $5b93
        stz     $cd48
        rts
@5cf3:  rts
@5cf4:  lda     $01
        bpl     @5d0c
        jsr     $fbc3       ; play system sound effect $11
        lda     $f88c
        jmi     $5b93
@5d03:  stz     $cd48
        stz     $0439,x
        jmp     _c147fe
@5d0c:  lda     $01
        and     #$02
        jne     $5d31
        lda     $01
        and     #$01
        jne     $5d66
        lda     $01
        and     #$04
        jne     $5ee0
        lda     $01
        and     #$08
        jne     $5d8c
        rts
@5d31:  lda     $0445,x
        beq     @5d41
        jsr     $fbad       ; play system sound effect $10
        dec     $0441,x
        dec     $0445,x
        bra     @5d63
@5d41:  lda     $0441,x
        bne     @5d5a
        lda     $cfc3
        beq     @5d4c
        rts
@5d4c:  jsr     $fbad       ; play system sound effect $10
        stz     $cd48
        lda     #$01
        sta     $0435,x
        jmp     _c14789
@5d5a:  inc     $0441,x
        inc     $0445,x
        jsr     $5d8c
@5d63:  jmp     _c15511
@5d66:  lda     $0445,x
        bne     @5d76
        jsr     $fbad       ; play system sound effect $10
        inc     $0441,x
        inc     $0445,x
        bra     @5d89
@5d76:  lda     $0441,x
        cmp     #$ff
        beq     @5d89
        jsr     $fbad       ; play system sound effect $10
        dec     $0441,x
        stz     $0445,x
        jsr     $5ee0
@5d89:  jmp     _c15511
@5d8c:  lda     $0449,x
        beq     @5d9e
        jsr     $fbad       ; play system sound effect $10
        dec     $0449,x
        dec     $0441,x
        dec     $0441,x
        rts
@5d9e:  lda     $044d,x
        bne     @5db8
        lda     $cfc3
        beq     @5da9
        rts
@5da9:  jsr     $fbad       ; play system sound effect $10
        stz     $cd48
        lda     $0445,x
        sta     $0435,x
        jmp     _c14789
@5db8:  jsr     $fbad       ; play system sound effect $10
        dec     $0441,x
        dec     $0441,x
        jsr     $5dd4
        lda     #$03
        sta     $cd37
        lda     #$04
        sta     $cd3a
        lda     #$07
        sta     $cd3b
        rts

; ---------------------------------------------------------------------------

_c15dd4:
@5dd4:  stz     $88
        dec     $044d,x
        jsr     $5e04
        lda     $cdfa
        bne     @5de6
        lda     #$05
        sta     $cdfa
@5de6:  dec     $cdfa
        rts

; ---------------------------------------------------------------------------

_c15dea:
@5dea:  lda     #$03
        sta     $88
        inc     $044d,x
        jsr     $5e04
        lda     $cdfa
        cmp     #$04
        bne     @5e00
        lda     #$ff
        sta     $cdfa
@5e00:  inc     $cdfa
        rts

; ---------------------------------------------------------------------------

_c15e04:
@5e04:  phx
        jsr     $5b86
        ldy     #$cd7b
        sty     $bf
        ldy     #$cdbb
        sty     $c1
        clr_ay
        lda     $044d,x
        clc
        adc     $88
        asl
        tax
        jsr     $5e3b
        inx
        jsr     $5e3b
        lda     $cdfa
        asl
        tax
        lda     $cefff5,x
        sta     $cd75
        lda     $cefff6,x
        sta     $cd76
        inc     $cd74
        plx
        rts

; ---------------------------------------------------------------------------

_c15e3b:
@5e3b:  phx
        lda     #$ff
        jsr     $5f6b
        lda     #$ff
        jsr     $5f6b
        lda     $db4f
        beq     @5e54
        lda     $2b34,x
        and     #$40
        beq     @5e7a
        bra     @5e76
@5e54:  lda     $db4e
        beq     @5e6f
        cmp     #$01
        beq     @5e66
        lda     $2b34,x
        and     #$02
        beq     @5e7a
        bra     @5e76
@5e66:  lda     $2b34,x
        and     #$10
        beq     @5e7a
        bra     @5e76
@5e6f:  lda     $2c34,x
        and     $92
        beq     @5e7a
@5e76:  lda     #$04
        bra     @5e7c
@5e7a:  lda     #$00
@5e7c:  sta     $c3
        lda     $2734,x
        sta     $98
        lda     #$09
        sta     $9a
        jsr     $fe4b
        phx
        ldx     $9c
        lda     #$09
        sta     $88
@5e91:  lda     $d11380,x   ; item names
        jsr     $5f67
        inx
        dec     $88
        bne     @5e91
        plx
        lda     $2734,x
        beq     @5ea7
        lda     #$cf
        bra     @5ea9
@5ea7:  lda     #$ff
@5ea9:  jsr     $5f6b
        stz     $88
        lda     $2834,x
@5eb1:  sec
        sbc     #$0a
        bcc     @5ebb
        inc     $88
        jmp     @5eb1
@5ebb:  clc
        adc     #$0a
        sta     $89
        lda     $88
        bne     @5ec6
        lda     #$ac
@5ec6:  clc
        adc     #$53
        jsr     $5f6b
        lda     $89
        ora     $88
        bne     @5ed6
        lda     #$ff
        bra     @5edb
@5ed6:  lda     $89
        clc
        adc     #$53
@5edb:  jsr     $5f6b
        plx
        rts

; ---------------------------------------------------------------------------

_c15ee0:
@5ee0:  lda     $0449,x
        cmp     #$03
        beq     @5ef4
        jsr     $fbad       ; play system sound effect $10
        inc     $0441,x
        inc     $0441,x
        inc     $0449,x
        rts
@5ef4:  lda     $044d,x
        cmp     #$7c
        beq     @5f16
        jsr     $fbad       ; play system sound effect $10
        inc     $0441,x
        inc     $0441,x
        jsr     $5dea
        lda     #$03
        sta     $cd37
        lda     #$03
        sta     $cd3a
        lda     #$07
        sta     $cd3b
@5f16:  rts

; ---------------------------------------------------------------------------

; menu for each battle command
_c15f17:
        .byte   $00,$0a,$0c,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
        .byte   $00,$0f,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$0d
        .byte   $0e,$00,$00,$00,$00,$00,$00,$00,$09,$00,$00,$00,$01,$01,$01,$01
        .byte   $01,$01,$02,$02,$02,$02,$02,$02,$03,$03,$03,$03,$03,$03,$04,$04
        .byte   $04,$04,$04,$04,$05,$05,$05,$05,$05,$07,$07,$07,$08,$06,$00,$00

; 00: none
; 01: spellblade
; 02: white
; 03: black
; 04: time
; 05: summon
; 06: blue
; 07: red
; 08: x-magic
; 09: sing
; 0a: other ???
; 0b: ???
; 0c: item
; 0d: combine
; 0e: drink
; 0f: throw

; ---------------------------------------------------------------------------

_c15f67:
@5f67:  cmp     #$53
        bcc     _5f7a

_c15f6b:
@5f6b:  sta     ($c1),y
        lda     #$ff
_5f6f:  sta     ($bf),y
        iny
        lda     $c3
        sta     ($c1),y
        sta     ($bf),y
        iny
        rts
_5f7a:  cmp     #$49
        bcc     @5f88
        clc
        adc     #$17
        sta     ($c1),y
        lda     #$52
        jmp     _5f6f
@5f88:  clc
        adc     #$40
        sta     ($c1),y
        lda     #$51
        jmp     _5f6f

; ---------------------------------------------------------------------------

_c15f92:
        clr_ax
@5f94:  lda     $cd6c,x
        bne     @5fa1
        lda     #$f0
        sta     $02f9,x
        jmp     @5fb8
@5fa1:  lda     $cd6d,x
        sta     $02f8,x
        lda     $cd6e,x
        sta     $02f9,x
        lda     #$e2
        sta     $02fa,x
        lda     $cd6f,x
        sta     $02fb,x
@5fb8:  inx4
        cpx     #$0008
        bne     @5f94
        lda     $040f
        and     #$0f
        ora     #$a0
        sta     $040f
        rts

; ---------------------------------------------------------------------------

_c15fcc:
        lda     $cd68
        beq     @5fef
        lda     $cd69
        eor     $f6
        sec
        sbc     $f9
        sta     $0220
        lda     $cd6a
        sta     $0221
        lda     #$d0
        sta     $0222
        lda     $cd6b
        eor     $f7
        sta     $0223
@5fef:  rts

; ---------------------------------------------------------------------------

; [  ]

_c15ff0:
        clr_ax
@5ff2:  lda     $cd48,x
        bne     @5fff
        lda     #$f0
        sta     $0201,x
        jmp     @6016
@5fff:  lda     $cd49,x
        sta     $0200,x
        lda     $cd4a,x
        sta     $0201,x
        lda     #$d0
        sta     $0202,x
        lda     $cd4b,x
        sta     $0203,x
@6016:  inx4
        cpx     #$0010
        bne     @5ff2
@601f:  lda     $cd48,x
        bne     @602c
        lda     #$f0
        sta     $0201,x
        jmp     @604a
@602c:  lda     $cd49,x
        eor     $f6
        sec
        sbc     $f9
        sta     $0200,x
        lda     $cd4a,x
        sta     $0201,x
        lda     #$d0
        sta     $0202,x
        lda     $cd4b,x
        eor     $f7
        sta     $0203,x
@604a:  inx4
        cpx     #$0020
        bne     @601f
        lda     #$aa
        sta     $0400
        sta     $0401
        rts

; ---------------------------------------------------------------------------

; [  ]

_c1605c:
        lda     $cfd3
        tax
        lda     $cfd4
        tay
        lda     #$06
        sta     $70
@6068:  lda     $2734,x
        pha
        lda     $2734,y
        sta     $2734,x
        pla
        sta     $2734,y
        longa
        txa
        clc
        adc     #$0100
        tax
        tya
        clc
        adc     #$0100
        tay
        shorta0
        dec     $70
        bne     @6068
        jmp     _c161b6

; ---------------------------------------------------------------------------

_c1608e:
@608e:  lda     $cd42
        sta     $7e
        lda     #$0c
        sta     $80
        jsr     $feba       ; +$82 = $7e * $80
        ldx     $82
        rts

; ---------------------------------------------------------------------------

_c1609d:
        jsr     $608e
        lda     #$06
        sta     $70
@60a4:  lda     $37ac,x
        pha
        lda     $37ad,x
        sta     $37ac,x
        pla
        sta     $37ad,x
        inx2
        dec     $70
        bne     @60a4
        jmp     _c161b6

; ---------------------------------------------------------------------------

; [  ]

_c160bb:
        jsr     $608e
        lda     $82
        clc
        adc     $cfd4
        tax
        lda     $cfd3
        tay
        jmp     _c160da

; ---------------------------------------------------------------------------

_c160cc:
        jsr     $608e
        lda     $82
        clc
        adc     $cfd3
        tax
        lda     $cfd4
        tay

_c160da:
@60da:  lda     $2734,y
        jeq     @6166
        cmp     $37ac,x
        bne     @610c
        lda     $2834,y
        clc
        adc     $37ae,x
        sta     $2834,y
        cmp     #$64
        bcc     @60fa
        lda     #$63
        sta     $2834,y
@60fa:  clr_a
        sta     $37ac,x
        sta     $37ae,x
        lda     #$ff
        sta     $37b4,x
        sta     $37b6,x
        jmp     @61b6
@610c:  lda     $2834,y
        beq     @6166
        cmp     #$01
        beq     @6166
        lda     $37ac,x
        bne     @6124
        lda     $2834,y
        dec
        sta     $2834,y
        jmp     @6169
@6124:  phx
        clr_ax
@6127:  lda     $2734,x
        beq     @6139
        inx
        cpx     #$0100
        bne     @6127
        lda     #$01
        sta     $cfd5
        plx
        rts
@6139:  lda     $2834,y
        dec
        sta     $2834,y
        lda     $2734,y
        sta     $2734,x
        lda     #$01
        sta     $2834,x
        lda     $2934,y
        sta     $2934,x
        lda     $2a34,y
        sta     $2a34,x
        lda     $2b34,y
        sta     $2b34,x
        lda     $2c34,y
        sta     $2c34,x
        txa
        tay
        plx
@6166:  jmp     @618f
@6169:  lda     $2734,y
        sta     $37ac,x
        lda     $2934,y
        sta     $37b0,x
        lda     $2a34,y
        sta     $37b2,x
        lda     $2b34,y
        sta     $37b4,x
        lda     $2c34,y
        sta     $37b6,x
        lda     #$01
        sta     $37ae,x
        jmp     @61b6
@618f:  lda     #$06
        sta     $70
@6193:  lda     $2734,y
        pha
        lda     $37ac,x
        sta     $2734,y
        pla
        sta     $37ac,x
        longa
        tya
        clc
        adc     #$0100
        tay
        txa
        clc
        adc     #$0002
        tax
        shorta0
        dec     $70
        bne     @6193

@61b6:
_c161b6:
        jsr     $39e2
        jsr     $3ccd
        stz     $cd38
        inc     $7b7d
        rts

; ---------------------------------------------------------------------------

; [  ]

_c161c3:
        lda     $db74
        bne     @61c9
        rts
@61c9:  clr_ax
        ldy     #$00e8
        lda     $db75
        and     #$80
        beq     @61f5
        lda     $db78
        beq     @61df
        dec     $db78
        bra     @61f5
@61df:  dec     $db7c
        bne     @61ef
        lda     $db75
        and     #$7f
        sta     $db74
        sta     $db75
@61ef:  lda     $dbed
        jsr     $6268
@61f5:  inx
        lda     $db75
        and     #$40
        beq     @621b
        lda     $db79
        beq     @6205
        dec     $db79
@6205:  dec     $db7d
        bne     @6215
        lda     $db75
        and     #$bf
        sta     $db74
        sta     $db75
@6215:  lda     $dbee
        jsr     $6268
@621b:  inx
        lda     $db75
        and     #$20
        beq     @6241
        lda     $db7b
        beq     @622b
        dec     $db7b
@622b:  dec     $db7e
        bne     @623b
        lda     $db75
        and     #$df
        sta     $db75
        sta     $db74
@623b:  lda     $dbef
        jsr     $6268
@6241:  inx
        lda     $db75
        and     #$10
        beq     @6267
        lda     $db7c
        beq     @6251
        dec     $db7c
@6251:  dec     $db7f
        bne     @6261
        lda     $db75
        and     #$ef
        sta     $db75
        sta     $db74
@6261:  lda     $dbf0
        jsr     $6268
@6267:  rts

; ---------------------------------------------------------------------------

; [  ]

_c16268:
@6268:  sta     $88
        lda     $d03e,x
        sec
        sbc     #$10
        eor     $f6
        sec
        sbc     $f9
        sta     $0200,y
        lda     $d04a,x
        sec
        sbc     #$08
        clc
        adc     $88
        sta     $0201,y
        lda     #$ec
        sta     $0202,y
        lda     #$33
        eor     $f7
        sta     $0203,y
        iny4
        rts

; ---------------------------------------------------------------------------

; [  ]

_c16295:
@6295:  longa
        ldx     #$0070
        stx     $88
        clr_ax
        stx     $8a
@62a0:  lda     $98
        clc
        adc     $88
        sta     $f588,x
        lda     $9a
        clc
        adc     $8a
        sta     $f58a,x
        inx4
        lda     $88
        sec
        sbc     #$0010
        sta     $88
        cmp     #$fff0
        bne     @62a0
        lda     #$0070
        sta     $88
        lda     $8a
        clc
        adc     #$0010
        sta     $8a
        cmp     #$0080
        bne     @62a0
        shorta0
        rts

; ---------------------------------------------------------------------------

_c162d7:
        lda     $db60
        jmi     _c1703a
        lda     $db61
        bne     @62e5
@62e4:  rts
@62e5:  longa
        clr_ax
        longa
        lda     #$f0f0
@62ee:  sta     $0300,x
        inx4
        cpx     #$0100
        bne     @62ee
        clr_ax
        lda     #$aaaa
@62ff:  sta     $0410,x
        inx2
        cpx     #$0010
        bne     @62ff
        lda     $db62
        sta     $98
        lda     $db64
        sta     $9a
        shorta
        jsr     $6295
        lda     #$40
        sta     $92
        ldy     #$0100
        jsr     _c163aa
        lda     $db72
        beq     @62e4
        longa
        clr_ax
        lda     #$f0f0
@632e:  sta     $0220,x
        inx4
        cpx     #$00d8
        bne     @632e
        shorta0
        inc     $db73
        lda     $db73
        and     #$01
        beq     @62e4
        asl
        tax
        longa
        lda     $d4b900,x
        sta     $9c
        lda     $d4b922,x
        sta     $9e
        lda     $db62
        clc
        adc     $9c
        sta     $98
        lda     $db64
        clc
        adc     $9e
        sta     $9a
        shorta
        jsr     $6295
        lda     #$28
        sta     $92
        ldy     #$0020
        jsr     _c163aa
        lda     $db73
        and     #$01
        asl
        tax
        longa
        lda     $d4b902,x
        sta     $9c
        lda     $d4b924,x
        sta     $9e
        lda     $db62
        clc
        adc     $9c
        sta     $98
        lda     $db64
        clc
        adc     $9e
        sta     $9a
        shorta
        jsr     $6295
        lda     #$28
        sta     $92
        ldy     #$0084
        jmp     _c163aa

; ---------------------------------------------------------------------------

_c163aa:
@63aa:  lda     $dbd3
        beq     @63b3
        lda     #$c0
        bra     @63b5
@63b3:  lda     #$a0
@63b5:  sta     $8e
        clr_ax
        lda     $db66
        sta     $88
        stz     $8a
        stz     $8c
@63c2:  lda     $7f7700,x
        beq     @63e1
        lda     $f589,x
        bne     @63e1
        lda     $f588,x
        cmp     #$f8
        bcs     @63e1
        eor     $f6
        sec
        sbc     $f9
        sta     $0200,y
        lda     $f58b,x
        beq     @63e5
@63e1:  lda     #$f0
        bra     @6407
@63e5:  lda     $f58a,x
        cmp     $8e
        bcc     @63ee
        bra     @63e1
@63ee:  lda     $f58a,x
        sta     $0201,y
        lda     $8a
        clc
        adc     $8c
        sta     $0202,y
        lda     $88
        eor     $f7
        sta     $0203,y
        iny4
@6407:  inc     $8a
        inc     $8a
        lda     $8a
        and     #$0f
        sta     $8a
        bne     @641a
        lda     $8c
        clc
        adc     #$20
        sta     $8c
@641a:  inx4
        dec     $92
        bne     @63c2
        rts

; ---------------------------------------------------------------------------

; [  ]

_c16423:
@6423:  lda     $db39
        and     #$01
        jne     @644c
        inc     $ef
        lda     #$08
        sta     $92
        sta     $db3a
        ldy     #$0000
@6439:  jsr     $649a
        cpy     #$0100
        bne     @6439
        lda     $92
        sta     $db3a
        inc     $db39
        stz     $ef
        rts
@644c:  inc     $ef
        lda     $db3a
        sta     $92
        ldy     #$0100
@6456:  jsr     $649a
        cpy     #$0200
        bne     @6456
        inc     $db39
        lda     $92
        sta     $db3a
        cmp     #$3e
        beq     @6480
        longa
        asl2
        tax
        shorta0
        lda     #$f0
@6474:  sta     $7d0a,x
        inx4
        cpx     #$00f8
        bne     @6474
@6480:  jsr     $6486
        stz     $ef
        rts

; ---------------------------------------------------------------------------

; [  ]

_c16486:
@6486:  ldx     #$7d29      ; copy from sprite data buffer
        ldy     #$0220
        phb
        longa
        lda     #$00d7
        mvn     #$7e,#$00
        shorta0
        plb
        rts

; ---------------------------------------------------------------------------

; [  ]

_c1649a:
@649a:  lda     $92
        sta     $d1d9,y
        phy
        jsr     $65d7
        ply
        longa
        tya
        clc
        adc     #$0010
        tay
        shorta0
        rts

; ---------------------------------------------------------------------------

; [  ]

_c164b0:
        lda     $db38
        bne     @64b6
        rts
@64b6:  cmp     #$02
        jeq     _c16423
        lda     $db3b
        beq     @64c8
        jsr     $64cf
        jmp     @64f4
@64c8:  lda     $db39
        and     #$01
        bne     @64f4
@64cf:  inc     $ef
        ldy     #$0070
        lda     #$08
        sta     $92
@64d8:  lda     $92
        sta     $d1d9,y
        phy
        jsr     $65d7
        ply
        tya
        sec
        sbc     #$10
        tay
        cmp     #$30
        bne     @64d8
        lda     $92
        sta     $db3a
        inc     $db39
        rts
@64f4:  ldy     #$0030
        lda     $db3a
        sta     $92
@64fc:  lda     $92
        sta     $d1d9,y
        phy
        jsr     $65d7
        ply
        tya
        sec
        sbc     #$10
        tay
        cmp     #$f0
        bne     @64fc
        lda     $92
        sta     $db3a
        longa
        asl2
        tax
        shorta0
        lda     #$f0
@651e:  sta     $7d0a,x
        inx4
        cpx     #$0100
        bne     @651e
        stz     $ef
        inc     $db39
        jsr     $6486
        rts

; ---------------------------------------------------------------------------

; [  ]

_c16533:
        lda     $db69
        bne     @6539
        rts
@6539:  clr_ax
        stz     $88
@653d:  lda     $dad8,x
        beq     @6549
        lda     $88
        clc
        adc     #$07
        sta     $88
@6549:  txa
        clc
        adc     #$08
        tax
        cmp     #$40
        bne     @653d
        lda     $88
        jeq     @65d3
        lda     #$3e
        sec
        sbc     $88
        longa
        asl2
        tay
        shorta0
        clr_ax
@6568:  lda     $dad8,x
        beq     @65c9
        lda     $dadc,x
        beq     @6578
        dec     $dadc,x
        jmp     @65c9
@6578:  dec     $dadd,x
        bne     @6580
        stz     $dad8,x
@6580:  phx
        lda     $dad9,x
        sta     $88
        lda     $dada,x
        sta     $89
        lda     $dadb,x
        tax
        lda     #$07
        sta     $8c
@6593:  lda     $d0e1e8,x
        clc
        adc     $88
        eor     $f6
        sec
        sbc     $f9
        sta     $0200,y
        lda     $d0e1e9,x
        clc
        adc     $89
        sta     $0201,y
        lda     $d0e1ea,x
        sta     $0202,y
        lda     $d0e1eb,x
        eor     $f7
        sta     $0203,y
        inx4
        iny4
        dec     $8c
        bne     @6593
        plx
@65c9:  txa
        clc
        adc     #$08
        tax
        cmp     #$40
        bne     @6568
        rts
@65d3:  stz     $db69
        rts

; ---------------------------------------------------------------------------

; [  ]

_c165d7:
@65d7:  lda     $d1d8,y
        bne     @65dd
@65dc:  rts
@65dd:  lda     $db5f
        bne     @65dc
        lda     $db3c
        beq     @6600
        phy
        clr_ax
@65ea:  lda     $d9d8,y
        sta     $db18,x
        lda     $da58,y
        sta     $db28,x
        inx
        iny
        cpx     #$0010
        bne     @65ea
        ply
        bra     @6603
@6600:  jsr     $697d
@6603:  lda     $d1e3,y     ; frame offset ???
        longa
        clc
        adc     $d1da,y     ; frame index
        asl
        tax
        lda     $d9b35e,x   ; pointer to animation frame data
        sta     $88
        shorta0
        lda     #$d9
        sta     $8a
        lda     $d1e5,y     ; width
        sta     $8c
        lda     $d1e6,y     ; height
        sta     $8d
        lda     $d1de,y     ; tile count
        sta     $9c
        lda     $d1df,y
        sta     $d1c5
        lda     $d1e0,y
        sta     $d1c6
        lda     $d1e1,y
        sta     $d1c7
        lda     $d1e2,y
        sta     $d1c8
        lda     $d1dc,y
        sta     $8e
        lda     $d1dd,y
        sta     $90
        lda     $d1d9,y
        sta     $92
        lda     $d1e7,y
        and     #$80
        sta     $96
        stz     $97
        stz     $94
        lda     $d1e7,y
        and     #$40
        beq     @6667
        lda     #$35
        bra     @6669
@6667:  lda     #$37
@6669:  sta     $95
        lda     $d1e7,y
        and     #$20
        beq     @6678
        lda     $95
        and     #$ef
        sta     $95
@6678:  jsr     $698c
        rts

; ---------------------------------------------------------------------------

; [  ]

_c1667c:
        lda     $dbd3
        bne     @66d4
        clr_ax
@6683:  stz     $8e
        lda     $d1cb,x
        bne     @66ce
        lda     $d1cf,x
        beq     @66ce
        cmp     #$08
        bne     @6698
        jsr     $66d5
        bra     @66ce
@6698:  pha
        txa
        asl5
        tay
        pla
        cmp     #$02
        bne     @66b0
        lda     $cf4d,y
        cmp     #$03
        bne     @66b0
        lda     #$05
        sta     $8e
@66b0:  lda     $cf4e,y
        bne     @66ce
        stz     $8a
        lda     $d1cf,x
        cmp     #$06
        beq     @66c9
        lda     $dbed,x
        clc
        adc     $8e
        sta     $8a
        lda     $d1cf,x
@66c9:  phx
        jsr     $673a
        plx
@66ce:  inx
        cpx     #$0004
        bne     @6683
@66d4:  rts

; ---------------------------------------------------------------------------

; [  ]

_c166d5:
@66d5:  phx
        txa
        sta     $8c
        asl5
        tay
        lda     $cf45,y
        clc
        adc     $cf49,y
        eor     $f6
        sec
        sbc     $f9
        sta     $88
        lda     $cf46,y
        clc
        adc     $cf4a,y
        clc
        adc     $dbed,x
        sta     $89
        lda     $cf44,y
        longa
        asl2
        tay
        shorta0
        lda     $8c
        asl
        tax
        lda     #$02
        sta     $8a
@670d:  lda     $88
        sta     $0200,y
        lda     $89
        sec
        sbc     #$08
        sta     $0201,y
        lda     $f874,x
        clc
        adc     #$c6
        sta     $0202,y
        lda     #$31
        sta     $0203,y
        lda     $88
        clc
        adc     #$08
        sta     $88
        iny4
        inx
        dec     $8a
        bne     @670d
        plx
        rts

; ---------------------------------------------------------------------------

; [  ]

_c1673a:
@673a:  pha
        dec
        asl3
        sta     $88
        pla
        cmp     #$07
        bne     @674a
        lda     #$04        ; 4 sprites
        bra     @674c
@674a:  lda     #$02        ; 2 sprites
@674c:  sta     $8c
        stz     $89
        txa
        asl5
        tay
        lda     $cf56,y
        bpl     @6763
        lda     $88
        clc
        adc     #$38
        sta     $88
@6763:  lda     $cf50,y
        and     #$38
        lsr3
        clc
        adc     $88
        tax
        lda     $d833e2,x
        longa
        asl4
        tax
        shorta0
        lda     $cf45,y
        clc
        adc     $cf49,y
        sta     $88         ; x offset
        lda     $cf46,y
        clc
        adc     $cf4a,y
        clc
        adc     $8a
        sta     $8a
        lda     $cf44,y
        longa
        asl2
        tay
        shorta0
@679d:  lda     $d83452,x
        clc
        adc     $88         ; x offset
        eor     $f6
        sec
        sbc     $f8         ; x offset (for back attack)
        sta     $0200,y
        iny
        inx
        lda     $d83452,x
        clc
        adc     $8a         ; y offset
        sta     $0200,y
        iny
        inx
        lda     $d83452,x
        sta     $0200,y     ; tile index
        iny
        inx
        lda     $d83452,x
        eor     $f7
        sta     $0200,y     ; tile flags
        iny
        inx
        dec     $8c
        bne     @679d
        rts

; ---------------------------------------------------------------------------

; [  ]

_c167d3:
@67d3:  clr_ax
        lda     #$f0
@67d7:  sta     $0220,x
        sta     $7d29,x
        inx
        cpx     #$00d8
        bne     @67d7
        rts

; ---------------------------------------------------------------------------

; [  ]

_c167e4:
        lda     $d1ae
        jeq     @68f0
        stz     $ef
        jsr     $697d
        clr_ax
        lda     #$aa
@67f5:  sta     $0402,x
        inx
        cpx     #$000c
        bne     @67f5
        lda     $d1bb
        bne     @6808
        jsr     $67d3
        bra     @6857
@6808:  lda     $d1bb
        cmp     #$ff
        bne     @6818
        jsr     $67d3
        stz     $d1ae
        jmp     @68f0
@6818:  lda     $d1bb
        bpl     @6857
        lda     #$01
        sta     $d1bb
        ldx     #$003b
@6825:  lda     $021c,x
        eor     #$40
        sta     $0220,x
        and     #$40
        beq     @683c
        lda     $0219,x
        sec
        sbc     #$08
        sta     $021d,x
        bra     @6845
@683c:  lda     $0219,x
        clc
        adc     #$08
        sta     $021d,x
@6845:  lda     $021b,x
        sta     $021f,x
        lda     $021a,x
        sta     $021e,x
        dex4
        bpl     @6825
@6857:  lda     $d1b9
        longa
        clc
        adc     $d1b0
        asl
        tax
        lda     $d9a486,x
        sta     $88
        shorta0
        lda     #$d9
        sta     $8a
        ldx     $d192
        stx     $8c
        lda     $8c
        sta     $98
        lda     $8d
        sta     $9a
        jsr     $fe4b
        lda     $d1b7
        sta     $d1c5
        lda     $d1b8
        sta     $d1c7
        stz     $d1c6
        stz     $d1c8
        lda     $d1b2
        sta     $8e
        lda     $d1b3
        sta     $90
        lda     $d1b6
        bpl     @68ad
        phx
        and     #$03
        tax
        lda     $90
        clc
        adc     $dbed,x
        sta     $90
        plx
@68ad:  lda     $d1af
        sta     $92
        stz     $97
        lda     $d1b6
        and     #$40
        sta     $96
        beq     @68c4
        lda     $8e
        sec
        sbc     #$08
        sta     $8e
@68c4:  stz     $94
        lda     #$37
        sta     $95
        jsr     $698c
        lda     $d1af
        sta     $88
        lda     #$10
        sta     $8c
@68d6:  lda     $88
        lsr2
        tay
        lda     $88
        and     #$03
        tax
        lda     f:_c16979,x
        ora     $0400,y
        sta     $0400,y
        inc     $88
        dec     $8c
        bne     @68d6
@68f0:  rts

; ---------------------------------------------------------------------------

; [  ]

_c168f1:
        lda     $d1a0
        bne     @68f7
        rts
@68f7:  stz     $ef
        jsr     $697d
        lda     $d1ab
        longa
        clc
        adc     $d1a2
        asl
        tax
        lda     $d9a486,x   ; pointers to ??? (+$d90000)
        sta     $88
        shorta0
        lda     #$d9
        sta     $8a
        ldx     $d184
        stx     $8c
        lda     $8c
        sta     $98
        lda     $8d
        sta     $9a
        jsr     $fe4b
        lda     $d1a9
        sta     $d1c5
        lda     $d1aa
        sta     $d1c7
        stz     $d1c6
        stz     $d1c8
        lda     $d1a4
        sta     $8e
        lda     $d1a5
        sta     $90
        lda     $d1a1
        sta     $92
        lda     $d1a8
        sta     $96
        stz     $97
        stz     $94
        lda     #$35
        sta     $95
        jsr     $698c       ;
        lda     $d1a1
        sta     $88
        lda     #$04
        sta     $8c
@695e:  lda     $88
        lsr2
        tay
        lda     $88
        and     #$03
        tax
        lda     f:_c16979,x
        ora     $0400,y     ; 16x16 sprite
        sta     $0400,y
        inc     $88
        dec     $8c
        bne     @695e
        rts

; ---------------------------------------------------------------------------

_c16979:
        .byte   $02,$08,$20,$80

; ---------------------------------------------------------------------------

_c1697d:
@697d:  clr_ax
@697f:  stz     $db18,x
        stz     $db28,x
        inx
        cpx     #$0010
        bne     @697f
        rts

; ---------------------------------------------------------------------------

; [  ]

_c1698c:
@698c:  ldx     $9c         ; tile count
        phx
        lda     $db6b
        beq     @69a3
        lda     $dbd3
        beq     @699e
        ldy     #$00b0
        bra     @69a6
@699e:  ldy     #$0090
        bra     @69a6
@69a3:  ldy     #$00e0
@69a6:  sty     $db6c
        stz     $8f
        stz     $91
        lda     $96
        beq     @69bb
        lda     $8e
        eor     #$ff
        inc
        sec
        sbc     #$08
        sta     $8e
@69bb:  lda     $8e
        bpl     @69c3
        lda     #$ff
        sta     $8f
@69c3:  lda     $90
        bpl     @69cb
        lda     #$ff
        sta     $91
@69cb:  lda     $8c
        asl3
        sta     $98
        stz     $99
        lda     $8d
        asl3
        sta     $9a
        stz     $9b
        longa
        lda     $96
        beq     @69e7
        lsr     $98
        bra     @69ed
@69e7:  clr_a
        sec
        sbc     $98
        sta     $98
@69ed:  clr_a
        sec
        sbc     $9a
        sta     $9a
        clr_ax
        shorta
        lda     $8d
        longa
        sta     $9e
@69fd:  lda     $98
        sta     $9c
        lda     $8c
        and     #$00ff
        tay
@6a07:  lda     $db3c
        beq     @6a14
        lda     $9c
        clc
        adc     $db18,x
        bra     @6a16
@6a14:  lda     $9c
@6a16:  clc
        adc     $d1c5
        clc
        adc     $8e
        cmp     #$00f8
        bcc     @6a27
        lda     #$00f0
        bra     @6a4d
@6a27:  sta     $f588,x
        lda     $db3c
        beq     @6a37
        lda     $9a
        clc
        adc     $db28,x
        bra     @6a39
@6a37:  lda     $9a
@6a39:  clc
        adc     $d1c7
        clc
        adc     $90
        cmp     $db6c
        bcc     @6a4d
        cmp     #$fff0
        bcs     @6a4d
        lda     #$00f0
@6a4d:  sta     $f589,x
        lda     $96
        beq     @6a5e
        lda     $9c
        sec
        sbc     #$0010
        sta     $9c
        bra     @6a66
@6a5e:  lda     $9c
        clc
        adc     #$0010
        sta     $9c
@6a66:  inx2
        dey
        bne     @6a07
        lda     $9a
        clc
        adc     #$0010
        sta     $9a
        dec     $9e
        bne     @69fd
        shorta0
        plx
        stx     $9c
        lda     $92
        longa
        asl2
        tax
        clr_a
        sta     $8c
        shorta
@6a89:  lda     [$88]
        sta     $98
        bmi     @6a9b       ; branch if string of tiles
        jsr     $6b6c       ; decode single animation frame tile
        bcs     @6ab0
        ldy     $88
        iny
        sty     $88
        bra     @6a89
@6a9b:  ldy     $88
        iny
        sty     $88
        lda     [$88]
        sta     $9e
        jsr     $6ab1       ; decode string of animation frame tiles
        bcs     @6ab0
        ldy     $88
        iny
        sty     $88
        bra     @6a89
@6ab0:  rts

; ---------------------------------------------------------------------------

; [ decode string of animation frame tiles ]

; $98: 1vhttttt
;      v = v-flip
;      h = h-flip
;      t = tile index
; $9e: tile count

_c16ab1:
@6ab1:  lda     $98
        and     #$1f
        cmp     #$1f
        bne     @6ad3
        lda     $9e         ; skip n tiles ???
        longa
        asl
        clc
        adc     $8c
        sta     $8c
        shorta0
        lda     $9c
        sec
        sbc     $9e
        sta     $9c
        beq     @6ad1
        clc
        rts
@6ad1:  sec
        rts
@6ad3:  ldy     $8c
        and     #$07
        asl
        sta     $8b
        lda     $98
        and     #$18
        asl2
        clc
        adc     $8b
        clc
        adc     $94
        sta     $9a
        lda     $98
        asl
        and     #$c0        ; vh flip
        ora     $95
        eor     $96
        sta     $9b
        lda     $92
        clc
        adc     $9e
        sta     $92
        lda     $9e
        pha
        lda     $ef
        beq     @6b2f       ; branch if sprite
@6b01:  lda     $f588,y
        eor     $f6
        sec
        sbc     $f9
        sta     $7d09,x
        lda     $f589,y
        sta     $7d0a,x
        lda     $9a
        sta     $7d0b,x
        lda     $9b
        eor     $f7
        sta     $7d0c,x
        inx4
        iny2
        dec     $9e
        bne     @6b01
        dec     $9f
        bpl     @6b01
        jmp     @6b5a
@6b2f:  lda     $f588,y
        eor     $f6
        sec
        sbc     $f9
        sta     $0200,x     ; x position
        lda     $f589,y
        sta     $0201,x     ; y position
        lda     $9a
        sta     $0202,x     ; tile index
        lda     $9b
        eor     $f7
        sta     $0203,x     ; vhoopppm
        inx4
        iny2
        dec     $9e
        bne     @6b2f
        dec     $9f
        bpl     @6b2f
@6b5a:  sty     $8c
        pla
        sta     $9e
        lda     $9c
        sec
        sbc     $9e
        sta     $9c
        beq     @6b6a
        clc
        rts
@6b6a:  sec
        rts

; ---------------------------------------------------------------------------

; [ decode single animation frame tile ]

; $98: 0vhttttt
;      c = tile count
;      v = v-flip
;      h = h-flip
;      t = tile index

_c16b6c:
@6b6c:  ldy     $8c
        lda     $98
        and     #$1f
        cmp     #$1f
        beq     @6be4       ; skip one tile
        and     #$07
        asl
        sta     $8b
        lda     $ef
        beq     @6bb0       ; branch if sprite
        lda     $98
        and     #$18
        asl2
        clc
        adc     $8b
        clc
        adc     $94
        sta     $7d0b,x
        lda     $98
        asl
        and     #$c0        ; vh flip
        ora     $95
        eor     $96
        eor     $f7
        sta     $7d0c,x
        lda     $f588,y
        eor     $f6
        sec
        sbc     $f9
        sta     $7d09,x
        lda     $f589,y
        sta     $7d0a,x
        jmp     @6bde
@6bb0:  lda     $98
        and     #$18
        asl2
        clc
        adc     $8b
        clc
        adc     $94
        sta     $0202,x     ; tile index
        lda     $98
        asl
        and     #$c0
        ora     $95
        eor     $96
        eor     $f7
        sta     $0203,x     ; vhoopppm
        lda     $f588,y
        eor     $f6
        sec
        sbc     $f9
        sta     $0200,x     ; x position
        lda     $f589,y
        sta     $0201,x     ; y position
@6bde:  inc     $92
        inx4
@6be4:  iny2
        sty     $8c
        dec     $9c
        beq     @6bee
        clc
        rts
@6bee:  sec
        rts

; ---------------------------------------------------------------------------

; [ hide damage numeral sprites ]

_c16bef:
@6bf0:  clr_ax
        lda     #$f8
@6bf4:  sta     $0220,x
        inx
        cpx     #$00c0      ; 48 sprites (4 digits per character/monster)
        bne     @6bf4
        clr_ax
@6bff:  sta     $0402,x     ; clear hi-sprite data
        inx
        cpx     #$000c
        bne     @6bff
        rts

; ---------------------------------------------------------------------------

; [  ]

_c16c08:
@6c09:  clr_ax
        lda     #$f8
@6c0d:  sta     $02e0,x
        inx
        cpx     #$0018
        bne     @6c0d
        stz     $040e
        rts

; ---------------------------------------------------------------------------

; [ get damage numeral vertical offset ]

_c16c1a:
@6c1a:  phx
        lda     $d178,x     ; frame counter
        cmp     #$24
        bcc     @6c24
        lda     #$24
@6c24:  tax
        lda     $d4b972,x   ; first digit
        clc
        adc     $8b
        sta     $8c
        lda     $d4b96f,x   ; second digit
        clc
        adc     $8b
        sta     $8d
        lda     $d4b96c,x   ; third digit
        clc
        adc     $8b
        sta     $8e
        lda     $d4b969,x   ; fourth digit
        clc
        adc     $8b
        sta     $8f
        plx
        lda     $d118,x
        bpl     @6c57       ; branch if not miss
        lda     $8c         ; digits move in unison
        sta     $8d
        sta     $8e
        sta     $8f
@6c57:  rts

; ---------------------------------------------------------------------------

; [ update damage numeral sprites (golem ???) ]

_c16c58:
        lda     $d116
        jeq     @6cd3
        jsr     $6c09
        ldy     #$00e0
        clr_ax
        lda     $d118,x
        beq     @6cc6       ; branch if disabled for this object
        lda     $d124,x
        sta     $88
        lda     $d160,x
        sta     $8a
        lda     $d16c,x
        sta     $8b
        jsr     $6c1a
        phx
        txa
        asl2
        tax
        stz     $90
@6c86:  phx
        lda     $90
        tax
        lda     $8c,x
        sta     $8b
        plx
        lda     $8a
        sta     $0200,y
        lda     $8b
        sta     $0201,y
        lda     $d130,x
        sta     $0202,y
        lda     $88
        sta     $0203,y
        lda     $8a
        clc
        adc     #$08
        sta     $8a
        inx
        iny4
        inc     $90
        lda     $90
        cmp     #$04
        bne     @6c86
        plx
        inc     $d178,x
        lda     $d178,x
        cmp     #$20
        bne     @6cc6
        stz     $d118,x     ; disable damage numerals
@6cc6:  clr_ax
        lda     $d118,x
        bne     @6cd3
        jsr     $6c09
        stz     $d116
@6cd3:  rts

; ---------------------------------------------------------------------------

; [ update damage numeral sprites ]

_c16cd4:
        lda     $d114
        bne     @6cdc       ; branch if damage numerals pending
        jmp     @6d5b
@6cdc:  jsr     $6bf0       ; hide damage numeral sprites
        ldy     #$0020
        clr_ax
@6ce4:  lda     $d118,x
        beq     @6d42       ; branch if disabled for this object
        lda     $d124,x     ; tile flags
        sta     $88
        lda     $d160,x
        sta     $8a
        lda     $d16c,x
        sta     $8b
        jsr     $6c1a       ; get damage numeral vertical offset
        phx
        txa
        asl2
        tax
        stz     $90
@6d02:  phx
        lda     $90
        tax
        lda     $8c,x
        sta     $8b
        plx
        lda     $8a
        sta     $0200,y     ; x
        lda     $8b
        sta     $0201,y     ; y
        lda     $d130,x
        sta     $0202,y     ; tile index
        lda     $88
        sta     $0203,y     ; tile flags
        lda     $8a         ; next digit
        clc
        adc     #$08
        sta     $8a
        inx
        iny4
        inc     $90
        lda     $90
        cmp     #$04
        bne     @6d02
        plx
        inc     $d178,x     ; increment frame counter
        lda     $d178,x
        cmp     #$30        ; 36 frames moving, 48 frames total
        bne     @6d42
        stz     $d118,x     ; disable damage numerals for this object
@6d42:  inx
        cpx     #$000c
        bne     @6ce4
        clr_ax
@6d4a:  lda     $d118,x
        bne     @6d5b       ; return if damage numerals enabled
        inx
        cpx     #$000c
        bne     @6d4a
        jsr     $6bf0       ; hide damage numeral sprites
        stz     $d114
@6d5b:  rts

; ---------------------------------------------------------------------------

; [  ]

_c16d5c:
        clr_axy
        lda     #$5e
        sta     $70
        stz     $72
@6d65:  lda     $d01e,y
        sta     $cf45,x
        lda     $d022,y
        sta     $cf46,x
        lda     #$00
        sta     $cf47,x
        sta     $cf49,x
        sta     $cf4a,x
        sta     $cf4e,x
        sta     $cf51,x
        sta     $cf43,x
        sta     $cf4d,x
        sta     $cf53,x
        sta     $cf56,x
        sta     $cf57,x
        sta     $cf58,x
        sta     $cf59,x
        sta     $cf5a,x
        sta     $cf5d,x
        sta     $cf5e,x
        sta     $cf5f,x
        sta     $cf60,x
        sta     $cf61,x
        sta     $cf62,x
        lda     #$07
        sta     $cf4f,x
        lda     #$01
        sta     $cf52,x
        lda     $72
        sta     $cf4c,x
        lda     $7a
        clc
        adc     #$09
        sta     $7a
        sta     $cf50,x
        lda     #$04
        sta     $cf48,x
        tya
        asl
        ora     #$38
        sta     $cf4b,x
        lda     $70
        sta     $cf44,x
        sec
        sbc     #$0a
        sta     $70
        lda     $cfc6,y
        cmp     #$ff
        bne     @6de5
        inc     $cf43,x
@6de5:  lda     $72
        clc
        adc     #$40
        sta     $72
        iny
        txa
        clc
        adc     #$20
        tax
        cpx     #$0080
        jne     @6d65
        jmp     @6dfd
@6dfd:  clr_ax
        stz     $df
        lda     #$80
        sta     $88
@6e05:  lda     $cf43,x
        bne     @6e10
        lda     $df
        ora     $88
        sta     $df
@6e10:  lsr     $88
        txa
        clc
        adc     #$20
        tax
        cpx     #$0080
        bne     @6e05
        rts

; ---------------------------------------------------------------------------

_c16e1c:
@6e1d:  sta     $88
        sta     $8a
        lda     $cf54,x
        bmi     @6e37
        lda     $cf56,x
        and     #$7f
        sta     $cf56,x
        lda     $88
        eor     #$ff
        inc
        sta     $8a
        bra     @6e3f
@6e37:  lda     $cf56,x
        ora     #$80
        sta     $cf56,x
@6e3f:  lda     $cf45,x
        clc
        adc     $8a
        sta     $cf45,x
        lda     $cf54,x
        sec
        sbc     $88
        sta     $cf54,x
        rts

; ---------------------------------------------------------------------------

_c16e52:
        lda     $cf53,x
        beq     @6eaa
        phx
        lda     $cf47,x
        asl3
        sta     $88
        lda     $cf55,x
        and     #$07
        clc
        adc     $88
        tax
        lda     $d4b93a,x
        sta     $88
        lda     $d4b922,x
        plx
        sta     $cf4a,x
        lda     $88
        sta     $cf51,x
        inc     $cf55,x
        lda     $cf47,x
        beq     @6e90
        cmp     #$01
        bne     @6e8c
        lda     #$02
        bra     @6e92
@6e8c:  lda     #$01
        bra     @6e92
@6e90:  lda     #$02
@6e92:  jsr     $6e1d
        and     #$7f
        bne     @6ea9
        stz     $cf4d,x
        stz     $cf53,x
        lda     $cf56,x
        and     #$7f
        sta     $cf56,x
        bra     @6eaa
@6ea9:  rts
@6eaa:  phy
        txa
        lsr5
        tay
        lda     $d1c1,y
        beq     @6ec5
        cmp     #$01
        beq     @6eca
        lda     $cf56,x
        and     #$7f
        sta     $cf56,x
        bra     @6ed2
@6ec5:  lda     $d1bd,y
        beq     @6ed2
@6eca:  lda     $cf56,x
        ora     #$80
        sta     $cf56,x
@6ed2:  ply
        rts

; ---------------------------------------------------------------------------

_c16ed4:
@6ed4:  lda     $cf45,x
        cmp     $cf5b,x
        beq     @6ee6
        sta     $cf5b,x
        lda     #$08
        sta     $cf5c,x
        bra     @6ef3
@6ee6:  dec     $cf5c,x
        bne     @6ef3
        inc     $cf5c,x
        lda     #$06
        sta     $88
        rts
@6ef3:  stz     $88
        rts

; ---------------------------------------------------------------------------

; [  ]

_c16ef6:
        phx
        phy
        txa
        lsr5
        tay
        lda     $d1cb,y
        bne     @6f74
        jsr     $6ed4
        lda     $cf5a,x
        beq     @6f74
        cmp     #$01
        bne     @6f1d
        lda     $cf50,x
        and     #$01
        beq     @6f74
        clr_ax
        stx     $94
        bra     @6f2f
@6f1d:  lda     $cf50,x
        and     #$01
        beq     @6f2b
        asl     $88
        ldx     #$0060
        bra     @6f2d
@6f2b:  clr_ax
@6f2d:  stx     $94
@6f2f:  lda     $96
        asl
        tax
        longa
        lda     $d0e1d8,x
        tay
        lda     $d0e1e0,x
        clc
        adc     $94
        tax
        shorta0
        lda     $f6
        beq     @6f76
        lda     #$06
        sta     $89
@6f4d:  lda     $f789,x
        sec
        sbc     $88
        sta     $0200,y
        inx
        iny
        lda     $f789,x
        sta     $0200,y
        inx
        iny
        lda     $f789,x
        sta     $0200,y
        inx
        iny
        lda     $f789,x
        sta     $0200,y
        inx
        iny
        dec     $89
        bne     @6f4d
@6f74:  bra     @6fa1
@6f76:  lda     #$06
        sta     $89
@6f7a:  lda     $f789,x
        clc
        adc     $88
        sta     $0200,y
        inx
        iny
        lda     $f789,x
        sta     $0200,y
        inx
        iny
        lda     $f789,x
        sta     $0200,y
        inx
        iny
        lda     $f789,x
        sta     $0200,y
        inx
        iny
        dec     $89
        bne     @6f7a
@6fa1:  ply
        plx
        rts

; ---------------------------------------------------------------------------

; [  ]

_c16fa4:
        phy
        phx
        txa
        lsr5
        tay
        lda     $d1cb,y
        bne     @6fce
        lda     $cf59,x
        beq     @6fce
        lda     $cf50,x
        and     #$38
        lsr3
        tax
        lda     $d4b908,x
        sta     $dbed,y
        clc
        adc     $99
        sta     $99
        bra     @6fd2
@6fce:  clr_a
        sta     $dbed,y
@6fd2:  plx
        ply
        rts

; ---------------------------------------------------------------------------

; [  ]

_c16fd5:
        lda     $db3e
        bne     @6fdb
        rts
@6fdb:  clr_ax
@6fdd:  sta     $0402,x
        inx
        cpx     #$000c
        bne     @6fdd
        lda     $db3f
        asl5
        tax
        lda     $cf44,x
        clc
        adc     $cf48,x
        longa
        asl2
        tax
        phx
        phb
        ldx     #$f8c9
        ldy     #$0238
        lda     #$00a7
        mvn     #$7e,#$00
        plb
        plx
        clr_ay
@700d:  lda     $0200,x
        sta     $0220,y
        inx2
        iny2
        cpy     #$0018
        bne     @700d
        shorta0
        tax
@7020:  lda     $0220,x
        sta     $f8c9,x
        inx
        cpx     #$00c0
        bne     @7020
        inc     $db40
        lda     $db40
        and     #$01
        beq     @7039
        jsr     $67d3
@7039:  rts

; ---------------------------------------------------------------------------

_c1703a:
@703a:  clr_ax
        longa
        lda     #$f0f0
@7041:  sta     $0300,x
        inx4
        cpx     #$0100
        bne     @7041
        clr_ax
@704f:  sta     $0410,x
        inx2
        cpx     #$0010
        bne     @704f
        shorta
        rts

; ---------------------------------------------------------------------------

_c1705c:
        clr_ax
@705e:  stz     $cf4e,x
        txa
        clc
        adc     #$20
        tax
        cmp     #$80
        bne     @705e
        rts

; ---------------------------------------------------------------------------

_c1706b:
        clr_axy
        lda     $db75
        sta     $88
        lda     $db74
        bne     @707a
        stz     $88
@707a:  asl     $88
        bcs     @70ba
        lda     $7b7e,y
        bmi     @7085
        bra     @708c
@7085:  lda     $7b8e,y
        bmi     @70bd
        bra     @70ba
@708c:  lda     $7b8e,y
        bmi     @70bd
        lda     $cf61,x
        bne     @70ba
        lda     $7b7e,y
        and     #$c0
        bne     @70bd
        lda     $cf56,x
        and     #$01
        bne     @70a9
        lda     $cf58,x
        bne     @70ba
@70a9:  lda     $cf45,x
        clc
        adc     $cf49,x
        cmp     #$c8
        beq     @70cb
        cmp     #$d8
        beq     @70cb
        bra     @70ba
@70ba:  stz     $cf4e,x
@70bd:  iny4
        txa
        clc
        adc     #$20
        tax
        cmp     #$80
        bne     @707a
        rts
@70cb:  lda     #$02
        sta     $cf4e,x
        jmp     @70bd

; ---------------------------------------------------------------------------

_c170d3:
        jsr     $6dfd
        jsr     $703a
        clr_ax
        sta     $96
@70dd:  lda     $cf44,x
        clc
        adc     $cf48,x
        longa
        asl2
        tay
        shorta0
        lda     $cf47,x
        beq     @7103
        phx
        asl
        tax
        lda     $d4b91c,x
        sta     $9e
        lda     $d4b91d,x
        sta     $9f
        plx
        bra     @710a
@7103:  lda     $cf4c,x
        sta     $9e
        stz     $9f
@710a:  lda     $cf62,x
        and     #$80
        bne     @7116
        lda     $cf43,x
        beq     @712a
@7116:  lda     #$06
        sta     $88
        lda     #$f8
@711c:  sta     $0201,y
        iny4
        dec     $88
        bne     @711c
        jmp     @72ae
@712a:  lda     $cf61,x
        beq     @7135
        lda     $a2
        and     #$02
        beq     @7116
@7135:  jsr     $6e52
        lda     $cf4e,x
        beq     @7143
        phx
        phy
        txy
        jmp     @714e
@7143:  phx
        phy
        txy
        lda     $cf58,x
        bne     @714e
        lda     $cf4d,x
@714e:  pha
        tax
        lda     $d8de5a,x
        tax
        stx     $8a
        tyx
        lda     $cf57,x
        beq     @7160
        dec
        bra     @7163
@7160:  lda     $cf51,x
@7163:  sta     $98
        pla
        asl3
        clc
        adc     $98
        sta     $98
        lda     $cf47,x
        asl
        tax
        lda     $d4b916,x
        clc
        adc     $98
        sta     $98
        lda     $d4b917,x
        adc     #$00
        sta     $99
        ldx     $98
        lda     $d8de7a,x
        pha
        sta     $98
        lda     #$06
        sta     $9a
        jsr     $fe4b
        tyx
        lda     $cf45,x
        clc
        adc     $cf49,x
        sta     $98
        stz     $99
        longa
        lda     $cf5d,x
        clc
        adc     $98
        sta     $98
        shorta0
        pla
        cmp     #$07
        bne     @71b8
        lda     $cf46,x
        dec
        bra     @71bb
@71b8:  lda     $cf46,x
@71bb:  clc
        adc     $cf4a,x
        sta     $99
        stz     $9a
        longa
        lda     $cf5f,x
        clc
        adc     $99
        sta     $99
        shorta0
        lda     $cf4b,x
        sta     $9a
        lda     $bc9a
        beq     @71e0
        lda     $9a
        and     #$ef
        sta     $9a
@71e0:  jsr     $6ef6
        jsr     $6fa4
        stz     $89
        lda     $cf4e,x
        bne     @71f2
        lda     $cf56,x
        bpl     @71fa
@71f2:  lda     #$40
        sta     $94
        lda     #$0c
        bra     @71fd
@71fa:  stz     $94
        clr_a
@71fd:  sta     $88
        longa
        lda     $8a
        clc
        adc     #$de4e
        sta     $90
        lda     $8a
        clc
        adc     #$de36
        adc     $88
        sta     $8c
        lda     $9c
        clc
        adc     #$b997      ; d4/b997 (battle character tilemaps)
        sta     $88
        shorta0
        lda     #$d4
        sta     $8a
        lda     #$d8
        sta     $8e
        lda     #$d8
        sta     $92
        lda     $dbd3
        beq     @7233
        lda     #$c0
        bra     @7235
@7233:  lda     #$a0
@7235:  sta     $a0
        ply
        tyx
        phx
        clr_ay
@723c:  lda     [$8c],y
        clc
        adc     $98
        eor     $f6
        sec
        sbc     $f8
        sta     $0200,x
        inx
        lda     [$90],y
        clc
        adc     $99
        cmp     $a0
        bcc     @7255
        lda     #$f0
@7255:  sta     $0200,x
        inx
        lda     [$88],y
        cmp     #$ff
        bne     @7267
        sta     $0200,x
        lda     #$01
        inx
        bra     @7273
@7267:  clc
        adc     $9e
        sta     $0200,x
        inx
        lda     $9a
        clc
        adc     $9f
@7273:  eor     $94
        eor     $f7
        sta     $0200,x
        inx
        iny
        cpy     #$0006
        bne     @723c
        plx
        lda     $a2
        and     #$01
        bne     @72ad
        txy
        lda     $96
        asl
        tax
        longa
        lda     $d0e1e0,x
        tax
        shorta0
        lda     #$18
        sta     $88
@729b:  lda     $f789,x
        sta     $f7e9,x
        lda     $0200,y
        sta     $f789,x
        inx
        iny
        dec     $88
        bne     @729b
@72ad:  plx
@72ae:  jsr     $72c1
        inc     $96
        txa
        clc
        adc     #$20
        tax
        cpx     #$0080
        jne     @70dd
        rts

; ---------------------------------------------------------------------------

_c172c1:
@72c1:  lda     $cf52,x
        beq     @72da
        inc     $cf50,x
        lda     $cf50,x
        and     $cf4f,x
        bne     @72da
        lda     $cf51,x
        inc
        and     #$07
        sta     $cf51,x
@72da:  rts

; ---------------------------------------------------------------------------

; [  ]

_c172db:
@72db:  pha
        lda     #$88
        sta     $dbb6
        jsr     $fc96       ; generate random number
        and     #$03
        beq     @72ec
        lda     #$56
        bra     @72ee
@72ec:  lda     #$0e
@72ee:  jsr     $fbd9       ; play sound effect
        jsr     $78f5       ; flash screen
        pla
        beq     @72fa
        jsr     $8141       ; wait
@72fa:  rts

; ---------------------------------------------------------------------------

; [  ]

_c172fb:
@72fb:  lda     #$78
        jsr     $72db
        lda     #$78
        jsr     $72db
        jsr     $7539
        lda     #$13
        sta     $f9e9
        lda     #$84
        jsr     $fbd9       ; play sound effect
        clr_ax
@7314:  lda     $ee58,x
        and     #$03
        bne     @7321
        stz     $ee57,x
        stz     $ee58,x
@7321:  inx2
        cpx     #$0500
        bne     @7314
@7328:  lda     $ff2f
        beq     @7337
        ldx     $bc79
        dex
        stx     $bc79
        jsr     $1cc2
@7337:  jsr     $7529
        stz     $86
        lda     $f9e9
        jsr     $7375
        inc     $86
        lda     $f9e9
        clc
        adc     #$04
        jsr     $7375
        lda     #$10
        sta     $86
        lda     $f9e9
        clc
        adc     #$08
        jsr     $7375
        inc     $86
        lda     $f9e9
        clc
        adc     #$0c
        jsr     $7375
        dec     $f9e9
        lda     $f9e9
        cmp     #$f0
        bne     @7328
        lda     #$02
        sta     $ff2e
        rts

; ---------------------------------------------------------------------------

_c17374:
@7375:  sta     $81
        sta     $80
        stz     $82
        stz     $87
@737d:  clr_ay
        lda     $82
        and     #$07
        tax
@7384:  lda     $d97c7a,x
        sta     $0070,y
        sta     $0071,y
        inx
        iny2
        cpy     #$0010
        bne     @7384
        phb
        lda     #$7f
        pha
        plb
        lda     $80
        bmi     @73d6
        cmp     #$14
        bcs     @73d6
        longa
        asl6
        tax
        lda     #$0016
        sta     $84
@73b1:  lda     $7eee57,x
        beq     @73cd
        and     #$01ff
        asl5
        clc
        adc     $86
        tay
        jsr     _c178ab
        lda     #$0001
        sta     $7eff2f
@73cd:  inx2
        dec     $84
        bne     @73b1
        shorta0
@73d6:  plb
        inc     $80
        inc     $81
        lda     $81
        bmi     @73e3
        cmp     #$14
        bcs     @73eb
@73e3:  inc     $82
        lda     $82
        cmp     #$08
        bne     @737d
@73eb:  rts

; ---------------------------------------------------------------------------

_c173ec:
        inc     $ff2e
        lda     #$78
        jsr     $72db
        lda     #$47
        sta     $ff04
        lda     #$03
        sta     $dbec
        stz     $ff2c
        inc     $dbeb
        lda     #$3c
        jsr     $72db
        lda     #$f0
        jsr     $72db
        lda     #$03
        sta     $bc9e
        lda     #$02
        sta     $bc8b
        sta     $bc8c
        lda     #$80
        sta     $ff2d
        lda     #$1c
        sta     $f9e9
        ldx     #$01e0
@7428:  phx
        jsr     $02f2       ; wait one frame
        jsr     $fc96       ; generate random number
        and     #$3f
        bne     @7436
        jsr     $72db
@7436:  plx
        dex
        bne     @7428
        jsr     $7539
@743d:  jsr     $7529
        jsr     $fc96       ; generate random number
        and     #$3f
        bne     @744a
        jsr     $72db
@744a:  clr_ax
        stx     $86
        lda     $f9e9
        jsr     $7471
        ldx     #$0010
        stx     $86
        lda     $f9e9
        clc
        adc     #$04
        jsr     $7471
        dec     $f9e9
        lda     $f9e9
        cmp     #$f4
        bne     @743d
        lda     #$f0
        jmp     _c18141       ; wait

; ---------------------------------------------------------------------------

_c17471:
@7471:  sta     $81
        and     #$1f
        sta     $80
        stz     $82
@7479:  clr_ay
        lda     $82
        and     #$07
        tax
@7480:  lda     $d97c7a,x
        sta     $0070,y
        sta     $0071,y
        inx
        iny2
        cpy     #$0010
        bne     @7480
        phb
        lda     #$7f
        pha
        plb
        lda     $80
        longa
        asl
        tax
        lda     #$0014
        sta     $84
@74a2:  lda     $7eee57,x
        and     #$01ff
        asl5
        clc
        adc     $86
        tay
        jsr     $7864
        txa
        clc
        adc     #$0040
        tax
        dec     $84
        bne     @74a2
        shorta0
        plb
        inc     $80
        inc     $81
        lda     $81
        bmi     @74cf
        cmp     #$20
        bcs     @74d7
@74cf:  inc     $82
        lda     $82
        cmp     #$08
        bne     @7479
@74d7:  rts

; ---------------------------------------------------------------------------

_c174d8:
@74d8:  jsr     $7539
        lda     $e4
        sta     $70
        clr_axy
@74e2:  asl     $70
        bcc     @7503
        lda     $d0e6,y
        beq     @7519
        longa
        asl4
        sta     $72
        clr_a
@74f4:  sta     $7fc000,x
        inx2
        dec     $72
        bne     @74f4
        shorta0
        bra     @7519
@7503:  lda     $d0e6,y
        beq     @7519
        longa
        asl5
        sta     $72
        txa
        clc
        adc     $72
        tax
        shorta0
@7519:  iny
        cpy     #$0008
        bne     @74e2
        jsr     $7529
        lda     $e4
        sta     $70
        jmp     _c12068       ; load monster palettes

; ---------------------------------------------------------------------------

_c17529:
@7529:  ldx     #$4000
        stx     $70
        ldx     #$c000
        lda     #$7f
        ldy     #$2000
        jmp     _c1fd27

; ---------------------------------------------------------------------------

_c17539:
@7539:  phb
        longa
        ldx     #$8000
        ldy     #$c000
        lda     #$3fff
        mvn     #$7f,#$7f
        shorta0
        plb
        rts

; ---------------------------------------------------------------------------

_c1754d:
@754d:  lda     $70
        pha
        ldx     #$0010
@7553:  phx
        jsr     $02f2       ; wait one frame
        clr_ax
        longa
@755b:  lda     $7e69,x
        jsr     $7576
        sta     $7e69,x
        inx2
        cpx     #$0020
        bne     @755b
        shorta0
        plx
        dex
        bne     @7553
        pla
        sta     $70
        rts

; ---------------------------------------------------------------------------

_c17576:
        .a16
@7576:  sta     $72
        and     #$001f
        cmp     #$001f
        beq     @7585
        lda     $72
        inc
        sta     $72
@7585:  lda     $72
        and     #$03e0
        cmp     #$03e0
        beq     @7597
        lda     $72
        clc
        adc     #$0020
        sta     $72
@7597:  lda     $72
        and     #$7c00
        cmp     #$7c00
        beq     @75a9
        lda     $72
        clc
        adc     #$0400
        sta     $72
@75a9:  lda     $72
        rts
        .a8

; ---------------------------------------------------------------------------

_c175ac:
@75ac:  lda     $70
        eor     #$ff
        sta     $74
        lda     $de
        and     $74
        sta     $de
        jmp     _c11cb8

; ---------------------------------------------------------------------------

_c175bb:
        cmp     #$0a
        beq     @75c6
        ora     #$80
        sta     $e5
        jmp     _75db
@75c6:  lda     $70
        pha
        jsr     $7539
        jsr     $7529
        pla
        ora     $de
        sta     $de
        jmp     _c11cb8

; ---------------------------------------------------------------------------

; [ battle graphics function $08:  ]

_c175d7:
        lda     #$81
        sta     $e5
_75db:  lda     $70
        sta     $e4
        lda     $de
        ora     $e4
        sta     $de
        jsr     $74d8
        jsr     $1cb8
        lda     $e4
        eor     #$ff
        sta     $74
        clr_ax
@75f3:  sta     $f52c,x
        inx
        cpx     #$0010
        bne     @75f3
        jsr     $772c
        jmp     _c11cb8

; ---------------------------------------------------------------------------

_c17602:
        cmp     #$0a
        beq     @760b
        sta     $e5
        jmp     _c17695
@760b:  sta     $e5
        jsr     $75ac
        jmp     _c18b2a

; ---------------------------------------------------------------------------

; [  ]

_c17613:
        cmp     #$0a
        beq     @761c
        sta     $e5
        jmp     _c1765e
@761c:  sta     $e5
        jsr     $75ac
        jmp     _c18b2a

; ---------------------------------------------------------------------------

_c17624:
@7624:  clr_ax
@7626:  lda     $d99655,x
        sta     $7e69,x
        inx
        cpx     #$0020
        bne     @7626
        lda     $70
        pha
        jsr     $1cb1       ; load black and white monster palette
        pla
        sta     $70
        rts

; ---------------------------------------------------------------------------

; [  ]

_c1763d:
@763d:  clr_ax
        lda     #$80
        sta     $72
        stz     $73
@7645:  lda     $7b9e,x
        and     #$30
        beq     @7652
        lda     $73
        ora     $72
        sta     $73
@7652:  lsr     $72
        inx4
        cpx     #$0020
        bne     @7645
        rts

; ---------------------------------------------------------------------------

; [  ]

_c1765e:
@765e:  lda     $de
        and     $70
        beq     @766a
        jsr     $76bc
        jmp     _c18b2a
@766a:  rts

; ---------------------------------------------------------------------------

; [  ]

_c1766b:
@766b:  lda     $de
        and     $70
        beq     @768b
        lda     $70
        eor     #$ff
        sta     $72
        lda     $de
        and     $72
        bne     @768b
        lda     $3efe
        and     #$01
        beq     @768b
        jsr     $72fb
        stz     $de
        sec
        rts
@768b:  clc
        rts

; ---------------------------------------------------------------------------

; [ battle graphics function $07: condemn death animation ]

_c1768d:
        jsr     $766b
        bcc     @7693
        rts
@7693:  stz     $e5

_c17695:
@7695:  lda     $de
        and     $70
        beq     @76ab
        lda     #$33
        sta     $dbb6       ; sound effect volume
        lda     #$3b
        jsr     $fbd9       ; play sound effect
        jsr     $76bc
        jsr     _c18b2a
@76ab:  lda     $ff2c
        and     $de
        sta     $ff2c
        lda     $ff2d
        and     $de
        sta     $ff2d
        rts

; ---------------------------------------------------------------------------

; [  ]

_c176bc:
@76bc:  lda     #$01
        sta     $bc8b
        lda     #$42
        sta     $bc85
        lda     #$02
        sta     $bc8c
        jsr     $35e1       ; set priority bit for battle bg tiles
        jsr     $7624
        jsr     $754d
        jsr     $763d
        lda     $70
        and     $73
        eor     #$ff
        sta     $73
        lda     $de
        and     $73
        sta     $de
        lda     $70
        pha
        jsr     $1cb1       ; load black and white monster palette
        pla
        sta     $70
        jsr     $76fe
        jsr     $35fe       ; clear priority bit for battle bg tiles
        stz     $bc8c
        stz     $bc8b
        stz     $bc85
        rts

; ---------------------------------------------------------------------------

; [  ]

_c176fe:
@76fe:  lda     $70
        sta     $e3
        eor     #$ff
        sta     $74
        lda     $de
        and     $e3
        beq     @772b
        lda     $de
        and     $74
        sta     $de
        phb
        longa
        ldx     #$8000
        ldy     #$c000
        lda     #$3fff
        mvn     #$7f,#$7f
        shorta0
        plb
        jsr     $772c
        jmp     _c11cb8
@772b:  rts

; ---------------------------------------------------------------------------

; [ something with boss dissolve death ??? ]

_c1772c:
@772c:  clr_axy
@772f:  lda     $d0e6,y
        beq     @7744
        sta     $76
        asl     $74
        rol
        and     #$01
@773b:  sta     $7f7500,x
        inx
        dec     $76
        bne     @773b
@7744:  iny
        cpy     #$0008
        bne     @772f
        ldx     #$0000
@774d:  ldy     #$c000
        sty     $d0e2
        ldy     #$2000
        sty     $d0e4
        ldy     #$0000
@775c:  jsr     $778a
        longa
        lda     $d0e2
        clc
        adc     #$0800
        sta     $d0e2
        lda     $d0e4
        clc
        adc     #$0400
        sta     $d0e4
        tya
        clc
        adc     #$0800
        tay
        shorta0
        cpy     #$4000
        bne     @775c
        inx
        cpx     #$0008
        bne     @774d
        rts

; ---------------------------------------------------------------------------

; [  ]

_c1778a:
@778a:  phx
        phy
        phy
        ldy     #$0000
        txa
        sta     $86
        lda     $e5
        and     #$7f
        asl4
        clc
        adc     $86
        tax
@779f:  lda     $e5
        bmi     @77a9
        lda     $d97c7a,x
        bra     @77b5
@77a9:  lda     $d97c7a,x
        eor     #$ff
        ora     $f52c,y
        sta     $f52c,y
@77b5:  sta     $0070,y
        sta     $0071,y
        lda     $e5
        sta     $85
        stz     $84
        inx
        iny2
        cpy     #$0010
        bne     @779f
        ply
        lda     #$40
        sta     $86
        stz     $87
        phb
        lda     #$7f
        pha
        plb
        longa
        tya
        lsr5
        tax
@77de:  lda     $7f7500,x
        and     #$0001
        beq     @77ef
        tya
        clc
        adc     #$0020
        tay
        bra     @7801
@77ef:  lda     $84
        bmi     @77fb
        jsr     $7864
        jsr     $7864
        bra     @7801
@77fb:  jsr     $781d
        jsr     $781d
@7801:  inx
        dec     $86
        bne     @77de
        shorta0
        plb
        ldx     #$0800
        stx     $70
        ldx     $d0e2
        lda     #$7f
        ldy     $d0e4
        jsr     $fd27
        ply
        plx
        rts

; ---------------------------------------------------------------------------

_c1781d:
        .a16
@781d:  lda     $8000,y
        and     $70
        sta     $c000,y
        lda     $8002,y
        and     $72
        sta     $c002,y
        lda     $8004,y
        and     $74
        sta     $c004,y
        lda     $8006,y
        and     $76
        sta     $c006,y
        lda     $8008,y
        and     $78
        sta     $c008,y
        lda     $800a,y
        and     $7a
        sta     $c00a,y
        lda     $800c,y
        and     $7c
        sta     $c00c,y
        lda     $800e,y
        and     $7e
        sta     $c00e,y
        tya
        clc
        adc     #$0010
        tay
        rts
        .a8

; ---------------------------------------------------------------------------

; [  ]

_c17864:
        .a16
@7864:  lda     $c000,y
        and     $70
        sta     $c000,y
        lda     $c002,y
        and     $72
        sta     $c002,y
        lda     $c004,y
        and     $74
        sta     $c004,y
        lda     $c006,y
        and     $76
        sta     $c006,y
        lda     $c008,y
        and     $78
        sta     $c008,y
        lda     $c00a,y
        and     $7a
        sta     $c00a,y
        lda     $c00c,y
        and     $7c
        sta     $c00c,y
        lda     $c00e,y
        and     $7e
        sta     $c00e,y
        tya
        clc
        adc     #$0010
        tay
        rts
        .a8

; ---------------------------------------------------------------------------

; [  ]

_c178ab:
@78ab:  longa
        lda     $c000,y
        and     $70
        sta     $c000,y
        lda     $c002,y
        and     $72
        sta     $c002,y
        lda     $c004,y
        and     $74
        sta     $c004,y
        lda     $c006,y
        and     $76
        sta     $c006,y
        lda     $c008,y
        and     $78
        sta     $c008,y
        lda     $c00a,y
        and     $7a
        sta     $c00a,y
        lda     $c00c,y
        and     $7c
        sta     $c00c,y
        lda     $c00e,y
        and     $7e
        sta     $c00e,y
        tya
        clc

; *** bug ***
; this instruction has an 8-bit parameter in the original ROM, but
; the accumulator is 16-bit here
        .a8
        adc     #$10
        tay
        longa
        rts
        .a8

; ---------------------------------------------------------------------------

; [ misc effect $03: flash screen ]

_c178f5:
@78f5:  lda     #$1e
        sta     $f8c8
        inc     $f8c7
        rts

; ---------------------------------------------------------------------------

; [ update screen flash ]

_c178fe:
        lda     $f8c7
        beq     @792f
        lda     #$02        ; color math affect bg2
        sta     $bc85
        lda     $f8c8
        ora     #$e0        ; flash white
        sta     $bc88
        sta     $bc89
        sta     $bc8a
        dec     $f8c8
        dec     $f8c8
        bne     @792f
        lda     #$e0        ; clear screen flash intensity
        sta     $bc88
        sta     $bc89
        sta     $bc8a
        stz     $f8c7
        stz     $bc85       ; color math affect none
@792f:  rts

; ---------------------------------------------------------------------------

; [  ]

_c17930:
@7930:  lda     $db56
        beq     @7978
        lda     $a2
        and     #$03
        bne     @7978
        lda     #$01
        sta     $98
        lda     #$07
        sta     $9a
        asl     $98
        lda     $9a
        asl
        clc
        adc     $98
        tax
        stz     $9b
        longa
        lda     $f849,x
        pha
@7954:  lda     $f847,x
        sta     $f849,x
        dex2
        dec     $9a
        bne     @7954
        pla
        sta     $f849,x
        shorta0
        clr_ax
@7969:  lda     $f849,x
        sta     $7e69,x
        sta     $7e79,x
        inx
        cpx     #$0010
        bne     @7969
@7978:  rts

; ---------------------------------------------------------------------------

_c17979:
        jsr     $7930
        lda     $d0ee
        beq     @7984
        jsr     $7eb4
@7984:  lda     $d0f0
        beq     @798c
        jsr     $7d5f
@798c:  lda     $d0f2
        beq     @7994
        jsr     $7ba0
@7994:  lda     $d0f4
        beq     @799c
        jsr     $7cb5
@799c:  lda     $d0f6
        beq     @79a4
        jsr     $7c49
@79a4:  rts

; ---------------------------------------------------------------------------

_c179a5:
        phx
        phy
        tax
        lda     $d97d25,x
        sta     $80
        lda     $d0f7
        bne     @79c3
        lda     #$0a        ; mode 2
        sta     $bc81
        lda     $7e
        sta     $d10d
        stz     $d10e
        stz     $d10f
@79c3:  lda     $7e
        bpl     @79f5
        lda     $80
        eor     #$ff
        sta     $80
        lda     $d0f7
        and     $80
        sta     $d0f7
        bne     @7a02
        stz     $d0f6
        stz     $d0f7
        stz     $d10d
        clr_ax
@79e2:  sta     $b404,x
        inx
        cpx     #$0040
        bne     @79e2
        inc     $b3c0
        lda     #$09        ; mode 1
        sta     $bc81
        bra     @7a02
@79f5:  lda     #$01
        sta     $d0f6
        lda     $d0f7
        ora     $80
        sta     $d0f7
@7a02:  longa
        clr_ay
@7a06:  lda     $0070,y
        pha
        iny2
        cpy     #$000c
        bne     @7a06
        shorta0
        jsr     $3cbb
        longa
        ldy     #$000c
@7a1c:  pla
        sta     $006e,y
        dey2
        bne     @7a1c
        shorta0
        ply
        plx
        rts

; ---------------------------------------------------------------------------

_c17a2a:
        phx
        phy
        tax
        lda     $d97d25,x
        sta     $80
        lda     $d0f5
        bne     @7a4b
        lda     $bc84
        ora     #$01
        sta     $bc84
        lda     $7e
        sta     $d10a
        stz     $d10b
        stz     $d10c
@7a4b:  lda     $7e
        bpl     @7a83
        lda     $80
        eor     #$ff
        sta     $80
        lda     $d0f5
        and     $80
        sta     $d0f5
        bne     @7a90
        stz     $d0f4
        stz     $d0f5
        stz     $d10a
        clr_ax
@7a6a:  sta     $a937,x
        sta     $a9b7,x
        sta     $acb7,x
        inx
        cpx     #$0080
        bne     @7a6a
        lda     $bc84
        and     #$fe
        sta     $bc84
        bra     @7a90
@7a83:  lda     #$01
        sta     $d0f4
        lda     $d0f5
        ora     $80
        sta     $d0f5
@7a90:  ply
        plx
        rts

; ---------------------------------------------------------------------------

; [  ]

_c17a93:
        phx
        phy
        tax
        lda     $d97d25,x
        sta     $80
        lda     $d0f3
        bne     @7aac
        lda     $7e
        sta     $d106
        stz     $d108
        stz     $d109
@7aac:  lda     $7e
        bpl     @7af2
        lda     $80
        eor     #$ff
        sta     $80
        lda     $d0f3
        and     $80
        sta     $d0f3
        bne     @7aff
        stz     $d0f2
        stz     $d0f3
        stz     $d106
        stz     $bc77
        stz     $bc79
        clr_ax
@7ad1:  sta     $a937,x
        sta     $a9b7,x
        sta     $acb7,x
        inx
        cpx     #$0080
        bne     @7ad1
        lda     $f8c5
        bne     @7af0
        clr_ax
@7ae7:  sta     $acb7,x
        inx
        cpx     #$0080
        bne     @7ae7
@7af0:  bra     @7aff
@7af2:  lda     #$01
        sta     $d0f2
        lda     $d0f3
        ora     $80
        sta     $d0f3
@7aff:  ply
        plx
        rts

; ---------------------------------------------------------------------------

; [  ]

_c17b02:
        phx
        phy
        tax
        lda     $d97d25,x
        sta     $80
        lda     $d0f1
        bne     @7b18
        jsr     $7d52
        lda     $7e
        sta     $d102
@7b18:  lda     $7e
        and     #$07
        bne     @7b33
        lda     $80
        eor     #$ff
        sta     $80
        lda     $d0f1
        and     $80
        sta     $d0f1
        bne     @7b40
        jsr     $7d8c
        bra     @7b40
@7b33:  lda     #$01
        sta     $d0f0
        lda     $d0f1
        ora     $80
        sta     $d0f1
@7b40:  ply
        plx
        rts

; ---------------------------------------------------------------------------

; [  ]

_c17b43:
        phx
        phy
        tax
        lda     $f8bd
        cmp     #$ff
        bne     @7b91
        lda     $d97d25,x
        sta     $80
        lda     $d0ef
        bne     @7b63
        stz     $d100
        jsr     $7eab
        lda     $7e
        sta     $d0fe
@7b63:  lda     $7e
        and     #$07
        bne     @7b84
        lda     $80
        eor     #$ff
        sta     $80
        lda     $d0ef
        and     $80
        sta     $d0ef
        bne     @7b91
        stz     $d0ee
        stz     $d0fe
        jsr     $7ee2
        bra     @7b91
@7b84:  lda     #$01
        sta     $d0ee
        lda     $d0ef
        ora     $80
        sta     $d0ef
@7b91:  ply
        plx
        rts
        clr_ax
@7b96:  sta     $d0ee,x
        inx
        cpx     #$000a
        bne     @7b96
        rts

; ---------------------------------------------------------------------------

_c17ba0:
@7ba0:  lda     $d107
        and     #$01
        bne     @7bd5
        lda     $d106
        and     #$1c
        lsr2
        sta     $8c
        stz     $88
        stz     $8a
        lda     $d106
        and     #$40
        beq     @7bc3
        jsr     $fc96       ; generate random number
        and     $8c
        sta     $d108
@7bc3:  lda     $d106
        and     #$20
        beq     @7bd5
        jsr     $fc96       ; generate random number
        and     $8c
        eor     #$ff
        inc
        sta     $d109
@7bd5:  lda     $d108
        sta     $88
        lda     $d109
        sta     $8a
        lda     $d107
        and     #$01
        bne     @7c14
        lda     $d106
        and     #$01
        beq     @7c14
        clr_ax
@7bef:  lda     $88
        sta     $a937,x
        sta     $a9b7,x
        lda     $8a
        sta     $a939,x
        sta     $a9b9,x
        inx4
        cpx     #$0080
        bne     @7bef
        lda     $88
        sta     $bc77
        lda     $8a
        sta     $bc79
        bra     @7c45
@7c14:  lda     $d106
        and     #$02
        beq     @7c45
        lda     $f8c5
        bne     @7c30
        clr_ax
@7c22:  lda     $88
        sta     $acb7,x
        inx4
        cpx     #$0080
        bne     @7c22
@7c30:  lda     $f8c6
        bne     @7c45
        clr_ax
@7c37:  lda     $88
        sta     $acb9,x
        inx4
        cpx     #$0080
        bne     @7c37
@7c45:  inc     $d107
        rts

; ---------------------------------------------------------------------------

_c17c49:
@7c49:  lda     $d10d
        and     #$1c
        lsr2
        sta     $8e
        lda     $d10d
        and     #$03
        asl5
        sta     $8c
        clr_ay
        lda     $d10f
        sta     $88
@7c65:  lda     $d10d
        and     #$1c
        lsr
        sta     $9a
        lda     $88
        jsr     $0a32
        stz     $98
        sec
        sbc     $8e
        bpl     @7c7f
        pha
        lda     #$03
        sta     $98
        pla
@7c7f:  sta     $b404,y
        lda     $8c
        ora     $98
        sta     $b405,y
        lda     $88
        clc
        adc     #$08
        sta     $88
        iny2
        cpy     #$0040
        bne     @7c65
        lda     $d10d
        and     #$60
        lsr5
        tax
        lda     $d10f
        clc
        adc     $c17cb1,x
        sta     $d10f
        inc     $b3c0
        rts

; ---------------------------------------------------------------------------

_c17cb1:
        tsb     $08
        bpl     @7cd5
@7cb5:  lda     $d10a
        and     #$60
        lsr5
        tax
        lda     f:_c17d4e,x
        sta     $92
        lda     $d10a
        and     #$1c
        lsr
        sta     $9a
        lda     $d10c
        sta     $88
        clr_ax
@7cd5:  phx
        lda     $d10a
        and     #$1c
        lsr
        sta     $9a
        lda     $88
        jsr     $0a32
        plx
        sta     $f9cc,x
        lda     $88
        clc
        adc     #$10
        sta     $88
        inx
        cpx     #$0010
        bne     @7cd5
        lda     $d10b
        and     #$01
        bne     @7d1e
        lda     $d10a
        and     #$01
        beq     @7d1e
        clr_axy
@7d05:  lda     $f9cc,y
        sta     $a937,x
        sta     $a9b7,x
        iny
        tya
        and     #$0f
        tay
        inx4
        cpx     #$0080
        bne     @7d05
        bra     @7d4a
@7d1e:  lda     $d10c
        clc
        adc     $92
        sta     $d10c
        lda     $d10a
        and     #$02
        beq     @7d4a
        clr_axy
        lda     $f8c5
        bne     @7d4a
@7d36:  lda     $f9cc,y
        sta     $acb7,x
        iny
        tya
        and     #$0f
        tay
        inx4
        cpx     #$0080
        bne     @7d36
@7d4a:  inc     $d10b
        rts

; ---------------------------------------------------------------------------

_c17d4e:
        .byte   $02,$06,$0e,$1e

; ---------------------------------------------------------------------------

_c17d52:
@7d52:  stz     $d104
        stz     $d111
        stz     $d112
        stz     $d113
        rts

; ---------------------------------------------------------------------------

_c17d5f:
@7d5f:  lda     $d102
        and     #$07
        asl
        tax
        lda     f:_c17d7c,x
        sta     $88
        lda     f:_c17d7c+1,x
        sta     $89
        jsr     $7d79
        inc     $d104
        rts

_c17d79:
@7d79:  jmp     ($0088)

; ---------------------------------------------------------------------------

_c17d7c:
        .addr   $7d8c,$7db0,$7e1f,$7e48,$7e6b,$7e1b,$7e44,$7e8b

; ---------------------------------------------------------------------------

_c17d8c:
        lda     #$e0
        sta     $bc88
        sta     $bc89
        sta     $bc8a
        stz     $d102
        stz     $d103
        stz     $d104
        stz     $d0f0
        stz     $bc85
        rts

; ---------------------------------------------------------------------------

_c17da7:
@7da7:  lda     $d102
        bmi     @7daf
        stz     $d102
@7daf:  rts

; ---------------------------------------------------------------------------

_c17db0:
        lda     #$42
        sta     $bc85
        lda     $d102
        and     #$08
        bne     @7dc0
        lda     #$04
        bra     @7dc2
@7dc0:  lda     #$02
@7dc2:  sta     $88
        lda     $d104
        and     $88
        beq     @7dd9
        lda     #$e0
        sta     $bc88
        sta     $bc89
        sta     $bc8a
        jmp     _c17da7
@7dd9:  lda     #$1f
        sta     $d111
        sta     $d112
        sta     $d113
        jmp     _c17de7

; ---------------------------------------------------------------------------

_c17de7:
@7de7:  stz     $bc88
        stz     $bc89
        stz     $bc8a
        lda     $d102
        and     #$40
        beq     @7dfe
        asl
        ora     $d113
        sta     $bc88
@7dfe:  lda     $d102
        and     #$20
        beq     @7e0c
        asl
        ora     $d112
        sta     $bc89
@7e0c:  lda     $d102
        and     #$10
        beq     @7e1a
        asl
        ora     $d111
        sta     $bc8a
@7e1a:  rts

; ---------------------------------------------------------------------------

_c17e1b:
@7e1b:  lda     #$82
        bra     _7e21

_c17e1f:
@7e1f:  lda     #$02
_7e21:  sta     $bc85
        jsr     $7ee5
        lsr     $88
        lda     $d104
        and     $88
        bne     @7e43
        lda     $d111
        cmp     #$1f
        beq     @7e43
        inc     $d111
        inc     $d112
        inc     $d113
        jsr     $7de7
@7e43:  rts

; ---------------------------------------------------------------------------

_c17e44:
@7e44:  lda     #$82
        bra     @7e4a
@7e48:  lda     #$02
@7e4a:  sta     $bc85
        jsr     $7ee5
        lsr     $88
        lda     $d104
        and     $88
        bne     @7e6a
        lda     $d111
        beq     @7e6a
        dec     $d111
        dec     $d112
        dec     $d113
        jsr     $7de7
@7e6a:  rts

; ---------------------------------------------------------------------------

_c17e6b:
        lda     $d103
        beq     @7e7a
        lda     $d111
        cmp     #$1f
        beq     @7e82
        jmp     _c17e1f
@7e7a:  lda     $d111
        jne     $7e48
@7e82:  lda     $d103
        eor     #$01
        sta     $d103
        rts

; ---------------------------------------------------------------------------

_c17e8b:
        lda     $d103
        beq     @7e9a
        lda     $d111
        cmp     #$1f
        beq     @7ea2
        jmp     _c17e1b
@7e9a:  lda     $d111
        jne     $7e44
@7ea2:  lda     $d103
        eor     #$01
        sta     $d103
        rts

; ---------------------------------------------------------------------------

_c17eab:
@7eab:  stz     $d101
        lda     #$20
        sta     $d0ff
        rts

; ---------------------------------------------------------------------------

_c17eb4:
@7eb4:  lda     $d0fe
        and     #$07
        asl
        tax
        lda     f:_c17ed2,x
        sta     $88
        lda     f:_c17ed2+1,x
        sta     $89
        jsr     @7ece
        inc     $d101
        rts
@7ece:  jmp     ($0088)

; ---------------------------------------------------------------------------

_c17ed1:
        rts

; ---------------------------------------------------------------------------

_c17ed2:
        .addr   $7ee2,$7f43,$7ef5,$7f9a,$7fc7,$7f70,$7ed1,$7ed1

; ---------------------------------------------------------------------------

_c17ee1:
        jmp     _c17f34

; ---------------------------------------------------------------------------

_c17ee4:
        lda     $d0fe
        and     #$08
        beq     @7ef0
        lda     #$01
        bra     @7ef2
@7ef0:  lda     #$03
@7ef2:  sta     $88
        rts

; ---------------------------------------------------------------------------

_c17ef5:
        jsr     $7ee5
        lda     $d101
        and     $88
        bne     @7f2a
        longa
        lda     $7e2b
        pha
        lda     $7e4b
        pha
        ldx     #$0002
@7f0c:  lda     $7e2b,x
        sta     $7e29,x
        lda     $7e4b,x
        sta     $7e49,x
        inx2
        cpx     #$001e
        bne     @7f0c
        pla
        sta     $7e67
        pla
        sta     $7e47
        shorta0
@7f2a:  rts

; ---------------------------------------------------------------------------

_c17f2b:
@7f2b:  lda     $d0fe
        bmi     @7f33
        stz     $d0fe
@7f33:  rts

; ---------------------------------------------------------------------------

_c17f34:
@7f34:  clr_ax
@7f36:  lda     $f540,x
        sta     $7e29,x
        inx
        cpx     #$0040
        bne     @7f36
        rts

; ---------------------------------------------------------------------------

_c17f43:
        lda     $d0fe
        and     #$08
        bne     @7f4e
        lda     #$04
        bra     @7f50
@7f4e:  lda     #$02
@7f50:  sta     $88
        clr_ax
        lda     $d101
        and     $88
        beq     @7f61
        jsr     $7f34
        jmp     _c17f2b
@7f61:  ldx     #$0002
        lda     #$ff
@7f66:  sta     $7e29,x
        inx
        cpx     #$0040
        bne     @7f66
        rts

; ---------------------------------------------------------------------------

_c17f70:
        lda     $d0ff
        cmp     #$1a
        bne     @7f84
        lda     $d100
        eor     #$01
        sta     $d100
        lda     #$06
        sta     $d0ff
@7f84:  lda     $d100
        beq     @7f91
        lda     $f8b4
        bne     @7f99
        jmp     _c17f9a
@7f91:  jsr     $7fc7
        lda     #$01
        sta     $f8b4
@7f99:  rts

; ---------------------------------------------------------------------------

_c17f9a:
@7f9a:  jsr     $7ee5
        lda     $d101
        and     $88
        bne     @7fc6
        lda     $d0ff
        beq     @7fc6
        tax
        stx     $98
        clr_ay
        longa
@7fb0:  lda     $f540,y
        jsr     $7ffe
        sta     $7e29,y
        iny2
        cpy     #$0040
        bne     @7fb0
        shorta0
        dec     $d0ff
@7fc6:  rts

; ---------------------------------------------------------------------------

_c17fc7:
@7fc7:  jsr     $7ee5
        lda     $d101
        and     $88
        bne     @7ffd
        lda     $d0ff
        cmp     #$1a
        beq     @7ffd
        tax
        stx     $98
        clr_ay
        longa
        lda     #$0020
        sec
        sbc     $98
        sta     $98
@7fe7:  lda     $f540,y
        jsr     $7ffe
        sta     $7e29,y
        iny2
        cpy     #$0040
        bne     @7fe7
        shorta0
        dec     $d0ff
@7ffd:  rts

; ---------------------------------------------------------------------------

_c17ffe:
        .a16
@7ffe:  sta     $88
        lda     $98
        asl5
        sta     $9a
        asl5
        sta     $9c
        lda     $88
        and     #$001f
        beq     @802b
        cmp     $98
        bcc     @8024
        lda     $88
        sec
        sbc     $98
        sta     $88
        bra     @802b
@8024:  lda     $88
        and     #$7fe0
        sta     $88
@802b:  lda     $88
        and     #$03e0
        beq     @8046
        cmp     $9a
        bcc     @803f
        lda     $88
        sec
        sbc     $9a
        sta     $88
        bra     @8046
@803f:  lda     $88
        and     #$7c1f
        sta     $88
@8046:  lda     $88
        and     #$7c00
        beq     @805f
        cmp     $9c
        bcc     @8058
        lda     $88
        sec
        sbc     $9c
        bra     @805f
@8058:  lda     $88
        and     #$03ff
        sta     $88
@805f:  lda     $88
        rts
        .a8

; ---------------------------------------------------------------------------

; [ move character back after attack ??? ]

_c18062:
@8062:  lda     $3bcd
        and     #$03
        pha
        asl5
        tax
        jsr     $8103
        pla
        pha
        tax
        lda     #$80
        sta     $72
        lda     $d1bd,x
        beq     @8083
        stz     $72
        lda     #$10
        bra     @808e
@8083:  lda     $db4a,x
        beq     @808c
        lda     #$20
        bra     @808e
@808c:  lda     #$10
@808e:  sta     $70
        pla
        asl5
        tax
        lda     $70
        ora     $72
        sta     $cf54,x
        lda     #$02
        sta     $cf4d,x
        lda     #$01
        sta     $cf53,x
        stz     $cf55,x
        jsr     $8103
        lda     $3bcd
        and     #$03
        tax
        stz     $d1cb,x
        rts

; ---------------------------------------------------------------------------

; [ move character forward to attack ]

_c180b8:
@80b8:  jsr     _c18d2f       ; get attacker id
        and     #$03
        pha
        asl5
        tax
        jsr     $8103
        pla
        pha
        tax
        stz     $72
        lda     #$01
        sta     $d1cb,x
        lda     $d1bd,x
        beq     @80de
        lda     #$80        ; move left
        sta     $72
        lda     #$10
        bra     @80e9
@80de:  lda     $db4a,x     ; character row
        beq     @80e7
        lda     #$20        ; move forward 32 pixels if in back row
        bra     @80e9
@80e7:  lda     #$10        ; move forward 16 pixels if in front row
@80e9:  sta     $70
        pla
        asl5
        tax
        lda     $70
        ora     $72
        sta     $cf54,x     ; set movement counter
        lda     #$02        ; walking animation
        sta     $cf4d,x
        lda     #$01
        sta     $cf53,x
; fallthrough

; ---------------------------------------------------------------------------

; [ wait for character to move forward ]

_c18103:
@8103:  phx
        jsr     $02f2       ; wait one frame
        plx
        lda     $cf53,x
        bne     @8103
        rts

; ---------------------------------------------------------------------------

; [ flash active monster ]

_c1810e:
@810e:  clr_ax
@8110:  sta     $7e69,x
        inx
        cpx     #$0020
        bne     @8110
        ldx     #$ffff
        stx     $7e6b
        jsr     $8125       ; flash monster (twice)
        jmp     _c18125

; ---------------------------------------------------------------------------

; [ flash monster ]

_c18125:
@8125:  lda     $dbe4
        beq     @812e
        lda     #$c0
        bra     @8134
@812e:  jsr     _c18d2f       ; get attacker id
        jsr     $fc74       ; get monster mask
@8134:  jsr     $1cb1       ; load black and white monster palette
        lda     #$03
        jsr     $8141       ; wait
        jsr     $1cb8
        lda     #$03
; fallthrough

; ---------------------------------------------------------------------------

; [ wait ]

; a = number of frames to wait

_c18141:
@8141:  pha
        jsr     $02f2       ; wait one frame
        pla
        dec
        bne     @8141
        rts

; ---------------------------------------------------------------------------

; [  ]

_c1814a:
@814a:  lda     ($eb)
        bmi     @816f
        jsr     _c18d2f       ; get attacker id
        and     #$03
        asl5
        tax
        stz     $cf58,x
        lda     $cf56,x
        and     #$fe
        sta     $cf56,x
        lda     ($eb)
        and     #$20
        bne     @8178
        jsr     $80b8       ; move character forward to attack
        bra     @8178
@816f:  lda     ($eb)
        and     #$20
        bne     @8178
        jsr     $810e       ; flash active monster
@8178:  rts

; ---------------------------------------------------------------------------

; [  ]

_c18179:
@8179:  lda     $3bcc
        and     #$20
        bne     @8188
        lda     $3bcc
        bmi     @8188
        jsr     $8062
@8188:  rts

; ---------------------------------------------------------------------------

; [ battle graphics function $0a: execute graphics script ]

; $f2: show monster
; $f6: show battle dialogue
; $f8: do misc effect
; $fc: do graphics commands

_c18189:
        ldx     #$3bcc      ; pointer to attack parameters
        stx     $eb
        ldx     #$3a4c      ; pointer to damage values
        stx     $e9
        ldx     #$384c      ; pointer to graphics commands
        stx     $e7
        ldx     #$7b49      ;
        stx     $ed
        ldx     #$3c3c      ; pointer to block type
        stx     $f0
        ldx     #$3cbf      ; pointer to message variables
        stx     $f4
        ldx     #$3c5f      ; pointer to message ids
        stx     $f2
        stz     $db76
        jsr     $814a
@81b2:  lda     ($e7)       ; script command
        cmp     #$ff
        beq     @820c       ; branch if terminator
        jsr     $8d59       ; get graphics script parameter 1
        cmp     #$f2        ; opcodes less than $f2 have no effect
        bcc     @81f9
        sec
        sbc     #$f2
        asl
        tax
        lda     f:_c18218,x
        sta     $70
        lda     f:_c18218+1,x
        sta     $71
        jsr     $8209
        jsr     $8d59       ; get graphics script parameter 1
        cmp     #$fc
        bne     @81f9       ; branch if not a graphics command
        iny
        lda     ($e7),y
        cmp     #$03
        bcc     @81e5
        cmp     #$07
        bne     @81f9
@81e5:  longa
        lda     $eb
        clc
        adc     #$0007
        sta     $eb
        shorta0
        lda     $ed
        clc
        adc     #$08
        sta     $ed
@81f9:  longa
        lda     $e7
        clc
        adc     #$0005
        sta     $e7
        shorta0
        jmp     @81b2
@8209:  jmp     ($0070)
@820c:  jsr     $9d93       ; wait for damage numerals
        jsr     $8179
        jsr     $3cbb
        jmp     _c19d3c

; ---------------------------------------------------------------------------

; jump table for graphics script parameter 1 ($f2-$ff)
_c18218:
        .addr               $8b46,$82a4,$82a4,$82a4,$8cbd,$82a4
        .addr   $8234,$82a4,$82a4,$82a4,$8b69,$82a4,$82a4,$82a4

; ---------------------------------------------------------------------------

; [ graphics script command $f8: execute misc effect ]

_c18234:
        jsr     $8d4d       ; get graphics script parameter 2
        asl
        tax
        lda     f:_c18248,x
        sta     $70
        lda     f:_c18248+1,x
        sta     $71
        jmp     ($0070)

; ---------------------------------------------------------------------------

; misc effect jump table
_c18248:
        .addr   $833d,$8332,$830e,$78f5,$82ab,$8317,$8329,$82a5
        .addr   $8320,$825e,$8281

; ---------------------------------------------------------------------------

; [ misc effect $09:  ]

_c1825e:
        jsr     _c18d47       ; get graphics script parameter 3
        bpl     @8273
        and     #$07
        tax
        lda     $d97d25,x
        eor     #$ff
        and     $ff2c
        sta     $ff2c
        rts
@8273:  and     #$07
        tax
        lda     $d97d25,x
        ora     $ff2c
        sta     $ff2c
        rts

; ---------------------------------------------------------------------------

; [ misc effect $0a:  ]

_c18281:
        jsr     _c18d47       ; get graphics script parameter 3
        bpl     @8296
        and     #$07
        tax
        lda     $d97d25,x
        eor     #$ff
        and     $ff2d
        sta     $ff2d
        rts
@8296:  and     #$07
        tax
        lda     $d97d25,x
        ora     $ff2d
        sta     $ff2d
        rts

; ---------------------------------------------------------------------------

; [ unused graphics script commands ]

_c182a4:
        rts

; ---------------------------------------------------------------------------

; [ misc effect $07: wait ]

_c182a5:
        jsr     _c18d47       ; get graphics script parameter 3
        jmp     _c18141       ; wait

; ---------------------------------------------------------------------------

; [ misc effect $04:  ]

_c1821b:
        jsr     _c18d47       ; get graphics script parameter 3
        sta     $7e
        and     #$03
        sta     $bc80
        lda     $7e
        and     #$3c
        asl2
        sta     $ff29
        lda     $7e
        and     #$40
        sta     $ff2a
        rts

; ---------------------------------------------------------------------------

_c182c6:
@82c6:  lda     $ff2a
        beq     @82d1
        jsr     $02f2       ; wait one frame
        jsr     $02f2       ; wait one frame
@82d1:  jsr     $02f2       ; wait one frame
        jsr     $02f2       ; wait one frame
        lda     $bc80
        cmp     $ff29
        beq     @82ea
        lda     $bc80
        clc
        adc     #$10
        sta     $bc80
        bra     @82c6
@82ea:  lda     $ff2a
        beq     @82f5
        jsr     $02f2       ; wait one frame
        jsr     $02f2       ; wait one frame
@82f5:  jsr     $02f2       ; wait one frame
        jsr     $02f2       ; wait one frame
        lda     $bc80
        and     #$f0
        beq     @830d
        lda     $bc80
        sec
        sbc     #$10
        sta     $bc80
        bra     @82ea
@830d:  rts

; ---------------------------------------------------------------------------

; [ misc effect $02: shake screen ]

_c1830e:
        jsr     _c18d47       ; get graphics script parameter 3
        sta     $7e
        clr_a
        jmp     _c17a93

; ---------------------------------------------------------------------------

; [ misc effect $05:  ]

_c18317:
        jsr     _c18d47       ; get graphics script parameter 3
        sta     $7e
        clr_a
        jmp     _c17b43

; ---------------------------------------------------------------------------

; [ misc effect $08:  ]

_c18320:
        jsr     _c18d47       ; get graphics script parameter 3
        sta     $7e
        clr_a
        jmp     _c17b02

; ---------------------------------------------------------------------------

; [ misc effect $06:  ]

_c18329:
        jsr     _c18d47       ; get graphics script parameter 3
        sta     $7e
        clr_a
        jmp     _c17a2a

; ---------------------------------------------------------------------------

; [ misc effect $01: play sound effect ]

_c18332:
        lda     #$88
        sta     $dbb6
        jsr     _c18d47       ; get graphics script parameter 3
        jmp     _c1fbd9       ; play sound effect

; ---------------------------------------------------------------------------

; [ misc effect $00: play song ]

_c1833d:
        jsr     _c18d47       ; get graphics script parameter 3
        sta     $ff04
        rts

; ---------------------------------------------------------------------------

; [  ]

_c18344:
@8344:  jsr     _c18d47       ; get graphics script parameter 3
        eor     #$ff
        sta     $70
        lda     $de
        and     $70
        sta     $70
        rts

; ---------------------------------------------------------------------------

; [  ]

_c18352:
@8352:  lda     $de
        eor     #$ff
        sta     $71
        jsr     _c18d47       ; get graphics script parameter 3
        and     $71
        sta     $70
        rts

; ---------------------------------------------------------------------------

; [  ]

_c18360:
@8360:  lda     #$5a        ; bg1 screen size 32x64
        sta     f:$002107
        rts

; ---------------------------------------------------------------------------

; [  ]

_c18367:
@8367:  lda     #$59        ; bg1 screen size 64x32 (default)
        sta     f:$002107
        rts

; ---------------------------------------------------------------------------

; [  ]

_c1836e:
@836e:  clr_ax
        longa
@8372:  sta     $acb7,x
        inx4
        cpx     #$0280
        bne     @8372
        shorta0
        rts

; ---------------------------------------------------------------------------

_c18382:
@8382:  clr_ax
        longa
        lda     $70
@8388:  sta     $a939,x
        sta     $a9b9,x
        inx4
        cpx     #$0080
        bne     @8388
        shorta0
        rts

; ---------------------------------------------------------------------------

_c1839b:
@839b:  clr_ax
        longa
        lda     $70
@83a1:  sta     $a937,x
        sta     $a9b7,x
        inx4
        cpx     #$0080
        bne     @83a1
        shorta0
        rts

; ---------------------------------------------------------------------------

_c18eb4:
@83b4:  clr_ax
        longa
        lda     $70
@83ba:  sta     $acb7,x
        inx4
        cpx     #$0080
        bne     @83ba
        shorta0
        rts

; ---------------------------------------------------------------------------

_c183ca:
@83ca:  ldx     #$0015
@83cd:  phx
        jsr     $02f2       ; wait one frame
        jsr     $875c
        longa
        lda     $bc79
        sec
        sbc     #$000c
        sta     $bc79
        sta     $70
        shorta0
        jsr     $8382
        plx
        dex
        bne     @83cd
        longa
        lda     $bc79
        sec
        sbc     #$0004
        sta     $bc79
        sta     $70
        shorta0
        jmp     _c18382

; ---------------------------------------------------------------------------

_c18400:
@8400:  ldx     #$0015
@8403:  phx
        jsr     $02f2       ; wait one frame
        jsr     $875c
        longa
        lda     $bc79
        clc
        adc     #$000c
        sta     $bc79
        sta     $70
        shorta0
        jsr     $8382
        plx
        dex
        bne     @8403
        longa
        lda     $bc79
        clc
        adc     #$0004
        sta     $bc79
        sta     $70
        shorta0
        jmp     _c18382

; ---------------------------------------------------------------------------

_c18436:
@8436:  lda     $f6
        bne     _846b
_843a:  ldx     #$0015
@843d:  phx
        jsr     $02f2       ; wait one frame
        jsr     $875c
        longa
        lda     $bc77
        sec
        sbc     #$000c
        sta     $bc77
        shorta0
        plx
        dex
        bne     @843d
        longa
        lda     $bc77
        sec
        sbc     #$0004
        sta     $bc77
        shorta0
        rts

; ---------------------------------------------------------------------------

_c18467:
@8467:  lda     $f6
        bne     _843a
_846b:  ldx     #$0015
@846e:  phx
        jsr     $02f2       ; wait one frame
        jsr     $875c
        longa
        lda     $bc77
        clc
        adc     #$000c
        sta     $bc77
        shorta0
        plx
        dex
        bne     @846e
        longa
        lda     $bc77
        clc
        adc     #$0004
        sta     $bc77
        shorta0
        rts

; ---------------------------------------------------------------------------

_c18498:
@8498:  longa
        lda     $bc77
        eor     #$0100
        sta     $bc77
        shorta0
        rts

; ---------------------------------------------------------------------------

; [ show monster $00: fade in ]

_c184a7:
        jsr     $8344
        clr_a
        jsr     $7602
        jsr     $8352
        clr_a
        jmp     _c175bb

; ---------------------------------------------------------------------------

; [  ]

_c184b5:
@84b5:  jsr     _c18d47       ; get graphics script parameter 3
        sta     $70
        lda     $de
        and     $70
        sta     $de
        rts

; ---------------------------------------------------------------------------

; [ show monster $01: iron claw ]

_c184c1:
        jsr     $8360
        jsr     $8400
        jsr     $84b5
        jsr     $8352
        lda     #$0a
        jsr     $75bb
        jsr     $83ca
        jmp     _c18367

; ---------------------------------------------------------------------------

; [ show monster $0b: merugene 3 ]

_c184d8:
        jsr     $8360
        lda     $bc84
        ora     #$01
        sta     $bc84
        jsr     $8400
        jsr     $84b5
        jsr     $8352
        lda     #$0a
        jsr     $75bb
        jsr     $8400
        jsr     $8367
        lda     $bc84
        and     #$fe
        sta     $bc84
        rts

; ---------------------------------------------------------------------------

; [ show monster $0c: merugene 4 ]

_c18500:
        jsr     $8360
        lda     $bc84
        ora     #$01
        sta     $bc84
        jsr     $83ca
        jsr     $84b5
        jsr     $8352
        lda     #$0a
        jsr     $75bb
        jsr     $83ca
        jsr     $8367
        lda     $bc84
        and     #$fe
        sta     $bc84
        rts

; ---------------------------------------------------------------------------

; [ show monster $02: discreet ??? ]

_c18528:
        jsr     $84b5
        jsr     $8352
        lda     #$0a
        jmp     _c175bb

; ---------------------------------------------------------------------------

; [ show monster $03: motor trap ]

_c18533:
        jsr     $8344
        clr_a
        jsr     $7602
        jsr     $8360
        jsr     $8400
        jsr     $8352
        lda     #$0a
        jsr     $75bb
        jsr     $83ca
        jmp     _c18367

; ---------------------------------------------------------------------------

; [ show monster $06: fade and drop ]

_c1854e:
        jsr     $8344
        lda     #$02
        jsr     $7602
        jsr     $8360
        jsr     $8400
        jsr     $8352
        lda     #$0a
        jsr     $75bb
        jsr     $83ca
        jmp     _c18367

; ---------------------------------------------------------------------------

; [ show monster $09: merugene 1 ]

_c1856a:
        jsr     $8367
        jsr     $8467
        jsr     $84b5
        jsr     $8352
        lda     #$0a
        jsr     $75bb
        jmp     _c18467

; ---------------------------------------------------------------------------

; [ show monster $0a: merugene 2 ]

_c1857e:
        jsr     $8367
        jsr     $8436
        jsr     $84b5
        jsr     $8352
        lda     #$0a
        jsr     $75bb
        jmp     _c18436

; ---------------------------------------------------------------------------

; [ show monster $04: switch ??? ]

_c18592:
        jsr     $8367
        jsr     $8467
        jsr     $84b5
        jsr     $8352
        lda     #$0a
        jsr     $75bb
        jmp     _c18436

; ---------------------------------------------------------------------------

_c185a6:
@85a6:  lda     $bc84
        and     #$fe
        sta     $bc84
        rts

; ---------------------------------------------------------------------------

_c185af:
@85af:  lda     $bc84
        ora     #$01
        sta     $bc84
        rts

; ---------------------------------------------------------------------------

; [ show monster $05: transform ]

_c185b8:
        jsr     $84b5
        jsr     $7539
        jsr     $7529
        jsr     $8352
        lda     $70
        ora     $de
        sta     $de
        jsr     $1c8a
        clr_ax
@85cf:  phx
        lda     f:_c18606,x
        phx
        jsr     $8141       ; wait
        jsr     $8498
        plx
        lda     f:_c18606+1,x
        jsr     $8141       ; wait
        jsr     $8498
        plx
        inx2
        cpx     #$0020
        bne     @85cf
        jsr     $8498
        jsr     $84b5
        jsr     $8352
        lda     $70
        ora     $de
        sta     $de
        jsr     $1cb8
        jsr     $8498
        jmp     _c11c84

; ---------------------------------------------------------------------------

_c18606:
        .byte   8,1
        .byte   8,1
        .byte   5,1
        .byte   5,1
        .byte   3,1
        .byte   3,1
        .byte   1,1
        .byte   1,1
        .byte   1,1
        .byte   1,1
        .byte   1,3
        .byte   1,3
        .byte   1,5
        .byte   1,5
        .byte   1,8
        .byte   1,8

; ---------------------------------------------------------------------------

; [ show monster $07: pages ]

_c18626:
@8626:  jsr     $02f2       ; wait one frame
        jsr     $1cb8
        stz     $70
        clr_ax
@8630:  lda     $d006,x
        beq     @863f
        cmp     $d026,x
        beq     @863f
        inc     $d026,x
        bra     @8641
@863f:  inc     $70
@8641:  inx
        cpx     #$0008
        bne     @8630
        lda     $70
        cmp     #$08
        bne     @8626
        jsr     $84b5
        jsr     $7539
        jsr     $7529
        jsr     $8352
        lda     $70
        ora     $de
        sta     $de
        clr_ax
@8661:  lda     $d006,x
        sta     $d026,x
        inx
        cpx     #$0008
        bne     @8661
@866d:  jsr     $02f2
        jsr     $1cb8
        stz     $70
        clr_ax
@8677:  lda     $d006,x
        beq     @8686
        lda     $d026,x
        beq     @8686
        dec     $d026,x
        bra     @8688
@8686:  inc     $70
@8688:  inx
        cpx     #$0008
        bne     @8677
        lda     $70
        cmp     #$08
        bne     @866d
        rts

; ---------------------------------------------------------------------------

; [  ]

_c18695:
@8695:  lda     #$88
        sta     $dbb6
        lda     #$8f
        jmp     _c1fbd9       ; play sound effect

; ---------------------------------------------------------------------------

; [ show monster $08: sandworm ]

_c1869f:
        lda     $de
        and     #$1f
        beq     @86a8
        jsr     $8695
@86a8:  jsr     $02f2       ; wait one frame
        jsr     $1cb8
        stz     $70
        clr_ax
@86b2:  lda     #$01
        sta     $d02e,x
        lda     $d006,x
        beq     @86c6
        cmp     $d026,x
        beq     @86c6
        inc     $d026,x
        bra     @86cb
@86c6:  stz     $d02e,x
        inc     $70
@86cb:  inx
        cpx     #$0008
        bne     @86b2
        lda     $70
        cmp     #$08
        bne     @86a8
        jsr     $84b5
        jsr     $7539
        jsr     $7529
        jsr     $8352
        lda     $70
        ora     $de
        sta     $de
        clr_ax
@86eb:  lda     $d006,x
        sta     $d026,x
        inx
        cpx     #$0008
        bne     @86eb
        jsr     $8695
@86fa:  jsr     $02f2
        jsr     $1cb8
        stz     $70
        clr_ax
@8704:  lda     #$01
        sta     $d02e,x
        lda     $d006,x
        beq     @871c
        lda     $d026,x
        beq     @871c
        cmp     #$01
        beq     @871c
        dec     $d026,x
        bra     @8724
@871c:  stz     $d02e,x
        stz     $d026,x
        inc     $70
@8724:  inx
        cpx     #$0008
        bne     @8704
        lda     $70
        cmp     #$08
        bne     @86fa
        jsr     $02f2       ; wait one frame
        jmp     _c11cb8

; ---------------------------------------------------------------------------

; [ do monster entry ]

_c18736:
        lda     $3eef       ; monster entry
        and     #$07
        asl
        tax
        lda     f:_c1874c,x
        sta     $70
        lda     f:_c1874c+1,x
        sta     $71
        jmp     ($0070)

; ---------------------------------------------------------------------------

; monster entry jump table
_c1874c:
        .addr   $8962,$897c,$87e3,$890c,$8826,$8926,$8962,$8962

; ---------------------------------------------------------------------------

; [  ]

_c1875c:
@875c:  jsr     $875f
@875f:  lda     $dbbc
        beq     @879c
        lda     $dbbd
        beq     @8799
        tay
        lda     $dbbe
        tax
        lda     #$0f
        sta     $70
        sta     $72
@8774:  lda     $70
        sta     $b455,y
        sta     $b456,y
        sta     $b453,x
        sta     $b454,x
        inx2
        dey2
        bmi     @878c
        dec     $70
        bne     @8774
@878c:  dec     $dbbd
        dec     $dbbd
        inc     $dbbe
        inc     $dbbe
        rts
@8799:  stz     $dbbc
@879c:  rts

; ---------------------------------------------------------------------------

; [  ]

_c1879d:
@879d:  lda     $dbbd
        cmp     #$3f
        beq     @87ce
        tay
        lda     $dbbe
        tax
        lda     #$e0
        sta     $70
@87ad:  cpy     #$0071
        bcc     @87b4
        bra     @87bc
@87b4:  lda     $70
        sta     $b455,y
        sta     $b455,x
@87bc:  inx
        dey
        bmi     @87c8
        inc     $70
        lda     $70
        cmp     #$ff
        bne     @87ad
@87c8:  dec     $dbbd
        inc     $dbbe
@87ce:  rts

; ---------------------------------------------------------------------------

; [  ]

_c187cf:
@87cf:  lda     $dbbc
        beq     @87dd
        jsr     $02f2       ; wait one frame
        jsr     $875c
        jmp     @87cf
@87dd:  lda     #$01
        sta     $f9a1
        rts

; ---------------------------------------------------------------------------

; [ monster entry $02:  ]

_c187e3:
        clr_ax
        stx     $bc79
@87e8:  lda     $d006,x
        sta     $d026,x
        inx
        cpx     #$0008
        bne     @87e8
@87f4:  jsr     $1c8a
        jsr     $875c
        stz     $70
        clr_ax
@87fe:  lda     $d006,x
        beq     @880d
        lda     $d026,x
        beq     @880d
        dec     $d026,x
        bra     @880f
@880d:  inc     $70
@880f:  inx
        cpx     #$0008
        bne     @87fe
        lda     $70
        cmp     #$08
        bne     @87f4
        jsr     $87cf
        clr_ax
        stx     $bc77
        jmp     _c11c84

; ---------------------------------------------------------------------------

; [ monster entry $04:  ]

_c18826:
        lda     #$8e
        sta     $dbbd
        lda     #$52
        sta     $dbbe
        jsr     $8836
        jmp     _c10491

; ---------------------------------------------------------------------------

; [  ]

_c18836:
@8836:  clr_ax
        stx     $dbd9
@883b:  jsr     $02f2       ; wait one frame
        jsr     $879d
        jsr     $88a8
        ldx     $dbd9
        inx2
        stx     $dbd9
        cpx     #$00a0
        bne     @883b
        longa
        clr_ax
@8855:  sta     $a00b,x
        sta     $a40b,x
        inx4
        cpx     #$0380
        bne     @8855
        shorta0
        inc     $dbd4
        rts

; ---------------------------------------------------------------------------

; [  ]

_c1886b:
        longa
        clr_ay
        lda     #$00ff
@8872:  sta     $b037,y     ; clear bg3 scroll hdma data
        dec
        iny2
        cpy     #$01c0
        bne     @8872
        clr_ax
        lda     #$00ff
@8882:  stz     $a00b,x
        stz     $a40b,x
        stz     $a009,x
        stz     $a409,x
        stz     $a937,x
        sta     $a939,x
        stz     $acb7,x
        sta     $acb9,x
        dec
        inx4
        cpx     #$0380
        bne     @8882
        shorta0
        rts

; ---------------------------------------------------------------------------

; [  ]

_c188a8:
@88a8:  longa
        lda     #$00a0
        sec
        sbc     $dbd9
        lsr
        asl
        clc
        adc     #$0040
        tay
        lda     $dbd9
        inc
        sta     $70
        clr_ax
        lda     #$0050
        sta     $74
@88c5:  lda     $74
        clc
        adc     $70
        sta     $74
        cmp     #$00a0
        bcc     @88e8
        sec
        sbc     #$00a0
        sta     $74
        txa
        clc
        adc     #$0020
        sta     $76
        tya
        lsr
        sec
        sbc     $76
        sta     $b037,y
        iny2
@88e8:  inx
        cpx     #$00a0
        bne     @88c5
        clr_axy
@88f1:  lda     $b037,y
        sta     $a00b,x
        sta     $a40b,x
        inx4
        iny2
        cpx     #$0380
        bne     @88f1
        shorta0
        inc     $dbd4
        rts

; ---------------------------------------------------------------------------

; [ monster entry $03:  ]

_c1890c:
        lda     $de
        pha
        stz     $de
        jsr     $1cb8
        clr_ax
        stx     $bc77
        stx     $bc79
        jsr     $87cf
        pla
        sta     $70
        clr_a
        jmp     _c175bb

; ---------------------------------------------------------------------------

; [ monster entry $05:  ]

_c18926:
        ldx     #$0080
        stx     $bc77
        clr_ax
        stx     $bc79
        lda     #$0f
        sta     $b3b7
        jsr     $1cb8
@8939:  jsr     $02f2       ; wait one frame
        jsr     $87cf
        jsr     $1ceb
        jsr     $1d65
        lda     $bc77
        sec
        sbc     #$08
        sta     $bc77
        inc     $db42
        dec     $b3b7
        bpl     @8939
        stz     $bc77
        stz     $b3b7
        jsr     $1cb8
        jmp     _c187cf

; ---------------------------------------------------------------------------

; [ monster entry $00: enter from side ]

_c18962:
        lda     $f6
        beq     @896b
        ldx     #$ff00
        bra     @896e
@896b:  ldx     #$0100
@896e:  stx     $bc77
        clr_ax
        stx     $bc79
        jsr     $8436
        jmp     _c187cf

; ---------------------------------------------------------------------------

; [ monster entry $01: enter from top ]

_c1897c:
        jsr     $8360
        ldx     #$0100
        stx     $bc79
        clr_ax
        stx     $bc77
        jsr     $83ca
        jsr     $8367
        jmp     _c187cf

; ---------------------------------------------------------------------------

; show monster jump table
;   0: fade
;   1: iron claw
;   2: discreet
;   3: motor trap
;   4: switch ???
;   5: transform
;   6: fade and drop
;   7: pages
;   8: sandworm
;   9: merugene 1
;   a: merugene 2
;   b: merugene 3
;   c: merugene 4
;   d: neo-exdeath
_c18993:
        .addr   $84a7,$84c1,$8528,$8533,$8592,$85b8,$854e,$8626
        .addr   $869f,$856a,$857e,$84d8,$8500,$89d0

; ---------------------------------------------------------------------------

_c189af:
@89af:  lda     #$e0
        sta     $bc8a
@89b4:  jsr     $02f2       ; wait one frame
        inc     $bc8a
        lda     $bc8a
        cmp     #$ff
        bne     @89b4
        rts

; ---------------------------------------------------------------------------

_c189c2:
@89c2:  jsr     $02f2       ; wait one frame
        dec     $bc8a
        lda     $bc8a
        cmp     #$e0
        bne     @89c2
        rts

; ---------------------------------------------------------------------------

; [ show monster $0d: neo-exdeath ]

_c189d0:
        stz     $ee56
        lda     #$20
        jsr     $72db
        lda     #$40
        jsr     $72db
        lda     #$00
        jsr     $72db
        clr_ax
@89e4:  phx
        jsr     $02f2       ; wait one frame
        jsr     $fc96       ; generate random number
        and     #$3f
        bne     @89f2
        jsr     $72db
@89f2:  jsr     $fc96       ; generate random number
        and     #$03
        tax
        stx     $bc77
        stx     $70
        jsr     $83b4
        plx
        inx
        cpx     #$0180
        bne     @89e4
        jsr     $85af
        clr_ax
        stx     $dbe5
        stx     $dbe7
        stz     $dbea
        lda     #$fe
        sta     $04f2
@8a1a:  jsr     $02f2       ; wait one frame
        inc     $dbea
        lda     $dbea
        and     #$1f
        bne     @8a2d
        inc     $dbe7
        inc     $dbe5
@8a2d:  lda     $dbe5
        cmp     #$08
        bne     @8a1a
        lda     #$38
        jsr     $8141       ; wait
        stz     $ee56
@8a3c:  jsr     $02f2       ; wait one frame
        jsr     $02f2       ; wait one frame
        jsr     $cb78
        lda     $ee56
        cmp     #$20
        bne     @8a3c
        inc     $ff2e
        stz     $ee56
        lda     #$02
        sta     $bc85
        jsr     $89af
        lda     #$1e
        sta     f:$00212c
        lda     #$1c
        sta     $04f2
        jsr     $02f2       ; wait one frame
        ldx     #$00f0
        stx     $bc77
        jsr     $85a6
        inc     $dbe4
        lda     #$f0
        jsr     $8141       ; wait
        lda     #$f0
        jsr     $8141       ; wait
        lda     #$09
        sta     $ff04
        lda     #$1f
        jsr     $335d
        jsr     $02f2       ; wait one frame
        jsr     $836e
        jsr     $0401
        inc     $dbe9
        lda     #$02
        sta     $b3bb
        inc     $b3b8
        lda     #$1f
        sta     $04f2
        jsr     $02f2       ; wait one frame
        ldx     #$00f0
        stx     $dbe5
        stx     $bc77
        clr_ax
        stx     $dbe7
        stx     $bc79
        stz     $dbe9
        jsr     $8ca8       ; show neo-exdeath intro dialogue
        jsr     $89c2
        stz     $bc85
        jsr     $84b5
        jsr     $8352
        lda     #$0a
        jsr     $75bb
        ldx     #$00f0
@8acf:  phx
        jsr     $02f2       ; wait one frame
        jsr     $02f2       ; wait one frame
        jsr     $02f2       ; wait one frame
        plx
        cpx     #$0080
        bne     @8ae2
        jsr     $78f5       ; flash screen
@8ae2:  cpx     #$0040
        bne     @8aea
        jsr     $78f5       ; flash screen
@8aea:  stx     $dbe5
        dex
        bne     @8acf
        lda     #$07
        sta     $dbec
        inc     $dbeb
        stz     $dbea
        lda     #$02
        sta     $dbe9
        jsr     $78f5       ; flash screen
        jsr     $9d46
        lda     #$03
        sta     $dbec
        jsr     $9d46
        lda     #$01
        sta     $dbec
        jsr     $9d46
        stz     $dbeb
        jsr     $02f2       ; wait one frame
        clr_ax
        stx     $70
        jsr     $8382
        clr_ax
        stx     $70
        jmp     _c1839b

; ---------------------------------------------------------------------------

; [  ]

_c18b2a:
@8b2a:  lda     $de
        sta     $70
        clr_ax
@8b30:  asl     $70
        bcs     @8b3c
        lda     $7b9e,x
        and     #$cf
        sta     $7b9e,x
@8b3c:  inx4
        cpx     #$0020
        bne     @8b30
        rts

; ---------------------------------------------------------------------------

; [ graphics script command $f2: show monster ]

_c18b46:
        inc     $d110
        jsr     $8d4d       ; get graphics script parameter 2
        and     #$3f
        asl
        tax
        lda     f:_c18993,x
        sta     $70
        lda     f:_c18993+1,x
        sta     $71
        jsr     @8b66
        jsr     _c18b2a
        stz     $d110
        rts
@8b66:  jmp     ($0070)

; ---------------------------------------------------------------------------

; [ graphics script command $fc: execute graphics commands ]

_c18b69:
        jsr     $8d4d       ; get graphics script parameter 2
        asl
        tax
        lda     f:_c18b7d,x
        sta     $70
        lda     f:_c18b7d+1,x
        sta     $71
        jmp     ($0070)

; ---------------------------------------------------------------------------

; graphics command jump table
;   0: attack animation
;   1: ability/command animation
;   2: special ability animation (animals/conjure/combine/terrain)
;   3: monster special attack animation ???
;   4: show attack name
;   5: display battle messages
;   6: show damage numerals
;   7:
;   8: no effect
;   9: show item name ???
;   10: item ???

_c18b7d:
        .addr   $b677,$8d5f,$8cf1,$8cf1,$8be4,$8c37,$01fe,$b68c
        .addr   $8ba9,$8baa,$8b93

; ---------------------------------------------------------------------------

_c18b93:
        jsr     $9d93       ; wait for damage numerals
        lda     #$0b
        jsr     $9d80       ; get pointer to character graphics properties
        sta     $cf58,y
        jsr     $b68c
        clr_a
        jsr     $9d80       ; get pointer to character graphics properties
        sta     $cf58,y
        rts

; ---------------------------------------------------------------------------

_c18ba9:
        rts

; ---------------------------------------------------------------------------

_c18baa:
        jsr     $9d93       ; wait for damage numerals
        lda     #$0b
        jsr     $9d80       ; get pointer to character graphics properties
        sta     $cf58,y
        jsr     _c18d47       ; get graphics script parameter 3
        sec
        sbc     #$e0
        longa
        clc
        adc     #$018a
        tax
        shorta0
        jsr     $b69c
        clr_a
        jsr     $9d80       ; get pointer to character graphics properties
        sta     $cf58,y
        rts

; ---------------------------------------------------------------------------

; string table data
_c18bd0:
        .byte   $0f,$00,$05,$01 ; attack name
        .byte   $18,$00,$05,$00 ; ability/command name
        .byte   $19,$00,$09,$00 ; special ability name (animals/conjure/combine/terrain)
        .byte   $1a,$00,$09,$00 ; monster special attack name
        .byte   $0e,$00,$09,$00 ; item name

; ---------------------------------------------------------------------------

; [ show attack name ]

_c18be4:
        jsr     $9d93       ; wait for damage numerals
        jsr     _c18d47       ; get graphics script parameter 3 (string table)
        asl2
        tax
        jsr     $8d53       ; get graphics script parameter 4 (string id)
        sta     $70
        lda     f:_c18bd0+2,x
        sta     $bca3       ; string length (5 or 9)
        lda     f:_c18bd0+3,x
        beq     @8c0c
        lda     $70
        cmp     #$57
        bcc     @8c0c
        lda     #$09
        sta     $bca3
        bra     @8c15
@8c0c:  cmp     #$48
        bcc     @8c15
        lda     #$06
        sta     $bca3
@8c15:  lda     f:_c18bd0,x   ; escape code
        sta     $dbf6
        lda     f:_c18bd0+1,x   ; string table offset (always zero)
        clc
        adc     $70
        sta     $dbf7       ; string id
        stz     $dbf8       ; null-terminator
        ldx     #$dbf6
        stx     $bca0
        lda     #$7e        ; source address = $7edbf6
        sta     $bca2
        jmp     _c13b1f       ;

; ---------------------------------------------------------------------------

; [ animation command $05: display queued battle messages ]

_c18c37:
        clr_ay
@8c39:  lda     ($f2),y     ; battle message queue
        beq     @8c4d
        cmp     #$ff
        beq     @8c53       ; branch if end of queue
        longa
        asl
        tax
        shorta0
        phy
        jsr     $8c6d       ; display battle message
        ply
@8c4d:  iny
        cpy     #$0018
        bne     @8c39
@8c53:  longa
        lda     a:$00f2       ; increment message queue pointer
        clc
        adc     #$0018
        sta     a:$00f2
        lda     a:$00f4       ; increment variable queue pointer
        clc
        adc     #$000c
        sta     a:$00f4
        shorta0
        rts

; ---------------------------------------------------------------------------

; [ display battle message ]

_c18c6d:
@8c6d:  lda     $d139a9,x   ; pointers to battle messages
        sta     $bca0
        lda     $d139aa,x
        sta     $bca1
.if LANG_EN
        lda     #$e7
.else
        lda     #$d1
.endif
        sta     $bca2
        jsr     $3c88       ; draw battle message
        jsr     _c18d47       ; get graphics script parameter 3
        beq     @8c8d
        jsr     $fc8c       ; wait for keypress
        bra     @8c90
@8c8d:  jsr     $8c93       ; wait for message
@8c90:  jmp     _c13cbb

; ---------------------------------------------------------------------------

; [ wait for message ]

_c18c93:
@8c93:  lda     $0424       ; message speed
@8c96:  and     #$07
        tax
        lda     f:_c18ca0,x
        jmp     _c18141       ; wait

; ---------------------------------------------------------------------------

; number of frames to wait for each message speed
_c18ca0:
        .byte   $20,$40,$60,$80,$a0,$c0,$e0,$00

; ---------------------------------------------------------------------------

; [ show neo-exdeath intro dialogue ]

; i am neo-exdeath!
; i shall erase all memory...
; all existence...all dimensions...
; and then i too shall disappear...
; for eternity!!!

; わたしは　ネオエクスデス
; すべての記憶　すべてのそんざい (存在)
; すべての次元を消し
; そして　わたしも消えよう
; 永遠に！！

_c18ca8:
@8ca8:  lda     #$cb
@8caa:  pha
        jsr     $8cd4       ; display battle dialogue
        lda     #$04
        jsr     $8c96
        jsr     $3cbb       ;
        pla
        inc
        cmp     #$d0
        bne     @8caa
        rts

; ---------------------------------------------------------------------------

; [ graphics script command $f6: show battle dialogue ]

_c18cbd:
        jsr     _c18d47       ; get graphics script parameter 3
        jsr     $8cd4       ; display battle dialogue
        jsr     $8d4d       ; get graphics script parameter 2
        jsr     $8c96
        jsr     $8d4d       ; get graphics script parameter 2
        bpl     @8cd1
        jsr     $fc8c       ; wait for keypress
@8cd1:  jmp     _c13cbb

; ---------------------------------------------------------------------------

; [ display battle dialogue ]

_c18cd4:
@8cd4:  longa
        asl
        tax
        shorta0
        lda     $d0f000,x   ; pointers to battle dialogue
        sta     $bca0
        lda     $d0f001,x
        sta     $bca1
.if LANG_EN
        lda     #$e7
.else
        lda     #$d0
.endif
        sta     $bca2
        jmp     _c13c88       ; draw battle message/dialogue

; ---------------------------------------------------------------------------

; [  ]

_c18cf1:
@8cf1:  jsr     $9d93       ; wait for damage numerals
        lda     #$0b
        jsr     $9d80       ; get pointer to character graphics properties
        sta     $cf58,y
        jsr     _c18d47       ; get graphics script parameter 3
        longa
        clc
        adc     #$011e
        tax
        shorta0
        jsr     $b69c
        clr_a
        jsr     $9d80       ; get pointer to character graphics properties
        sta     $cf58,y
        rts

; ---------------------------------------------------------------------------

; [ show character in ready stance ]

_c18d14:
        phy
        jsr     _c18d2f       ; get attacker id
        and     #$03
        tay
        lda     #$01
        sta     $d1cb,y
        ply
        rts

; ---------------------------------------------------------------------------

; [ show character in normal stance ]

_c18d22:
        phy
        jsr     _c18d2f       ; get attacker id
        and     #$03
        tay
        clr_a
        sta     $d1cb,y
        ply
        rts

; ---------------------------------------------------------------------------

; [ get attacker id ]

_c18d2f:
@8d2f:  ldy     #$0001      ; attacker id
        lda     ($eb),y
        rts

; ---------------------------------------------------------------------------

; [ get target id ]

_c18d35:
        ldy     #$0002      ; target id
        lda     ($eb),y
        rts

; ---------------------------------------------------------------------------

_c18d3b:
        ldy     #$0003      ;
        lda     ($eb),y
        rts

; ---------------------------------------------------------------------------

_c18d41:
        ldy     #$0004
        lda     ($eb),y
        rts

; ---------------------------------------------------------------------------

; [ get graphics script parameter 3 ]

_c18d47:
@8d47:  ldy     #$0003
        lda     ($e7),y
        rts

; ---------------------------------------------------------------------------

; [ get graphics script parameter 2 ]

_c18d4d:
@8d4d:  ldy     #$0002
        lda     ($e7),y
        rts

; ---------------------------------------------------------------------------

; [ get graphics script parameter 4 ]

_c18d53:
@8d53:  ldy     #$0004
        lda     ($e7),y
        rts

; ---------------------------------------------------------------------------

; [ get graphics script parameter 1 ]

_c18d59:
@8d59:  ldy     #$0001
        lda     ($e7),y
        rts

; ---------------------------------------------------------------------------

; [ ability animation ]

_c18d5f:
        jsr     _c18d47       ; get graphics script parameter 3
        asl
        tax
        lda     f:_c18d88,x
        sta     $70
        lda     f:_c18d88+1,x
        sta     $71
        jmp     ($0070)

; ---------------------------------------------------------------------------

_c18d73:
        rts

; ---------------------------------------------------------------------------

; [  ]

_c18d74:
        phy
        phx
        jsr     _c18d47       ; get graphics script parameter 3
        tax
        lda     $d0dbe3,x
        cmp     #$ff
        beq     @8d85
        jsr     $fbe4       ; play animation sound effect
@8d85:  plx
        ply
        rts

; ---------------------------------------------------------------------------

; ability animation pointers
_c18d88:
        .addr   $8d73,$98d3,$9e4d,$9986,$9f44,$9815,$9c7c,$998b ; $00
        .addr   $9966,$8d73,$9951,$9951,$9b74,$98df,$992d,$9977
        .addr   $9ef6,$8d73,$98c1,$9be3,$8d73,$8d73,$8d73,$8d73 ; $10
        .addr   $8d73,$8d73,$98f7,$8d73,$98a9,$8d73,$8d73,$8d73
        .addr   $9909,$991b,$8d73,$8d73,$972e,$974a,$8d73,$9897 ; $20
        .addr   $987d,$981d,$8d73,$8d73,$8d73,$99e0,$99ad,$8d73
        .addr   $8e14,$8e20,$8e29,$8e32,$8e3b,$8e44,$8e4a,$8e53 ; $30
        .addr   $8e62,$8e72,$8e82,$8e92,$8ea2,$8eb2,$8ec2,$8ed2
        .addr   $8eea,$8f01,$8f11,$8f21,$8f2a,$8f33             ; $40

; ---------------------------------------------------------------------------

; [ ability animation $30: knight (credits) ]

_c18e14:
        jsr     $80b8
        jsr     $9f44

_c18e1a:
        jsr     $8062       ; move character back after attack
        jmp     _c1906f

; ---------------------------------------------------------------------------

; [ ability animation $31: monk (credits) ]

_c18e20:
        jsr     $80b8
        jsr     $9f44
        jmp     _c18e1a

; ---------------------------------------------------------------------------

; [ ability animation $32: thief (credits) ]

_c18e29:
        jsr     $80b8
        jsr     $9951
        jmp     _c18e1a

; ---------------------------------------------------------------------------

; [ ability animation $33: dragoon (credits) ]

_c18e32:
        jsr     $9b74
        jsr     $99e0
        jmp     _c1906f

; ---------------------------------------------------------------------------

; [ ability animation $34: ninja (credits) ]

_c18e3b:
        jsr     $80b8
        jsr     $9ef6
        jmp     _c18e1a

; ---------------------------------------------------------------------------

; [ ability animation $35: samurai (credits) ]

_c18e44:
        jsr     $9be3
        jmp     _c1906f

; ---------------------------------------------------------------------------

; [ ability animation $36: berserker (credits) ]

_c18e4a:
        jsr     $80b8
        jsr     $9f44
        jmp     _c18e1a

; ---------------------------------------------------------------------------

; [ ability animation $37: hunter (credits) ]

_c18e53:
        jsr     $80b8
        ldy     #$0003
        clr_a
        sta     ($e7),y
        jsr     $8cf1
        jmp     _c18e1a

; ---------------------------------------------------------------------------

; [ ability animation $38: mystic knight (credits) ]

_c18e62:
        jsr     $80b8
        ldy     #$0004
        lda     #$01
        sta     ($e7),y
        jsr     $9f44
        jmp     _c18e1a

; ---------------------------------------------------------------------------

; [ ability animation $39: white mage (credits) ]

_c18e72:
        jsr     $80b8       ; move character forward to attack
        ldy     #$0003
        lda     #$1e        ; spell animation $1e
        sta     ($e7),y
        jsr     $b677
        jmp     _c18e1a

; ---------------------------------------------------------------------------

; [ ability animation $3a: black mage (credits) ]

_c18e82:
        jsr     $80b8
        ldy     #$0003
        lda     #$2b
        sta     ($e7),y
        jsr     $b677
        jmp     _c18e1a

; ---------------------------------------------------------------------------

; [ ability animation $3b: time mage (credits) ]

_c18e92:
        jsr     $80b8
        ldy     #$0003
        lda     #$42
        sta     ($e7),y
        jsr     $b677
        jmp     _c18e1a

; ---------------------------------------------------------------------------

; [ ability animation $3c: summoner (credits) ]

_c18ea2:
        jsr     $80b8
        ldy     #$0003
        lda     #$69
        sta     ($e7),y
        jsr     $b677
        jmp     _c18e1a

; ---------------------------------------------------------------------------

; [ ability animation $3d: blue mage (credits) ]

_c18eb2:
        jsr     $80b8
        ldy     #$0003
        lda     #$9f
        sta     ($e7),y
        jsr     $b677
        jmp     _c18e1a

; ---------------------------------------------------------------------------

; [ ability animation $3e: red mage (credits) ]

_c18ec2:
        jsr     $80b8
        ldy     #$0003
        lda     #$30
        sta     ($e7),y
        jsr     $b677
        jmp     _c18e1a

; ---------------------------------------------------------------------------

; [ ability animation $3f: mediator (credits) ]

_c18ed2:
        jsr     $80b8
        lda     #$c9
        sta     $7c4b
        ldy     #$0003
        lda     #$e1
        sta     ($e7),y
        jsr     $b677
        stz     $7c4b
        jmp     _c18e1a

; ---------------------------------------------------------------------------

; [ ability animation $40: chemist (credits) ]

_c18eea:
        jsr     $80b8
        stz     $3bcc
        ldx     #$012a
        jsr     $b58b
        lda     #$01
        jsr     $96ec
        jsr     $9d3c
        jmp     _c18e1a

; ---------------------------------------------------------------------------

; [ ability animation $41: geomancer (credits) ]

_c18f01:
        jsr     $80b8
        ldy     #$0003
        lda     #$51
        sta     ($e7),y
        jsr     $8cf1
        jmp     _c18e1a

; ---------------------------------------------------------------------------

; [ ability animation $42: bard (credits) ]

_c18f11:
        jsr     $80b8
        ldy     #$0003
        lda     #$57
        sta     ($e7),y
        jsr     $b677
        jmp     _c18e1a

; ---------------------------------------------------------------------------

; [ ability animation $43: dancer (credits) ]

_c18f21:
        jsr     $80b8
        jsr     $981d
        jmp     _c18e1a

; ---------------------------------------------------------------------------

; [ ability animation $44: mimic (credits) ]

_c18f2a:
        jsr     $80b8
        jsr     $98df
        jmp     _c18e1a

; ---------------------------------------------------------------------------

; [ ability animation $45: freelancer (credits) ]

_c18f33:
        jsr     $80b8
        jsr     $9f44
        jmp     _c18e1a

; ---------------------------------------------------------------------------

; [  ]

_c18f3c:
        lda     $f9ed
        and     #$7f
        bne     @8f44
        rts
@8f44:  sta     $70
        stz     $71
        lda     $f9ee
        sta     $76
        lda     $f9ef
        tax
        stx     $78
        longa
        clr_axy
        lda     $70
        pha
        sta     $72
        asl     $70
        lda     #$0003
        sec
        sbc     $70
        sta     $74
@8f67:  lda     $72
        sta     $fdf0,y
        lda     $74
        bmi     @8f83
        txa
        sec
        sbc     $72
        asl2
        clc
        adc     #$000a
        clc
        adc     $74
        sta     $74
        dec     $72
        bra     @8f8f
@8f83:  txa
        asl2
        clc
        adc     #$0006
        clc
        adc     $74
        sta     $74
@8f8f:  inx
        iny2
        cpx     $72
        bcc     @8f67
        tyx
        dex2
@8f99:  lda     $fdf0,x
        cmp     $fdee,x
        beq     @8fa8
        txa
        lsr
        sta     $fdf0,y
        iny2
@8fa8:  dex2
        bne     @8f99
        pla
        asl
        eor     #$ffff
        inc
        clc
        adc     #$0102
        sta     $70
        tax
        beq     @8fca
        clr_ax
        lda     #$00ff
@8fc0:  sta     $7efbf0,x
        inx2
        cpx     $70
        bne     @8fc0
@8fca:  shorta0
        dey2
@8fcf:  lda     $fdf0,y
        clc
        adc     $76
        bcs     @8fdb
        cmp     #$f7
        bcc     @8fdd
@8fdb:  lda     #$f7
@8fdd:  sta     $7efbf1,x
        lda     $76
        sec
        sbc     $fdf0,y
        bcc     @8fed
        cmp     #$08
        bcs     @8fef
@8fed:  lda     #$08
@8fef:  sta     $7efbf0,x
        inx2
        dey2
        bpl     @8fcf
        phb
        lda     #$7e
        pha
        plb
        txy
        dex2
        ldx     #$00fe
        ldy     #$0100
        longa
@9009:  lda     $fbf0,x
        sta     $fbf0,y
        iny2
        dex2
        bpl     @9009
        clr_ay
        asl     $78
        lda     $78
        cmp     #$0100
        bcc     @9044
        sec
        sbc     $78
        sta     $70
        lda     #$00ff
@9028:  sta     $f9f0,y
        iny2
        cpy     $70
        bne     @9028
        clr_ax
@9033:  lda     $fbf0,x
        sta     $f9f0,y
        inx2
        iny2
        cpy     #$0200
        bne     @9033
        bra     @906a
@9044:  lda     #$0100
        sec
        sbc     $78
        tax
@904b:  lda     $fbf0,x
        sta     $f9f0,y
        inx2
        iny2
        cpx     #$0200
        bne     @904b
        lda     #$00ff
@905d:  cpy     #$0200
        beq     @906a
        sta     $f9f0,y
        iny2
        jmp     @905d
@906a:  shorta0
        plb
        rts

; ---------------------------------------------------------------------------

; [ show character stats (credits) ]

_c1906f:
        lda     #$bf
        sta     $bc86
        lda     #$7e
        sta     $f9ed
        lda     #$80
        sta     $f9ee
        lda     $d04b
        sta     $f9ef
        jsr     $8f3c
        jsr     $fd1d       ; wait for vblank
        lda     #$02
        sta     $f9a1
@908f:  jsr     $fd1d       ; wait for vblank
        jsr     $8f3c
        lda     $f9ee
        cmp     $d03f
        beq     @90a3
        inc     $f9ee
        inc     $f9ee
@90a3:  dec     $f9ed
        lda     $f9ed
        cmp     #$18
        bne     @908f
        jsr     $36eb       ; decompress battle bg graphics
        ldx     #$1000
        stx     $70
        ldx     $72
        ldy     #$7800
        lda     $74
        jsr     $fd27
        jsr     $fc64
        clr_ax
@90c4:  lda     $7e29,x
        sta     $7f29,x
        inx
        cpx     #$0040
        bne     @90c4
        jsr     $9481
        lda     #$02
        sta     $dbf5
        jsr     $24e2       ; load character graphics
        jsr     $962c
        lda     #$01
        sta     $cf63
        inc     $fefa
        jsr     $3725       ; load battle bg graphics
        ldy     #$1080
        ldx     #$0500
        stx     $70
        ldx     #$7000
        lda     #$7f
        jsr     $fd27
        lda     #$30
        sta     f:$002123
        jsr     $fd1d       ; wait for vblank
        clr_ax
@9104:  lda     $7f7703,x
        and     #$cf
        sta     $7f7703,x
        inx4
        cpx     #$0100
        bne     @9104
        lda     #$03
        sta     $dbf5
@911c:  jsr     $fd1d       ; wait for vblank
        jsr     $946b
        bcc     @911c
        jsr     $fd1d       ; wait for vblank
        jsr     $94ea
        ldx     #$1800
        stx     $70
        ldx     #$8000
        ldy     #$6000
        lda     #$7f
        jsr     $fd27
        jsr     $fd1d       ; wait for vblank
        clr_ax
        lda     #$aa
@9141:  sta     $0400,x
        inx
        cpx     #$0020
        bne     @9141
        clr_ax
@914c:  lda     $d0e42b,x
        sta     $0200,x
        inx
        cpx     #$0060
        bne     @914c
        lda     #$f0
@915b:  sta     $0200,x
        inx
        cpx     #$0200
        bne     @915b
        lda     #$12
        sta     $fefb
        clr_ax
        stx     $bc77
        stx     $fefc
        stx     $fefe
        stz     $ff00
        lda     #$01
        sta     $dbf5
@917c:  jsr     $fd1d       ; wait for vblank
        jsr     $8f3c
        lda     $f9ee
        cmp     #$80
        beq     @9192
        lda     $f9ee
        sec
        sbc     #$04
        sta     $f9ee
@9192:  inc     $f9ed
        lda     $f9ed
        cmp     #$7f
        beq     @91a6
        inc     $f9ed
        lda     $f9ed
        cmp     #$7f
        bne     @917c
@91a6:  lda     #$c4
        sta     $bc84
        ldy     #$8000
        sty     $70
        lda     #$7f
        sta     $72
        ldy     #$8010
        sty     $74
        lda     #$7f
        sta     $76
        clr_ax
        longa
@91c1:  clr_ay
@91c3:  lda     $d1f000,x
        and     #$ff00
        sta     $7e
        xba
        lsr
        ora     $7e
        sta     [$70],y
        clr_a
        sta     [$74],y
        iny2
        inx2
        cpy     #$0010
        bne     @91c3
        tya
        clc
        adc     #$0010
        tay
        lda     $70
        clc
        adc     #$0020
        sta     $70
        lda     $74
        clc
        adc     #$0020
        sta     $74
        cpx     #$1000
        bne     @91c1
        clr_ax
@91fb:  lda     $d1f000,x
        and     #$ff00
        sta     $7e
        xba
        lsr
        ora     $7e
        sta     $7fc000,x
        inx2
        cpx     #$1000
        bne     @91fb
        shorta0
        ldx     #$2000
        stx     $70
        ldx     #$8000
        ldy     #$7000
        lda     #$7f
        jsr     $fd27
        ldx     #$1000
        stx     $70
        ldx     #$c000
        ldy     #$4000
        lda     #$7f
        jsr     $fd27
        clr_ax
@9238:  sta     $7e09,x
        inx
        cpx     #$0020
        bne     @9238
        ldx     #$7fff
        stx     $7e0d
        stx     $7e0f
        jsr     $933e
        ldx     #$1000
        stx     $70
        ldx     #$bcb1
        ldy     #$5800
        lda     #$7e
        jsr     $fd27
        ldx     #$1000
        stx     $70
        ldx     #$bcb1
        ldy     #$4800
        lda     #$7e
        jsr     $fd27
        lda     #$07
        sta     f:$00210b
        clr_ax
@9275:  lda     $d0e169,x
        sta     $dbf6,x
        inx
        cpx     #$0080
        bne     @9275
        jsr     $933e
        jsr     $2dac
        ldx     #$0500
        stx     $70
        ldx     #$bcb1
        ldy     #$5800
        lda     #$7e
        jsr     $fd27
        jsr     $fd1d       ; wait for vblank
        ldx     #$0100
        stx     $bc79
        clr_ax
        stx     $fefe
        lda     #$17
        sta     $fefb
        jsr     $9360
        jsr     $2dac
        jsr     $93af
        stz     $ff32
        stz     $cdfa
        stz     $ff03
@92bd:  jsr     $02f2       ; wait one frame
        lda     $fefe
        and     #$0f
        bne     @92cf
        lda     $ff32
        bne     @92cf
        jsr     $931a
@92cf:  ldx     $bc79
        beq     @92d8
        dex
        stx     $bc79
@92d8:  lda     $ff32
        bne     @92e4
        ldx     $fefe
        inx
        stx     $fefe
@92e4:  ldx     $a2
        cpx     #$0ac4
        bcc     @92bd
        ldx     $04f0
        cpx     #$01b1
        bne     @9319
@92f3:  jsr     $02f2       ; wait one frame
        ldx     $fefe
        inx
        stx     $fefe
        txa
        and     #$0f
        bne     @9305
        jsr     $931a
@9305:  ldx     $bc79
        dex
        stx     $bc79
        cpx     #$ff00
        bne     @92f3
        lda     #$16
        sta     $fefb
        jmp     _c1ee2a
@9319:  rts

; ---------------------------------------------------------------------------

; [  ]

_c1931a:
@931a:  jsr     $9360
        jsr     $2dac
        lda     $ff03
        and     #$1f
        longa
        asl6
        clc
        adc     #$4800
        sta     $ff01
        shorta0
        inc     $ff00
        inc     $ff03
        rts

; ---------------------------------------------------------------------------

; [  ]

_c1933e:
@933e:  clr_ax
@9340:  sta     $bcb1,x
        inx
        cpx     #$1000
        bne     @9340
@9349:  ldx     #$dbf6
        stx     $bca0
        ldx     #$bcb1
        stx     $bca2
        lda     #$20
        sta     $bca4
        lda     #$20
        sta     $bca5
        rts

; ---------------------------------------------------------------------------

; [  ]

_c19360:
@9360:  clr_ax
@9362:  sta     $bcb1,x
        inx
        cpx     #$0080
        bne     @9362
        jsr     $9349
        clr_ax
        lda     $cdfa
        tay
        lda     $b535,y
        cmp     #$ff
        bne     @938a
@937b:  lda     $d0dbd4,x
        sta     $dbf6,x
        inx
        cpx     #$0010
        bne     @937b
        bra     @93ab
@938a:  cmp     #$fe
        bne     @9396
        inc     $ff32
        stz     $dbf6
        bra     @93ab
@9396:  lda     $d0e163,x
        sta     $dbf6,x
        inx
        cpx     #$0008
        bne     @9396
        clr_ax
        lda     $cdfa
        sta     $dbfa,x
@93ab:  inc     $cdfa
        rts

; ---------------------------------------------------------------------------

; [  ]

_c193af:
@93af:  clr_ax
@93b1:  sta     $dbf6,x
        sta     $b535,x
        inx
        cpx     #$0200
        bne     @93b1
        ldx     #$090b
        stx     $70
        ldx     #$0006
@93c5:  txa
        jsr     $9443
        inx
        cpx     #$006f
        bne     @93c5
        ldx     #$002c
        lda     #$05
        jsr     $942f
        ldx     #$0032
        lda     #$05
        jsr     $942f
        ldx     #$0038
        lda     #$05
        jsr     $942f
        ldx     #$003e
        lda     #$05
        jsr     $942f
        ldx     #$0044
        lda     #$04
        jsr     $942f
        ldx     #$0049
        lda     #$02
        jsr     $942f
        clr_axy
@9402:  lda     $b535,x
        beq     @940c
        txa
        sta     $dbf6,y
        iny
@940c:  stz     $b535,x
        inx
        cpx     #$0200
        bne     @9402
        clr_ax
@9417:  lda     $dbf6,x
        beq     @9425
        sta     $b535,x
        inx
        cpx     #$0200
        bne     @9417
@9425:  lda     #$ff
        sta     $b53d,x
        dec
        sta     $b557,x
        rts

; ---------------------------------------------------------------------------

; [  ]

_c1942f:
@942f:  tay
@9430:  lda     $b536,x
        beq     @943c
        stz     $b535,x
        inx
        dey
        bne     @9430
@943c:  rts

; ---------------------------------------------------------------------------

; [  ]

_c1943d:
@943d:  phx
        jsr     $fc74
        plx
        rts

; ---------------------------------------------------------------------------

; [  ]

_c19443:
@9443:  phx
        sta     $75
        asl
        tax
        lda     $d0ec01,x
        jsr     $943d
        sta     $74
        lda     $d0ec00,x
        tay
        lda     ($70),y
        and     $74
        beq     @9469
        lda     $75
        cmp     #$4e
        bcc     @9465
        clc
        adc     #$32
@9465:  tax
        inc     $b535,x
@9469:  plx
        rts

; ---------------------------------------------------------------------------

; [  ]

_c1946b:
@946b:  ldx     $bc8e
        cpx     #$0040
        beq     @947f
        dex4
        stx     $bc8e
        stx     $bc94
        clc
        rts
@947f:  sec
        rts

; ---------------------------------------------------------------------------

; [  ]

_c19481:
@9481:  ldx     #$71ec
        stx     $70
        lda     #$7f
        sta     $72
        clr_ax
        lda     #$b0
        sta     $7e
        lda     #$57
        sta     $80
@9494:  clr_ay
        lda     $7e
        sta     $82
@949a:  lda     $82
        sta     $7f7700,x
        lda     $80
        sta     $7f7701,x
        lda     [$70],y
        sta     $7f7702,x
        iny
        lda     [$70],y
        and     #$c0
        ora     #$31
        sta     $74
        lda     [$70],y
        and     #$1c
        lsr
        ora     $74
        sta     $7f7703,x
        iny
        inx4
        lda     $82
        clc
        adc     #$08
        sta     $82
        cpy     #$0010
        bne     @949a
        longa
        lda     $70
        clc
        adc     #$0040
        sta     $70
        shorta0
        lda     $80
        clc
        adc     #$08
        sta     $80
        cmp     #$97
        bne     @9494
        rts

; ---------------------------------------------------------------------------

; [  ]

_c194ea:
@94ea:  jsr     $24e2       ; load character graphics
        clr_ax
@94ef:  longa
        lda     $d97ce1,x
        sta     $b8
        lda     $d97ced,x
        sta     $82
        shorta0
        phx
        lda     #$7f
        sta     $84
        lda     #$7f
        sta     $80
        clr_ax
@950b:  phx
        longa
        txa
        asl
        tax
        lda     $d97cf9,x
        clc
        adc     $b8
        sta     $7e
        shorta0
        plx
        clr_ay
        lda     [$82],y
        jsr     $9559
        ldy     #$0001
        lda     [$82],y
        jsr     $9559
        ldy     #$0010
        lda     [$82],y
        jsr     $9559
        ldy     #$0011
        lda     [$82],y
        jsr     $9559
        longa
        lda     $82
        clc
        adc     #$0002
        sta     $82
        shorta0
        inx
        cpx     #$0008
        bne     @950b
        plx
        inx2
        cpx     #$000c
        bne     @94ef
        rts

; ---------------------------------------------------------------------------

; [  ]

_c19559:
@9559:  sty     $86
        sta     $70
        ldy     #$0000
        jsr     $9581
        jsr     $95a6
        ldy     #$0020
        jsr     $9581
        jsr     $95a6
        ldy     #$0040
        jsr     $9581
        jsr     $95a6
        ldy     #$0060
        jsr     $9581
        jmp     _c195a6

; ---------------------------------------------------------------------------

; [  ]

_c19581:
@9581:  longa
        tya
        clc
        adc     $86
        tay
        shorta0
        phx
        asl     $70
        rol
        and     #$01
        tax
        lda     f:_c195b7,x
        sta     $72
        asl     $70
        rol
        and     #$01
        tax
        lda     f:_c195b7+2,x
        ora     $72
        plx
        rts

; ---------------------------------------------------------------------------

; [  ]

_c195a6:
@95a6:  phy
        sta     [$7e],y
        iny2
        sta     [$7e],y
        iny2
        sta     [$7e],y
        iny2
        sta     [$7e],y
        ply
        rts

; ---------------------------------------------------------------------------

; [  ]

_c195b7:
        .byte   $00,$f0
        .byte   $00,$0f
        .byte   $00,$f0
        .byte   $00,$0f

; ---------------------------------------------------------------------------

; [  ]

_c195bf:
@95bf:  clr_axy
@95c2:  lda     #$08
        sta     $78
@95c6:  phx
        tyx
        lda     $7fd800,x
        sta     $70
        lda     $7fd801,x
        sta     $71
        lda     $7fd810,x
        sta     $72
        lda     $7fd811,x
        sta     $73
        lda     #$08
        sta     $76
        plx
@95e5:  clr_a
        asl     $73
        rol
        asl     $72
        rol
        asl     $71
        rol
        asl     $70
        rol
        sta     $7fe081,x
        inx2
        dec     $76
        bne     @95e5
        iny2
        dec     $78
        bne     @95c6
        longa
        tya
        clc
        adc     #$0010
        tay
        shorta0
        cpy     $7e
        bne     @95c2
        clr_ax
@9613:  sta     $7fe001,x
        inx2
        cpx     #$0080
        bne     @9613
        clr_ax
@9620:  sta     $7fe000,x
        inx2
        cpx     #$2000
        bne     @9620
        rts

; ---------------------------------------------------------------------------

; [  ]

_c1962c:
@962c:  ldx     #$00c0
        stx     $7e
        jsr     $95bf
        lda     #$c0
        sta     f:$00211a
        ldx     #$2000
        stx     $70
        ldx     #$e000
        ldy     #$1000
        lda     #$7f
        jsr     $fd27
        ldx     #$2000
        stx     $70
        ldx     #$e000
        ldy     #$2000
        lda     #$7f
        jsr     $fd27
        ldx     #$2000
        stx     $70
        ldx     #$e000
        ldy     #$3000
        lda     #$7f
        jsr     $fd27
        lda     #$01
        sta     $7fe000
        inc
        sta     $7fe002
        inc
        sta     $7fe100
        inc
        sta     $7fe102
        inc
        sta     $7fe200
        inc
        sta     $7fe202
        ldx     #$2000
        stx     $70
        ldx     #$e000
        clr_ay
        lda     #$7f
        jsr     $fd27
        clr_ax
@969a:  lda     $ed96,x
        sta     $7e09,x
        inx
        cpx     #$0020
        bne     @969a
        stz     $7e09
        stz     $7e0a
        lda     #$cc
        sta     $7ebc84
        ldx     #$0024
        stx     $bc96
        ldx     #$0010
        stx     $bc98
        ldx     #$ff38
        stx     $bc77
        ldx     #$ff92
        stx     $bc79
        clr_ax
        stx     $bc90
        stx     $bc92
        ldx     #$0100
        stx     $bc8e
        stx     $bc94
        stz     $bc8c
        stz     $bc85
        lda     #$07        ; mode 7
        sta     $bc81
        inc     $bc8d
        jmp     _c102f2       ; wait one frame

; ---------------------------------------------------------------------------

; [ set attacker animation frame ]

_c196ec:
@96ec:  jsr     $9d80       ; get pointer to character graphics properties
        sta     $cf58,y
        phy
        phx
        jsr     $8d47       ; get graphics script parameter 3
        tax
        lda     $d0dfbc,x   ; 0 or 1
        plx
        ply
        sta     $70
        lda     $cf56,y
        ora     $70
        sta     $cf56,y
        rts

; ---------------------------------------------------------------------------

; [  ]

_c19709:
@9709:  jsr     $02f2       ; wait one frame
        lda     $cf53
        ora     $cf73
        ora     $cf93
        ora     $cfb3
        bne     @9709
        rts

; ---------------------------------------------------------------------------

; [  ]

_c1971b:
@971b:  jsr     _c18d2f       ; get attacker id
        tay
        lda     #$01
        sta     $d1d4,y
        rts

; ---------------------------------------------------------------------------

; [  ]

_c19725:
@9725:  jsr     _c18d2f       ; get attacker id
        tay
        clr_a
        sta     $d1d4,y
        rts

; ---------------------------------------------------------------------------

; [ ability animation $24: hide ]

_c1972e:
        jsr     _c18d2f       ; get attacker id
        tax
        asl2
        tay
        lda     #$80
        sta     $72
        jsr     $9763
        jsr     $9da1
        jsr     $9d80       ; get pointer to character graphics properties
        lda     #$01
        sta     $cf43,y
        jmp     _c1971b

; ---------------------------------------------------------------------------

; [ ability animation $25: show ]

_c1974a:
        jsr     $9d80       ; get pointer to character graphics properties
        clr_a
        sta     $cf43,y
        jsr     _c18d2f       ; get attacker id
        tax
        asl2
        tay
        stz     $72
        jsr     $9763
        jsr     $9da1
        jmp     _c19725

; ---------------------------------------------------------------------------

; [ run on/off screen ??? ]

_c19763:
@9763:  lda     $7b7e,y
        and     #$c0
        bne     @979d       ; branch if dead or stone
        lda     $d1bd,x
        beq     @9773
        lda     #$50
        bra     @977e
@9773:  lda     $db4a,x
        beq     @977c
        lda     #$20
        bra     @977e
@977c:  lda     #$30
@977e:  sta     $70
        phx
        txa
        asl5
        tax
        lda     $70
        ora     $72
        sta     $cf54,x
        lda     #$02
        sta     $cf4d,x
        lda     #$01
        sta     $cf53,x
        stz     $cf55,x
        plx
@979d:  rts

; ---------------------------------------------------------------------------

; [  ]

_c1979e:
        inc     $dbbb
        jsr     $9709
        jsr     $9d93       ; wait for damage numerals
        jsr     $8d3b
        beq     @9814
        jsr     $8d74
        stz     $d1cf
        stz     $d1d0
        stz     $d1d1
        stz     $d1d2
        lda     $df
        sta     $74
        clr_ayx
@97c2:  asl     $74
        bcc     @97d7
        lda     $7b81,y
        bmi     @97d7
        lda     $d1d4,x
        bne     @97d7
        lda     #$80
        sta     $72
        jsr     $9763
@97d7:  inx
        iny4
        cpy     #$0010
        bne     @97c2
@97e1:  jsr     $02f2       ; wait one frame
        lda     #$04
        sta     $70
        clr_axy
@97eb:  lda     $cf53,x
        bne     @9803
        lda     $7b81,y
        bmi     @9801
        lda     $7b7e,y
        and     #$c0
        bne     @9801
        lda     #$01
        sta     $cf43,x
@9801:  dec     $70
@9803:  iny4
        txa
        clc
        adc     #$20
        tax
        cmp     #$80
        bne     @97eb
        lda     $70
        bne     @97e1
@9814:  rts

; ---------------------------------------------------------------------------

; [ ability animation $05: guard ]

_c19815:
        jsr     $8d74
        lda     #$01
        jmp     _c196ec

; ---------------------------------------------------------------------------

; [ ability animation $29: dance ]

_c1981d:
        jsr     $8d74
        lda     #$0e
        jsr     $96ec
        ldx     #$0040
@9828:  phx
        jsr     $02f2       ; wait one frame
        plx
        txa
        and     #$07
        bne     @9862
        jsr     $9d80       ; get pointer to character graphics properties
        phx
        txa
        lsr3
        and     #$03
        tax
        lda     f:_c19871,x
        sta     $cf57,y
        lda     f:_c19875,x
        sta     $70
        lda     $cf49,y
        clc
        adc     $70
        sta     $cf49,y
        lda     f:_c19879,x
        sta     $70
        lda     $cf56,y
        eor     $70
        sta     $cf56,y
        plx
@9862:  dex
        bne     @9828
        clr_a
        jsr     $96ec
        clr_a
        sta     $cf57,y
        sta     $cf49,y
        rts

; ---------------------------------------------------------------------------

_c19871:
        .byte   $04,$05,$06,$07

_c19875:
        .byte   $00,$fe,$00,$02

_c19879:
        .byte   $80,$00,$80,$00

; ---------------------------------------------------------------------------

; [ ability animation $28: flirt ]

_c1987d:
        jsr     $9d93       ; wait for damage numerals
        lda     #$0e
        jsr     $96ec
        jsr     $9d3c
        lda     #$0b
        jsr     $96ec
        ldx     #$0108
        jsr     $b69c
        clr_a
        jmp     _c196ec

; ---------------------------------------------------------------------------

_c19897:
        jsr     $9d93       ; wait for damage numerals
        lda     #$0b
        jsr     $96ec
        ldx     #$010e
        jsr     $b69c
        clr_a
        jmp     _c196ec

; ---------------------------------------------------------------------------

; [ ability animation $1c: catch ]

_c198a9:
        jsr     $9d93       ; wait for damage numerals
        lda     #$0b
        jsr     $96ec
        ldx     #$010b
        jsr     $b69c
        ldx     #$0110
        jsr     $b69c
        clr_a
        jmp     _c196ec

; ---------------------------------------------------------------------------

; [ ability animation $12: gil toss ]

_c198c1:
        jsr     $9d93       ; wait for damage numerals
        lda     #$0b
        jsr     $96ec
        ldx     #$010a
        jsr     $b69c
        clr_a
        jmp     _c196ec

; ---------------------------------------------------------------------------

_c198d3:
        lda     #$0b
        jsr     $96ec
        jsr     $9d41
        clr_a
        jmp     _c196ec

; ---------------------------------------------------------------------------

; [ ability animation $0d: dragon sword ]

_c198df:
        jsr     $9d93       ; wait for damage numerals
        lda     #$0b
        jsr     $96ec
        ldx     #$0109
        jsr     $b69c
        ldx     #$010c
        jsr     $b69c
        clr_a
        jmp     _c196ec

; ---------------------------------------------------------------------------

; [ ability animation $1a: tame ]

_c198f7:
        jsr     $9d93       ; wait for damage numerals
        lda     #$0b
        jsr     $96ec
        ldx     #$00bf
        jsr     $b69c
        clr_a
        jmp     _c196ec

; ---------------------------------------------------------------------------

; [ ability animation $20: pray ]

_c19909:
        jsr     $9d93       ; wait for damage numerals
        lda     #$0b
        jsr     $96ec
        ldx     #$00d8
        jsr     $b69c
        clr_a
        jmp     _c196ec

; ---------------------------------------------------------------------------

; [ ability animation $21: revive ]

_c1991b:
        jsr     $9d93       ; wait for damage numerals
        lda     #$0b
        jsr     $96ec
        ldx     #$0019
        jsr     $b69c
        clr_a
        jmp     _c196ec

; ---------------------------------------------------------------------------

; [ ability animation $0e: smoke ]

_c1992d:
        jsr     $9d93       ; wait for damage numerals
        lda     #$0b
        jsr     $96ec
        jsr     $8d3b
        beq     @993e
        lda     $df
        sta     ($eb),y
@993e:  jsr     $8d4d       ; get graphics script parameter 2
        iny
        sta     ($e7),y
        ldx     #$010b
        jsr     $b69c
        jsr     $9d41
        clr_a
        jmp     _c196ec

; ---------------------------------------------------------------------------

; [ ability animation $0a: steal/capture ]

_c19951:
        jsr     $8d74
        jsr     $9d37
        jsr     $9d41
        lda     #$0b
        jsr     $96ec
        jsr     $9d41
        clr_a
        jmp     _c196ec

; ---------------------------------------------------------------------------

; [ ability animation $08: mantra ]

_c19966:
        jsr     $9d93       ; wait for damage numerals
        ldx     #$0111
        jsr     $b58b
        lda     #$01
        jsr     $96ec
        jmp     _c19d3c

; ---------------------------------------------------------------------------

; [ ability animation $0f: image ]

_c19977:
        jsr     $8d74
        lda     #$0b
        jsr     $96ec
        jsr     $9d41
        clr_a
        jmp     _c196ec

; ---------------------------------------------------------------------------

; [ ability animation $03: def ]

_c19986:
        lda     #$01
        jmp     _c196ec

; ---------------------------------------------------------------------------

; [ ability animation $07: buildup ]

_c1998b:
        jsr     $9d93       ; wait for damage numerals
        ldx     #$0107
        jsr     $b58b
        lda     #$01
        jsr     $96ec
        jmp     _c19d3c

; ---------------------------------------------------------------------------

_c1999c:
@999c:  clr_ax
        lda     #$f0
@99a0:  sta     $f8c9,x
        inx
        cpx     #$00d8
        bne     @99a0
        stz     $db40
        rts

; ---------------------------------------------------------------------------

; [ ability animation $2e: interceptor rocket ]

_c199ad:
        jsr     $9d93       ; wait for damage numerals
        jsr     $999c
        jsr     _c18d2f       ; get attacker id
        sta     $db3f
        inc     $db3e
        lda     #$0b
        jsr     $9d8c
        jsr     $9d80       ; get pointer to character graphics properties
        clr_a
        sta     $cf5d,y
        sta     $cf5e,y
        sta     $cf5f,y
        sta     $cf60,y
        sta     $cf46,y
        phy
        jsr     _c18d2f       ; get attacker id
        clc
        adc     #$08
        tax
        ply
        jmp     _9a16

; ---------------------------------------------------------------------------

; [ ability animation $2d: jump attack ]

_c199e0:
        jsr     $9d93       ; wait for damage numerals
        jsr     $999c
        jsr     $fc64
        jsr     _c18d2f       ; get attacker id
        sta     $db3f
        inc     $db3e
        lda     #$0b
        jsr     $9d8c
        jsr     $9d80       ; get pointer to character graphics properties
        clr_a
        sta     $cf5d,y
        sta     $cf5e,y
        sta     $cf5f,y
        sta     $cf60,y
        sta     $cf46,y
        phy
        jsr     $8d74
        jsr     $8d35       ; get target id
        jsr     $fc7a
        tax
        ply
_9a16:  phx
        lda     $d072,x
        sec
        sbc     #$18
        lsr4
        sta     $70
        clc
        adc     $d066,x
        sta     $cf45,y
        clr_a
        sta     $cf43,y
        lda     $70
        beq     @9a4e
        tax
@9a33:  phx
        jsr     $02f2       ; wait one frame
        jsr     $9d80       ; get pointer to character graphics properties
        lda     $cf45,y
        dec
        sta     $cf45,y
        lda     $cf46,y
        clc
        adc     #$10
        sta     $cf46,y
        plx
        dex
        bne     @9a33
@9a4e:  plx
        jsr     $9d80       ; get pointer to character graphics properties
        lda     $d072,x
        sec
        sbc     #$18
        sta     $cf46,y
        lda     $d066,x
        sta     $cf45,y
        jsr     $8d74
        jsr     $9d37
        jsr     $9d80       ; get pointer to character graphics properties
        lda     $cf56,y
        ora     #$80
        sta     $cf56,y
        lda     #$0b
        jsr     $9d8c
        jsr     $9d80       ; get pointer to character graphics properties
        lda     $cf45,y
        sta     $a6
        lda     $cf46,y
        sta     $a7
        jsr     $9a8a
        jmp     _c19725
@9a8a:  jsr     _c18d2f       ; get attacker id
        tax
        lda     $f8b9,x
        sta     $a9
        lda     $f8b5,x
        sta     $a8
        jsr     $0a6e
        jsr     $09a7
        clr_ax
        lda     $ae
        jsr     $0996
        stz     $cdfb
        stz     $ce3b
        longa
        lda     $af
        lsr
        sta     $b1
        lsr3
        sta     $b3
        stz     $b5
        shorta0
@9abc:  jsr     $02f2       ; wait one frame
        jsr     $9d4b
        clr_ax
        lda     #$0c
        jsr     $09b9
        longa
        lda     $af
        sec
        sbc     #$000c
        sta     $af
        clc
        adc     #$000c
        cmp     $b1
        bcc     @9af4
        lda     $b5
        clc
        adc     $b3
        sta     $b5
        lda     $b3
        beq     @9b18
        dec
        sta     $b3
        lda     $cf5f,y
        sec
        sbc     $b5
        sta     $cf5f,y
        bra     @9b18
@9af4:  lda     $b1
        lsr3
        cmp     $b3
        bne     @9b03
        stz     $b3
        stz     $b5
        bra     @9b0f
@9b03:  lda     $b3
        inc
        sta     $b3
        lda     $b5
        sec
        sbc     $b3
        sta     $b5
@9b0f:  lda     $cf5f,y
        sec
        sbc     $b5
        sta     $cf5f,y
@9b18:  shorta0
        lda     $b0
        bpl     @9abc
        lda     $a8
        sta     $cf45,y
        lda     $a9
        sta     $cf46,y
        clr_a
        sta     $cf5d,y
        sta     $cf5e,y
        sta     $cf5f,y
        sta     $cf60,y
        jsr     $9d37
        jsr     $9d80       ; get pointer to character graphics properties
        lda     $cf56,y
        and     #$7f
        sta     $cf56,y
        clr_a
        jsr     $9d8c
        jsr     $9d41
        stz     $db3e
        jsr     $67d3
        jsr     _c18d2f       ; get attacker id
        tax
        stz     $d1cb,x
        jmp     _c1fc6d

; ---------------------------------------------------------------------------

_c19b5b:
        iny
        cld
@9b5d:  jsr     $9d80       ; get pointer to character graphics properties
        tya
        lsr5
        tax
        lda     $cf45,y
        sta     $f8b5,x
        lda     $cf46,y
        sta     $f8b9,x
        rts

; ---------------------------------------------------------------------------

; [ ability animation $0c: jump (part 1) ]

_c19b74:
        jsr     $9d93       ; wait for damage numerals
        jsr     $999c
        stz     $db41
        jsr     $fc64
        jsr     _c18d2f       ; get attacker id
        pha
        tay
        lda     #$01
        sta     $d1d4,y
        pla
        sta     $db3f
        lda     #$01
        sta     $db3e
        jsr     $8d74
        jsr     $9b5d
        jsr     $80b8
        jsr     $9d37
        lda     #$0b
        jsr     $9d8c
@9ba4:  jsr     $02f2       ; wait one frame
        jsr     $9d80       ; get pointer to character graphics properties
        longa
        lda     $cf5d,y
        dec
        sta     $cf5d,y
        shorta0
        inc     $db41
        inc     $db41
        lda     $cf46,y
        sec
        sbc     $db41
        sta     $cf46,y
        cmp     #$a0
        bcc     @9ba4
        jsr     $02f2       ; wait one frame
        jsr     $9d80       ; get pointer to character graphics properties
        lda     #$01
        sta     $cf43,y
        lda     #$20
        jsr     $8141       ; wait
        stz     $db3e
        jsr     $67d3
        jmp     _c1fc6d

; ---------------------------------------------------------------------------

; [ ability animation $13: slash ]

_c19be3:
        jsr     $8d14
        jsr     $9d93       ; wait for damage numerals
        lda     #$01
        jsr     $9d8c
        lda     $cf45,y
        sta     $a6
        lda     $cf46,y
        sta     $a7
        jsr     $9b5d
        lda     #$00
        sta     $a8
        lda     $dbd3
        beq     @9c08
        lda     #$70
        bra     @9c0a
@9c08:  lda     #$50
@9c0a:  sta     $a9
        jsr     $0a6e
        jsr     $09a7
        clr_ax
        lda     $ae
        jsr     $0996
        stz     $cdfb
        stz     $ce3b
        jsr     $8d74
@9c22:  jsr     $02f2       ; wait one frame
        jsr     $9d4b
        clr_ax
        lda     #$0c
        jsr     $09b9
        longa
        lda     $af
        sec
        sbc     #$000c
        sta     $af
        shorta0
        lda     $b0
        bpl     @9c22
        ldx     #$010d
        jsr     $b69c
        jsr     $9d80       ; get pointer to character graphics properties
        lda     #$08
        sta     $a6
        sta     $cf45,y
        lda     #$50
        sta     $a7
        sta     $cf46,y
        longa
        clr_a
        sta     $cf5d,y
        sta     $cf5f,y
        shorta
        lda     $cf56,y
        ora     #$80
        sta     $cf56,y
        lda     #$0b
        jsr     $96ec
        jsr     $8d74
        jsr     $9a8a
        clr_a
        jsr     $96ec
        jmp     _c18d22

; ---------------------------------------------------------------------------

; [ ability animation $06: kick ]

_c19c7c:
        jsr     $8d14       ; show character in ready stance
        jsr     $9d93       ; wait for damage numerals
        jsr     $9d37       ;
        lda     #$0f
        jsr     $9d8c
        jsr     $8d74
        lda     $cf45,y
        sta     $a6
        lda     $cf46,y
        sta     $a7
        lda     #$08
        sta     $a8
        lda     #$50
        sta     $a9
        jsr     $0a6e
        jsr     $09a7
        clr_ax
        lda     $ae
        jsr     $0996
        stz     $cdfb
        stz     $ce3b
        ldx     $af
        phx
@9cb5:  jsr     $02f2       ; wait one frame
        jsr     $9d4b
        clr_ax
        lda     #$0c
        jsr     $09b9
        longa
        lda     $af
        sec
        sbc     #$000c
        sta     $af
        shorta0
        lda     $b0
        bpl     @9cb5
        jsr     $9d37
        jsr     $9d80       ; get pointer to character graphics properties
        lda     $cf56,y
        ora     #$80
        sta     $cf56,y
        jsr     $9d37
        lda     #$0f
        jsr     $9d8c
        plx
        stx     $b1
@9cec:  jsr     $02f2       ; wait one frame
        jsr     $9d4b
        clr_ax
        lda     #$f4
        jsr     $09b9
        longa
        lda     $af
        clc
        adc     #$000c
        sta     $af
        cmp     $b1
        beq     @9d0c
        shorta0
        bra     @9cec
@9d0c:  shorta0
        jsr     $02f2       ; wait one frame
        jsr     $9d4b
        jsr     $9d80       ; get pointer to character graphics properties
        clr_a
        sta     $cf5d,y
        sta     $cf5e,y
        sta     $cf5f,y
        sta     $cf60,y
        lda     $cf56,y
        and     #$7f
        sta     $cf56,y
        jsr     $9d37
        clr_a
        jsr     $9d8c
        jmp     _c18d22

; ---------------------------------------------------------------------------

_c19d37:
@9d37:  lda     #$03
        jsr     $9d8c

_c19d3c:
@9d3c:  lda     #$08
        jmp     _c18141       ; wait

; ---------------------------------------------------------------------------

_c19d41:
@9d41:  lda     #$10
        jmp     _c18141       ; wait

; ---------------------------------------------------------------------------

_c19d46:
        lda     #$3c
        jmp     _c18141       ; wait

; ---------------------------------------------------------------------------

_c19d4b:
@9d4b:  lda     $ce3b
        sta     $80
        stz     $81
        lda     $cebb
        jsr     $0b59
        jsr     $9d80       ; get pointer to character graphics properties
        longa
        lda     $84
        sta     $cf5d,y
        shorta0
        lda     $cdfb
        sta     $80
        stz     $81
        lda     $ce7b
        jsr     $0b59
        jsr     $9d80       ; get pointer to character graphics properties
        longa
        lda     $84
        sta     $cf5f,y
        shorta0
        rts

; ---------------------------------------------------------------------------

; [ get pointer to character graphics properties ]

_c19d80:
@9d80:  pha
        jsr     _c18d2f       ; get attacker id
        asl5
        tay
        pla
        rts

; ---------------------------------------------------------------------------

; [  ]

_c19d8c:
@9d8c:  jsr     $9d80       ; get pointer to character graphics properties
        sta     $cf58,y
        rts

; ---------------------------------------------------------------------------

; [ wait for damage numerals ]

_c19d93:
@9d93:  lda     $d114
        ora     $d116
        beq     @9da0
        jsr     $02f2       ; wait one frame
        bra     @9d93
@9da0:  rts

; ---------------------------------------------------------------------------

_c19da1:
@9da1:  jsr     $02f2       ; wait one frame
        jsr     _c18d2f       ; get attacker id
        asl5
        tay
        lda     $cf53,y
        bne     @9da1
        rts

; ---------------------------------------------------------------------------

_c19db3:
@9db3:  phx
        lda     $7e
        pha
        jsr     $02f2       ; wait one frame
        pla
        sta     $7e
        plx
        txa
        asl5
        tay
        lda     $cf53,y
        bne     @9db3
        rts

; ---------------------------------------------------------------------------

; [  ]

_c19dcb:
        jsr     $8d3b
        sta     $7e
        clr_ax
@9dd2:  asl     $7e
        bcc     @9e01
        lda     $d1d4,x
        bne     @9df9
        jsr     $9db3
        lda     $d1bd,x
        ora     $d1cb,x
        bne     @9df9
        lda     $db4a,x
        beq     @9e01
        lda     #$10
        sta     $cf54,y
        lda     #$02
        sta     $cf4d,y
        dec
        sta     $cf53,y
@9df9:  lda     $db4a,x
        beq     @9e01
        stz     $db4a,x
@9e01:  inx
        cpx     #$0004
        bne     @9dd2
        jmp     _c19709

; ---------------------------------------------------------------------------

_c19e0a:
        jsr     $8d3b
        sta     $7e
        clr_ax
@9e11:  asl     $7e
        bcc     @9e44
        lda     $d1d4,x
        bne     @9e3c
        jsr     $9db3
        lda     $d1bd,x
        ora     $d1cb,x
        bne     @9e3c
        lda     $db4a,x
        beq     @9e2e
        lda     #$10
        bra     @9e30
@9e2e:  lda     #$90
@9e30:  sta     $cf54,y
        lda     #$02
        sta     $cf4d,y
        dec
        sta     $cf53,y
@9e3c:  lda     $db4a,x
        eor     #$01
        sta     $db4a,x
@9e44:  inx
        cpx     #$0004
        bne     @9e11
        jmp     _c19709

; ---------------------------------------------------------------------------

; [ ability animation $02: row ]

_c19e4d:
        jsr     _c18d2f       ; get attacker id
        tax
        lda     $d1d4,x
        bne     @9e7e
        jsr     $9da1
        phy
        jsr     _c18d2f       ; get attacker id
        tax
        ply
        lda     $d1bd,x
        ora     $d1cb,x
        bne     @9e7e
        lda     $db4a,x
        beq     @9e70
        lda     #$10
        bra     @9e72
@9e70:  lda     #$90
@9e72:  sta     $cf54,y
        lda     #$02
        sta     $cf4d,y
        dec
        sta     $cf53,y
@9e7e:  lda     $db4a,x
        eor     #$01
        sta     $db4a,x
        jmp     _c19da1

; ---------------------------------------------------------------------------

_c19e89:
        phx
        phy
        lda     ($eb)
        and     #$40
        bne     @9ed5
        jsr     $8d35       ; get target id
        jsr     $fc7a
        asl5
        tax
        lda     ($eb)
        and     #$10
        beq     @9ea7       ; branch if no crit flash
        lda     #$10
        bra     @9ea9
@9ea7:  lda     #$08
@9ea9:  sta     $70
        lda     $cf58,x
        pha
        lda     $70
        pha
        lda     $cf49,x
        clc
        adc     $70
        sta     $cf49,x
        lda     #$07
        sta     $cf58,x
        phx
        jsr     $9d41
        plx
        pla
        sta     $70
        lda     $cf49,x
        sec
        sbc     $70
        sta     $cf49,x
        pla
        sta     $cf58,x
@9ed5:  ply
        plx
        rts

; ---------------------------------------------------------------------------

; [  ]

_c19ed8:
@9ed8:  cmp     #$09
        beq     @9ee1
        cmp     #$11
        beq     @9ee1
        rts
@9ee1:  ldx     #$0119
        jmp     _c1b69c
@9ee7:  asl
        tax
        longa
        lda     $d0df44,x
        tax
        shorta0
        jmp     _c1b58b

; ---------------------------------------------------------------------------

; [ ability animation $10: throw ]

_c19ef6:
        jsr     $9d93       ; wait for damage numerals
        lda     $7c63
        cmp     #$5a
        beq     @9f13
        cmp     #$5b
        beq     @9f13
        lda     #$0b
        jsr     $96ec
        ldx     #$010f
        jsr     $b69c
        clr_a
        jmp     _c196ec
@9f13:  jsr     $8d14
        stz     $d1d3
        stz     $71
        stz     $70
        jsr     _c18d2f       ; get attacker id
        asl2
        tay
        lda     $7b7e,y
        and     #$30
        beq     @9f32
        lda     #$02
        sta     $d1d3
        clr_a
        bra     @9f35
@9f32:  lda     $7c63
@9f35:  jsr     $a8fc
        lda     $f582
        sta     $d1bc
        jsr     $a112
        jmp     _c18d22

; ---------------------------------------------------------------------------

; [ ability animation $04: fight ]

_c19f44:
        jsr     $9d93       ; wait for damage numerals
        lda     ($eb)
        bmi     @9f5a       ; branch if attacker is a monster
        jsr     $8d14
        jsr     $8d53       ; get graphics script parameter 4
        and     #$7f
        beq     @9f5a
        dec
        tax
        jsr     $9ee7
@9f5a:  lda     ($eb)
        bpl     @9f87
        jsr     _c18d2f       ; get attacker id
        and     #$07
        asl
        tax
        longa
        lda     $d97cd1,x
        sta     $7e
        shorta0
        jsr     $8d53       ; get graphics script parameter 4
        bmi     @9f7a
        ldy     #$0013
        bra     @9f7d
@9f7a:  ldy     #$0014
@9f7d:  lda     #$01
        sta     $d1d3
        lda     ($7e),y
        jmp     @9fba
@9f87:  stz     $d1d3
        stz     $71
        jsr     _c18d2f       ; get attacker id
        asl2
        tay
        lda     $7b7e,y
        and     #$30
        beq     @9fa2
        lda     #$02
        sta     $d1d3
        clr_a
        jmp     @9fba
@9fa2:  jsr     _c18d2f       ; get attacker id
        tax
        lda     $ceff84,x
        tax
        jsr     $8d53       ; get graphics script parameter 4
        bmi     @9fb5
        lda     $37ac,x
        bra     @9fba
@9fb5:  inc     $71
        lda     $37ad,x
@9fba:  pha
        lda     ($eb)
        and     #$10
        sta     $70         ; crit flash
        pla
        jsr     $a8fc
        lda     $f582
        sta     $d1bc
        jsr     $a112
        lda     ($eb)
        bmi     @9fde
        jsr     $8d53       ; get graphics script parameter 4
        and     #$7f
        beq     @9fde
        dec
        tax
        jsr     $9ed8
@9fde:  lda     ($eb)
        bmi     @9fe5
        jsr     _c18d22
@9fe5:  phx
        ldx     $f0
        inx
        stx     $f0
        plx
        rts

; ---------------------------------------------------------------------------

; [  ]

_c19fed:
        phy
        lda     $70
        pha
        lda     ($eb)
        bpl     @9ff8
        clr_a
        bra     @9ffa
@9ff8:  lda     #$08
@9ffa:  sta     $70
        jsr     _c18d2f       ; get attacker id
        clc
        adc     $70
        tay
        lda     $d036,y
        sta     $d1a9
        lda     $d042,y
        sta     $d1aa
        stz     $d1a4
        stz     $d1a5
        pla
        sta     $70
        jsr     _c18d2f       ; get attacker id
        ply
        rts

; ---------------------------------------------------------------------------

; [  ]

_c1a01d:
@a01d:  phy
        phx
        ldx     $70
        phx
        lda     ($eb)
        and     #$40
        beq     @a02b
        clr_a
        bra     @a02d
@a02b:  lda     #$08
@a02d:  sta     $70
        stz     $71
        ldy     #$0006
        lda     ($eb),y
        beq     @a040
        pha
        lda     #$10
        sta     $71
        pla
        bra     @a043
@a040:  jsr     $8d35       ; get target id
@a043:  jsr     $fc7a
        clc
        adc     $70
        tay
        lda     $d036,y
        sec
        sbc     $71
        sta     $d1b7
        lda     $d042,y
        sta     $d1b8
        stz     $d1b2
        stz     $d1b3
        plx
        stx     $70
        plx
        ply
        rts

; ---------------------------------------------------------------------------

; [  ]

_c1a065:
@a065:  phy
        jsr     $8d3b
        ora     ($f0)       ; block type
        beq     @a070
        ply
        sec
        rts
@a070:  ply
        clc
        rts

; ---------------------------------------------------------------------------

; [  ]

_c1a073:
@a073:  phx
        ldy     #$0006
        lda     ($eb),y
        beq     @a08a
        jsr     $a0a4
        lda     $f870
        sta     $cf45,x
        lda     $f871
        sta     $cf46,x
@a08a:  plx
        lda     $d1bc
        and     #$0f
        cmp     #$01
        beq     @a0a3
        lda     ($eb)
        and     #$40
        bne     @a0a3
        jsr     $a0a4
        lda     $f872
        sta     $cf58,x
@a0a3:  rts

; ---------------------------------------------------------------------------

; [  ]

_c1a0a4:
@a0a4:  jsr     $8d35       ; get target id
        jsr     $fc7a
        asl5
        tax
        rts

; ---------------------------------------------------------------------------

_c1a0b1:
@a0b1:  phx
        lda     $d1bc
        and     #$0f
        cmp     #$01
        beq     @a0d4
        lda     ($eb)
        and     #$40
        bne     @a0d4
        jsr     $a0a4
        lda     $cf58,x
        sta     $f872
        jsr     $8d3b
        beq     @a0d4
        lda     #$07
        sta     $cf58,x
@a0d4:  plx
        rts

; ---------------------------------------------------------------------------

_c1a0d6:
@a0d6:  phx
        ldy     #$0006
        lda     ($eb),y
        beq     @a110
        jsr     $fc7a
        asl5
        tax
        lda     $cf45,x
        sta     $70
        lda     $cf46,x
        sta     $71
        jsr     $a0a4
        lda     $cf45,x
        sta     $f870
        lda     $cf46,x
        sta     $f871
        lda     $70
        sec
        sbc     #$10
        sta     $cf45,x
        lda     $71
        sta     $cf46,x
        jsr     $9d41
@a110:  plx
        rts

; ---------------------------------------------------------------------------

; [  ]

_c1a112:
        lda     #$02
        sta     $d184
        sta     $d185
        lda     #$d9
        sta     $d188
        lda     $f586
        asl
        tax
        lda     $d99e34,x
        sta     $d186
        lda     $d99e35,x
        sta     $d187
        lda     #$04
        sta     $d192
        sta     $d193
        lda     #$d9        ; animation graphics bank
        sta     $d196
        lda     $f585
        asl
        tax
        lda     $d99e94,x
        sta     $d194
        lda     $d99e95,x
        sta     $d195
        stz     $d1ab
        stz     $d1ac
        stz     $d1b9
        stz     $d1ba
        stz     $d1a8
        stz     $d1b6
        stz     $d1bb
        stz     $d1c9
        stz     $d1ca
        lda     ($eb)
        and     #$10
        beq     @a176       ; branch if no crit flash
        jsr     $78f5       ; flash screen
@a176:  jsr     $a0b1
        jsr     $a065
        bcs     @a182
        lda     #$49
        bra     @a185
@a182:  lda     $f583       ; animation sound effect
@a185:  jsr     $fbe4       ; play animation sound effect
        lda     ($eb)
        bpl     @a1a2
        jsr     $a0d6
        lda     #$40
        sta     $d1a8
        sta     $d1b6
        lda     ($eb)
        and     #$40
        beq     @a1ed
        inc     $d1c9
        bra     @a1ed
@a1a2:  jsr     $a0d6
        jsr     $8d2f       ; get attacker id
        and     #$03
        sta     $70
        tay
        lda     #$02
        sta     $d1c1,y
        jsr     $8d35       ; get target id
        jsr     $fc7a
        sta     $72
        lda     ($eb)
        and     #$40
        beq     @a1c5
@a1c0:  inc     $d1c9
        bra     @a1ed
@a1c5:  lda     $70
        cmp     $72
        bne     @a1d5
        lda     $70
        tay
        lda     $d1bd,y
        bne     @a1dd
        bra     @a1c0
@a1d5:  lda     $72
        tay
        lda     $d1bd,y
        bne     @a1c0
@a1dd:  lda     #$40
        sta     $d1a8
        sta     $d1b6
        lda     $70
        tay
        lda     #$01
        sta     $d1c1,y
@a1ed:  jsr     $9fed
        pha
        lda     $d1bc
        bmi     @a1fb
        jsr     $8d53       ; get graphics script parameter 4
        bpl     @a207
@a1fb:  lda     #$05
        sta     $73
        stz     $70
        lda     #$04
        sta     $72
        bra     @a211
@a207:  lda     #$04
        sta     $73
        lda     #$06
        sta     $70
        stz     $72
@a211:  pla
        tax
        lda     f:_c1a843,x
        clc
        adc     $70
        sta     $d1a1
        txa
        asl5
        tax
        phx
        lda     $d1d3
        cmp     #$01
        beq     @a236
        lda     $72
        sta     $cf48,x
        lda     $73
        sta     $cf58,x
@a236:  jsr     $a01d
        lda     #$08
        sta     $d1af
        stz     $d1a2
        stz     $d1b0
        lda     #$02
        sta     $d18b
        sta     $d199
        ldx     $d186
        stx     $70
        lda     $d188
        sta     $72
        ldx     $d194
        stx     $74
        lda     $d196
        sta     $76
        lda     [$70]       ; bg1 width ???
        lsr4
        inc
        sta     $d189
        lda     [$74]       ; bg3 width ???
        lsr4
        inc
        sta     $d197
        lda     [$70]       ; bg1 height ???
        and     #$0f
        inc
        sta     $d18c
        lda     [$74]       ; bg3 height ???
        and     #$0f
        inc
        sta     $d19a
        lda     #$01
        sta     $d18a
        sta     $d198
@a28c:  ldx     $d186
        stx     $70
        lda     $d188
        sta     $72
        ldx     $d194
        stx     $74
        lda     $d196
        sta     $76
        ldy     #$0001
        lda     [$70],y
        longa
        asl7
        sta     $78
        lda     [$74],y
        and     #$00ff
        asl7
        sta     $7a
        shorta0
        stz     $7c
        lda     $d18b
        tay
        dec     $d18a
        bne     @a327
        lda     $d189
        sta     $d18a
        inc     $d1ac
@a2d5:  stz     $7e
        ldx     $70
        stx     $84
        lda     $72
        sta     $86
        lda     $d1d3
        bne     @a307
        lda     [$84],y
        cmp     #$ff
        beq     @a307       ; branch if end of frame
        lda     [$84],y
        bmi     @a301
        longa
        clc
        adc     $78
        sta     $d1a2
        shorta0
        iny
        lda     #$01
        sta     $d1a0
        bra     @a327
@a301:  jsr     $a3d3
        iny
        bra     @a2d5
@a307:  lda     $d18c
        beq     @a31d
        dec     $d18c
        beq     @a31d
        jsr     $9fed
        ldy     #$0002
        tya
        sta     $d18b
        bra     @a2d5
@a31d:  lda     #$01
        sta     $d189
        sta     $d18a
        inc     $7c
@a327:  tya
        sta     $d18b
        lda     $d199
        tay
        lda     $d1bc
        and     #$40
        beq     @a33a
        lda     $7c
        beq     @a39c
@a33a:  dec     $d198
        bne     @a39c
        lda     $d197
        sta     $d198
        inc     $d1ba
@a348:  jsr     $a065
        bcc     @a392
        lda     #$0e
        sta     $7e
        ldx     $74
        stx     $84
        lda     $76
        sta     $86
        lda     [$84],y
        cmp     #$ff
        beq     @a37c
        lda     [$84],y
        bmi     @a376
        longa
        clc
        adc     $7a
        sta     $d1b0
        shorta0
        iny
        lda     #$01
        sta     $d1ae
        bra     @a39c
@a376:  jsr     $a3d3
        iny
        bra     @a348
@a37c:  lda     $d19a
        beq     @a392
        dec     $d19a
        beq     @a392
        jsr     $a01d
        ldy     #$0002
        tya
        sta     $d199
        bra     @a348
@a392:  lda     #$ff
        sta     $d1bb
        sta     $d1ae
        inc     $7c
@a39c:  tya
        sta     $d199
        lda     $7c
        cmp     #$02
        beq     @a3ac
        jsr     $02f2       ; wait one frame
        jmp     @a28c
@a3ac:  plx
        clr_a
        sta     $d1c1
        sta     $d1c2
        sta     $d1c3
        sta     $d1c4
        sta     $d1a0
        lda     ($eb)
        bmi     @a3cd
        clr_a
        sta     $cf57,x
        sta     $cf58,x
        lda     #$04
        sta     $cf48,x
@a3cd:  jsr     $a073
        jmp     _c102f2       ; wait one frame

; ---------------------------------------------------------------------------

; [  ]

_c1a3d3:
@a3d3:  and     #$7f
        asl
        tax
        lda     f:_c1a3e6,x
        sta     $80
        lda     f:_c1a3e6+1,x
        sta     $81
        jmp     ($0080)

; ---------------------------------------------------------------------------

_c1a3e6:
        .addr   $a7a5,$a7b3,$a7c4,$a7ac,$a4e7,$a6ad,$a67b,$a4de
        .addr   $a70f,$a7bd,$a6df,$a4d1,$a01d,$a737,$a4cb,$a4be
        .addr   $a4b5,$a4ae,$a497,$a480,$a442,$a461,$a431,$a416

; ---------------------------------------------------------------------------

; [  ]

_c1a416:
        phy
        lda     $d1b6
        and     #$40
        sta     $d1b6
        jsr     $8d35       ; get target id
        jsr     $fc7a
        and     #$03
        ora     #$80
        ora     $d1b6
        sta     $d1b6
        ply
        rts

; ---------------------------------------------------------------------------

; [  ]

_c1a431:
        lda     ($eb)
        and     #$40
        beq     @a441
@a437:  lda     [$84],y
        cmp     #$ff
        beq     @a440
        iny
        bra     @a437
@a440:  dey
@a441:  rts

; ---------------------------------------------------------------------------

; [  ]

_c1a442:
        phy
        jsr     $8d35       ; get target id
        phx
        jsr     $fc7a
        plx
        ply
        asl5
        tax
        iny
        lda     [$84],y
        sta     $80
        lda     $cf49,x
        clc
        adc     $80
        sta     $cf49,x
        rts

; ---------------------------------------------------------------------------

; [  ]

_c1a461:
        phy
        jsr     $8d35       ; get target id
        phx
        jsr     $fc7a
        plx
        ply
        asl5
        tax
        iny
        lda     [$84],y
        sta     $80
        lda     $cf49,x
        sec
        sbc     $80
        sta     $cf49,x
        rts

; ---------------------------------------------------------------------------

; [  ]

_c1a480:
        phy
        jsr     $8d35       ; get target id
        phx
        jsr     $fc7a
        plx
        ply
        asl5
        tax
        iny
        lda     [$84],y
        sta     $cf57,x
        rts

; ---------------------------------------------------------------------------

; [  ]

_c1a497:
        phy
        jsr     $8d35       ; get target id
        phx
        jsr     $fc7a
        plx
        ply
        asl5
        tax
        iny
        lda     [$84],y
        sta     $cf58,x
        rts

; ---------------------------------------------------------------------------

; [  ]

_c1a4ae:
        iny
        lda     [$84],y
        sta     $d1ca
        rts

; ---------------------------------------------------------------------------

; [  ]

_c1a4b5:
        dec     $d1ca
        beq     @a4bd
        dey3
@a4bd:  rts

; ---------------------------------------------------------------------------

; [  ]

_c1a4be:
@a4be:  lda     $d1ba
        and     #$03
        bne     @a4ca
        lda     #$81
        sta     $d1bb
@a4ca:  rts

; ---------------------------------------------------------------------------

; [  ]

_c1a4cb:
        lda     #$ff
        sta     $d1bb
        rts

; ---------------------------------------------------------------------------

; [  ]

_c1a4d1:
        ldx     $d1a9
        stx     $d1b7
        ldx     $d1a4
        stx     $d1b2
        rts

; ---------------------------------------------------------------------------

; [  ]

_c1a4de:
        lda     $d1bc
        and     #$bf
        sta     $d1bc
        rts

; ---------------------------------------------------------------------------

; [  ]

_c1a4e7:
        iny
        lda     [$84],y
        asl
        tax
        lda     f:_c1a4fb,x
        sta     $80
        lda     f:_c1a4fb+1,x
        sta     $81
        jmp     ($0080)

; ---------------------------------------------------------------------------

_c1a4fb:
        .addr   $a57e,$a519,$a513,$a503

; ---------------------------------------------------------------------------

_c1a503:
        lda     #$0e
        sta     $af
        lda     #$08
        jsr     $a51d
        ldx     $af
        dex2
        stx     $af
        rts

; ---------------------------------------------------------------------------

_c1a513:
        stz     $af
        lda     #$10
        bra     _a51d

_c1a519:
        stz     $af
        lda     #$08
_a51d:  sta     $ae
        lda     $d1a9
        clc
        adc     $d1b2
        sta     $a6
        lda     $d1aa
        clc
        adc     $d1b3
        sta     $a7
        lda     $d1b7
        clc
        adc     $d1b2
        sec
        sbc     $ae
        sta     $a8
        lda     $d1c9
        beq     @a54b
        asl     $ae
        lda     $a8
        clc
        adc     $ae
        sta     $a8
@a54b:  lda     $d1b8
        clc
        adc     $d1b3
        clc
        adc     $af
        sta     $a9
        stz     $d1a6
        stz     $d1a7
        stz     $d1b4
        stz     $d1b5
        jsr     $0a6e
        jsr     $a570
        ldx     $d1a9
        stx     $d1b7
        rts

; ---------------------------------------------------------------------------

; [  ]

_c1a570:
@a570:  longa
        lda     $af
        clc
        adc     #$0009
        sta     $af
        shorta0
        rts

; ---------------------------------------------------------------------------

_c1a57e:
        lda     $d1a9
        clc
        adc     $d1a4
        sta     $a6
        lda     $d1aa
        clc
        adc     $d1a5
        sta     $a7
        lda     $d1b7
        clc
        adc     $d1a4
        sta     $a8
        lda     $d1b8
        clc
        adc     $d1a5
        adc     #$0c
        sta     $a9
        stz     $d1a6
        stz     $d1a7
        stz     $d1b4
        stz     $d1b5
        jsr     $0a6e
        jmp     _c1a570

; ---------------------------------------------------------------------------

; [  ]

_c1a5b6:
@a5b6:  lda     $af
        cmp     #$08
        bcc     @a5e8
        cmp     #$10
        bcc     @a5e4
        cmp     #$20
        bcc     @a5e0
        cmp     #$30
        bcc     @a5dc
        cmp     #$40
        bcc     @a5d8
        cmp     #$50
        bcc     @a5d4
        lda     #$08
        bra     @a5ea
@a5d4:  lda     #$07
        bra     @a5ea
@a5d8:  lda     #$06
        bra     @a5ea
@a5dc:  lda     #$05
        bra     @a5ea
@a5e0:  lda     #$04
        bra     @a5ea
@a5e4:  lda     #$03
        bra     @a5ea
@a5e8:  lda     #$02
@a5ea:  rts

; ---------------------------------------------------------------------------

; [  ]

_c1a5eb:
@a5eb:  lda     $d1b4
        tax
        stx     $80
        lda     $ae
        clc
        adc     #$40
        jsr     $0b59
        lda     a:$00a6
        longa
        clc
        adc     $84
        and     #$00ff
        tax
        shorta0
        txa
        sec
        sbc     $d1b2
        sta     $d1b7
        lda     $d1b4
        tax
        stx     $80
        lda     $ae
        jsr     $0b59
        lda     a:$00a7
        longa
        clc
        adc     $84
        and     #$00ff
        tax
        shorta0
        txa
        sec
        sbc     $d1b3
        sta     $d1b8
        rts

; ---------------------------------------------------------------------------

; [  ]

_c1a633:
@a633:  lda     $d1a6
        tax
        stx     $80
        lda     $ae
        clc
        adc     #$40
        jsr     $0b59
        lda     a:$00a6
        longa
        clc
        adc     $84
        and     #$00ff
        tax
        shorta0
        txa
        sec
        sbc     $d1a4
        sta     $d1a9
        lda     $d1a6
        tax
        stx     $80
        lda     $ae
        jsr     $0b59
        lda     a:$00a7
        longa
        clc
        adc     $84
        and     #$00ff
        tax
        shorta0
        txa
        sec
        sbc     $d1a5
        sta     $d1aa
        rts

; ---------------------------------------------------------------------------

_c1a67b:
        ldx     $7e
        phx
        ldx     $84
        phx
        lda     $d1ac
        lsr
        and     #$03
        sta     $d1ab
        jsr     $a633
        jsr     $a5b6
        sta     $80
        lda     $af
        clc
        adc     $80
        sta     $af
        lda     $d1a6
        sec
        sbc     $80
        sta     $d1a6
        bcc     @a6a6
        dey2
@a6a6:  plx
        stx     $84
        plx
        stx     $7e
        rts

; ---------------------------------------------------------------------------

_c1a6ad:
        ldx     $7e
        phx
        ldx     $84
        phx
        lda     $d1ac
        lsr
        and     #$03
        sta     $d1ab
        jsr     $a633
        jsr     $a5b6
        sta     $80
        lda     $af
        sec
        sbc     $80
        sta     $af
        bcc     @a6cf
        dey2
@a6cf:  lda     $d1a6
        clc
        adc     $80
        sta     $d1a6
        plx
        stx     $84
        plx
        stx     $7e
        rts

; ---------------------------------------------------------------------------

_c1a6df:
        ldx     $7e
        phx
        ldx     $84
        phx
        lda     $d1ac
        and     #$01
        sta     $d1ab
        jsr     $a633
        lda     #$0a
        sta     $80
        lda     $af
        sec
        sbc     $80
        sta     $af
        bcc     @a6ff
        dey2
@a6ff:  lda     $d1a6
        clc
        adc     $80
        sta     $d1a6
        plx
        stx     $84
        plx
        stx     $7e
        rts

; ---------------------------------------------------------------------------

_c1a70f:
        ldx     $7e
        phx
        ldx     $84
        phx
        jsr     $a5eb
        lda     #$0a
        sta     $80
        lda     $af
        sec
        sbc     $80
        sta     $af
        bcc     @a727
        dey2
@a727:  lda     $d1b4
        clc
        adc     $80
        sta     $d1b4
        plx
        stx     $84
        plx
        stx     $7e
        rts

; ---------------------------------------------------------------------------

_c1a737:
        ldx     $7e
        phx
        ldx     $84
        phx
        lda     $d1ba
        and     #$04
        lsr2
        sta     $d1b9
        jsr     $a4be
        jsr     $a5eb
        lda     #$04
        sta     $80
        lda     $af
        sec
        sbc     $80
        sta     $af
        bcc     @a75c
        dey2
@a75c:  lda     $d1b4
        clc
        adc     $80
        sta     $d1b4
        lda     #$10
        sta     $80
        lda     $d1ba
        asl4
        jsr     $0a00
        clc
        adc     $d1b8
        sta     $d1b8
        lda     #$10
        sta     $80
        lda     $d1ba
        clc
        adc     #$40
        asl4
        jsr     $0a00
        clc
        adc     $d1b7
        plx
        stx     $84
        plx
        stx     $7e
        rts

; ---------------------------------------------------------------------------

_c1a796:
@a796:  phy
        jsr     $8d2f       ; get attacker id
        ply
        asl5
        tax
        iny
        lda     [$84],y
        rts

; ---------------------------------------------------------------------------

_c1a7a5:
        jsr     $a796
        sta     $cf58,x
        rts

; ---------------------------------------------------------------------------

_c1a7ac:
        jsr     $a796
        sta     $cf57,x
        rts

; ---------------------------------------------------------------------------

_c1a7b3:
        iny
        lda     $7e
        tax
        lda     [$84],y
        sta     $d189,x
        rts

; ---------------------------------------------------------------------------

_c1a7bd:
        lda     $7e
        tax
        stz     $d1a0,x
        rts

; ---------------------------------------------------------------------------

; [  ]

_c1a7c4:
        iny
        lda     [$84],y
        lsr4
        and     #$fe
        tax
        lda     f:_c1a7e7,x
        sta     $80
        lda     f:_c1a7e7+1,x
        sta     $81
        lda     [$84],y
        and     #$1f
        inc
        sta     $82
        lda     $7e
        tax
        jmp     ($0080)

; ---------------------------------------------------------------------------

_c1a7e7:
        .addr   $a7f7,$a7fd,$a800,$a806,$a809,$a80c,$a812,$a815

; ---------------------------------------------------------------------------

_c1a7f7:
        jsr     $a825
        jmp     _c1a82f

; ---------------------------------------------------------------------------

_c1a7fd:
        jmp     _c1a82f

; ---------------------------------------------------------------------------

_c1a800:
        jsr     $a81b
        jmp     _c1a82f

; ---------------------------------------------------------------------------

_c1a806:
        jmp     _c1a825

; ---------------------------------------------------------------------------

_c1a809:
        jmp     _c1a81b

; ---------------------------------------------------------------------------

_c1a80c:
        jsr     $a825
        jmp     _c1a839

; ---------------------------------------------------------------------------

_c1a812:
        jmp     _c1a839

; ---------------------------------------------------------------------------

_c1a815:
        jsr     $a81b
        jmp     _c1a839

; ---------------------------------------------------------------------------

_c1a81b:
@a81b:  lda     $d1a4,x
        clc
        adc     $82
        sta     $d1a4,x
        rts

; ---------------------------------------------------------------------------

_c1a825:
@a825:  lda     $d1a4,x
        sec
        sbc     $82
        sta     $d1a4,x
        rts

; ---------------------------------------------------------------------------

_c1a82f:
@a82f:  lda     $d1a5,x
        clc
        adc     $82
        sta     $d1a5,x
        rts

; ---------------------------------------------------------------------------

_c1a839:
@a839:  lda     $d1a5,x
        sec
        sbc     $82
        sta     $d1a5,x
        rts

; ---------------------------------------------------------------------------

_c1a843:
        .byte   $5e,$54,$4a,$40

; ---------------------------------------------------------------------------

; [ load attack animation properties ]

_c1a847:
@a847:  stx     $7e
        ldx     #$0005      ; get pointer to animation properties
        stx     $80
        jsr     $fe67       ; ++$82 = +$7e * +$80
        ldx     $82
        lda     $d838ec,x   ; graphics type

; type 0: spell 1
        and     #$e0
        bne     @a866
        and     #$1f
        lda     $d838ec,x   ; graphics index
        jsr     $aabe       ; load spell 1 graphics
        bra     @a8ba

; type 1: spell 2
@a866:  cmp     #$20
        bne     @a875
        lda     $d838ec,x
        and     #$1f
        jsr     $aace       ; load spell 2 graphics
        bra     @a8ba

; type 2: spell 3
@a875:  cmp     #$40
        bne     @a884
        lda     $d838ec,x
        and     #$1f
        jsr     $aade       ; load spell 3 graphics
        bra     @a8ba

; type 3: weapon hit
@a884:  cmp     #$60
        bne     @a893
        lda     $d838ec,x
        and     #$1f
        jsr     $aa9e       ; load weapon hit graphics
        bra     @a8ba

; type 4: animals
@a893:  cmp     #$80
        bne     @a8ba
        lda     $d838ec,x
        and     #$1f
        jsr     $aaee       ; load animals graphics
        lda     $d838ed,x   ; palette index
        and     #$7f
        ldy     #$0140
        jsr     $aa3e       ; load attack palette (16-colors)
        lda     $d838ed,x   ; palette index
        and     #$7f
        ldy     #$0160
        jsr     $aa3e       ; load attack palette (16-colors)
        bra     @a8d2

; type 5, 6, 7: no graphics
@a8ba:  lda     $d838ed,x   ; palette index
        and     #$7f
        ldy     #$0140
        jsr     _c1aa1d       ; load attack palette (8-colors)
        lda     $d838ed,x   ; palette index
        and     #$7f
        ldy     #$0160
        jsr     _c1aa1d       ; load attack palette (8-colors)
@a8d2:  lda     $d838ee,x   ; script
        sta     $f586
        lda     $d838ed,x   ; msb of byte 1
        lsr7
        sta     $f587
        lda     $d838ef,x   ; init function
        sta     $f582
        lda     $d838f0,x   ; sound effect
        sta     $f583
        stz     $db3c
        stz     $db3d
        rts

; ---------------------------------------------------------------------------

; [  ]

_c1a8fc:
@a8fc:  phx
        sta     $7e
        lda     #$09
        sta     $80
        jsr     $feba       ; +$82 = $7e * $80
        ldx     $82
        lda     $d9985b,x
        and     #$20
        beq     @a91d
        lda     $71
        beq     @a915
        inx
@a915:  lda     $d9985c,x
        plx
        jmp     _c1a8fc
@a91d:  lda     ($eb)
        and     #$01
        beq     @a93f       ; branch if not a monster special attack
        lda     ($eb)
        and     #$fe
        sta     ($eb)
        jsr     $8d53       ; get graphics script parameter 4
        and     #$80
        sta     ($e7),y
        lda     ($eb)
        and     #$40
        beq     @a939
        clr_a
        bra     @a93b
@a939:  lda     #$a6
@a93b:  plx
        jmp     _c1a8fc
@a93f:  lda     $70
        beq     @a94f
        stz     $70
        lda     $d9985d,x
        beq     @a94f
        plx
        jmp     _c1a8fc
@a94f:  jsr     $8d53       ; get graphics script parameter 4
        and     #$7f
        beq     @a96b
        clc
        adc     #$8d
        sta     $7e
        lda     #$09
        sta     $80
        phx
        jsr     $feba       ; +$82 = $7e * $80
        ldx     $82
        jsr     $a9d5
        plx
        bra     @a987
@a96b:  lda     ($f0)       ; block type
        beq     @a984
        clc
        adc     #$9f
        sta     $7e
        lda     #$09
        sta     $80
        phx
        jsr     $feba       ; +$82 = $7e * $80
        ldx     $82
        jsr     $a9b5       ; load alt. weapon graphics
        plx
        bra     @a987
@a984:  jsr     $a9d5
@a987:  jsr     $a992       ; load weapon graphics
        plx
        stz     $db3c
        stz     $db3d
        rts

; ---------------------------------------------------------------------------

; [ load weapon graphics ]

_c1a992:
@a992:  lda     $d99855,x
        jsr     $aa8e       ; load weapon graphics
        lda     $d99856,x
        ldy     #$0140
        jsr     _c1aa1d       ; load attack palette (8-colors)
        lda     $d9985b,x
        sta     $f582
        lda     $d99857,x   ; animation script
        sta     $f586
        stz     $f587
        rts

; ---------------------------------------------------------------------------

; [ load alt. weapon graphics ]

_c1a9b5:
@a9b5:  lda     $d99858,x
        jsr     $aaae       ; load alt. weapon graphics
        lda     $d99859,x
        ldy     #$0160
        jsr     _c1aa1d       ; load attack palette (8-colors)
        lda     $d9985a,x
        sta     $f585
        lda     $d9985c,x   ; sound effect
        sta     $f583
        rts

; ---------------------------------------------------------------------------

; [ load weapon hit graphics ]

_c1a9d5:
@a9d5:  lda     $7bfd
        beq     @a9fd       ; branch if no sword slap
        lda     $d99858
        jsr     $aa9e       ; load weapon hit graphics
        lda     $d99859
        ldy     #$0160
        jsr     _c1aa1d       ; load attack palette (8-colors)
        lda     $d9985a
        sta     $f585
        lda     $d9985c     ; sound effect
        sta     $f583
        stz     $7bfd
        rts
@a9fd:  lda     $d99858,x
        jsr     $aa9e       ; load weapon hit graphics
        lda     $d99859,x
        ldy     #$0160
        jsr     _c1aa1d       ; load attack palette (8-colors)
        lda     $d9985a,x
        sta     $f585
        lda     $d9985c,x   ; sound effect
        sta     $f583
        rts

; ---------------------------------------------------------------------------

; [ load attack palette (8-colors) ]

_c1aa1d:
@aa1d:  phx
        longa
        asl4
        tax
        shorta0
        lda     #$10
        sta     $70
@aa2c:  lda     $d1a3a0,x   ; load 8-color palette
        sta     $7e09,y
        sta     $7e19,y
        inx
        iny
        dec     $70
        bne     @aa2c
        plx
        rts

; ---------------------------------------------------------------------------

; [ load attack palette (16-colors) ]

_c1aa3e:
@aa3e:  phx
        longa
        asl4
        tax
        shorta0
        lda     #$20
        sta     $70
@aa4d:  lda     $d1a3a0,x   ; load 16-color palette
        sta     $7e09,y
        inx
        iny
        dec     $70
        bne     @aa4d
        plx
        rts

; ---------------------------------------------------------------------------

; [ init tile pointers (3bpp) ]

_c1aa5c:
@aa5c:  pha
        clr_ax
        longa
@aa61:  sta     $7fc000,x
        clc
        adc     #$0018
        inx2
        cpx     #$0800
        bne     @aa61
        shorta0
        pla
        rts

; ---------------------------------------------------------------------------

; [ init tile pointers (4bpp) ]

_c1aa75:
@aa75:  pha
        clr_ax
        longa
@aa7a:  sta     $7fc000,x
        clc
        adc     #$0020
        inx2
        cpx     #$0800
        bne     @aa7a
        shorta0
        pla
        rts

; ---------------------------------------------------------------------------

; [ load weapon graphics ]

_c1aa8e:
@aa8e:  phx
        pha
        lda     #$01
        jsr     $aafe       ; load attack graphics pointers (weapons)
        jsr     $aa5c       ; init tile pointers (3bpp)
        pla
        jsr     $ab1a
        plx
        rts

; ---------------------------------------------------------------------------

; [ load weapon hit graphics ]

_c1aa9e:
@aa9e:  phx
        pha
        lda     #$02
        jsr     $aafe       ; load attack graphics pointers (weapon hits)
        jsr     $aa5c       ; init tile pointers (3bpp)
        pla
        jsr     $ab1a
        plx
        rts

; ---------------------------------------------------------------------------

; [ load alt. weapon graphics ]

_c1aaae:
@aaae:  phx
        pha
        lda     #$06
        jsr     $aafe       ; load attack graphics pointers (weapons alt.)
        jsr     $aa5c       ; init tile pointers (3bpp)
        pla
        jsr     $ab1a
        plx
        rts

; ---------------------------------------------------------------------------

; [ load spell 1 graphics ]

_c1aabe:
@aabe:  phx
        pha
        lda     #$00
        jsr     $aafe       ; load attack graphics pointers (spells 1)
        jsr     $aa5c       ; init tile pointers (3bpp)
        pla
        jsr     $ab1a
        plx
        rts

; ---------------------------------------------------------------------------

; [ load spell 2 graphics ]

_c1aace:
@aace:  phx
        pha
        lda     #$03
        jsr     $aafe       ; load attack graphics pointers (spells 2)
        jsr     $aa5c       ; init tile pointers (3bpp)
        pla
        jsr     $ab1a
        plx
        rts

; ---------------------------------------------------------------------------

; [ load spell 3 graphics ]

_c1aade:
@aade:  phx
        pha
        lda     #$04
        jsr     $aafe       ; load attack graphics pointers (spells 3)
        jsr     $aa5c       ; init tile pointers (3bpp)
        pla
        jsr     $ab1a
        plx
        rts

; ---------------------------------------------------------------------------

; [ load animals graphics ]

_c1aaee:
@aaee:  phx
        pha
        lda     #$05
        jsr     $aafe       ; load attack graphics pointers (animals)
        jsr     $aa75       ; init tile pointers (4bpp)
        pla
        jsr     $abd7
        plx
        rts

; ---------------------------------------------------------------------------

; [ load attack graphics pointers ]

; a: 0 = spells 1, 1 = weapon, 2 = weapon hits,
;    3 = spells 2, 4 = spells 3, 5 = animals, 6 = weapons alt.

_c1aafe:
@aafe:  sta     $7e
        lda     #$0c
        sta     $80
        jsr     $feba       ; +$82 = $7e * $80
        ldx     $82
        clr_ay
@ab0b:  lda     $d0df68,x   ; copy 12 bytes
        sta     a:$0070,y
        inx
        iny
        cpy     #$000c
        bne     @ab0b
        rts

; ---------------------------------------------------------------------------

; [ load attack graphics (3bpp) ]

_c1ab1a:
@ab1a:  longa
        asl6
        clc
        adc     $70
        sta     $70
        lda     $7a
        pha
        lda     $76
        sta     $80         ; graphics bank
        lda     #$d000
        sta     $82
        lda     #$007f
        sta     $84
@ab38:  lda     [$70]       ; tilemap value (vhtttttt)
        xba
        pha
        pha
        and     #$3fff      ; tile index
        asl
        tax
        and     #$07ff
        lda     $7fc000,x   ; tile pointer
        clc
        adc     $74
        sta     $7e         ; graphics address
        pla
        and     #$4000      ; h-flip
        sta     $86
        pla
        and     #$8000      ; v-flip
        bne     @ab84

; no v-flip
        clr_ay
@ab5c:  lda     [$7e]       ; get word (first 2 bitplanes)
        jsr     $ac91       ; flip horizontally
        sta     [$82],y     ; copy to ram buffer
        inc     $7e
        inc     $7e
        iny2
        cpy     #$0010
        bne     @ab5c
@ab6e:  lda     [$7e]       ; get byte (3rd bitplane)
        jsr     $ac91       ; flip horizontally
        and     #$00ff
        sta     [$82],y
        inc     $7e
        iny2
        cpy     #$0020
        bne     @ab6e
        jmp     @abaf

; v-flip
@ab84:  ldy     #$000e
@ab87:  lda     [$7e]
        jsr     $ac91       ; flip horizontally
        sta     [$82],y
        inc     $7e
        inc     $7e
        dey2
        cpy     #$fffe
        bne     @ab87
        ldy     #$001e
@ab9c:  lda     [$7e]
        jsr     $ac91       ; flip horizontally
        and     #$00ff
        sta     [$82],y
        inc     $7e
        dey2
        cpy     #$000e
        bne     @ab9c
@abaf:  lda     $82         ; next tile
        clc
        adc     #$0020
        sta     $82
        inc     $70
        inc     $70
        dec     $7a
        jne     @ab38
        pla                 ; copy tile to vram
        asl5
        sta     $70
        shorta0
        ldx     #$d000
        lda     #$7f
        ldy     $78
        jmp     _c1fd27

; ---------------------------------------------------------------------------

; [ [ load attack graphics (4bpp) ]

_c1abd7:
@abd7:  longa
        asl6
        clc
        adc     $70
        sta     $70
        lda     $7a
        pha
        lda     $76         ; tile graphics bank
        sta     $80
        lda     #$d000      ; graphics buffer address
        sta     $82
        lda     #$007f      ; graphics buffer bank
        sta     $84
@abf5:  lda     [$70]       ; tilemap value (vhtttttt)
        xba
        pha
        pha
        and     #$3fff      ; tile index
        asl
        and     #$07ff
        tax
        lda     $7fc000,x   ; tile pointer
        clc
        adc     $74         ; tile offset
        sta     $7e
        pla
        and     #$4000      ; h-flip
        sta     $86
        pla
        and     #$8000      ; v-flip
        bne     @ac3f
        tay
@ac18:  lda     [$7e]
        jsr     $ac91       ; flip horizontally
        sta     [$82],y
        inc     $7e
        inc     $7e
        iny2
        cpy     #$0010
        bne     @ac18
@ac2a:  lda     [$7e]
        jsr     $ac91       ; flip horizontally
        sta     [$82],y
        inc     $7e
        inc     $7e
        iny2
        cpy     #$0020
        bne     @ac2a
        jmp     @ac69
@ac3f:  ldy     #$000e
@ac42:  lda     [$7e]
        jsr     $ac91       ; flip horizontally
        sta     [$82],y
        inc     $7e
        inc     $7e
        dey2
        cpy     #$fffe
        bne     @ac42
        ldy     #$001e
@ac57:  lda     [$7e]
        jsr     $ac91       ; flip horizontally
        sta     [$82],y
        inc     $7e
        inc     $7e
        dey2
        cpy     #$000e
        bne     @ac57
@ac69:  lda     $82
        clc
        adc     #$0020
        sta     $82
        inc     $70
        inc     $70
        dec     $7a
        jne     @abf5
        pla
        asl5
        sta     $70
        shorta0
        ldx     #$d000
        lda     #$7f
        ldy     $78
        jmp     _c1fd27

; ---------------------------------------------------------------------------

; [ flip horizontally ]

_c1ac91:
@ac91:  pha
        lda     $86         ; return if no horizontal flip
        beq     @aca6
        pla
        xba
        sta     $7c
        phx
        ldx     #$0010
@ac9e:  asl     $7c
        ror
        dex
        bne     @ac9e
        plx
        rts
@aca6:  pla
        rts

; ---------------------------------------------------------------------------

; [  ]

_c1aca8:
        clr_ax
@acaa:  lda     $db80,x
        beq     @ace1
        txa
        asl
        tay
        longa
        lda     $db88,y
        sta     f:$002116
        lda     $f87c,y
        bne     @acc2
        bra     @acde
@acc2:  lda     $f87c,y
        and     #$00ff
        inc
        ora     #$3c00
        sta     f:$002118
        lda     $f87d,y
        and     #$00ff
        inc
        ora     #$3c00
        sta     f:$002118
@acde:  shorta0
@ace1:  inx
        cpx     #$0008
        bne     @acaa
        rts

; ---------------------------------------------------------------------------

_c1ace8:
@ace8:  phx
        phy
        sty     $72
        tyx
        lda     $72
        asl
        tay
        lda     $d016,x
        clc
        adc     $d006,x
        dec
        sta     $72
        stz     $73
        lda     $cffe,x
        lsr
        dec
        clc
        adc     $d00e,x
        sta     $74
        lda     $f6
        beq     @ad13
        lda     #$1e
        sec
        sbc     $74
        sta     $74
@ad13:  stz     $75
        longa
        lda     $72
        asl5
        clc
        adc     $74
        adc     #$5800
        sta     $db88,y
        shorta0
        ply
        plx
        rts

; ---------------------------------------------------------------------------

; [  ]

_c1ad2d:
@ad2d:  clr_axy
        stz     $70
        lda     $de
        sta     $71
@ad36:  asl     $71
        bcc     @ad55
        lda     $7b9e,x
        and     #$c0
        bne     @ad55
        lda     $7ba1,x
        and     #$10
        beq     @ad55
        jsr     $afe0
        jsr     $ace8
        lda     #$01
        sta     $db80,y
        bra     @ad59
@ad55:  clr_a
        sta     $db80,y
@ad59:  iny
        inx4
        cpx     #$0020
        bne     @ad36
        rts

; ---------------------------------------------------------------------------

_c1ad64:
        clr_axy
        stz     $70
        stz     $72
@ad6b:  lda     $7b9e,x
        asl
        rol     $70
        lda     $7ba1,x
        asl
        rol     $72
        iny
        inx4
        cpx     #$0020
        bne     @ad6b
        lda     $70
        ora     $72
        sta     $70
        lda     $70
        pha
        and     $de
        beq     @ad93
        sta     $70
        jsr     $768d
@ad93:  pla
        eor     #$ff
        sta     $70
        lda     $de
        eor     #$ff
        and     $70
        beq     @ada5
        sta     $70
        jsr     $75d7
@ada5:  clr_ax
@ada7:  lda     $7b9e,x
        and     #$30
        sta     $70
        lda     $7bbe,x
        and     #$30
        cmp     $70
        bne     @ade2
        lda     $7b9f,x
        and     #$10
        sta     $70
        lda     $7bbf,x
        and     #$10
        cmp     $70
        bne     @ade2
        lda     $7ba1,x
        and     #$20
        sta     $70
        lda     $7bc1,x
        and     #$20
        cmp     $70
        bne     @ade2
        inx4
        cpx     #$0020
        bne     @ada7
        bra     @ae22
@ade2:  clr_ayx
@ade5:  lda     $7b9f,y
        and     #$10
        lsr4
        sta     $70
        lda     $7ba1,y
        and     #$20
        lsr5
        ora     $70
        sta     $70
        lda     $db9c,x
        and     #$02
        beq     @ae0b
        lda     $70
        eor     #$01
        sta     $70
@ae0b:  lda     $db9c,x
        and     #$fe
        ora     $70
        sta     $db9c,x
        inx
        iny4
        cpx     #$0008
        bne     @ade5
        jsr     $1cb8
@ae22:  clr_axy
@ae25:  lda     $7b9e,y
        and     #$30
        beq     @ae39
        lda     $cffe,x
        asl2
        sec
        sbc     #$0c
        sta     $d096,x
        bra     @ae3c
@ae39:  stz     $d096,x
@ae3c:  iny4
        inx
        cpx     #$0008
        bne     @ae25
        jmp     @ae49
@ae49:  clr_ax
@ae4b:  lda     $7b9e,x
        sta     $7bbe,x
        inx
        cpx     #$0020
        bne     @ae4b
        rts

; ---------------------------------------------------------------------------

_c1ae58:
@ae58:  phy
        phx
@ae5a:  phx
        jsr     $02f2       ; wait one frame
        plx
        dex
        bne     @ae5a
        plx
        ply
        rts

; ---------------------------------------------------------------------------

_c1ae65:
@ae65:  phx
        phy
        phx
        txa
        asl5
        tay
        lda     #$01
        sta     $cf61,y
        ldx     #$0010
        jsr     $ae58
        clr_a
        sta     $cf58,y
        sta     $cf57,y
        plx
        txa
        sta     $7a
        jsr     $b09f
        txa
        jsr     $af05
        jsr     $aed7
        ldx     #$0010
        jsr     $ae58
        clr_a
        sta     $cf61,y
        ply
        plx
        rts

; ---------------------------------------------------------------------------

_c1ae9c:
@ae9c:  clr_ax
@ae9e:  stz     $d1cf,x
        lda     $d1cb,x
        bne     @aecd
        txa
        asl2
        tay
        lda     $7b7e,y
        bmi     @aeb9
        lda     $7b8e,y
        bpl     @aec3
        jsr     $ae65
        bra     @aecd
@aeb9:  lda     $7b8e,y
        bmi     @aec3
        jsr     $ae65
        bra     @aecd
@aec3:  txa
        sta     $7a
        jsr     $b09f
        txa
        jsr     $af05
@aecd:  jsr     $aed7
        inx
        cpx     #$0004
        bne     @ae9e
        rts

; ---------------------------------------------------------------------------

_c1aed7:
@aed7:  phy
        txa
        asl2
        tay
        lda     $7b7e,y
        sta     $7b8e,y
        lda     $7b7f,y
        sta     $7b8f,y
        lda     $7b80,y
        sta     $7b90,y
        lda     $7b81,y
        sta     $7b91,y
        ply
        rts

; ---------------------------------------------------------------------------

_c1aef6:
        jmp     _c1ae9c

; ---------------------------------------------------------------------------

_c1aef9:
@aef9:  tax
        asl5
        tay
        sta     $74
        stz     $75
        rts

; ---------------------------------------------------------------------------

; [  ]

_c1af05:
@af05:  phx
        phy
        jsr     $aef9
        lda     $cf43,y
        bne     @af1e
        lda     $cf53,y
        bne     @af1e
        txa
        asl2
        tax
        jsr     $af21       ; update character status animation
        jsr     $b01a       ; update character status sprite
@af1e:  ply
        plx
        rts

; ---------------------------------------------------------------------------

; [ update character status animation ]

_c1af21:
@af21:  lda     $7b7e,x
        and     #$80
        beq     @af2c       ; branch if not dead
        lda     #$08
        bra     @af72
@af2c:  lda     $7b7e,x
        and     #$40
        beq     @af37       ; branch if not stone
        lda     #$03
        bra     @af72
@af37:  lda     $7b7e,x
        and     #$02
        beq     @af40       ; branch if not zombie
        bra     @af6c
@af40:  lda     $7b7e,x
        and     #$44
        beq     @af4b       ; branch if not poison ???
        lda     #$03
        bra     @af72
@af4b:  lda     $7b7f,x
        and     #$60
        beq     @af56       ; branch if not paralyzed or sleeping
        lda     #$03
        bra     @af72
@af56:  lda     $7b81,x
        and     #$02
        beq     @af61       ; branch if not low hp
        lda     #$03
        bra     @af72
@af61:  lda     $7b81,x
        and     #$04
        beq     @af6c       ; branch if not singing
        lda     #$09
        bra     @af72
@af6c:  clr_a
        sta     $cf4d,y
        bra     @af83
@af72:  pha
        jsr     $b087       ; check if character is selected
        bcc     @af7b
        pla
        bra     @af6c
@af7b:  pla
        sta     $cf4d,y
        clr_a
        sta     $cf58,y
@af83:  lda     $7b7e,x
        and     #$20
        beq     @af8e       ; branch if not toad
        lda     #$01
        bra     @af9a
@af8e:  lda     $7b7e,x
        and     #$10
        beq     @af99       ; branch if not mini
        lda     #$02
        bra     @af9a
@af99:  clr_a
@af9a:  sta     $cf47,y     ; graphics
        lda     $7b7f,x
        and     #$03
        sta     $cf5a,y     ; image charges
        lda     $7b7e,x
        and     #$08
        sta     $cf59,y     ; float
        lda     $7b81,x
        bpl     @afc3       ; branch if not erased
        lda     $cf62,y
        ora     #$80
        sta     $cf62,y
        lda     $cf43,y
        ora     #$80
        sta     $cf43,y
        rts
@afc3:  lda     $cf62,y
        and     #$7f
        sta     $cf62,y
        lda     $cf43,y
        and     #$7f
        sta     $cf43,y
        rts

; ---------------------------------------------------------------------------

_c1afd4:
        .byte   $00,$0b,$16,$21,$2c,$37,$42,$4d,$58,$63,$6e,$79

; ---------------------------------------------------------------------------

; [  ]

_c1afe0:
@afe0:  phx
        txa
        clc
        adc     #$10
        tax
        jsr     $afeb
        plx
        rts

; ---------------------------------------------------------------------------

; [  ]

_c1afeb:
@afeb:  phx
        txa
        lsr
        sta     $74
        lsr
        tax
        lda     f:_c1afd4,x
        tax
        stz     $72
        lda     $3d78,x
@affc:  sec
        sbc     #$0a
        bcc     @b006
        inc     $72
        jmp     @affc
@b006:  clc
        adc     #$0a
        sta     $73
        lda     $74
        tax
        lda     $72
        sta     $f874,x
        lda     $73
        sta     $f875,x
        plx
        rts

; ---------------------------------------------------------------------------

; [ update character status sprite ]

_c1b01a:
@b01a:  phy
        phx
        lda     $7a
        tay
        lda     $7b7e,x     ; character status
        and     #$80
        bne     @b076       ; branch if dead
        lda     $7b81,x
        and     #$10
        beq     @b034       ; branch if not condemned
        jsr     $afeb       ;
        lda     #$08
        bra     @b077
@b034:  lda     $7b7e,x
        and     #$08
        beq     @b03f       ; branch if not float
        lda     #$06
        bra     @b077
@b03f:  lda     $7b7e,x
        and     #$01
        beq     @b04a       ; branch if not blind
        lda     #$02
        bra     @b077
@b04a:  lda     $7b7f,x
        and     #$40
        beq     @b055       ; branch if not sleeping
        lda     #$03
        bra     @b077
@b055:  lda     $7b7f,x
        and     #$20
        beq     @b060       ; branch if not paralyzed
        lda     #$04
        bra     @b077
@b060:  lda     $7b7f,x
        and     #$10
        beq     @b06b       ; branch if not charmed
        lda     #$05
        bra     @b077
@b06b:  lda     $7b7f,x
        and     #$04
        beq     @b076       ; branch if not mute
        lda     #$01
        bra     @b077
@b076:  clr_a
@b077:  sta     $d1cf,y
        jsr     $b087       ; check if character is selected
        bcc     @b084
        lda     #$07        ; show selected indicator
        sta     $d1cf,y
@b084:  plx
        ply
        rts

; ---------------------------------------------------------------------------

; [ check if character is selected ]

_c1b087:
@b087:  lda     $cd40
        bne     @b09d
        lda     $41b0
        and     #$01
        beq     @b09d
        txa
        lsr2
        cmp     $cd42
        bne     @b09d
        sec
        rts
@b09d:  clc
        rts

; ---------------------------------------------------------------------------

; [  ]

_c1b09f:
@b09f:  phx
        phy
        tax
        longa
        asl5
        tay
        sta     $74
        shorta0
        lda     $cf43,y
        bne     @b103
        lda     $cf53,y
        bne     @b103
        txa
        sta     $70
        asl2
        tay
        lda     $7b7e,y
        and     #$c0
        bne     @b103
        lda     $d1bd,x
        beq     @b0e9
        lda     $7b7f,y
        and     #$10
        bne     @b103
        stz     $d1bd,x
        jsr     $b106
        ora     #$80
        sta     $cf54,y
        lda     #$02
        sta     $cf4d,y
        lda     #$01
        sta     $cf53,y
        bra     @b103
@b0e9:  lda     $7b7f,y
        and     #$10
        beq     @b103
        inc     $d1bd,x
        jsr     $b106
        sta     $cf54,y
        lda     #$02
        sta     $cf4d,y
        lda     #$01
        sta     $cf53,y
@b103:  ply
        plx
        rts

; ---------------------------------------------------------------------------

_c1b106:
@b106:  ldy     $74
        lda     $70
        tax
        lda     $db4a,x
        beq     @b114
        lda     #$30
        bra     @b116
@b114:  lda     #$20
@b116:  rts

; ---------------------------------------------------------------------------

_c1b117:
        clr_ax
@b119:  lda     $7b7e,x
        sta     $7b8e,x
        inx
        cpx     #$0010
        bne     @b119
        rts

; ---------------------------------------------------------------------------

_c1b126:
        .byte   $00,$20,$40,$60

; ---------------------------------------------------------------------------

_c1b12a:
        clr_ax
@b12c:  phx
        lda     f:_c1b126,x
        tay
        sty     $8c
        lda     $cf43,y
        bne     @b140
        txa
        asl2
        tax
        jsr     $b1ac
@b140:  plx
        inx
        cpx     #$0004
        bne     @b12c
        jsr     $b181
        lda     $f8c3
        and     #$01
        beq     @b169
        longa
        lda     $7f37
        sec
        sbc     #$0421
        sta     $7f37
        cmp     #$2108
        bne     @b165
        inc     $f8c3
@b165:  shorta0
        rts
@b169:  longa
        lda     $7f37
        clc
        adc     #$0421
        sta     $7f37
        cmp     #$7fff
        bne     @b17d
        inc     $f8c3
@b17d:  shorta0
        rts

; ---------------------------------------------------------------------------

_c1b181:
@b181:  clr_ax
@b183:  lda     $db43,x
        beq     @b1a5
        lda     f:_c1b126,x
        tay
        phx
        clr_ax
        longa
@b192:  lda     $f849,x
        sta     $7f89,y
        inx2
        iny2
        cpx     #$0020
        bne     @b192
        shorta0
        plx
@b1a5:  inx
        cpx     #$0004
        bne     @b183
        rts

; ---------------------------------------------------------------------------

_c1b1ac:
@b1ac:  phy
        lda     #$20
        sta     $88
        lda     $7b8e,x
        sta     $8a
        lda     $7b8f,x
        sta     $8b
        lda     $7b90,x
        sta     $8c
        lda     $8a
        bpl     @b1d1
@b1c4:  lda     $ecf6,y
        sta     $7f89,y
        iny
        dec     $88
        bne     @b1c4
        bra     @b1dc
@b1d1:  lda     $ed76,y
        sta     $7f89,y
        iny
        dec     $88
        bne     @b1d1
@b1dc:  ply
        lda     $8a
        beq     @b1f5
        and     #$40
        beq     @b1ea
        jsr     $b266
        bra     @b216
@b1ea:  lda     $8a
        and     #$02
        beq     @b1f5
        jsr     $b2c1
        bra     @b216
@b1f5:  lda     $8a
        and     #$04
        beq     @b200
        jsr     $b282
        bra     @b216
@b200:  lda     $8b
        beq     @b216
        and     #$80
        beq     @b20d
        jsr     $b294
        bra     @b216
@b20d:  lda     $8b
        and     #$08
        beq     @b216
        jsr     $b2af
@b216:  lda     $8c
        beq     @b265
        and     #$80
        beq     @b224
        clr_a
        jsr     $b2d9
        bra     @b265
@b224:  lda     $8c
        and     #$40
        beq     @b231
        lda     #$01
        jsr     $b2d9
        bra     @b265
@b231:  lda     $8c
        and     #$20
        beq     @b23e
        lda     #$02
        jsr     $b2d9
        bra     @b265
@b23e:  lda     $8c
        and     #$10
        beq     @b24b
        lda     #$03
        jsr     $b2d9
        bra     @b265
@b24b:  lda     $8c
        and     #$08
        beq     @b258
        lda     #$04
        jsr     $b2d9
        bra     @b265
@b258:  lda     $8c
        and     #$04
        beq     @b265
        lda     #$05
        jsr     $b2d9
        bra     @b265
@b265:  rts

; ---------------------------------------------------------------------------

; [  ]

_c1b266:
@b266:  phy
        phx
        longa
        clr_ax
@b26c:  lda     $d99835,x
        sta     $7f89,y
        iny2
        inx2
        cpx     #$0020
        bne     @b26c
        shorta0
        plx
        ply
        rts

; ---------------------------------------------------------------------------

_c1b282:
@b282:  longa
        lda     #$7edb
        sta     $7f91,y
        lda     #$4dd3
        sta     $7f99,y
        shorta0
        rts

; ---------------------------------------------------------------------------

_c1b294:
@b294:  longa
        lda     #$00ff
        lda     #$5294
        sta     $7f93,y
        lda     #$4210
        sta     $7f9b,y
        lda     #$7fff
        sta     $7f9d,y
        shorta0
        rts

; ---------------------------------------------------------------------------

_c1b2af:
@b2af:  longa
        lda     #$013f
        sta     $7f91,y
        lda     #$001f
        sta     $7f99,y
        shorta0
        rts

; ---------------------------------------------------------------------------

_c1b2c1:
@b2c1:  longa
        lda     #$3af5
        sta     $7f91,y
        lda     #$3210
        sta     $7f99,y
        lda     #$7fff
        sta     $7f8f,y
        shorta0
        rts

; ---------------------------------------------------------------------------

_c1b2d9:
@b2d9:  phx
        sta     $88
        lda     $a2
        and     #$02
        bne     @b2f2
        lda     $88
        longa
        asl
        tax
        lda     f:_c1b2f4,x
        sta     $7f8b,y
        shorta0
@b2f2:  plx
        rts

; ---------------------------------------------------------------------------

_c1b2f4:
        .word   $6a60,$031f,$0b64,$001a,$017f,$7fff

; ---------------------------------------------------------------------------

; [  ]

_c1b300:
@b300:  jsr     $1cb8
        stz     $db55
        stz     $db56
        stz     $db57
        stz     $db43
        stz     $db44
        stz     $db45
        stz     $db46
        stz     $db5d
        rts

; ---------------------------------------------------------------------------

; animation frame sizes (width then height)
_c1b31c:
        .byte   $03,$03 ; $00
        .byte   $02,$04
        .byte   $07,$03
        .byte   $02,$02
        .byte   $01,$01
        .byte   $06,$06
        .byte   $10,$0a
        .byte   $05,$05
        .byte   $05,$06
        .byte   $01,$02
        .byte   $05,$03
        .byte   $01,$0a
        .byte   $0a,$0a
        .byte   $04,$0a
        .byte   $02,$0b
        .byte   $04,$04
        .byte   $03,$04 ; $10
        .byte   $03,$05
        .byte   $01,$0b
        .byte   $06,$03
        .byte   $06,$05
        .byte   $04,$07
        .byte   $04,$02
        .byte   $01,$03
        .byte   $06,$0a
        .byte   $02,$03
        .byte   $04,$08
        .byte   $04,$03
        .byte   $02,$01
        .byte   $05,$02
        .byte   $04,$05
        .byte   $09,$01
        .byte   $03,$09 ; $20
        .byte   $02,$02
        .byte   $05,$04
        .byte   $0b,$07
        .byte   $03,$01
        .byte   $03,$08
        .byte   $0c,$07
        .byte   $06,$02
        .byte   $08,$02
        .byte   $0a,$03
        .byte   $0c,$05
        .byte   $0e,$05
        .byte   $10,$05
        .byte   $08,$05
        .byte   $08,$03
        .byte   $0a,$05
        .byte   $09,$01 ; $30
        .byte   $04,$08
        .byte   $0c,$01
        .byte   $02,$0a
        .byte   $0b,$0a
        .byte   $02,$09

; ---------------------------------------------------------------------------

; [  ]

_c1b388:
        sta     $cf61
        sta     $cf81
        sta     $cfa1
        sta     $cfc1
        rts

; ---------------------------------------------------------------------------

_c1b395:
        .word   $0060,$0050
        .word   $0060,$0050
        .word   $0060,$0050
        .word   $0068,$ffb0
        .word   $0070,$ffc0
        .word   $0000,$00a0
        .word   $0070,$ffb8
        .word   $0070,$ffb0
        .word   $0070,$0050
        .word   $0060,$0040
        .word   $0078,$0050
        .word   $0078,$0040
        .word   $00f8,$0020
        .word   $0078,$0038
        .word   $0078,$0018
        .word   $0070,$ffb8
        .word   $0078,$0040
        .word   $00f8,$0020
        .word   $0000,$0000
        .word   $0000,$0000
        .word   $0060,$0050

; ---------------------------------------------------------------------------

_c1b3e9:
        .byte   0,0,0,1,1,1,1,1,0,0,0,0,1,0,0,1,0,0,0,0,0

; ---------------------------------------------------------------------------

; [  ]

_c1b3fe:
@b3fe:  ora     #$e0
        sta     $bc88
        sta     $bc89
        sta     $bc8a
        rts

; ---------------------------------------------------------------------------

; [  ]

_c1b40a:
@b40a:  lda     #$10
        sta     $bc85
        lda     #$1f
        sta     $f86c
        jsr     $b3fe
@b417:  jsr     $02f2       ; wait one frame
        lda     $f86c
        jsr     $b3fe
        dec     $f86c
        bpl     @b417
        rts

; ---------------------------------------------------------------------------

_c1b426:
@b426:  lda     #$10
        sta     $bc85
        stz     $f86c
@b42e:  jsr     $02f2       ; wait one frame
        lda     $f86c
        jsr     $b3fe
        inc     $f86c
        lda     $f86c
        cmp     #$20
        bne     @b42e
        rts

; ---------------------------------------------------------------------------

_c1b442:
@b442:  phx
        lda     #$dd
        sta     $dbb6
        lda     #$93
        jsr     $fbd9       ; play sound effect
        jsr     $b426
        lda     #$80
        sta     $db60
        jsr     $02f2       ; wait one frame
        lda     $7c4b
        tax
        jsr     $2736
        jsr     $26fb
        clr_ax
        stx     $78
        lda     $dbd3
        beq     @b46f
        lda     #$20
        sta     $78
@b46f:  longa
        lda     $74
        asl2
        clc
        adc     #$0048
        sta     $db62
        lda     $76
        asl2
        sta     $76
        lda     #$0060
        sec
        sbc     $76
        adc     $78
        sta     $db64
        shorta0
        lda     #$38
        sta     $db66
        lda     #$01
        sta     $db60
        sta     $db61
        jsr     $b40a
        plx
        rts

; ---------------------------------------------------------------------------

; [  ]

_c1b4a2:
@b4a2:  phx
        jsr     $8d47       ; get graphics script parameter 3
        cmp     #$60
        beq     @b4b1
        cmp     #$61
        jne     @b4b4
@b4b1:  jmp     @b534
@b4b4:  jsr     $8d3b
        beq     @b4b1
        jsr     $b426
        lda     #$05
        sta     $7e
        clr_a
        jsr     $7b43
        lda     #$80
        sta     $db60
        jsr     $02f2       ; wait one frame
        jsr     $8d47       ; get graphics script parameter 3
        longa
        sec
        sbc     #$005f
        sta     $70
        asl
        tax
        lda     $d97c50,x
        tax
        shorta0
        lda     $70
        pha
        jsr     $2736
        jsr     $26fb
        pla
        pha
        asl2
        tax
        longa
        lda     f:_c1b395,x
        sta     $db62
        lda     f:_c1b395+2,x
        sta     $db64
        shorta0
        lda     $dbd3
        beq     @b516
        longa
        lda     $db64
        clc
        adc     #$0020
        sta     $db64
        shorta0
@b516:  lda     #$38
        sta     $db66
        lda     #$01
        sta     $db60
        sta     $db61
        pla
        tax
        lda     f:_c1b3e9,x
        bne     @b530
        jsr     $b40a
        bra     @b534
@b530:  clr_a
        jsr     $b3fe
@b534:  plx
        rts

; ---------------------------------------------------------------------------

; [  ]

_c1b536:
@b536:  lda     $7c4b
        cmp     #$ff
        jne     _c1b442
        lda     ($eb)
        jmi     @b573
        jsr     $8d47       ; get graphics script parameter 3
        ldx     #$0100
        cmp     #$12
        bcc     @b574
        inx
        cmp     #$24
        bcc     @b574
        inx
        cmp     #$36
        bcc     @b574
        inx
        cmp     #$57
        bcc     @b574
        inx
        cmp     #$5f
        bcc     @b574
        inx
        cmp     #$71
        bcc     @b574
        inx
        cmp     #$82
        bcc     @b573
        cmp     #$a2
        bcc     @b574
@b573:  rts
@b574:  cmp     #$73
        beq     @b57d
        cpx     #$0105
        bne     _c1b58b
@b57d:  ldx     #$0105
        jsr     _c1b58b
        lda     #$01
        sta     $dbdf
        jmp     _c1b4a2

; ---------------------------------------------------------------------------

; [  ]

_c1b58b:
@b58b:  stz     $f86d
        jsr     $a847       ; load attack animation properties
        lda     $f582
        sta     $d1bc
        jsr     $8d2f       ; get attacker id
        asl5
        tax
        phx
        lda     #$0b
        sta     $cf58,x
        jsr     $8d2f       ; get attacker id
        jsr     $fc74
        sta     $db53
        sta     $db52
        stz     $db50
        stz     $db51
        stz     $db54
        jsr     $c0d5
        lda     $d1bc
        and     #$3f
        beq     @b5c8
        jsr     $b633
@b5c8:  lda     $d1bc
        and     #$3f
        cmp     #$02
        bne     @b5ea
        lda     #$02
        sta     $70
        clr_ax
@b5d7:  lda     $70
        sta     $d3de,x
        clc
        adc     #$02
        sta     $70
        txa
        clc
        adc     #$10
        tax
        cmp     #$80
        bne     @b5d7
@b5ea:  cmp     #$08
        bne     @b602
        clr_axy
@b5f1:  lda     $c1e3e4,x
        sta     $d3de,y
        inx
        tya
        clc
        adc     #$10
        tay
        cmp     #$80
        bne     @b5f1
@b602:  jsr     $e810
        jsr     $e81e
        inc     $d110
@b60b:  lda     #$01
        sta     $db38
        jsr     $02f2       ; wait one frame
        clr_ax
        lda     #$08
        jsr     $c409
        lda     $74
        cmp     #$08
        bne     @b60b
        stz     $d110
        stz     $db38
        jsr     $67d3
        jsr     $02f2       ; wait one frame
        plx
        stz     $cf58,x
        jmp     _c1fc6d

; ---------------------------------------------------------------------------

_c1b633:
@b633:  jsr     $8d2f       ; get attacker id
        asl4
        tax
        stx     $70
        lda     #$08
        sta     $74
        clr_ay
@b643:  lda     #$10
        sta     $72
        ldx     $70
@b649:  lda     $d1d8,x
        sta     $d1d8,y
        lda     $d3d8,x
        sta     $d3d8,y
        iny
        inx
        dec     $72
        bne     @b649
        dec     $74
        bne     @b643
        rts

; ---------------------------------------------------------------------------

_c1b660:
@b660:  clr_ax
@b662:  sta     $d1d8,x
        inx
        cpx     #$0800
        bne     @b662
        clr_ax
@b66d:  sta     $d9d8,x
        inx
        cpx     #$0160
        bne     @b66d
        rts

; ---------------------------------------------------------------------------

; [  ]

_c1b677:
        jsr     $b660
        stz     $db6b
        stz     $db77
        stz     $dbdf
        jsr     $9d93       ; wait for damage numerals
        jsr     $8d47       ; get graphics script parameter 3
        jsr     $b536
        stz     $db6b
        stz     $db77
        jsr     $9d93       ; wait for damage numerals
        jsr     $8d47       ; get graphics script parameter 3
        tax
        stz     $db6a
; fallthrough

; ---------------------------------------------------------------------------

_c1b69c:
@b69c:  stx     $f86e
        stz     $f86d
        stz     $db6b
        stz     $db77
@b6a8:  inc     $db77
        stz     $f86a
        stz     $f86b
        jsr     $a847       ; load attack animation properties
        jsr     $b300
        lda     $f582
        sta     $d1bc
        and     #$3f
        asl
        tax
        lda     f:_c1b746,x
        sta     $70
        lda     f:_c1b746+1,x
        sta     $71
        jsr     $b742
        ldx     $f86a
        bne     @b69c
        lda     $db61
        beq     @b71d
        stz     $f8b4
        lda     #$80
        sta     $db60
        jsr     $02f2       ; wait one frame
        lda     #$10
        sta     $bc85
        lda     #$1f
        sta     $f86c
        jsr     $b3fe
        jsr     $24d5
        jsr     $b40a
        clr_a
        stz     $7e
        jsr     $7b43
@b6fe:  jsr     $02f2       ; wait one frame
        lda     $d0ee
        bne     @b6fe
        stz     $db60
        ldx     $f86e
        cpx     #$0068
        bne     @b71d
        ldx     #$0000
        stx     $f86e
        ldx     #$001f
        jmp     @b6a8
@b71d:  stz     $db56
        lda     $f86d
        bne     @b733
        inc     $f86d
        ldx     $f86e
        jsr     $8d41
        jne     @b6a8
@b733:  stz     $dbdf
        stz     $bc85
        jsr     $ad2d
        jsr     $1cb8
        jmp     _c13cbb
@b742:  jmp     ($0070)
        rts

; ---------------------------------------------------------------------------

_c1b746:
        .addr   $e82f,$e82f,$e82f,$e82f,$e82f,$e82f,$e82f,$e82f ; $00
        .addr   $e82f,$e82f,$e82f,$e82f,$e82f,$e92c,$e82f,$e92c
        .addr   $e82f,$e82f,$e82f,$e82f,$e82f,$e82f,$e82f,$e82f ; $10
        .addr   $e962,$e82f,$e82f,$e92c,$e82f,$e82f,$e82f,$e92c
        .addr   $e92c,$e92c,$e92c,$d2d0,$e82f,$e92c,$e92c,$e82f ; $20
        .addr   $e82f,$e82f,$e82f,$e82f,$e92c,$e92c,$e82f,$e82f
        .addr   $e92c,$e82f,$e82f,$e82f,$e82f,$e82f,$e82f,$e92c ; $30
        .addr   $e82f,$b745,$b745

; ---------------------------------------------------------------------------

; [  ]

_c1b7bc:
        stz     $db6b
        stz     $d111
        stz     $d112
        stz     $d113
        clr_ax
@b7ca:  stz     $d7d8,x
        inx
        cpx     #$0200
        bne     @b7ca
        tay
@b7d4:  lda     ($eb),y
        sta     $db50,y
        iny
        cpy     #$0005
        bne     @b7d4
        lda     $f86d
        beq     @b801
        lda     $db50
        asl
        and     #$80
        sta     $70
        lda     $db50
        eor     #$40
        and     #$7f
        ora     $70
        sta     $db50
        jsr     $8d41
        sta     $db53
        stz     $db54
@b801:  lda     $d1bc
        and     #$3f
        cmp     #$0c
        bne     @b819
        lda     $df
        sta     $db53
        lda     $db50
        and     #$3f
        sta     $db50
        bra     @b82a
@b819:  lda     $d1bc
        and     #$40
        beq     @b82a
        lda     $db53
        beq     @b827
        lda     #$80
@b827:  sta     $db53
@b82a:  jsr     $c0d5
        jmp     _c1b830

; ---------------------------------------------------------------------------

; [  ]

_c1b830:
@b830:  lda     $d1bc
        and     #$3f
        asl
        tax
        lda     f:_c1b847,x
        sta     $70
        lda     f:_c1b847+1,x
        sta     $71
        jmp     ($0070)

; ---------------------------------------------------------------------------

_c1b846:
        rts

; ---------------------------------------------------------------------------

_c1b847:
        .addr   $b846,$bf29,$bf3f,$bf5b,$bf85,$c035,$c050,$c031 ; $00
        .addr   $bf3f,$bee8,$bebd,$bea7,$be5a,$bdec,$c02c,$bdbc
        .addr   $be42,$bcde,$bcdb,$bf39,$bfa2,$bec9,$bf1d,$bcbd ; $10
        .addr   $bd23,$bc97,$bc75,$bc2d,$bcbd,$bbef,$bc0f,$bbda
        .addr   $bbb8,$bb8e,$bb59,$d2d0,$bb2b,$baf6,$ba65,$ba3d ; $20
        .addr   $ba22,$ba12,$b846,$b846,$b9f6,$b9cb,$b9af,$b961
        .addr   $b9f0,$b989,$bfcb,$bfe1,$c019,$bff7,$c008,$b8bc ; $30
        .addr   $b8b9

; ---------------------------------------------------------------------------

_c1b8b9:
        jmp     _c1bbe6

; ---------------------------------------------------------------------------

_c1b8bc:
        jsr     $c099
        jsr     _c1bf0d
        jsr     $bdbf
        clr_ax
@b8c7:  jsr     $fc96       ; generate random number
        sta     $ce7b,x
        inx
        cpx     #$0040
        bne     @b8c7
        ldx     #$0030
        stx     $76
        clr_axy
@b8db:  lda     #$10
        sta     $d3de,x
        sta     $d45e,x
        sta     $d4de,x
        sta     $d55e,x
        lda     $ce7b,y
        clc
        adc     #$40
        sta     $cebb,y
        lda     $ce83,y
        clc
        adc     #$40
        sta     $cec3,y
        lda     $ce8b,y
        clc
        adc     #$40
        sta     $cecb,y
        lda     $ce93,y
        clc
        adc     #$40
        sta     $ced3,y
        lda     #$38
        sta     $cdfb,y
        sta     $ce03,y
        sta     $ce0b,y
        sta     $ce13,y
        sta     $ce3b,y
        sta     $ce43,y
        sta     $ce4b,y
        sta     $ce53,y
        longa
        lda     #$0050
        sta     $d1e1,x
        sta     $d261,x
        sta     $d2e1,x
        sta     $d361,x
        lda     $76
        sta     $d1df,x
        adc     #$0038
        sta     $d25f,x
        adc     #$0038
        sta     $d2df,x
        adc     #$0038
        sta     $d35f,x
        shorta0
        iny
        txa
        clc
        adc     #$10
        tax
        cpx     #$0030
        jne     @b8db
        rts

; ---------------------------------------------------------------------------

; [ load spirit/paraclete animation ??? ]

_c1b961:
        lda     ($eb)
        and     #$02
        beq     @b988       ; return if not spirit/paraclete
        lda     #$ef        ; animation script $ef
        longa
        asl
        tax
        lda     $d97d42,x   ; pointer to attack animation scripts
        sta     $70
        clr_ax
@b975:  lda     $70
        sta     $d3da,x
        txa
        clc
        adc     #$0010
        tax
        cpx     #$0080      ; load 8 copies ???
        bne     @b975
        shorta0
@b988:  rts

; ---------------------------------------------------------------------------

; [  ]

_c1b989:
        lda     $f6
        beq     @b9ae
        lda     #$fd
        longa
        asl
        tax
        lda     $d97d42,x   ; pointer to attack animation scripts
        sta     $70
        clr_ax
@b99b:  lda     $70
        sta     $d3da,x
        txa
        clc
        adc     #$0010
        tax
        cpx     #$0080
        bne     @b99b
        shorta0
@b9ae:  rts

; ---------------------------------------------------------------------------

_c1b9af:
        jsr     $c099
        ldy     #$0040
        jsr     $c077
        lda     #$21
        sta     $d3de
        lda     #$01
        sta     $d3ee
        sta     $d3fe
        sta     $d40e
        jmp     _c1bf10

; ---------------------------------------------------------------------------

_c1b9cb:
        jsr     $c099
        jsr     _c1bf10
        jsr     $bdbf
_b9d4:  clr_ax
@b9d6:  jsr     $fc96       ; generate random number
        and     #$07
        inc
        sta     $d3de,x
        longa
        txa
        clc
        adc     #$0010
        tax
        shorta0
        cpx     #$0200
        bne     @b9d6
        rts

; ---------------------------------------------------------------------------

_c1b9f0:
        jsr     $b9f6
        jmp     _b9d4

; ---------------------------------------------------------------------------

_c1b9f6:
@b9f6:  jsr     $bdbf
        clr_ax
@b9fb:  stz     $d467,x
        stz     $d567,x
        longa
        txa
        clc
        adc     #$0010
        tax
        shorta0
        cpx     #$0080
        bne     @b9fb
        rts

; ---------------------------------------------------------------------------

_c1ba12:
        jsr     $c099
        jsr     _c1bf0a
        lda     $d3de
        clc
        adc     #$02
        sta     $d3ee
        rts

; ---------------------------------------------------------------------------

_c1ba22:
        lda     ($eb)
        bmi     @ba3c
        jsr     $c099
        jsr     _c1bf07
        lda     #$f8
        longa
        asl
        tax
        lda     $d97d42,x   ; pointer to attack animation scripts
        sta     $d3da
        shorta0
@ba3c:  rts

; ---------------------------------------------------------------------------

_c1ba3d:
        jsr     $c099
        jsr     _c1bf0d
        lda     #$00
        sta     $ce8b
        clc
        adc     #$40
        sta     $cecb
        lda     #$55
        sta     $ce8c
        clc
        adc     #$40
        sta     $cecc
        lda     #$aa
        sta     $ce8d
        clc
        adc     #$40
        sta     $cecd
        rts

; ---------------------------------------------------------------------------

_c1ba65:
        jsr     $c099
        jsr     $bdbf
        clr_ax
        stz     $70
@ba6f:  lda     $70
        inc
        sta     $70
        sta     $d3de,x
        stz     $d7df,x
        clc
        adc     #$08
        sta     $d4de,x
        stz     $d8df,x
        stz     $d467,x
        stz     $d567,x
        longa
        txa
        clc
        adc     #$0010
        tax
        shorta0
        cpx     #$0080
        bne     @ba6f
        rts

; ---------------------------------------------------------------------------

_c1ba9a:
@ba9a:  clr_ax
@ba9c:  lda     ($eb)
        bmi     @baab
        lda     $d5d8,x
        sec
        sbc     #$10
        sta     $d5d8,x
        bra     @bab4
@baab:  lda     $d5d8,x
        clc
        adc     #$18
        sta     $d5d8,x
@bab4:  lda     $d5da,x
        sec
        sbc     #$08
        sta     $d5da,x
        lda     $d5d8,x
        sta     $a6
        lda     $d5da,x
        sta     $a7
        lda     $d5dc,x
        sta     $a8
        lda     $d5de,x
        sta     $a9
        phx
        jsr     $0a6e
        plx
        lda     $ae
        sta     $d3e3,x
        lda     $af
        sta     $d3e4,x
        lda     $b0
        sta     $d3e5,x
        longa
        txa
        clc
        adc     #$0010
        tax
        shorta0
        cpx     #$0080
        bne     @ba9c
        rts

; ---------------------------------------------------------------------------

_c1baf6:
        jsr     $c099
        jsr     $ba9a
        jsr     $bdbf
        clr_ax
        stz     $70
@bb03:  lda     $70
        inc
        sta     $70
        sta     $d7df,x
        clc
        adc     #$08
        sta     $d8df,x
        stz     $d467,x
        stz     $d567,x
        longa
        txa
        clc
        adc     #$0010
        tax
        shorta0
        cpx     #$0080
        bne     @bb03
        inc     $db6b
        rts

; ---------------------------------------------------------------------------

_c1bb2b:
        jsr     $c099
        ldy     #$0080
        jsr     $c077
        clr_ax
        stz     $70
@bb38:  lda     $70
        clc
        adc     #$02
        sta     $d3de,x
        sta     $70
        jsr     $fc96       ; generate random number
        sta     $d5e1,x
        longa
        txa
        clc
        adc     #$0010
        tax
        shorta0
        cpx     #$0080
        bne     @bb38
        rts

; ---------------------------------------------------------------------------

_c1bb59:
        jsr     $c099
        jsr     $bdbf
        clr_ax
@bb61:  stz     $d467,x
        stz     $d567,x
        txa
        clc
        adc     #$10
        tax
        cpx     #$0080
        bne     @bb61
        clr_ax
        stz     $70
@bb75:  lda     $70
        sta     $ce7b,x
        clc
        adc     #$40
        sta     $cebb,x
        lda     $70
        clc
        adc     #$20
        sta     $70
        inx
        cpx     #$0020
        bne     @bb75
        rts

; ---------------------------------------------------------------------------

_c1bb8e:
        jsr     $bdbf
        clr_ax
@bb93:  lda     #$02
        sta     $d3de,x
        clc
        adc     #$02
        sta     $d45e,x
        clc
        adc     #$02
        sta     $d4de,x
        stz     $d567,x
        longa
        txa
        clc
        adc     #$0010
        tax
        shorta0
        cpx     #$0080
        bne     @bb93
        rts

; ---------------------------------------------------------------------------

_c1bbb8:
        jsr     $c099
        jsr     $bdbf
        clr_ax
@bbc0:  jsr     $fc96       ; generate random number
        and     #$07
        inc
        sta     $d3de,x
        longa
        txa
        clc
        adc     #$0010
        tax
        shorta0
        cpx     #$0200
        bne     @bbc0
        rts

; ---------------------------------------------------------------------------

_c1bbda:
        jsr     $c099
        jsr     $bbe6
        jsr     _c1bf10
        jmp     _c1bdbf

; ---------------------------------------------------------------------------

_c1bbe6:
@bbe6:  jsr     $8d3b
        bne     @bbee
        jsr     _c1bf04
@bbee:  rts

; ---------------------------------------------------------------------------

_c1bbef:
        jsr     $bf39
        longa
        lda     $f586
        inc
        asl
        tax
        lda     $d97d42,x   ; pointer to attack animation scripts
        sta     $d43a
        shorta0
        lda     #$01
        sta     $d43e
        inc     $d447
        jmp     _c1bbe6

; ---------------------------------------------------------------------------

_c1bc0f:
        jsr     _c1bf3f
        longa
        lda     $f586
        inc
        asl
        tax
        lda     $d97d42,x   ; pointer to attack animation scripts
        sta     $d43a
        shorta0
        stz     $d440
        jsr     $bbe6
        jmp     _c1bf19

; ---------------------------------------------------------------------------

_c1bc2d:
        jsr     $c099
        jsr     _c1bf04
        jsr     $8d3b
        beq     @bc74
        jsr     $bdbf
        inc     $d3e7
        lda     #$01
        sta     $d3de
        longa
        lda     $f586
        inc
        asl
        tax
        lda     $d97d42,x   ; pointer to attack animation scripts
        sta     $d3da
        shorta0
        ldx     #$0080
@bc58:  inc     $d3e7,x
        jsr     $fc96       ; generate random number
        and     #$0f
        inc
        sta     $d3de,x
        longa
        txa
        clc
        adc     #$0010
        tax
        shorta0
        cpx     #$0180
        bne     @bc58
@bc74:  rts

; ---------------------------------------------------------------------------

_c1bc75:
        jsr     $bf29
        jsr     $c035
        jsr     $bbe6
        longa
        lda     $f586
        inc
        asl
        tax
        lda     $d97d42,x   ; pointer to attack animation scripts
        sta     $d40a
        sta     $d42a
        sta     $d44a
        shorta0
        rts

; ---------------------------------------------------------------------------

_c1bc97:
        jsr     $c099
        longa
        lda     $f586
        inc
        asl
        tax
        clr_ay
@bca4:  lda     $d97d42,x   ; pointer to attack animation scripts
        sta     $d41a,y
        tya
        clc
        adc     #$0010
        tay
        cmp     #$0040
        bne     @bca4
        shorta0
        inc     $db6b
        rts

; ---------------------------------------------------------------------------

_c1bcbd:
        jsr     $c099
        longa
        lda     $f586
        inc
        asl
        tax
        lda     $d97d42,x   ; pointer to attack animation scripts
        sta     $d41a
        shorta0
        jsr     _c1bf07
        inc     $d427
        jmp     _c1bbe6

; ---------------------------------------------------------------------------

_c1bcdb:
        jmp     _c1bd5f

; ---------------------------------------------------------------------------

_c1bcde:
        jsr     $bd5f
        jsr     $014c
        ldx     $e9
        stx     $70
        clr_axy
@bceb:  jsr     $bda1
        cmp     #$08
        bcc     @bcf7
        sec
        sbc     #$08
        bra     @bcf9
@bcf7:  ora     #$80
@bcf9:  sta     $d3e2,y
        longa
        tya
        clc
        adc     #$0010
        tay
        lda     $70
        clc
        adc     #$0018
        sta     $70
        shorta0
        inx
        cpx     #$0008
        bne     @bceb
        jsr     $8d3b
        beq     @bd22
        lda     #$ef
        sta     $7e
        clr_a
        jsr     $7b02
@bd22:  rts

; ---------------------------------------------------------------------------

_c1bd23:
        jsr     $c02c
        jsr     _c1bf04
        jsr     $8d3b
        beq     @bd5e
        jsr     $bdbf
        inc     $d3e7
        inc     $d3f7
        longa
        lda     $f586
        inc
        asl
        tax
        lda     $d97d42,x   ; pointer to attack animation scripts
        sta     $d3ea
        ldy     #$0020
@bd49:  lda     $d97d44,x
        sta     $d3da,y
        tya
        clc
        adc     #$0010
        tay
        cpy     #$0200
        bne     @bd49
        shorta0
@bd5e:  rts

; ---------------------------------------------------------------------------

_c1bd5f:
@bd5f:  jsr     _c1bf3f
        jsr     _c1bf19
        lda     $db50
        and     #$40
        bne     @bd90
        longa
        lda     $f586
        inc
        asl
        tax
        clr_ay
@bd76:  lda     $d97d42,x   ; pointer to attack animation scripts
        sta     $d3da,y
        tya
        clc
        adc     #$0010
        tay
        cpy     #$0080
        bne     @bd76
        shorta0
        lda     #$10
        jsr     $fc57
@bd90:  lda     $d1e7
        ora     #$20
        sta     $d1e7
        lda     $d1f7
        ora     #$20
        sta     $d1f7
        rts

; ---------------------------------------------------------------------------

_c1bda1:
@bda1:  phx
        phy
        clr_axy
        iny
@bda7:  lda     ($70),y
        cmp     #$ff
        bne     @bdb8
        iny2
        inx
        cpx     #$000c
        bne     @bda7
        clr_a
        bra     @bdb9
@bdb8:  txa
@bdb9:  ply
        plx
        rts

; ---------------------------------------------------------------------------

_c1bdbc:
        jmp     _c1bdbf

; ---------------------------------------------------------------------------

_c1bdbf:
@bdbf:  clr_ax
@bdc1:  lda     $d1d8,x
        sta     $d258,x
        sta     $d2d8,x
        sta     $d358,x
        lda     $d3d8,x
        sta     $d458,x
        sta     $d4d8,x
        sta     $d558,x
        lda     $d5d8,x
        sta     $d658,x
        sta     $d6d8,x
        sta     $d758,x
        inx
        cpx     #$0080
        bne     @bdc1
        rts

; ---------------------------------------------------------------------------

_c1bdec:
        jsr     $bdbf
        clr_ax
@bdf1:  lda     $d3de,x
        inc2
        sta     $d45e,x
        inc2
        sta     $d4de,x
        inc2
        sta     $d55e,x
        txa
        clc
        adc     #$10
        tax
        cpx     #$0080
        bne     @bdf1
        ldx     $f586
        stx     $70
        clr_axy
        longa
@be17:  lda     $70
        asl
        tax
        lda     $d97d42,x   ; pointer to attack animation scripts
        sta     $d3da,y
        sta     $d3ea,y
        sta     $d3fa,y
        sta     $d40a,y
        sta     $d41a,y
        sta     $d42a,y
        inc     $70
        tya
        clc
        adc     #$0080
        tay
        cpy     #$0200
        bne     @be17
        shorta0
        rts

; ---------------------------------------------------------------------------

_c1be42:
        jsr     $c099
        longa
        lda     $f586
        inc
        asl
        tax
        lda     $d97d42,x   ; pointer to attack animation scripts
        sta     $d3ea
        shorta0
        jmp     _c1bf0a

; ---------------------------------------------------------------------------

_c1be5a:
        jsr     _c1bf04
        lda     $db53
        sta     $70
        clr_ax
@be64:  asl     $70
        bcs     @be70
        inx
        cpx     #$0004
        bne     @be64
        bra     @bea6
@be70:  txa
        asl4
        tax
        clr_ay
@be78:  lda     $d1d8,x
        sta     $d218,y
        lda     $d3d8,x
        sta     $d418,y
        lda     $d5d8,x
        sta     $d618,y
        inx
        iny
        cpy     #$0010
        bne     @be78
        longa
        lda     $f586
        inc
        asl
        tax
        lda     $d97d42,x   ; pointer to attack animation scripts
        sta     $d41a
        shorta0
        inc     $d427
@bea6:  rts

; ---------------------------------------------------------------------------

_c1bea7:
        jsr     $c099
        ldy     #$0040
        jsr     $c077
        lda     #$08
        sta     $d3de
        lda     #$10
        sta     $d3ee
        jmp     _c1bf0a

; ---------------------------------------------------------------------------

_c1bebd:
        jsr     $c099
        ldy     #$0020
        jsr     $c077
        jmp     _c1bf07

; ---------------------------------------------------------------------------

_c1bec9:
        jsr     $c099
        jsr     _c1bf04
        lda     #$08
        sta     $d3de
        inc     $d3e7
        lda     #$09
        sta     $d3ee
        inc     $d3f7
        lda     #$0a
        sta     $d41e
        inc     $d427
        rts

; ---------------------------------------------------------------------------

_c1bee8:
        jsr     $c099
        ldy     #$0060
        jsr     $c077
        jsr     _c1bf0d
        lda     #$08
        sta     $d3de
        lda     #$10
        sta     $d3ee
        lda     #$18
        sta     $d3fe
        rts

; ---------------------------------------------------------------------------

_c1bf04:
@bf04:  stz     $d3e7

_c1bf07:
@bf07:  stz     $d3f7

_c1bf0a:
@bf0a:  stz     $d407

_c1bf0d:
@bf0d:  stz     $d417

_c1bf10:
@bf10:  stz     $d427
        stz     $d437

_c1bf16:
@bf16:  stz     $d447

_c1bf19:
@bf19:  stz     $d457
        rts

; ---------------------------------------------------------------------------

_c1bf1d:
        jsr     $c099
        ldy     #$0080
        jsr     $c077
        jmp     _bf2c

; ---------------------------------------------------------------------------

_c1bf29:
@bf29:  jsr     $c099
_bf2c:  stz     $d3e7
        stz     $d407
        stz     $d427
        stz     $d447
        rts

; ---------------------------------------------------------------------------

_c1bf39:
@bf39:  jsr     _c1bf3f
        jmp     _c1bf16

; ---------------------------------------------------------------------------

_c1bf3f:
@bf3f:  jsr     $c099
        clr_ax
@bf44:  phx
        jsr     $fc96       ; generate random number
        and     #$1f
        bne     @bf4d
        inc
@bf4d:  plx
        sta     $d3de,x
        txa
        clc
        adc     #$10
        tax
        cmp     #$80
        bne     @bf44
        rts

; ---------------------------------------------------------------------------

_c1bf5b:
        jsr     $bf29
        longa
        lda     $f586
        asl
        tax
        lda     $d97d42,x   ; pointer to attack animation scripts
        sta     $d3ea
        lda     $d97d44,x
        sta     $d40a
        lda     $d97d46,x
        sta     $d42a
        lda     $d97d48,x
        sta     $d44a
        shorta0
        rts

; ---------------------------------------------------------------------------

_c1bf85:
        jsr     $c099
        clr_ax
        lda     #$10
@bf8c:  sta     $d3de,x
        dec
        pha
        txa
        clc
        adc     #$10
        tax
        pla
        cpx     #$0080
        bne     @bf8c
        ldy     #$0080
        jmp     _c1c077

; ---------------------------------------------------------------------------

_c1bfa2:
        jsr     $c099
        jsr     $bbe6
        jmp     _c1bf10

; ---------------------------------------------------------------------------

_c1bfab:
@bfab:  asl
        tax
        lda     $d97d42,x   ; pointer to attack animation scripts
        sta     $d3da
        sta     $d3ea
        sta     $d3fa
        sta     $d40a
        sta     $d41a
        sta     $d42a
        sta     $d43a
        sta     $d44a
        clr_a
        rts

; ---------------------------------------------------------------------------

_c1bfcb:
        lda     ($eb)
        and     #$40
        beq     @bfdb
        longa
        lda     #$0033
        jsr     $bfab
        shorta
@bfdb:  jsr     $c099
        jmp     _c1bf10

; ---------------------------------------------------------------------------

_c1bfe1:
        lda     ($eb)
        and     #$40
        beq     @bff1
        longa
        lda     #$00fe
        jsr     $bfab
        shorta
@bff1:  jsr     $c099
        jmp     _c1bf10

; ---------------------------------------------------------------------------

_c1bff7:
        lda     ($eb)
        and     #$40
        beq     @c007
        longa
        lda     #$00ff
        jsr     $bfab
        shorta
@c007:  rts

; ---------------------------------------------------------------------------

_c1c008:
        lda     ($eb)
        and     #$40
        beq     @c018
        longa
        lda     #$0100
        jsr     $bfab
        shorta
@c018:  rts

; ---------------------------------------------------------------------------

_c1c019:
        lda     ($eb)
        and     #$40
        beq     @c029
        longa
        lda     #$0038
        jsr     $bfab
        shorta
@c029:  jmp     _c1c02c

; ---------------------------------------------------------------------------

_c1c02c:
@c02c:  jsr     $c099
        bra     _c035

_c1c031:
        lda     #$01
        bra     _c037

_c1c035:
_c035:  lda     #$04
_c037:  sta     $d3de
        sta     $d3ee
        sta     $d3fe
        sta     $d40e
        sta     $d41e
        sta     $d42e
        sta     $d43e
        sta     $d44e
        rts

; ---------------------------------------------------------------------------

_c1c050:
        jsr     $c099
        ldy     #$0040
        jsr     $c077
        jsr     $bf10
        jmp     _c1c05f

; ---------------------------------------------------------------------------

_c1c05f:
@c05f:  lda     #$04
        clr_ax
        inc
@c064:  sta     $d3de,x
        clc
        adc     #$04
        pha
        txa
        clc
        adc     #$10
        tax
        pla
        cpx     #$0080
        bne     @c064
        rts

; ---------------------------------------------------------------------------

_c1c077:
@c077:  sty     $72
        longa
        lda     $f586
        asl
        tax
        clr_ay
@c082:  lda     $d97d42,x   ; pointer to attack animation scripts
        sta     $d3da,y
        inx2
        tya
        clc
        adc     #$0010
        tay
        cpy     $72
        bne     @c082
        shorta0
        rts

; ---------------------------------------------------------------------------

_c1c099:
@c099:  lda     $db53
        jsr     $fc7a
        asl4
        tax
        stx     $70
        lda     #$08
        sta     $74
        clr_ay
@c0ac:  lda     #$10
        sta     $72
        ldx     $70
@c0b2:  lda     $d1d8,x
        sta     $d1d8,y
        lda     $d3d8,x
        sta     $d3d8,y
        lda     $d5d8,x
        sta     $d5d8,y
        lda     $d7d8,x
        sta     $d7d8,y
        iny
        inx
        dec     $72
        bne     @c0b2
        dec     $74
        bne     @c0ac
        rts

; ---------------------------------------------------------------------------

_c1c0d5:
        clr_ax
        lda     $db53
        sta     $70
        stz     $71
@c0de:  asl     $70
        jcc     @c1c0
        lda     #$01
        sta     $d3e7,x
        longa
        lda     $f586
        asl
        phx
        tax
        lda     $d97d42,x   ; pointer to attack animation scripts
        plx
        sta     $d3da,x
        sta     $74
        shorta0
        lda     #$d9
        sta     $d3dc,x
        sta     $76
        phx
        lda     [$74]
        and     #$3f
        asl
        tax
        lda     $c1b31d,x   ; height
        sta     $78
        lda     $c1b31c,x   ; width
        plx
        sta     $d3d8,x
        sta     $d1e5,x
        sta     $7e
        lda     $78
        sta     $d3d9,x
        sta     $d1e6,x
        sta     $80
        jsr     $feba       ; +$82 = $7e * $80
        lda     $82
        sta     $d1de,x
        ldy     #$0001
        lda     [$74],y     ; animation speed
        lsr4
        inc
        sta     $d3dd,x     ; set frame duration
        jsr     $c266
        sta     $d3de,x
        lda     [$74],y
        and     #$0f
        inc
        sta     $d3e0,x     ;
        lda     #$02
        sta     $d3df,x     ; animation script offset
        lda     $db50
        and     #$80
        sta     $78
        lda     $db50
        asl
        and     #$80
        ora     $71
        sta     $d3e2,x
        lda     $db51
        ora     $78
        sta     $d3e1,x
        lda     $f86d
        beq     @c194
        lda     $71
        ora     $78
        sta     $d3e1,x
        phx
        lda     $71
        tay
        lda     ($ed),y
        bne     @c184
        plx
        jmp     @c1c0
@c184:  jsr     $fc7a
        plx
        sta     $72
        lda     $d3e2,x
        and     #$80
        ora     $72
        sta     $d3e2,x
@c194:  stz     $d3e6,x
        stz     $d5e1,x
        stz     $d1dc,x
        stz     $d1dd,x
        stz     $d1e3,x
        stz     $d1e4,x
        stz     $d1e7,x
        stz     $d1e7,x
        lda     $d3d8,x
        sta     $d1e5,x
        lda     $d3d9,x
        sta     $d1e6,x
        jsr     $c35d
        jsr     $c296
        bra     @c1c3
@c1c0:  stz     $d3e7,x
@c1c3:  txa
        clc
        adc     #$10
        tax
        inc     $71
        lda     $71
        cmp     #$08
        jne     @c0de
        jsr     $c20d
        jmp     _c1c1d9

; ---------------------------------------------------------------------------

; [  ]

_c1c1d9:
@c1d9:  stz     $db75
        clr_axy
@c1df:  lda     $c1c28d,x
        sta     $db78,y
        lda     #$40
        sta     $db7c,y
        inx2
        iny
        cpy     #$0004
        bne     @c1df
        lda     $db50
        and     #$40
        bne     @c20c
        lda     $db77
        beq     @c20c
        lda     $db76
        tay
        lda     $3c4c,y     ; aegis shield characters
        sta     $db75
        inc     $db76
@c20c:  rts

; ---------------------------------------------------------------------------

; [  ]

_c1c20d:
@c20d:  lda     $db6a
        bne     @c265
        inc     $db6a
        clr_ax
        lda     $db54
        sta     $76
        stz     $71
@c21e:  asl     $76
        bcc     @c257
        inc     $dad8,x
        lda     $db50
        and     #$40
        beq     @c234
        lda     #$1c
        sta     $dadb,x
        clr_a
        bra     @c23a
@c234:  clr_a
        sta     $dadb,x
        lda     #$08
@c23a:  clc
        adc     $71
        tay
        lda     $d036,y
        sta     $dad9,x
        lda     $d042,y
        sta     $dada,x
        jsr     $c266
        sta     $dadc,x
        lda     #$3c
        sta     $dadd,x
        bra     @c25a
@c257:  stz     $dad8,x
@c25a:  inc     $71
        txa
        clc
        adc     #$08
        tax
        cmp     #$40
        bne     @c21e
@c265:  rts

; ---------------------------------------------------------------------------

; [  ]

_c1c266:
@c266:  phx
        lda     $db50
        and     #$40
        bne     @c278
        lda     $71
        asl
        tax
        lda     $c1c28d,x
        bra     @c28b
@c278:  clr_ax
@c27a:  lda     $d0aa,x
        cmp     $71
        beq     @c287
        inx
        cpx     #$0008
        bne     @c27a
@c287:  lda     $c1c28d,x
@c28b:  plx
        rts

; ---------------------------------------------------------------------------

_c1c28d:
        .byte   $03,$06, $09,$0c,$0f,$12,$15,$18,$1b

; ---------------------------------------------------------------------------

_c1c296:
@c296:  stz     $d5d9,x
        stz     $d5db,x
        stz     $d5dd,x
        stz     $d5df,x
        lda     $d3e1,x
        bmi     @c2ab
        lda     #$08
        bra     @c2ac
@c2ab:  clr_a
@c2ac:  sta     $72
        lda     $d3e1,x
        and     #$07
        clc
        adc     $72
        tay
        phy
        ldy     #$0002
        lda     [$74],y
        ply
        and     #$e0
        beq     @c2d4
        lda     $d036,y
        sta     $a6
        sta     $d5d8,x
        lda     $d042,y
        sta     $a7
        sta     $d5da,x
        bra     @c2f5
@c2d4:  lda     $d3d9,x
        asl3
        sta     $72
        lda     $d066,y
        sta     $a6
        sta     $d5d8,x
        lda     $d072,y
        sec
        sbc     $72
        sta     $a7
        sta     $d5da,x
        clr_a
        sbc     #$00
        sta     $d5db,x
@c2f5:  lda     $d3e2,x
        bmi     @c2fe
        lda     #$08
        bra     @c2ff
@c2fe:  clr_a
@c2ff:  sta     $72
        lda     $d3e2,x
        and     #$07
        clc
        adc     $72
        tay
        phy
        ldy     #$0002
        lda     [$74],y
        ply
        and     #$e0
        beq     @c327
        lda     $d036,y
        sta     $d5dc,x
        sta     $a8
        lda     $d042,y
        sta     $d5de,x
        sta     $a9
        bra     @c348
@c327:  lda     $d3d9,x
        asl3
        sta     $72
        lda     $d066,y
        sta     $d5dc,x
        sta     $a8
        lda     $d072,y
        sec
        sbc     $72
        sta     $d5de,x
        sta     $a9
        clr_a
        sbc     #$00
        sta     $d5df,x
@c348:  phx
        jsr     $0a6e
        plx
        lda     $ae
        sta     $d3e3,x
        lda     $af
        sta     $d3e4,x
        lda     $b0
        sta     $d3e5,x
        rts

; ---------------------------------------------------------------------------

_c1c35d:
@c35d:  stz     $d1e0,x
        stz     $d1e2,x
        lda     $d3e2,x
        bmi     @c36c
        lda     #$08
        bra     @c36d
@c36c:  clr_a
@c36d:  sta     $72
        lda     $d3e2,x
        and     #$07
        clc
        adc     $72
        tay
        phy
        ldy     #$0002
        lda     [$74],y
        ply
        and     #$e0
        beq     @c3eb
        cmp     #$20
        beq     @c3dd
        cmp     #$40
        beq     @c3be
        cmp     #$60
        beq     @c39f
        cmp     #$80
        beq     @c393
@c393:  lda     #$80
        sta     $d1df,x
        lda     #$50
        sta     $d1e1,x
        bra     @c408
@c39f:  lda     $d3d9,x
        asl3
        sta     $72
        lda     $d07e,y
        sta     $d1df,x
        lda     $d08a,y
        sec
        sbc     $72
        sta     $d1e1,x
        clr_a
        sbc     #$00
        sta     $d1e2,x
        bra     @c408
@c3be:  lda     $d3d9,x
        asl3
        sta     $72
        lda     $d07e,y
        sta     $d1df,x
        lda     $d08a,y
        clc
        adc     $72
        sta     $d1e1,x
        clr_a
        adc     #$00
        sta     $d1e2,x
        bra     @c408
@c3dd:  lda     $d036,y
        sta     $d1df,x
        lda     $d042,y
        sta     $d1e1,x
        bra     @c408
@c3eb:  lda     $d3d9,x
        asl3
        sta     $72
        lda     $d066,y
        sta     $d1df,x
        lda     $d072,y
        sec
        sbc     $72
        sta     $d1e1,x
        clr_a
        sbc     #$00
        sta     $d1e2,x
@c408:  rts

; ---------------------------------------------------------------------------

; [ execute animation script ]

; a: number of threads
; x: first thread offset (thread id * $10)

_c1c409:
@c409:  sta     $76
        stz     $74
@c40d:  lda     $d3e7,x
        jeq     @c4cf
        lda     $d3da,x     ; pointer to animation script
        sta     $70
        lda     $d3db,x
        sta     $71
        lda     $d3dc,x
        sta     $72
        ldy     #$0002
        lda     [$70],y
        and     #$1f
        longa
        asl7
        sta     $7a         ; animation frame offset
        shorta0
        dec     $d3de,x     ; decrement frame counter
        jne     @c4dc
        lda     $d3dd,x     ; animation frame duration
        sta     $d3de,x
        lda     $d3df,x     ; animation script offset
        tay
        cmp     #$02
        bne     @c48a
        phy
        ldy     $f586
        cpy     #$0094
        bne     @c469
        jsr     $8d3b
        bne     @c461
        lda     #$49
        bra     @c464
@c461:  lda     $f583       ; animation sound effect
@c464:  jsr     $fbe4       ; play animation sound effect
        bra     @c488
@c469:  lda     $dbdf
        beq     @c472
        lda     #$88
        bra     @c47f
@c472:  lda     $db50
        and     #$40
        beq     @c47d
        lda     #$33
        bra     @c47f
@c47d:  lda     #$dd
@c47f:  sta     $dbb6
        lda     $f583
        jsr     $fbd9       ; play sound effect
@c488:  ply
        iny
@c48a:  lda     [$70],y
        cmp     #$ff
        beq     @c4b8       ; branch if end of script
        lda     [$70],y
        bmi     @c4b2
        clc
        adc     $d7de,x
        longa
        clc
        adc     $7a         ; add frame offset
        sta     $d1da,x
        shorta0
        iny
        lda     #$01
        sta     $d1d8,x     ; animation needs update ???
        tya
        sta     $d3df,x     ; save animation script offset
        stz     $db5f
        bra     @c4dc
@c4b2:  jsr     $c4fd       ; execute animation command
        iny
        bra     @c48a
@c4b8:  tya
        sta     $d3df,x
        lda     $d3e0,x
        beq     @c4cf
        dec     $d3e0,x
        beq     @c4cf
        lda     #$03
        tay
        sta     $d3df,x
        jmp     @c48a
@c4cf:  lda     #$01
        sta     $d3de,x
        stz     $d1d8,x
        stz     $d3e7,x
        inc     $74
@c4dc:  longa
        txa
        clc
        adc     #$0010
        tax
        shorta0
        dec     $76
        jne     @c40d
        lda     $dba4
        beq     @c4fc
        jsr     $1d65
        inc     $db42
        stz     $dba4
@c4fc:  rts

; ---------------------------------------------------------------------------

; [ execute animation command ]

_c1c4fd:
@c4fd:  and     #$7f
        asl
        phx
        tax
        lda     $c1c512,x
        sta     $80
        lda     $c1c513,x
        sta     $81
        plx
        jmp     ($0080)

; ---------------------------------------------------------------------------

; animation command jump table (commands $80-$fe)
_c1c512:
        .addr   $df24,$deb3,$deb9,$dc04,$debf,$dec5,$decb,$e64f ; $80
        .addr   $e76a,$e774,$e77b,$e791,$da13,$e80f,$e635,$e80f
        .addr   $e2aa,$e27b,$e30a,$e59a,$e425,$e46a,$e2db,$e5cf ; $90
        .addr   $e612,$e61d,$e09c,$e108,$e0ff,$e1cb,$e0ff,$e145
        .addr   $e326,$e51b,$fc64,$fc6d,$e096,$e3ec,$e086,$e3a4 ; $a0
        .addr   $e4de,$e058,$e022,$dfe0,$e203,$e184,$de8d,$de62
        .addr   $de08,$dd98,$ddb4,$ddd0,$ddec,$de3b,$dd48,$dd72 ; $b0
        .addr   $dcdf,$dd15,$dca7,$dc74,$d2d0,$dc4d,$dc3b,$e372
        .addr   $dbf0,$dbd6,$dbe3,$dba9,$d2d0,$db9c,$e340,$e551 ; $c0
        .addr   $db7d,$db8d,$db54,$db67,$db2b,$dae4,$da59,$dac2
        .addr   $da2c,$da04,$d9ed,$d9b5,$d99a,$d990,$d903,$d8bf ; $d0
        .addr   $d8d1,$d895,$d83b,$d7e6,$d7d0,$d7ad,$d789,$d777
        .addr   $d780,$d742,$d723,$d6f3,$d6c1,$d665,$d62b,$d610 ; $e0
        .addr   $d589,$d5b1,$d536,$d4f1,$d4d0,$d476,$d41d,$d3e2
        .addr   $d34a,$d2d0,$d281,$d272,$d5e9,$d1b9,$d1cf,$df9e ; $f0
        .addr   $c75b,$c740,$c6e3,$c625,$c616,$c610,$b745

; ---------------------------------------------------------------------------

; [  ]

_c1c610:
        iny
        lda     [$70],y
        jmp     _c1fbd9       ; play sound effect
        phx
        lda     $d3e2,x
        and     #$03
        tax
        iny
        lda     [$70],y
        sta     $d1cb,x
        plx
        rts

; ---------------------------------------------------------------------------

_c1c625:
        phx
        lda     $d3e2,x
        and     #$03
        asl5
        tax
        iny
        lda     [$70],y
        sta     $7e
        stz     $7f
        iny
        lda     [$70],y
        beq     @c691
        cmp     #$01
        beq     @c681
        cmp     #$02
        beq     @c671
        cmp     #$03
        beq     @c661
        cmp     #$04
        beq     @c657
        lda     $cf62,x
        and     #$7f
        sta     $cf62,x
        plx
        rts
@c657:  lda     $cf62,x
        ora     #$80
        sta     $cf62,x
        plx
        rts
@c661:  longa
        lda     $cf5d,x
        sec
        sbc     $7e
        sta     $cf5d,x
        shorta0
        plx
        rts
@c671:  longa
        lda     $cf5d,x
        clc
        adc     $7e
        sta     $cf5d,x
        shorta0
        plx
        rts
@c681:  longa
        lda     $cf5f,x
        sec
        sbc     $7e
        sta     $cf5f,x
        shorta0
        plx
        rts
@c691:  longa
        lda     $cf5f,x
        clc
        adc     $7e
        sta     $cf5f,x
        shorta0
        plx
        rts

; ---------------------------------------------------------------------------

_c1c6a1:
        longa
        lda     $bc77
        sta     $d7df,x
        lda     $bc79
        sta     $d7e1,x
        lda     $d5d8,x
        sec
        sbc     $d5dc,x
        sta     $bc77
        lda     $d5da,x
        sec
        sbc     $d5de,x
        clc
        adc     #$00c0
        sta     $bc79
        shorta0
        inc     $bc9a
        rts

; ---------------------------------------------------------------------------

_c1c6ce:
        longa
        lda     $d7df,x
        sta     $bc77
        lda     $d7e1,x
        sta     $bc79
        shorta0
        stz     $bc9a
        rts

; ---------------------------------------------------------------------------

_c1c6e3:
        iny
        lda     [$70],y
        beq     @c72c
        cmp     #$01
        beq     @c718
        cmp     #$02
        beq     @c704
        iny
        lda     [$70],y
        longa
        sta     $7e
        lda     $bc77
        sec
        sbc     $7e
        sta     $bc77
        shorta0
        rts
@c704:  iny
        lda     [$70],y
        longa
        sta     $7e
        lda     $bc77
        clc
        adc     $7e
        sta     $bc77
        shorta0
        rts
@c718:  iny
        lda     [$70],y
        longa
        sta     $7e
        lda     $bc79
        sec
        sbc     $7e
        sta     $bc79
        shorta0
        rts
@c72c:  iny
        lda     [$70],y
        longa
        sta     $7e
        lda     $bc79
        clc
        adc     $7e
        sta     $bc79
        shorta0
        rts

; ---------------------------------------------------------------------------

; [  ]

_c1c740:
        iny
        lda     [$70],y
        ora     #$58
        sta     f:$002107
        rts

; ---------------------------------------------------------------------------

_c1c74a:
        lda     $db50
        and     #$40
        beq     @c75a
@c751:  lda     [$70],y
        cmp     #$ff
        beq     @c75a
        iny
        bra     @c751
@c75a:  rts

; ---------------------------------------------------------------------------

_c1c75b:
        lda     $db53
        bne     @c76a
@c760:  lda     [$70],y
        cmp     #$fe
        beq     @c769
        iny
        bra     @c760
@c769:  dey
@c76a:  rts

; ---------------------------------------------------------------------------

_c1c76b:
        .addr   $e0fc,$d1ed,$d195,$d1a7,$caa4,$d2d0,$ca9b,$ca55
        .addr   $c9fd,$ca0a,$c9f4,$c9dc,$c9b9,$c9a3,$c9a0,$c997
        .addr   $c98b,$c984,$c959,$c83d,$c907,$c8d3,$c891,$c867
        .addr   $c830,$c7f8,$c7e8,$c7c1,$c7b5,$c6a1,$c6ce,$de78
        .addr   $c7af,$dcbc

; ---------------------------------------------------------------------------

_c1c7af:
        lda     #$ff
        sta     $04f2
        rts

; ---------------------------------------------------------------------------

_c1c7b5:
        lda     #$07
        sta     $dbec
        inc     $dbeb
        stz     $ee56
        rts

; ---------------------------------------------------------------------------

_c1c7c1:
        phx
        txa
        bne     @c7ce
        stz     $dbd1
        stz     $dbd2
        inc     $dbd0
@c7ce:  longa
        txa
        lsr4
        tax
        shorta0
        jsr     $fc96       ; generate random number
        and     #$07
        clc
        adc     #$04
        sta     $cefb,x
        plx
        jmp     _c1cc81

; ---------------------------------------------------------------------------

_c1c7e8:
        iny
        lda     [$70],y
        sta     $7e
        lda     $d3e2,x
        bpl     @c7f7
        lda     $7e
        sta     $d7de,x
@c7f7:  rts

; ---------------------------------------------------------------------------

_c1c7f8:
        phx
        phy
        longa
        clr_ay
@c7fe:  lda     $0070,y
        pha
        iny2
        cpy     #$000c
        bne     @c7fe
        shorta0
        lda     $d3e1,x
        and     #$07
        tax
        lda     $db9c,x
        eor     #$03
        sta     $db9c,x
        jsr     $1cb8
        longa
        ldy     #$000c
@c822:  pla
        sta     $006e,y
        dey2
        bne     @c822
        shorta0
        ply
        plx
        rts

; ---------------------------------------------------------------------------

_c1c830:
        txa
        beq     @c83c
        lda     $d1df,x
        clc
        adc     #$50
        sta     $d1df,x
@c83c:  rts

; ---------------------------------------------------------------------------

_c1c83d:
        phx
        stx     $7e
        txa
        lsr3
        and     #$fe
        tax
        lda     $c1d87d,x
        sta     $80
        lda     $c1d87e,x
        sta     $81
        ldx     $7e
        lda     $80
        sta     $d1df,x
        stz     $d1e0,x
        lda     $81
        sta     $d1e1,x
        stz     $d1e2,x
        plx
        rts

; ---------------------------------------------------------------------------

_c1c867:
        phx
        stx     $7e
        txa
        lsr3
        and     #$fe
        tax
        lda     $c1d885,x
        sta     $80
        lda     $c1d886,x
        sta     $81
        ldx     $7e
        lda     $80
        sta     $d1df,x
        stz     $d1e0,x
        lda     $81
        sta     $d1e1,x
        stz     $d1e2,x
        plx
        rts

; ---------------------------------------------------------------------------

_c1c891:
        lda     $d1df,x
        sta     $d5d8,x
        sta     $a6
        lda     $d1e1,x
        sta     $d5da,x
        sta     $a7
        lda     $d5dc,x
        sta     $a8
        lda     $d5de,x
        sta     $a9
        phx
        jsr     $0a6e
        plx
        lda     $ae
        sta     $d3e3,x
        lda     $af
        sta     $d3e4,x
        lda     $b0
        sta     $d3e5,x
        longa
        lda     $d1df,x
        sta     $d5dc,x
        lda     $d1e1,x
        sta     $d5de,x
        shorta0
        jmp     _c1e23b

; ---------------------------------------------------------------------------

_c1c8d3:
        lda     $d5da,x
        clc
        adc     #$03
        sta     $d5da,x
        sta     $a7
        lda     $d5d8,x
        clc
        adc     #$28
        sta     $d5d8,x
        sta     $a6
        clc
        adc     #$10
        sta     $a8
        lda     $d5de,x
        sta     $a9
        longa
        lda     $d5d8,x
        sta     $d5dc,x
        lda     $d5da,x
        sta     $d5de,x
        shorta0
        jmp     _c1e06c

; ---------------------------------------------------------------------------

_c1c907:
        lda     $d5d8,x
        sta     $a6
        stz     $d5d9,x
        lda     $d5da,x
        sta     $a7
        stz     $d5db,x
        lda     $d3e2,x
        bpl     @c91f
        clr_a
        bra     @c921
@c91f:  lda     #$ff
@c921:  sta     $d1df,x
        sta     $a8
        stz     $d1e0,x
        jsr     $fc96       ; generate random number
        and     #$7f
        clc
        adc     #$18
        sta     $d1e1,x
        sta     $a9
        stz     $d1e2,x
        stz     $d1dc,x
        stz     $d1dd,x
        phx
        jsr     $0a6e
        plx
        lda     $ae
        sta     $d3e3,x
        lda     $af
        sta     $d3e4,x
        lda     $b0
        sta     $d3e5,x
        lda     #$02
        sta     $d3e6,x
        rts

; ---------------------------------------------------------------------------

_c1c959:
        phx
        jsr     $db18
        phx
        ldx     $78
        cpx     #$0100
        bcc     @c969
        lda     #$80
        bra     @c96a
@c969:  clr_a
@c96a:  plx
        sta     $ce7b,x
        clc
        adc     #$40
        sta     $cebb,x
        lda     #$18
        sta     $cdfb,x
        sta     $ce3b,x
        lda     #$10
        sta     $cefb,x
        jmp     _c1e3c0

; ---------------------------------------------------------------------------

_c1c984:
        txa
        jeq     _c1d4e2
        rts

; ---------------------------------------------------------------------------

_c1c98b:
        longa
        lda     #$0050
        sta     $db64
        shorta0
        rts

; ---------------------------------------------------------------------------

_c1c997:
        jsr     $d7e6
        lda     #$10
        sta     $d1df,x
        rts

; ---------------------------------------------------------------------------

_c1c9a0:
        jmp     _c1e0ff

; ---------------------------------------------------------------------------

_c1c9a3:
        phx
        jsr     $e0ff
        txa
        lsr4
        tax
        lda     #$30
        sta     $ce0b,x
        sta     $ce4b,x
        plx
        jmp     _c1cf2f

; ---------------------------------------------------------------------------

_c1c9b9:
        jsr     $cfc9
        jmp     _c1e0ff

; ---------------------------------------------------------------------------

_c1c9bf:
@c9bf:  lda     $d7df,x
        sta     $7e
        lda     #$10
        sta     $80
        phx
        jsr     $feba       ; +$82 = $7e * $80
        plx
        lda     $d5e1,x
        clc
        adc     #$06
        sta     $d5e1,x
        and     #$0f
        clc
        adc     $82
        rts

; ---------------------------------------------------------------------------

_c1c9dc:
        jsr     $fc96       ; generate random number
        sta     $d5e1,x
        jsr     $c9bf
        sta     $d3e6,x
        lda     $d3e3,x
        sta     $d7e1,x
        jsr     $cfec
        jmp     _c1e0ff

; ---------------------------------------------------------------------------

_c1c9f4:
        jsr     $c9fd
        lda     #$08
        sta     $d3e6,x
        rts

; ---------------------------------------------------------------------------

_c1c9fd:
@c9fd:  jsr     $ca81
        inc     $d7e1,x
        lda     $d3e3,x
        sta     $d7e2,x
        rts

; ---------------------------------------------------------------------------

_c1ca0a:
        lda     #$06
        sta     $f8b2
        longa
        lda     $d1df,x
        sta     $d5dc,x
        sta     $d5ec
        sta     $d5fc
        sta     $d60c
        sta     $d61c
        sta     $d62c
        sta     $d63c
        sta     $d64c
        lda     $d1e1,x
        sta     $d5de,x
        sta     $d5ee
        sta     $d5fe
        sta     $d60e
        sta     $d61e
        sta     $d62e
        sta     $d63e
        sta     $d64e
        shorta0
        lda     #$20
        jsr     $ca66
        lda     #$08
        sta     $d3e6,x
        rts

; ---------------------------------------------------------------------------

_c1ca55:
        lda     #$10
        sta     $f8b2
        jsr     $fc96       ; generate random number
        and     #$0f
        sec
        sbc     #$88
        clc
        adc     $d3e3,x
@ca66:  sta     $d3e3,x
        sta     $d7e2,x
        sta     $d3f3
        sta     $d403
        sta     $d413
        sta     $d423
        sta     $d433
        sta     $d443
        sta     $d453
@ca81:  lda     #$08
        sta     $d3e6,x
        longa
        lda     $d5d8,x
        sta     $d1df,x
        lda     $d5da,x
        sta     $d1e1,x
        shorta0
        stz     $d7e1,x
        rts

; ---------------------------------------------------------------------------

_c1ca9b:
        jsr     $fc96       ; generate random number
        and     #$0f
        sta     $d5e4
        rts

; ---------------------------------------------------------------------------

_c1caa4:
        phx
        jsr     $cadb
        cpx     #$0010
        bcc     @cac2
        lda     #$40
        sta     $cdfb,x
        stz     $ce3b,x
        lda     #$01
        sta     $ce1b,x
        sta     $ce5b,x
        lda     #$f0
        jmp     @cad4
@cac2:  lda     #$58
        sta     $cdfb,x
        lda     #$20
        sta     $ce3b,x
        stz     $ce1b,x
        stz     $ce5b,x
        lda     #$10
@cad4:  sta     $cefb,x
        plx
        jmp     _c1d15a

; ---------------------------------------------------------------------------

_c1cadb:
@cadb:  longa
        stx     $78
        txa
        lsr4
        tax
        stx     $84
        shorta0
        rts

; ---------------------------------------------------------------------------

_c1caeb:
@caeb:  ldx     $84
        jsr     $09ca
        sta     $86
        ldx     $84
        jsr     $09e5
        sta     $87
        ldx     $78
        lda     $86
        sta     $d1dc,x
        lda     $87
        sta     $d1dd,x
        rts

; ---------------------------------------------------------------------------

_c1cb06:
        .addr   $d217,$d15a,$d2d0,$d147,$d0d5,$d0c3,$d0bf,$d02a
        .addr   $d01d,$cfd9,$cf56,$cf07,$cef6,$ceda,$dbf7,$c74a
        .addr   $d2d0,$ceb9,$cde9,$cd92,$cd53,$cd34,$ccfd,$ccf6
        .addr   $cce2,$cb88,$cb6a,$cb62,$cb5a,$cb56,$cb4f,$cb46

; ---------------------------------------------------------------------------

; [ flash screen (if not already flashing) ]

_c1cb46:
@cb46:  lda     $f8c7
        bne     @cb4e
        jsr     $78f5       ; flash screen
@cb4e:  rts

; ---------------------------------------------------------------------------

; [  ]

_c1cb4f:
        iny
        lda     [$70],y
        sta     $dbec
        rts

; ---------------------------------------------------------------------------

_c1cb56:
        stz     $dbeb
        rts

; ---------------------------------------------------------------------------

_c1cb5a:
        txa
        jeq     _c1deb9
        iny
        rts

; ---------------------------------------------------------------------------

_c1cb62:
        txa
        jeq     _c1d41d
        iny
        rts

; ---------------------------------------------------------------------------

_c1cb6a:
        phx
        lda     $ee56
        beq     @cb76
        jsr     $cb98
        dec     $ee56
@cb76:  plx
        rts

; ---------------------------------------------------------------------------

_c1cb78:
        phx
        lda     $ee56
        cmp     #$20
        beq     @cb86
        jsr     $cbc9
        inc     $ee56
@cb86:  plx
        rts

; ---------------------------------------------------------------------------

_c1cb88:
        phx
        lda     $ee56
        cmp     #$20
        beq     @cb96
        jsr     $cb98
        inc     $ee56
@cb96:  plx
        rts

; ---------------------------------------------------------------------------

_c1cb98:
@cb98:  clr_ax
        longa
@cb9c:  lda     $ee56
        and     #$00ff
        sta     $7e
        lda     $edf8,x
        jsr     $cbe9
        sta     $7e8b,x
        lda     $ee56
        and     #$00ff
        sta     $7e
        lda     $ee18,x
        jsr     $cbe9
        sta     $7eab,x
        inx2
        cpx     #$001e
        bne     @cb9c
        shorta0
        rts

; ---------------------------------------------------------------------------

_c1cbc9:
@cbc9:  clr_ax
        longa
@cbcd:  lda     $ee56
        and     #$00ff
        sta     $7e
        lda     $ee38,x
        jsr     $cbe9
        sta     $7ecb,x
        inx2
        cpx     #$001e
        bne     @cbcd
        shorta0
        rts

; ---------------------------------------------------------------------------

_c1cbe9:
        .a16
@cbe9:  sta     $84
        lda     $7e
        asl5
        sta     $80
        asl5
        sta     $82
        lda     $84
        and     #$001f
        clc
        adc     $7e
        sta     $7e
        and     #$7fe0
        bne     @cc15
        lda     $84
        and     #$7fe0
        ora     $7e
        sta     $84
        bra     @cc1c
@cc15:  lda     $84
        ora     #$001f
        sta     $84
@cc1c:  lda     $84
        and     #$03e0
        clc
        adc     $80
        sta     $80
        and     #$7c1f
        bne     @cc36
        lda     $84
        and     #$7c1f
        ora     $80
        sta     $84
        bra     @cc3d
@cc36:  lda     $84
        ora     #$03e0
        sta     $84
@cc3d:  lda     $84
        and     #$7c00
        clc
        adc     $82
        sta     $82
        and     #$83ff
        bne     @cc57
        lda     $84
        and     #$03ff
        ora     $82
        sta     $84
        bra     @cc5e
@cc57:  lda     $84
        ora     #$7c00
        sta     $84
@cc5e:  lda     $84
        rts
        .a8

; ---------------------------------------------------------------------------

_c1cc61:
        .byte   $00,$01,$02,$03,$04,$05,$06,$07
        .byte   $07,$06,$05,$04,$03,$02,$01,$00

_c1cc71:
        .byte   $20,$20,$20,$20,$00,$00,$00,$00
        .byte   $00,$00,$00,$00,$20,$20,$20,$20

; ---------------------------------------------------------------------------

_c1cc81:
@cc81:  phy
        phx
        longa
        txa
        lsr4
        tax
        shorta0
        stx     $84
        lda     $ce7b,x
        clc
        adc     $cefb,x
        sta     $ce7b,x
        lda     $cebb,x
        sec
        sbc     $cefb,x
        sta     $cebb,x
        jsr     $09ca
        sta     $82
        ldx     $84
        jsr     $09e5
        sta     $83
        ldx     $84
        lda     $ce7b,x
        lsr4
        tax
        lda     $c1cc61,x
        sta     $7e
        lda     $c1cc71,x
        sta     $7f
        plx
        lda     $d1e7,x
        and     #$df
        ora     $7f
        sta     $d1e7,x
        lda     $7e
        sta     $d1e3,x
        lda     $82
        sta     $d1dc,x
        lda     $83
        sta     $d1dd,x
        ply
        rts

; ---------------------------------------------------------------------------

_c1cce2:
        jsr     $cc81
        lda     $dbd0
        beq     @ccf5
        dey8
        jsr     $cb46
@ccf5:  rts

; ---------------------------------------------------------------------------

_c1ccf6:
        txa
        jeq     _c1e2aa
        rts

; ---------------------------------------------------------------------------

_c1ccfd:
        lda     $d3e6,x
        clc
        adc     #$02
        sta     $d3e6,x
        longa
        lda     $d3e4,x
        sec
        sbc     #$0002
        sta     $d3e4,x
        lda     $d3e4,x
        bmi     @cd2d
        shorta0
        dey3
        jsr     $e23b
        inc     $d5e1,x
        lda     $d5e1,x
        and     #$06
        lsr
        sta     $d1e3,x
        rts
@cd2d:  shorta0
        stz     $d1e3,x
        rts

; ---------------------------------------------------------------------------

_c1cd34:
        phx
        stx     $78
        inc     $d5e1,x
        lda     $d5e1,x
        and     #$01
        bne     @cd4b
        lda     $d3e2,x
        bpl     @cd51
        jsr     $da89
        bcc     @cd51
@cd4b:  dey4
        plx
        rts
@cd51:  plx
        rts

; ---------------------------------------------------------------------------

_c1cd53:
        lda     $d3e6,x
        clc
        adc     #$02
        sta     $d3e6,x
        longa
        lda     $d3e4,x
        sec
        sbc     #$0002
        sta     $d3e4,x
        lda     $d3e4,x
        bmi     @cd8b
        shorta0
        dey3
        jsr     $e0bc
        inc     $d5e1,x
        lda     $d5e1,x
        and     #$03
        beq     @cd8a
        lda     $d1e3,x
        cmp     #$04
        beq     @cd8a
        inc     $d1e3,x
@cd8a:  rts
@cd8b:  shorta0
        stz     $d1e3,x
        rts

; ---------------------------------------------------------------------------

_c1cd92:
        lda     $d3e6,x
        clc
        adc     #$0c
        sta     $d3e6,x
        longa
        lda     $d3e4,x
        sec
        sbc     #$000c
        sta     $d3e4,x
        lda     $d3e4,x
        bmi     @cdd6
        shorta0
        dey3
        jsr     $e23b
        inc     $d5e1,x
        lda     #$10
        sta     $80
        lda     $d5e1,x
        asl3
        phx
        jsr     $0a00
        plx
        clc
        adc     $d5e3,x
        sta     $d1dd,x
        jsr     $fc96       ; generate random number
        and     #$03
        sta     $d1e3,x
@cdd6:  shorta0
        rts

; ---------------------------------------------------------------------------

_c1cdda:
@cdda:  ldx     $ce3d
        lda     $d3e2,x
        and     #$7f
        asl5
        tay
        rts

; ---------------------------------------------------------------------------

_c1cde9:
        phx
        phy
        stx     $ce3d
        longa
        clr_ay
@cdf2:  lda     $0070,y
        pha
        iny2
        cpy     #$000c
        bne     @cdf2
        shorta0
        jsr     $cdda
        lda     $cf45,y
        sta     $a6
        lda     $cf46,y
        sta     $a7
        lda     #$20
        sta     $a8
        lda     #$50
        sta     $a9
        jsr     $0a6e
        jsr     $09a7
        clr_ax
        lda     $ae
        jsr     $0996
        stz     $cdfb
        stz     $ce3b
@ce28:  jsr     $02f2       ; wait one frame
        lda     $ce3b
        tax
        stx     $80
        lda     $cebb
        jsr     $0b59
        jsr     $cdda
        longa
        lda     $84
        sta     $cf5d,y
        shorta0
        lda     $cdfb
        tax
        stx     $80
        lda     $ce7b
        jsr     $0b59
        jsr     $cdda
        longa
        lda     $84
        sta     $cf5f,y
        shorta0
        clr_ax
        inc
        jsr     $09b9
        longa
        lda     $af
        sec
        sbc     #$0001
        sta     $af
        shorta0
        lda     $b0
        bpl     @ce28
        ldx     #$0020
@ce77:  phx
        jsr     $02f2       ; wait one frame
        jsr     $cdda
        lda     $cf62,y
        eor     #$80
        sta     $cf62,y
        plx
        dex
        bne     @ce77
        jsr     $cdda
        lda     $cf62,y
        ora     #$80
        sta     $cf62,y
        ldx     $ce3d
        lda     $d3e2,x
        asl2
        tax
        lda     $7b81,x
        ora     #$80
        sta     $7b81,x
        longa
        ldy     #$000c
@ceab:  pla
        sta     $006e,y
        dey2
        bne     @ceab
        shorta0
        ply
        plx
        rts

; ---------------------------------------------------------------------------

_c1ceb9:
        phx
        clr_ax
        lda     $db52
        sta     $98
@cec1:  asl     $98
        bcc     @ced2
        lda     $dbaf,x
        cmp     #$f7
        bcs     @ced2
        clc
        adc     #$08
        sta     $dbaf,x
@ced2:  inx
        cpx     #$0004
        bne     @cec1
        plx
        rts

; ---------------------------------------------------------------------------

_c1ceda:
        phx
        jsr     $db18
        jsr     $e45b
        ldx     $84
        lda     #$20
        jsr     $0996
        ldx     $78
        lda     $86
        sta     $d1dc,x
        lda     $87
        sta     $d1dd,x
        plx
        rts

; ---------------------------------------------------------------------------

_c1cef6:
        jsr     $d02a
        inc     $d5e1,x
        lda     $d5e1,x
        and     #$0c
        lsr2
        sta     $d1e3,x
        rts

; ---------------------------------------------------------------------------

_c1cf07:
        lda     $d3e6,x
        clc
        adc     #$08
        sta     $d3e6,x
        longa
        lda     $d3e4,x
        sec
        sbc     #$0008
        sta     $d3e4,x
        lda     $d3e4,x
        bmi     @cf2b
        shorta0
        dey4
        jsr     $e23b
@cf2b:  shorta0
        rts

; ---------------------------------------------------------------------------

_c1cf2f:
@cf2f:  phx
        txa
        lsr4
        clc
        adc     #$10
        tax
        phx
        lda     #$0c
        jsr     $0996
        jsr     $09ca
        sta     $74
        plx
        jsr     $09e5
        sta     $75
        plx
        lda     $74
        sta     $d1dc,x
        lda     $75
        sta     $d1dd,x
        rts

; ---------------------------------------------------------------------------

_c1cf56:
        lda     $d3e6,x
        clc
        adc     #$02
        sta     $d3e6,x
        lda     $d3e5,x
        bne     @cf73
        lda     $d3e4,x
        cmp     #$20
        bcc     @cf7b
        cmp     #$40
        bcc     @cf82
        cmp     #$60
        bcc     @cf8a
@cf73:  lda     #$30
        sta     $7e
        lda     #$03
        bra     @cf90
@cf7b:  lda     #$18
        sta     $7e
        clr_a
        bra     @cf90
@cf82:  lda     #$20
        sta     $7e
        lda     #$01
        bra     @cf90
@cf8a:  lda     #$28
        sta     $7e
        lda     #$02
@cf90:  sta     $d1e3,x
        txa
        lsr4
        phx
        tax
        lda     $7e
        sta     $ce0b,x
        sta     $ce4b,x
        plx
        longa
        lda     $d3e4,x
        sec
        sbc     #$0002
        sta     $d3e4,x
        lda     $d3e4,x
        bmi     @cfc2
        shorta0
        dey3
        jsr     $cf2f
        jsr     $e23b
        bra     @cfc5
@cfc2:  stz     $d1e3,x
@cfc5:  shorta0
        rts

; ---------------------------------------------------------------------------

_c1cfc9:
@cfc9:  lda     $d7df,x
        sta     $d1e3,x
        inc
        cmp     #$06
        bne     @cfd5
        clr_a
@cfd5:  sta     $d7df,x
        rts

; ---------------------------------------------------------------------------

_c1cfd9:
        lda     $d3e6,x
        cmp     #$fc
        beq     @cfe6
        clc
        adc     #$0c
        sta     $d3e6,x
@cfe6:  jsr     $cfc9
        jmp     _c1e23b

; ---------------------------------------------------------------------------

_c1cfec:
@cfec:  lda     #$08
        sta     $80
        lda     $d7e3,x
        clc
        adc     #$08
        sta     $d7e3,x
        lda     $d7df,x
        asl3
        clc
        adc     $d7e3,x
        phx
        jsr     $0a00
        plx
        sta     $7e
        lda     $d7e1,x
        clc
        adc     $7e
        sta     $d3e3,x
        lda     $d7df,x
        and     #$0f
        lsr
        sta     $d1e3,x
        rts

; ---------------------------------------------------------------------------

_c1d01d:
        jsr     $e23b
        jsr     $cfec
        jsr     $c9bf
        sta     $d3e6,x
        rts

; ---------------------------------------------------------------------------

_c1d02a:
@d02a:  lda     $d1df,x
        sta     $a6
        lda     $d1e1,x
        sta     $a7
        longa
        lda     $d1df,x
        sta     $d5d8,x
        lda     $d1e1,x
        sta     $d5da,x
        shorta0
        lda     $d5dc,x
        sta     $a8
        lda     $d5de,x
        sta     $a9
        phx
        jsr     $0a6e
        plx
        lda     $d5dd,x
        ora     $d5df,x
        bne     @d0a2
        jsr     $d0a6
        lda     $ae
        sec
        sbc     $d7e2,x
        bmi     @d072
        lda     $d7e2,x
        clc
        adc     $7e
        sta     $d7e2,x
        bra     @d07b
@d072:  lda     $d7e2,x
        sec
        sbc     $7e
        sta     $d7e2,x
@d07b:  sta     $d3e3,x
        lda     $d7e1,x
        bne     @d091
        lda     $d3e3,x
        clc
        adc     #$10
        lsr5
        sta     $d1e3,x
@d091:  lda     $b0
        bne     @d09b
        lda     $af
        cmp     #$0c
        bcc     @d0a2
@d09b:  jsr     $e23b
        dey3
        rts
@d0a2:  stz     $d1e3,x
        rts

; ---------------------------------------------------------------------------

_c1d0a6:
@d0a6:  lda     $ae
        sec
        sbc     $d7e2,x
        bmi     @d0b8
@d0ae:  cmp     $f8b2
        bcc     @d0bc
        lda     $f8b2
        bra     @d0bc
@d0b8:  eor     #$ff
        bra     @d0ae
@d0bc:  sta     $7e
        rts

; ---------------------------------------------------------------------------

_c1d0bf:
        stz     $cd68
        rts

; ---------------------------------------------------------------------------

_c1d0c3:
        inc     $d5e3
        lda     $d5e3
        and     #$02
        beq     @d0d1
        stz     $cd68
        rts
@d0d1:  inc     $cd68
        rts

; ---------------------------------------------------------------------------

_c1d0d5:
        inc     $d5e3
        lda     $d5e3
        and     #$0f
        bne     @d100
        jsr     $d104
        stz     $7e
        lda     $db50
        and     #$40
        bne     @d0ef
        lda     #$08
        sta     $7e
@d0ef:  lda     $db53
        phx
        jsr     $fc7a
        clc
        adc     $7e
        plx
        cmp     $d5e4
        bne     @d100
        rts
@d100:  dey3
        rts

; ---------------------------------------------------------------------------

_c1d104:
@d104:  phx
@d105:  inc     $d5e4
        lda     $d5e4
        and     #$0f
        sta     $d5e4
        asl
        tax
        longa
        lda     $de
        and     $ceffd5,x
        bne     @d121
        shorta0
        bra     @d105
@d121:  shorta0
        lda     $d5e4
        tax
        lda     $d04e,x
        clc
        adc     $d096,x
        sta     $cd69
        lda     $d05a,x
        sta     $cd6a
        lda     #$33
        sta     $cd6b
        lda     #$01
        sta     $cd68
        jsr     $fbad       ; play system sound effect $10
        plx
        rts

; ---------------------------------------------------------------------------

_c1d147:
        iny
        lda     [$70],y
        sta     $7e
        inc     $d5e3
        lda     $d5e3
        and     $7e
        bne     @d159
        jsr     $d104
@d159:  rts

; ---------------------------------------------------------------------------

_c1d15a:
@d15a:  phx
        jsr     $cadb
        ldx     $84
        lda     $ce5b,x
        beq     @d177
        lda     $ce3b,x
        clc
        adc     #$04
        sta     $ce3b,x
        cmp     #$20
        bne     @d185
        stz     $ce5b,x
        bra     @d185
@d177:  lda     $ce3b,x
        sec
        sbc     #$04
        sta     $ce3b,x
        bne     @d185
        inc     $ce5b,x
@d185:  jsr     $caeb
        ldx     $84
        dec     $cdfb,x
        lda     $cefb,x
        jsr     $0996
        plx
        rts

; ---------------------------------------------------------------------------

_c1d195:
        longa
        lda     $d5dc,x
        sta     $d1df,x
        lda     $d5de,x
        sta     $d1e1,x
        shorta0
        rts

; ---------------------------------------------------------------------------

_c1d1a7:
        longa
        lda     $d5d8,x
        sta     $d1df,x
        lda     $d5da,x
        sta     $d1e1,x
        shorta0
        rts

; ---------------------------------------------------------------------------

; [  ]

_c1d1b9:
        iny
        lda     [$70],y
        phx
        asl
        tax
        lda     $c1c76b,x
        sta     $7e
        lda     $c1c76c,x
        sta     $7f
        plx
        jmp     ($007e)

; ---------------------------------------------------------------------------

; [  ]

_c1d1cf:
        iny
        lda     [$70],y
        phx
        asl
        tax
        lda     $c1cb06,x
        sta     $7e
        lda     $c1cb07,x
        sta     $7f
        plx
        jmp     ($007e)

; ---------------------------------------------------------------------------

_c1d1e5:
        .byte   $00,$28
        .byte   $00,$58
        .byte   $09,$70
        .byte   $00,$80

; ---------------------------------------------------------------------------

_c1d1ed:
        phx
        stx     $7e
        txa
        lsr3
        and     #$fe
        tax
        lda     $c1d1e5,x
        sta     $80
        lda     $c1d1e6,x
        sta     $81
        ldx     $7e
        lda     $80
        sta     $d1df,x
        stz     $d1e0,x
        lda     $81
        sta     $d1e1,x
        stz     $d1e2,x
        plx
        rts

; ---------------------------------------------------------------------------

_c1d217:
        lda     $d3e6,x
        clc
        adc     #$08
        sta     $d3e6,x
        longa
        lda     $d3e4,x
        sec
        sbc     #$0008
        sta     $d3e4,x
        lda     $d3e4,x
        bmi     @d26b
        shorta0
        dey6
        jsr     $e23b
        inc     $d5e1,x
        lda     #$10
        sta     $80
        lda     $d5e1,x
        asl5
        phx
        jsr     $0a00
        plx
        clc
        adc     $d5e3,x
        sta     $d1dd,x
        lda     $d7e2,x
        sta     $d1e3,x
        inc     $d7e2,x
        lda     $d7e2,x
        cmp     #$03
        bne     @d26b
        stz     $d7e2,x
@d26b:  stz     $d1e3,x
        shorta0
        rts

; ---------------------------------------------------------------------------

_c1d272:
        iny
        lda     [$70],y
        beq     @d27b
        stz     $db72
        rts
@d27b:  lda     #$01
        sta     $db72
        rts

; ---------------------------------------------------------------------------

_c1d281:
        iny
        lda     #$02
        sta     $bc85
        lda     [$70],y
        and     #$1f
        sta     $7e
        lda     [$70],y
        bmi     @d2c9
        and     #$40
        beq     @d2bb
        lda     [$70],y
        and     #$20
        beq     @d2ab
        lda     $bc88
        sec
        sbc     $7e
        sta     $bc88
        sta     $bc89
        sta     $bc8a
        rts
@d2ab:  lda     $bc88
        clc
        adc     $7e
        sta     $bc88
        sta     $bc89
        sta     $bc8a
        rts
@d2bb:  lda     [$70],y
@d2bd:  ora     #$e0
        sta     $bc88
        sta     $bc89
        sta     $bc8a
        rts
@d2c9:  stz     $bc85
        clr_a
        jmp     @d2bd

; ---------------------------------------------------------------------------

_c1d2cf:
        iny
        lda     [$70],y
        bne     @d2ec
        phx
        jsr     $e391
        clc
        adc     #$40
        sta     $cebb,x
        lda     #$60
        sta     $cdfb,x
        lda     #$30
        sta     $ce3b,x
        jmp     _c1e3c0
@d2ec:  phx
        jsr     $e589
        jsr     $e45b
        ldx     $84
        lda     #$08
        jsr     $0996
        lda     [$70],y
        cmp     #$02
        bne     @d320
        lda     $cdfb,x
        bne     @d30a
        lda     #$40
        sta     $cdfb,x
@d30a:  dec     $cdfb,x
        dec     $cdfb,x
        lda     $ce3b,x
        bne     @d31a
        lda     #$20
        sta     $ce3b,x
@d31a:  dec     $ce3b,x
        dec     $ce3b,x
@d320:  ldx     $78
        lda     $d1e3,x
        inc
        and     #$01
        sta     $d1e3,x
        ldx     $78
        lda     $86
        sta     $d1dc,x
        lda     $87
        sta     $d1dd,x
        plx
        rts

; ---------------------------------------------------------------------------

_c1d339:
        .byte   $03,$03,$02,$02,$02,$02,$01,$01
        .byte   $01,$00,$01,$00,$01,$00,$00,$01,$00

_c1d34a:
        phx
        phy
        longa
        clr_ay
@d350:  lda     $0070,y
        pha
        iny2
        cpy     #$000c
        bne     @d350
        shorta0
        lda     $bc84
        ora     #$01
        sta     $bc84
        stz     $ce7b
        stz     $ce7c
@d36c:  jsr     $02f2       ; wait one frame
        inc     $ce7b
        lda     $ce7b
        and     #$03
        bne     @d36c
        lda     $ce7c
        tax
        lda     $c1d339,x
        longa
        sta     $70
        clr_ax
@d387:  lda     $a937,x
        clc
        adc     $70
        sta     $a937,x
        lda     $a9b7,x
        sec
        sbc     $70
        sta     $a9b7,x
        inx4
        cpx     #$0080
        bne     @d387
        shorta0
        inc     $ce7c
        lda     $ce7c
        cmp     #$10
        bne     @d36c
        lda     $de
        sta     $70
        lda     #$02
        jsr     $7602
        longa
        clr_ax
@d3bc:  stz     $a937,x
        inx4
        cpx     #$0100
        bne     @d3bc
        lda     $bc84
        and     #$00fe
        sta     $bc84
        ldy     #$000c
@d3d4:  pla
        sta     $006e,y
        dey2
        bne     @d3d4
        shorta0
        ply
        plx
        rts

; ---------------------------------------------------------------------------

_c1d3e2:
        phx
        txa
        lsr4
        tax
        iny
        lda     [$70],y
        bne     @d3f7
        stz     $cdfb,x
        jsr     $fc96       ; generate random number
        sta     $ce7b,x
@d3f7:  lda     $cdfb,x
        cmp     #$80
        bcs     @d404
        clc
        adc     #$04
        sta     $cdfb,x
@d404:  lda     $ce7b,x
        clc
        adc     #$10
        sta     $ce7b,x
        jsr     $09ca
        plx
        sta     $d1dd,x
        jsr     $fc96       ; generate random number
        and     #$03
        sta     $d1e3,x
        rts

; ---------------------------------------------------------------------------

_c1d41d:
@d41d:  phx
        iny
        lda     [$70],y
        and     #$07
        bne     @d43d
        clr_ax
@d427:  txa
        stx     $80
        jsr     $df09
        bcc     @d435
        phx
        clr_a
        jsr     $1aa6
        plx
@d435:  inx
        cpx     #$0008
        bne     @d427
        plx
        rts
@d43d:  clr_ax
@d43f:  stx     $80
        txa
        jsr     $df09
        bcc     @d44e
        phx
        lda     #$0c
        jsr     $1aa6
        plx
@d44e:  inx
        cpx     #$0008
        bne     @d43f
        lda     $d3e2
        ora     #$80
        sta     $d3e2
        lda     [$70],y
        lsr3
        and     #$0f
        ldx     #$0000
        jsr     $ded1
        inc     $db56
        plx
        rts

; ---------------------------------------------------------------------------

_c1d46e:
        .byte   $10,$10
        .byte   $50,$50
        .byte   $90,$90
        .byte   $d0,$d0

; ---------------------------------------------------------------------------

_c1d476:
        phx
        txa
        lsr4
        tax
        iny
        lda     [$70],y
        bne     @d49e
        lda     $c1d46e,x
        sta     $ce7b,x
        lda     #$40
        sta     $cdfb,x
        lda     $d237
        ora     #$20
        sta     $d237
        lda     $d257
        ora     #$20
        sta     $d257
@d49e:  txa
        cmp     #$04
        bcc     @d4b1
        lda     $ce7b,x
        clc
        adc     #$04
        ora     #$80
        sta     $ce7b,x
        jmp     @d4bc
@d4b1:  lda     $ce7b,x
        clc
        adc     #$04
        and     #$7f
        sta     $ce7b,x
@d4bc:  lda     $cdfb,x
        asl
        sta     $80
        lda     $ce7b,x
        clc
        adc     #$40
        jsr     $0a00
        plx
        sta     $d1dc,x
        rts

; ---------------------------------------------------------------------------

_c1d4d0:
        iny
        lda     [$70],y
        bne     _c1d4e2
        lda     #$10
        sta     $bc85
        lda     #$1f
        sta     $f86c
        jmp     _c1b3fe

_c1d4e2:
@d4e2:  lda     $f86c
        jsr     $b3fe
        lda     $f86c
        beq     @d4f0
        dec     $f86c
@d4f0:  rts

; ---------------------------------------------------------------------------

_c1d4f1:
        iny
        lda     [$70],y
        beq     @d50e
        sta     $cdfb
        stz     $ce7b
        longa
        lda     $db62
        sta     $d5d8
        lda     $db64
        sta     $d5da
        shorta0
        rts
@d50e:  phx
        lda     $cdfb
        tax
        stx     $80
        lda     $ce7b
        ora     #$80
        jsr     $0b59
        longa
        lda     $84
        clc
        adc     $d5da
        sta     $db64
        shorta0
        lda     $ce7b
        clc
        adc     #$08
        sta     $ce7b
        plx
        rts

; ---------------------------------------------------------------------------

_c1d536:
        iny
        lda     [$70],y
        and     #$3f
        sta     $7e
        stz     $7f
        lda     [$70],y
        and     #$c0
        beq     @d55c
        cmp     #$40
        beq     @d56b
        cmp     #$80
        beq     @d57a
        longa
        lda     $db64
        sec
        sbc     $7e
        sta     $db64
        shorta0
        rts
@d55c:  longa
        lda     $db62
        clc
        adc     $7e
        sta     $db62
        shorta0
        rts
@d56b:  longa
        lda     $db62
        sec
        sbc     $7e
        sta     $db62
        shorta0
        rts
@d57a:  longa
        lda     $db64
        clc
        adc     $7e
        sta     $db64
        shorta0
        rts

; ---------------------------------------------------------------------------

_c1d589:
        lda     $d1df,x
        sta     $a6
        lda     $d1e1,x
        sta     $a7
        lda     $d5dc,x
        sta     $a8
        lda     $d5de,x
        sta     $a9
        longa
        lda     $d1df,x
        sta     $d5dc,x
        lda     $d1e1,x
        sta     $d5de,x
        shorta0
        jmp     _c1e06c

; ---------------------------------------------------------------------------

_c1d5b1:
        lda     $d3e6,x
        clc
        adc     #$04
        sta     $d3e6,x
        longa
        lda     $d3e4,x
        sec
        sbc     #$0004
        sta     $d3e4,x
        lda     $d3e4,x
        bmi     @d5e2
        shorta0
        dey3
        jsr     $e0bc
        inc     $d5e1,x
        lda     $d5e1,x
        and     #$04
        lsr2
        sta     $d1e3,x
        rts
@d5e2:  shorta0
        stz     $d1e3,x
        rts

; ---------------------------------------------------------------------------

_c1d5e9:
        lda     $d3e6,x
        clc
        adc     #$08
        sta     $d3e6,x
        longa
        lda     $d3e4,x
        sec
        sbc     #$0008
        sta     $d3e4,x
        lda     $d3e4,x
        bmi     @d60c
        shorta0
        dey2
        jsr     $e0bc
        rts
@d60c:  shorta0
        rts

; ---------------------------------------------------------------------------

_c1d610:
        lda     #$20
        sta     $d5e4,x
        lda     #$80
        sta     $d5e5,x
        longa
        lda     $d1df,x
        sta     $d5d8,x
        lda     $d1e1,x
        sta     $d5da,x
        shorta0
        phy
        phx
        stz     $81
        lda     $d5e4,x
        sta     $80
        lda     $d5e5,x
        jsr     $0b59
        plx
        longa
        lda     $84
        clc
        adc     $d5d8,x
        sta     $d1df,x
        shorta0
        lda     $d5e5,x
        clc
        adc     #$02
        sta     $d5e5,x
        clc
        adc     #$40
        cmp     #$80
        bcs     @d660
        lda     #$02
        sta     $d1e3,x
        bra     @d663
@d660:  stz     $d1e3,x
@d663:  ply
        rts

; ---------------------------------------------------------------------------

_c1d665:
        phx
        jsr     $fc96       ; generate random number
        and     #$0f
        sta     $84
        stz     $85
        longa
        lda     $84
        clc
        adc     $d1df,x
        sec
        sbc     #$0008
        sta     $80
        lda     $84
        clc
        adc     $d1e1,x
        sec
        sbc     #$0008
        sta     $82
        shorta0
        ldx     #$0080
@d68f:  lda     $d3e7,x
        bne     @d6af
        lda     #$03
        sta     $d3df,x
        lda     #$01
        sta     $d3e7,x
        longa
        lda     $80
        sta     $d1df,x
        lda     $82
        sta     $d1e1,x
        shorta0
        plx
        rts
@d6af:  longa
        txa
        clc
        adc     #$0010
        tax
        shorta0
        cpx     #$0200
        bne     @d68f
        plx
        rts

; ---------------------------------------------------------------------------

_c1d6c1:
        phy
        phx
        txa
        lsr4
        tax
        lda     $ce7b,x
        clc
        adc     #$08
        ora     #$80
        sta     $ce7b,x
        jsr     $09ca
        plx
        sta     $d1dd,x
        lda     $d1dc,x
        clc
        adc     $d5e4,x
        sta     $d1dc,x
        ply
        rts

; ---------------------------------------------------------------------------

_c1d6e7:
        .byte   $fd,$fe,$ff,$01,$02,$03

_c1d6ed:
        .byte   $48,$48,$40,$40,$38,$30

; ---------------------------------------------------------------------------

_c1d6f3:
        phx
        stx     $7e
        txa
        lsr4
        sta     $82
        tax
        lda     $c1d6ed,x
        sta     $cdfb,x
        stz     $ce7b,x
        lda     $c1d6e7,x
        ldx     $7e
        sta     $d5e4,x
        lda     $d3e2,x
        and     #$80
        ora     $82
        sta     $d3e2,x
        stz     $d1dd,x
        stz     $d1dc,x
        plx
        rts

; ---------------------------------------------------------------------------

_c1d723:
        phy
        phx
        txa
        lsr5
        tax
        lda     #$08
        jsr     $0996
        jsr     $09ca
        plx
        sta     $d1dc,x
        ply
        rts

; ---------------------------------------------------------------------------

_c1d7ea:
        .byte   $30,$90,$40,$a0

_c1d7ee:
        .byte   $88,$88,$68,$68

; ---------------------------------------------------------------------------

_c1d742:
        phx
        stx     $7e
        txa
        lsr5
        tax
        lda     #$08
        sta     $cdfb,x
        jsr     $fc96       ; generate random number
        sta     $ce7b,x
        lda     $c1d73a,x
        sta     $80
        lda     $c1d73e,x
        sta     $81
        ldx     $7e
        lda     $80
        sta     $d1df,x
        stz     $d1e0,x
        lda     $81
        sta     $d1e1,x
        stz     $d1e2,x
        plx
        rts

; ---------------------------------------------------------------------------

_c1d777:
        lda     $d1e7,x
        ora     #$20
        sta     $d1e7,x
        rts

; ---------------------------------------------------------------------------

_c1d780:
        lda     $d1e7,x
        and     #$df
        sta     $d1e7,x
        rts

; ---------------------------------------------------------------------------

_c1d789:
        phy
        phx
        txa
        lsr4
        tax
        lda     $ce7b,x
        pha
        lda     #$08
        jsr     $0996
        jsr     $09ca
        sta     $7e
        pla
        clc
        adc     #$40
        sta     $80
        plx
        lda     $7e
        sta     $d1dc,x
        ply
        rts

; ---------------------------------------------------------------------------

; [ animation command $dd:  ]

_c1d7ad:
        phx
        txa
        lsr4
        tax
        lda     #$40
        sta     $cdfb,x
        lda     #$80
        sta     $ce7b,x
        plx
        lda     #$f0
        sta     $d1df,x
        stz     $d1e0,x
        lda     #$60
        sta     $d1e1,x
        stz     $d1e2,x
        rts

; ---------------------------------------------------------------------------

_c1d7d0:
        phy
        phx
        txa
        lsr4
        tax
        lda     #$20
        jsr     $0996
        jsr     $09ca
        plx
        sta     $d1dc,x
        ply
        rts

; ---------------------------------------------------------------------------

_c1d7e6:
@d7e6:  phx
        stx     $7e
        txa
        lsr4
        tax
        lda     $c1d82b,x
        sta     $cdfb,x
        lda     $c1d833,x
        sta     $ce7b,x
        lda     $c1d823,x
        sta     $80
        lda     $dbd3
        beq     @d80f
        lda     $80
        clc
        adc     #$20
        sta     $80
@d80f:  ldx     $7e
        lda     #$f0
        sta     $d1df,x
        stz     $d1e0,x
        lda     $80
        sta     $d1e1,x
        stz     $d1e2,x
        plx
        rts

; ---------------------------------------------------------------------------

_c1d823:
        .byte   $90,$80,$70,$60,$50,$40,$30,$20
        .byte   $14,$18,$1c,$20,$24,$28,$2c,$30
        .byte   $00,$10,$20,$30,$40,$50,$60,$70

; ---------------------------------------------------------------------------

_c1d83b:
        phy
        phx
        stx     $7e
        lda     $d1e0,x
        bne     @d879
        lda     $d1df,x
        lsr4
        sta     $82
        txa
        lsr4
        sta     $80
        asl2
        tay
        lda     $7b9e,y
        bmi     @d879
        lda     $80
        tay
        lda     $d036,y
        lsr4
        cmp     $82
        bne     @d879
        txa
        lsr4
        ora     #$80
        sta     $d3e2,x
        plx
        ply
        jmp     _c1df24
@d879:  plx
        ply
        iny
        rts

; ---------------------------------------------------------------------------

_c1d87d:
        .byte   $f0,$58
        .byte   $c8,$68
        .byte   $f9,$70
        .byte   $d0,$80

_c1d885:
        .byte   $20,$58
        .byte   $40,$68
        .byte   $29,$70
        .byte   $48,$80

_c1d88d:
        .byte   $f0,$28
        .byte   $f0,$58
        .byte   $f9,$70
        .byte   $f0,$80

; ---------------------------------------------------------------------------

_c1d895:
        phx
        stx     $7e
        txa
        lsr3
        and     #$fe
        tax
        lda     $c1d88d,x
        sta     $80
        lda     $c1d88e,x
        sta     $81
        ldx     $7e
        lda     $80
        sta     $d1df,x
        stz     $d1e0,x
        lda     $81
        sta     $d1e1,x
        stz     $d1e2,x
        plx
        rts

; ---------------------------------------------------------------------------

_c1d8bf:
        iny
        lda     [$70],y
        asl2
        sta     $7e
        lda     $d10d
        and     #$e3
        ora     $7e
        sta     $d10d
        rts

; ---------------------------------------------------------------------------

_c1d8d1:
        iny
        lda     [$70],y
        asl2
        sta     $7e
        lda     $d10a
        and     #$e3
        ora     $7e
        sta     $d10a
        rts

; ---------------------------------------------------------------------------

_c1d8e3:
        .byte   $20,$40,$80,$08,$20,$40,$80,$18

_c1d8eb:
        .byte   $20,$40,$20,$40,$88,$80,$80,$80

_c1d8f3:
        .byte   $f8,$f8,$f8,$f8,$f8,$f8,$f8,$f8

_c1d8fb:
        .byte   $20,$40,$20,$40,$88,$80,$80,$80

; ---------------------------------------------------------------------------

_c1d903:
        lda     $d5d8,x
        sta     $a6
        stz     $d5d9,x
        lda     $d5da,x
        sta     $a7
        stz     $d5db,x
        phx
        txa
        lsr4
        tax
        lda     $db50
        bmi     @d92d
        lda     $c1d8e3,x
        sta     $7e
        lda     $c1d8eb,x
        sta     $80
        bra     @d939
@d92d:  lda     $c1d8f3,x
        sta     $7e
        lda     $c1d8fb,x
        sta     $80
@d939:  plx
        lda     $7e
        sta     $d1df,x
        sta     $a8
        stz     $d1e0,x
        lda     $80
        sta     $d1e1,x
        sta     $a9
        stz     $d1e2,x
        stz     $d1dc,x
        stz     $d1dd,x
        phx
        jsr     $0a6e
        plx
        lda     $ae
        sta     $d3e3,x
        lda     $af
        sta     $d3e4,x
        lda     $b0
        sta     $d3e5,x
        stz     $d3e6,x
        jsr     $e23b
        inc     $d5e1,x
        lda     #$10
        sta     $80
        lda     $d5e1,x
        asl3
        phx
@d97c:  jsr     $0a00
        plx
        clc
        adc     $d5e3,x
        sta     $d1dd,x
        txa
        lsr4
        sta     $d1e3,x
        rts
        lda     $d7e3,x
        bne     @d997
        iny
        rts
@d997:  jmp     _c1df24

; ---------------------------------------------------------------------------

_c1d99a:
        lda     $d116
        bne     @d9ad
        txa
        lsr4
        cmp     #$04
        bcs     @d9ad
        cmp     $d117
        beq     @d9af
@d9ad:  iny
        rts
@d9af:  inc     $d7e3,x
        jmp     _c1df24
        lda     $d7e3,x
        bne     @d9bb
        rts
@d9bb:  stz     $d7e3,x
        inc     $d117
        phx
        phy
        sta     $81
        longa
        clr_ay
@d9c9:  lda     $0070,y
        pha
        iny2
        cpy     #$000c
        bne     @d9c9
        shorta0
        jsr     $0158
        longa
        ldy     #$000c
@d9df:  pla
        sta     $006e,y
        dey2
        bne     @d9df
        shorta0
        ply
        plx
        rts

; ---------------------------------------------------------------------------

_c1d9ed:
        iny
        lda     [$70],y
        bmi     @d9fb
        lda     $d1e7,x
        ora     #$20
        sta     $d1e7,x
        rts
@d9fb:  lda     $d1e7,x
        and     #$df
        sta     $d1e7,x
        rts

; ---------------------------------------------------------------------------

_c1da04:
        iny
        lda     [$70],y
        bmi     @da0f
        and     #$0f
        sta     $bc7f
        rts
@da0f:  stz     $bc7f
        rts

; ---------------------------------------------------------------------------

_c1da13:
        iny
        lda     [$70],y
        bmi     @da28
        and     #$3c
        asl2
        sta     $80
        lda     [$70],y
        and     #$03
        ora     $80
        sta     $bc80
        rts
@da28:  stz     $bc80
        rts

; ---------------------------------------------------------------------------

_c1da2c:
        phx
        iny
        lda     [$70],y
        sta     $80
        lda     #$08
        sta     $82
@da36:  jsr     $fc96       ; generate random number
        and     $80
        sta     $d9d8,x
        stz     $d9d9,x
        jsr     $fc96       ; generate random number
        and     $80
        sta     $da58,x
        stz     $da59,x
        inx2
        dec     $82
        bne     @da36
        lda     #$01
        sta     $db3c
        plx
        rts

; ---------------------------------------------------------------------------

_c1da59:
        phx
        jsr     $fc64
        lda     $d3e2,x
        bmi     @da65
        clr_a
        bra     @da84
@da65:  and     #$07
        tax
        lda     $cffe,x
        cmp     #$07
        bcc     @da83
        cmp     #$0b
        bcc     @da7f
        cmp     #$0f
        bcc     @da7b
        lda     #$03
        bra     @da84
@da7b:  lda     #$02
        bra     @da84
@da7f:  lda     #$01
        bra     @da84
@da83:  clr_a
@da84:  plx
        sta     $d7de,x
        rts

; ---------------------------------------------------------------------------

_c1da89:
@da89:  ldx     $78
        lda     $d3e2,x
        and     #$07
        tax
        lda     $d026,x
        cmp     $d006,x
        beq     @daa6
        inc     $d026,x
        lda     $de
        jsr     $1a77
        inc     $dba4
        sec
        rts
@daa6:  stz     $d026,x
        ldx     $78
        lda     $d3e2,x
        and     #$07
        jsr     $fc74
        eor     #$ff
        sta     $74
        lda     $de
        and     $74
        sta     $de
        jsr     $1a77
        clc
        rts

; ---------------------------------------------------------------------------

_c1dac2:
        phx
        stx     $78
        inc     $d5e1,x
        lda     $d5e1,x
        and     #$01
        bne     @dad9
        lda     $d3e2,x
        bpl     @dadd
        jsr     $da89
        bcc     @dadd
@dad9:  dey2
        plx
        rts
@dadd:  ldx     $78
        stz     $d3f7,x
        plx
        rts

; ---------------------------------------------------------------------------

_c1dae4:
        phx
        jsr     $db18
        jsr     $e45b
        ldx     $84
        lda     $cefb,x
        jsr     $0996
        ldx     $78
        inc     $d5e1,x
        lda     $d5e1,x
        and     #$03
        bne     @db06
        ldx     $84
        dec     $cefb,x
        bmi     @db16
@db06:  ldx     $78
        lda     $86
        sta     $d1dc,x
        lda     $87
        sta     $d1dd,x
        dey2
        plx
        rts
@db16:  plx
        rts

; ---------------------------------------------------------------------------

_c1db18:
@db18:  stx     $78
        longa
        txa
        lsr
        sta     $80
        lsr2
        sta     $84
        stz     $85
        tax
        shorta0
        rts

; ---------------------------------------------------------------------------

_c1db2b:
        phx
        jsr     $db18
        phx
        longa
        lda     $78
        lsr
        tax
        shorta0
        txa
        plx
        sta     $ce7b,x
        clc
        adc     #$40
        sta     $cebb,x
        lda     #$18
        sta     $cdfb,x
        sta     $ce3b,x
        lda     #$10
        sta     $cefb,x
        jmp     _c1e3c0

; ---------------------------------------------------------------------------

_c1db54:
        iny
        lda     [$70],y
        sta     $d7dd,x
        stz     $d7de,x
        longi
        tya
        sta     $d7db,x
        shorta0
        rts

; ---------------------------------------------------------------------------

_c1db67:
        dec     $d7dd,x
        beq     @db79
        inc     $d7de,x
        longa
        lda     $d7db,x
        tay
        shorta0
        rts
@db79:  stz     $d7de,x
        rts
        iny
        lda     [$70],y
        sta     $d7da,x
        longi
        tya
        sta     $d7d8,x
        shorta0
        rts

; ---------------------------------------------------------------------------

_c1db8d:
        dec     $d7da,x
        beq     @db9b
        longa
        lda     $d7d8,x
        tay
        shorta0
@db9b:  rts

; ---------------------------------------------------------------------------

_c1db9c:
        iny
        longa
        lda     [$70],y
        sta     $f86a
        shorta0
        iny
        rts

; ---------------------------------------------------------------------------

; [ animation command $c3: set animation size ]

; b1 = size

_c1dba9:
        iny
        lda     [$70],y
        phx
        and     #$3f
        asl
        tax
        lda     $c1b31c,x   ; width
        sta     $7e
        lda     $c1b31d,x   ; height
        sta     $80
        plx
        inc     $db5f
        lda     $7e
        sta     $d1e5,x
        lda     $80
        sta     $d1e6,x
        phx
        jsr     $feba       ; +$82 = $7e * $80
        plx
        lda     $82
        sta     $d1de,x
        rts

; ---------------------------------------------------------------------------

; [  ]

_c1dbd6:
        lda     $d1dc,x
        sta     $d7e4,x
        lda     $d1dd,x
        sta     $d7e5,x
        rts

; ---------------------------------------------------------------------------

_c1dbe3:
        lda     $d7e4,x
        sta     $d1dc,x
        lda     $d7e5,x
        sta     $d1dd,x
        rts

; ---------------------------------------------------------------------------

_c1dbf0:
        stz     $d1dc,x
        stz     $d1dd,x
        rts

; ---------------------------------------------------------------------------

_c1dbf7:
        lda     $d7e2,x
        bne     _c1dc04
        lda     #$80
        sta     $7e
        iny
        jmp     _dc09

; ---------------------------------------------------------------------------

; [ animation command $83: set animation palette ]

; b1 = palette index

_c1dc04:
@dc04:  iny
        lda     [$70],y
        sta     $7e
_dc09:  lda     $7e
        bmi     @dc32
        lda     $db5d
        bne     @dc26
        lda     $70
        pha
        lda     [$70],y
        and     #$7f
        phx
        phy
        ldy     #$0140
        jsr     $aa1d       ; load attack palette (8-colors)
        ply
        plx
        pla
        sta     $70
@dc26:  lda     $d1e7,x
        ora     #$40
        sta     $d1e7,x
        inc     $db5d
        rts
@dc32:  lda     $d1e7,x
        and     #$bf
        sta     $d1e7,x
        rts

; ---------------------------------------------------------------------------

; [ animation command $be:  ]

_c1dc3b:
        longa
        lda     $d5dc,x
        sta     $d1df,x
        lda     $d5de,x
        sta     $d1e1,x
        shorta0
        rts

; ---------------------------------------------------------------------------

_c1dc4d:
        lda     $d3e6,x
        clc
        adc     #$10
        sta     $d3e6,x
        longa
        lda     $d3e4,x
        sec
        sbc     #$0010
        sta     $d3e4,x
        lda     $d3e4,x
        bmi     @dc70
        shorta0
        dey3
        jsr     $e23b
@dc70:  shorta0
        rts

; ---------------------------------------------------------------------------

_c1dc74:
        longa
        lda     $d1df,x
        sec
        sbc     #$0004
        sta     $d1df,x
        shorta0
        lda     $d5e1,x
        cmp     #$40
        bne     @dc8f
        lda     #$01
        sta     $d407,x
@dc8f:  lda     $d5e1,x
        cmp     #$80
        beq     @dca3
        inc     $d5e1,x
        and     #$04
        lsr2
        sta     $d1e3,x
        dey2
        rts
@dca3:  stz     $d1e3,x
        rts
        phx
        iny
        lda     [$70],y
        longa
        asl4
        tax
        shorta0
        lda     #$01
        sta     $d3e7,x
        plx
        rts

_c1dcbc:
        phx
        iny
        lda     [$70],y
        jsr     $fc74
        sta     $7e
        lda     $db53
        and     $7e
        beq     @dcdd
        lda     [$70],y
        longa
        asl4
        tax
        shorta0
        lda     #$01
        sta     $d3e7,x
@dcdd:  plx
        rts

_c1dcdf:
        longa
        lda     $d1df,x
        sec
        sbc     #$0004
        sta     $d1df,x
        lda     $d1e1,x
        clc
        adc     #$0004
        sta     $d1e1,x
        shorta0
        lda     $d5e1,x
        cmp     #$28
        beq     @dd0e
        cmp     #$10
        bne     @dd08
        lda     #$01
        sta     $d1e3,x
@dd08:  inc     $d5e1,x
        dey2
        rts
@dd0e:  stz     $d5e1,x
        stz     $d1e3,x
        rts

; ---------------------------------------------------------------------------

_c1dd15:
        longa
        lda     $d1df,x
        sec
        sbc     #$0004
        sta     $d1df,x
        lda     $d1e1,x
        sec
        sbc     #$0004
        sta     $d1e1,x
        shorta0
        lda     $d5e1,x
        cmp     #$28
        beq     @dd44
        cmp     #$04
        bne     @dd3e
        lda     #$01
        sta     $d1e3,x
@dd3e:  inc     $d5e1,x
        dey2
        rts
@dd44:  stz     $d5e1,x
        rts

; ---------------------------------------------------------------------------

_c1dd48:
        longa
        lda     $d1df,x
        sec
        sbc     #$0004
        sta     $d1df,x
        lda     $d1e1,x
        clc
        adc     #$0002
        sta     $d1e1,x
        shorta0
        lda     $d5e1,x
        cmp     #$28
        beq     @dd6e
        inc     $d5e1,x
        dey2
        rts
@dd6e:  stz     $d5e1,x
        rts

; ---------------------------------------------------------------------------

_c1dd72:
        longa
        lda     $d1df,x
        clc
        adc     #$0004
        sta     $d1df,x
        lda     $d1e1,x
        clc
        adc     #$0002
        sta     $d1e1,x
        shorta0
        lda     $d5e1,x
        cmp     #$24
        beq     @dd97
        inc     $d5e1,x
        dey2
@dd97:  rts

; ---------------------------------------------------------------------------

_c1dd98:
        iny
        lda     [$70],y
        sta     $80
        stz     $81
        longa
        lda     $d1df,x
        clc
        adc     $80
        sta     $d1df,x
        lda     $d1dc,x
        sta     $d5e2,x
        shorta0
        rts

; ---------------------------------------------------------------------------

_c1ddb4:
        iny
        lda     [$70],y
        sta     $80
        stz     $81
        longa
        lda     $d1e1,x
        clc
        adc     $80
        sta     $d1e1,x
        lda     $d1dc,x
        sta     $d5e2,x
        shorta0
        rts

; ---------------------------------------------------------------------------

_c1ddd0:
        iny
        lda     [$70],y
        sta     $80
        stz     $81
        longa
        lda     $d1df,x
        sec
        sbc     $80
        sta     $d1df,x
        lda     $d1dc,x
        sta     $d5e2,x
        shorta0
        rts

; ---------------------------------------------------------------------------

_c1ddec:
        iny
        lda     [$70],y
        sta     $80
        stz     $81
        longa
        lda     $d1e1,x
        sec
        sbc     $80
        sta     $d1e1,x
        lda     $d1dc,x
        sta     $d5e2,x
        shorta0
        rts

; ---------------------------------------------------------------------------

_c1de08:
        longa
        lda     $d1df,x
        sec
        sbc     #$0004
        sta     $d1df,x
        shorta0
        lda     $d5e1,x
        cmp     #$40
        bne     @de23
        lda     #$01
        sta     $d417,x
@de23:  lda     $d5e1,x
        cmp     #$80
        beq     @de37
        inc     $d5e1,x
        and     #$04
        lsr2
        sta     $d1e3,x
        dey2
        rts
@de37:  stz     $d1e3,x
        rts

; ---------------------------------------------------------------------------

_c1de3b:
        longa
        lda     $d1df,x
        sec
        sbc     #$0004
        sta     $d1df,x
        shorta0
        lda     $d5e1,x
        cmp     #$40
        beq     @de5e
        inc     $d5e1,x
        and     #$04
        lsr2
        sta     $d1e3,x
        dey2
        rts
@de5e:  stz     $d1e3,x
        rts

; ---------------------------------------------------------------------------

_c1de62:
        longa
        lda     $d1df,x
        clc
        adc     #$0100
        sta     $d1df,x
        lda     $d1dc,x
        sta     $d5e2,x
        shorta0
        rts

; ---------------------------------------------------------------------------

_c1de78:
        lda     $dbd3
        beq     @de8c
        longa
        lda     $d1e1,x
        clc
        adc     #$0020
        sta     $d1e1,x
        shorta0
@de8c:  rts

; ---------------------------------------------------------------------------

; [ animation command $ae: set position ]

_c1de8d:
        iny
        lda     [$70],y
        sta     $d1df,x
        stz     $d1e0,x
        iny
        lda     [$70],y
        sta     $d1e1,x
        stz     $d1e2,x
        stz     $d1dc,x
        stz     $d1dd,x
        rts

; ---------------------------------------------------------------------------

_c1dea6:
@dea6:  iny
        lda     [$70],y
        sta     $7e
        txa
        lsr4
        and     #$07
        rts

; ---------------------------------------------------------------------------

_c1deb3:
        jsr     $dea6
        jmp     _c17b43

; ---------------------------------------------------------------------------

_c1deb9:
@deb9:  jsr     $dea6
        jmp     _c17b02

; ---------------------------------------------------------------------------

_c1debf:
        jsr     $dea6
        jmp     _c17a93

; ---------------------------------------------------------------------------

_c1dec5:
        jsr     $dea6
        jmp     _c179a5

; ---------------------------------------------------------------------------

_c1decb:
        jsr     $dea6
        jmp     _c17a2a

; ---------------------------------------------------------------------------

; [ load target palette ]

_c1ded1:
@ded1:  phy
        phx
        longa
        asl5
        tax
        shorta0
        lda     $db55
        bne     @def9
        clr_ay
@dee5:  lda     $d99655,x   ; target palette
        sta     $7e69,y
        sta     $f849,y
        inx
        iny
        cpy     #$0020
        bne     @dee5
        inc     $db55
@def9:  plx
        phx
        lda     $d3e2,x
        bmi     @df06
        and     #$03
        tax
        inc     $db43,x
@df06:  plx
        ply
        rts

; ---------------------------------------------------------------------------

_c1df09:
@df09:  phx
        jsr     $fc74
        sta     $82
        lda     $de
        and     $82
        beq     @df18
        plx
        sec
        rts
@df18:  plx
        clc
        rts

; ---------------------------------------------------------------------------

_c1df1b:
@df1b:  lda     $dbe4
        beq     @df22
        sec
        rts
@df22:  clc
        rts

; ---------------------------------------------------------------------------

; [ animation command $80:  ]

; b1: -aaaaccc
;     a:
;     c:

_c1df24:
@df24:  iny
        lda     [$70],y
        and     #$07
        bne     @df5e
        lda     $d3e2,x
        bmi     @df39
        and     #$03
        phx
        tax
        stz     $db43,x     ; don't use target palette (character)
        plx
        rts
@df39:  lda     $d3e2,x
        and     #$07
        sta     $80
        jsr     $df09
        bcc     @df5d
        jsr     $df1b
        bcc     @df59
        stz     $80
        clr_a
        jsr     $1aa6
        lda     #$01
        sta     $80
        clr_a
        jsr     $1aa6
        rts
@df59:  clr_a
        jsr     $1aa6
@df5d:  rts
@df5e:  lda     [$70],y
        lsr3
        and     #$0f
        jsr     $ded1
        lda     $d3e2,x
        bpl     @df92
        and     #$07
        sta     $80
        jsr     $df09
        bcc     @df9d
        jsr     $df1b
        bcc     @df8d
        stz     $80
        lda     #$0c
        jsr     $1aa6
        lda     #$01
        sta     $80
        lda     #$0c
        jsr     $1aa6
        bra     @df92
@df8d:  lda     #$0c
        jsr     $1aa6
@df92:  lda     [$70],y
        and     #$07
        cmp     #$02
        bne     @df9d
        inc     $db56
@df9d:  rts

; ---------------------------------------------------------------------------

; [ animation command $f7:  ]

_c1df9e:
        phx
        phy
        sty     $7e
        longa
        clr_ay
@dfa6:  lda     $0070,y
        pha
        iny2
        cpy     #$000c
        bne     @dfa6
        shorta0
        ldy     $7e
        iny
        lda     [$70],y
        sta     $72
        lda     $d3e1,x
        bpl     @dfcc
        and     #$07
        jsr     $fc74       ; get bit mask
        sta     $70
        lda     $72
        jsr     $7613
@dfcc:  longa
        ldy     #$000c
@dfd1:  pla
        sta     $006e,y
        dey2
        bne     @dfd1
        shorta0
        ply
        plx
        iny
        rts

; ---------------------------------------------------------------------------

; [  ]

_c1dfe0:
        phx
        phy
        sty     $7e
        longa
        clr_ay
@dfe8:  lda     $0070,y
        pha
        iny2
        cpy     #$000c
        bne     @dfe8
        shorta0
        ldy     $7e
        iny
        lda     [$70],y
        sta     $72
        lda     $d3e2,x
        bpl     @e00e
        and     #$07
        jsr     $fc74       ; get bit mask
        sta     $70
        lda     $72
        jsr     $7613
@e00e:  longa
        ldy     #$000c
@e013:  pla
        sta     $006e,y
        dey2
        bne     @e013
        shorta0
        ply
        plx
        iny
        rts

; ---------------------------------------------------------------------------

; [  ]

_c1e022:
        lda     $d3e6,x
        clc
        adc     #$08
        sta     $d3e6,x
        longa
        lda     $d3e4,x
        sec
        sbc     #$0008
        sta     $d3e4,x
        lda     $d3e4,x
        bmi     @e051
        shorta0
        dey2
        jsr     $e0bc
        inc     $d5e1,x
        lda     $d5e1,x
        and     #$02
        lsr
        sta     $d1e3,x
        rts
@e051:  shorta0
        stz     $d1e3,x
        rts

; ---------------------------------------------------------------------------

_c1e058:
        lda     $d5dc,x
        sta     $a6
        lda     $d5de,x
        sta     $a7
        lda     $d5d8,x
        sta     $a8
        lda     $d5da,x
        sta     $a9

_c1e06c:
@e06c:  phx
        jsr     $0a6e
        plx
        lda     $ae
        sta     $d3e3,x
        lda     $af
        sta     $d3e4,x
        lda     $b0
        sta     $d3e5,x
        stz     $d3e6,x
        jmp     _c1e0bc

; ---------------------------------------------------------------------------

; [  ]

_c1e086:
        phx
        txa
        lsr4
        tax
        lda     $c1e3d4,x
        jsr     $fc57
        plx
        rts

; ---------------------------------------------------------------------------

; [  ]

_c1e096:
        iny
        lda     [$70],y
        jmp     _c1fc57

; ---------------------------------------------------------------------------

_c1e09c:
        longa
        lda     $d1df,x
        clc
        adc     #$0090
        sta     $d1df,x
        lda     $d1e1,x
        sec
        sbc     #$0090
        sta     $d1e1,x
        lda     $d1dc,x
        sta     $d5e2,x
        shorta0
        rts

; ---------------------------------------------------------------------------

; [  ]

_c1e0bc:
@e0bc:  phy
        phx
        stz     $81
        lda     $d3e6,x
        sta     $80
        lda     $d3e3,x
        clc
        adc     #$40
        jsr     $0b59
        plx
        longa
        lda     $84
        clc
        adc     $d5dc,x
        sta     $d1df,x
        shorta0
        phx
        stz     $81
        lda     $d3e6,x
        sta     $80
        lda     $d3e3,x
        jsr     $0b59
        plx
        longa
        lda     $84
        clc
        adc     $d5de,x
        sta     $d1e1,x
        shorta0
        ply
        rts

; ---------------------------------------------------------------------------

_c1e0fc:
        stz     $d7e2,x

_c1e0ff:
@e0ff:  lda     $d1dd,x
        sta     $d5e3,x
        jmp     _c1e23b

; ---------------------------------------------------------------------------

_c1e108:
        longa
        lda     $d1df,x
        sec
        sbc     #$0008
        sta     $d1df,x
        lda     $d1e1,x
        clc
        adc     #$0008
        sta     $d1e1,x
        shorta0
        phx
        lda     #$10
        sta     $80
        lda     $d5e1,x
        asl4
        jsr     $0a00
        plx
        clc
        adc     $d5e3,x
        sta     $d1dd,x
        lda     $d5e1,x
        cmp     #$24
        beq     @e144
        inc     $d5e1,x
        dey2
@e144:  rts

; ---------------------------------------------------------------------------

_c1e145:
        lda     $d3e6,x
        clc
        adc     #$04
        sta     $d3e6,x
        longa
        lda     $d3e4,x
        sec
        sbc     #$0004
        sta     $d3e4,x
        lda     $d3e4,x
        bmi     @e180
        shorta0
        dey2
        jsr     $e23b
        inc     $d5e1,x
        lda     #$10
        sta     $80
        lda     $d5e1,x
        asl3
        phx
        jsr     $0a00
        plx
        clc
        adc     $d5e3,x
        sta     $d1dd,x
@e180:  shorta0
        rts

; ---------------------------------------------------------------------------

_c1e184:
        lda     $d3e6,x
        clc
        adc     #$04
        sta     $d3e6,x
        longa
        lda     $d3e4,x
        sec
        sbc     #$0004
        sta     $d3e4,x
        lda     $d3e4,x
        bmi     @e1c7
        shorta0
        dey2
        jsr     $e23b
        inc     $d5e1,x
        lda     #$10
        sta     $80
        lda     $d5e1,x
        asl3
        phx
        jsr     $0a00
        plx
        clc
        adc     $d5e3,x
        sta     $d1dd,x
        txa
        lsr4
        sta     $d1e3,x
@e1c7:  shorta0
        rts

; ---------------------------------------------------------------------------

_c1e1cb:
        lda     $d3e6,x
        clc
        adc     #$08
        sta     $d3e6,x
        longa
        lda     $d3e4,x
        sec
        sbc     #$0008
        sta     $d3e4,x
        lda     $d3e4,x
        bmi     @e1fc
        shorta0
        dey3
        jsr     $e23b
        inc     $d5e1,x
        lda     $d5e1,x
        and     #$0c
        lsr2
        sta     $d1e3,x
        rts
@e1fc:  shorta0
        stz     $d1e3,x
        rts

; ---------------------------------------------------------------------------

_c1e203:
        lda     $d3e6,x
        clc
        adc     #$08
        sta     $d3e6,x
        longa
        lda     $d3e4,x
        sec
        sbc     #$0008
        sta     $d3e4,x
        lda     $d3e4,x
        bmi     @e234
        shorta0
        dey3
        jsr     $e23b
        inc     $d5e1,x
        lda     $d5e1,x
        and     #$04
        lsr2
        sta     $d1e3,x
        rts
@e234:  shorta0
        stz     $d1e3,x
        rts

; ---------------------------------------------------------------------------

_c1e23b:
@e23b:  phy
        phx
        stz     $81
        lda     $d3e6,x
        sta     $80
        lda     $d3e3,x
        clc
        adc     #$40
        jsr     $0b59
        plx
        longa
        lda     $84
        clc
        adc     $d5d8,x
        sta     $d1df,x
        shorta0
        phx
        stz     $81
        lda     $d3e6,x
        sta     $80
        lda     $d3e3,x
        jsr     $0b59
        plx
        longa
        lda     $84
        clc
        adc     $d5da,x
        sta     $d1e1,x
        shorta0
        ply
        rts

; ---------------------------------------------------------------------------

_c1e27b:
        lda     #$01
        sta     $7e
        lda     #$07
        sta     $80
        phx
        asl     $7e
        lda     $7e
        tax
        stz     $81
        longa
        dec     $80
        lda     $7f69,x
        pha
@e293:  sta     $82
        lda     $7f6b,x
        sta     $7f69,x
        inx2
        dec     $80
        bne     @e293
        pla
        sta     $7f69,x
        shorta0
        plx
        rts

; ---------------------------------------------------------------------------

_c1e2aa:
@e2aa:  lda     #$01
        sta     $7e
        lda     #$07
        sta     $80
        phx
        asl     $7e
        dec     $80
        lda     $80
        asl
        clc
        adc     $7e
        tax
        stz     $81
        longa
        lda     $7f69,x
        pha
@e2c6:  lda     $7f67,x
        sta     $7f69,x
        dex
        dex
        dec     $80
        bne     @e2c6
        pla
        sta     $7f69,x
        shorta0
        plx
        rts

; ---------------------------------------------------------------------------

_c1e2db:
        phx
        jsr     $e589
        lda     $80
        sta     $ce7b,x
        clc
        adc     #$40
        sta     $cebb,x
        lda     #$18
        sta     $cdfb,x
        lda     #$08
        sta     $ce3b,x
        lda     #$20
        sta     $cefb,x
        jsr     $e45b
        ldx     $78
        lda     $86
        sta     $d1dc,x
        lda     $87
        sta     $d1dd,x
        plx
        rts

; ---------------------------------------------------------------------------

_c1e30a:
        phx
        jsr     $e589
        lda     $80
        sta     $ce7b,x
        clc
        adc     #$40
        sta     $cebb,x
        stz     $cdfb,x
        stz     $ce3b,x
        lda     #$01
        sta     $cefb,x
        plx
        rts

; ---------------------------------------------------------------------------

_c1e326:
        phx
        jsr     $e391
        clc
        adc     #$40
        sta     $cebb,x
        lda     #$70
        sta     $cdfb,x
        sta     $ce3b,x
        lda     #$fc
        sta     $cefb,x
        jmp     _c1e3c0

; ---------------------------------------------------------------------------

_c1e340:
        phx
        jsr     $e589
        lda     $80
        sta     $ce7b,x
        clc
        adc     #$40
        sta     $cebb,x
        lda     #$10
        sta     $cdfb,x
        sta     $ce3b,x
        lda     #$10
        sta     $cefb,x
        jsr     $e45b
        ldx     $78
        lda     $86
        sta     $d1dc,x
        lda     $87
        sta     $d1dd,x
        lda     #$07
        sta     $d1e3,x
        plx
        rts

; ---------------------------------------------------------------------------

_c1e372:
        phx
        jsr     $e589
        lda     $80
        sta     $ce7b,x
        clc
        adc     #$40
        sta     $cebb,x
        lda     #$70
        sta     $cdfb,x
        sta     $ce3b,x
        lda     #$fc
        sta     $cefb,x
        jmp     _c1e3c0

; ---------------------------------------------------------------------------

_c1e391:
@e391:  stx     $78
        txa
        lsr4
        sta     $84
        stz     $85
        tax
        jsr     $fc96       ; generate random number
        sta     $ce7b,x
        rts

; ---------------------------------------------------------------------------

_c1e3a4:
        phx
        jsr     $e589
        lda     $80
        sta     $ce7b,x
        clc
        adc     #$40
        sta     $cebb,x
        lda     #$40
        sta     $cdfb,x
        sta     $ce3b,x
        lda     #$fc
        sta     $cefb,x

_c1e3c0:
@e3c0:  jsr     $e45b
        ldx     $78
        lda     $86
        sta     $d1dc,x
        lda     $87
        sta     $d1dd,x
        stz     $d1e3,x
        plx
        rts

; ---------------------------------------------------------------------------

_c1e3d4:
        .byte   $00,$00,$00,$00,$0e,$0c,$10,$0a

_c1e3dc:
        .byte   $60,$00,$40,$20,$c0,$a0,$e0,$80

_c1e3e4:
        .byte   $08,$02,$06,$04,$0e,$0c,$10,$0a

; ---------------------------------------------------------------------------

_c1e3ec:
        phx
        jsr     $e589
        phx
        lda     $c1e3dc,x
        plx
        sec
        sbc     #$40
        sta     $ce7b,x
        clc
        adc     #$40
        sta     $cebb,x
        lda     #$18
        sta     $cdfb,x
        lda     #$08
        sta     $ce3b,x
        lda     #$02
        sta     $cefb,x
        jsr     $e45b
        ldx     $78
        lda     $86
        sta     $d1dc,x
        lda     $87
        sta     $d1dd,x
        stz     $d1e3,x
        plx
        rts

; ---------------------------------------------------------------------------

; [ animation command $94:  ]

_c1e425:
        phx
        jsr     $e589
        lda     $80
        sta     $ce7b,x
        clc
        adc     #$40
        sta     $cebb,x
        lda     #$04
        sta     $cdfb,x
        sta     $ce3b,x
        lda     #$02
        sta     $cefb,x
        jsr     $e45b
        ldx     $78
        lda     $86
        sec
        sbc     #$05
        sta     $d1dc,x
        lda     $87
        sec
        sbc     #$08
        sta     $d1dd,x
        stz     $d1e3,x
        plx
        rts

; ---------------------------------------------------------------------------

; [  ]

_c1e45b:
@e45b:  ldx     $84
        jsr     $09ca
        sta     $86
        ldx     $84
        jsr     $09e5
        sta     $87
        rts

; ---------------------------------------------------------------------------

; [ animation command $95:  ]

_c1e46a:
        phx
        jsr     $e589
        jsr     $e45b
        ldx     $84
        lda     #$fc
        jsr     $0996
        ldx     $84
        lda     $cefb,x
        jsr     $09b9
        cmp     #$20
        bcs     @e4ac
        and     #$07
        bne     @e496
        ldx     $78
        lda     $d1e3,x
        and     #$03
        cmp     #$03
        beq     @e496
        inc     $d1e3,x
@e496:  ldx     $78
        lda     $86
        sec
        sbc     #$05
        sta     $d1dc,x
        lda     $87
        sec
        sbc     #$08
        sta     $d1dd,x
        dey2
        plx
        rts
@e4ac:  ldx     $78
        stz     $d1e3,x
        plx
        rts

; ---------------------------------------------------------------------------

_c1e4b3:
@e4b3:  lda     $cdfb,x
        ldx     #$0007
        cmp     #$08
        bcc     @e4dc
        dex
        cmp     #$10
        bcc     @e4dc
        dex
        cmp     #$18
        bcc     @e4dc
        dex
        cmp     #$20
        bcc     @e4dc
        dex
        cmp     #$28
        bcc     @e4dc
        dex
        cmp     #$30
        bcc     @e4dc
        dex
        cmp     #$38
        bcc     @e4dc
        dex
@e4dc:  txa
        rts

; ---------------------------------------------------------------------------

_c1e4de:
        phx
        jsr     $e589
        jsr     $e45b
        ldx     $84
        lda     #$fc
        jsr     $0996
        ldx     $84
        lda     $cdfb,x
        beq     @e514
        lda     $cefb,x
        jsr     $09b9
        lda     $cdfb,x
        jsr     $e4b3
        ldx     $78
        sta     $d1e3,x
        ldx     $78
        lda     $86
        sta     $d1dc,x
        lda     $87
        sta     $d1dd,x
        dey2
        plx
        rts
@e514:  ldx     $78
        stz     $d1e3,x
        plx
        rts

; ---------------------------------------------------------------------------

_c1e51b:
        phx
        jsr     $e589
        jsr     $e45b
        ldx     $84
        lda     $cdfb,x
        beq     @e54a
        lda     $cefb,x
        jsr     $09b9
        lda     $cdfb,x
        jsr     $e4b3
        ldx     $78
        sta     $d1e3,x
        ldx     $78
        lda     $86
        sta     $d1dc,x
        lda     $87
        sta     $d1dd,x
        dey2
        plx
        rts
@e54a:  ldx     $78
        stz     $d1e3,x
        plx
        rts

; ---------------------------------------------------------------------------

_c1e551:
        phx
        jsr     $e589
        jsr     $e45b
        ldx     $84
        lda     $cdfb,x
        cmp     #$70
        beq     @e582
        lda     $cefb,x
        jsr     $09b9
        lda     $cdfb,x
        jsr     $e4b3
        ldx     $78
        sta     $d1e3,x
        ldx     $78
        lda     $86
        sta     $d1dc,x
        lda     $87
        sta     $d1dd,x
        dey2
        plx
        rts
@e582:  ldx     $78
        stz     $d1e3,x
        plx
        rts

; ---------------------------------------------------------------------------

_c1e589:
@e589:  txa
        stx     $78
        asl
        sta     $80
        txa
        lsr4
        sta     $84
        stz     $85
        tax
        rts

; ---------------------------------------------------------------------------

_c1e59a:
        phx
        jsr     $e589
        jsr     $e45b
        ldx     $84
        lda     $cefb,x
        jsr     $09b9
        cmp     #$20
        bcs     @e5c8
        lsr3
        and     #$03
        ldx     $78
        sta     $d1e3,x
        lda     $86
        sta     $d1dc,x
        lda     $87
        sec
        sbc     #$08
        sta     $d1dd,x
        dey2
        plx
        rts
@e5c8:  ldx     $78
        stz     $d1e3,x
        plx
        rts

; ---------------------------------------------------------------------------

_c1e5cf:
        phx
        jsr     $e589
        jsr     $e45b
        ldx     $84
        lda     #$04
        jsr     $0996
        dec     $cefb,x
        beq     @e60b
        ldx     $78
        and     #$08
        lsr3
        sta     $d1e3,x
        lda     $87
        and     #$80
        lsr6
        clc
        adc     $d1e3,x
        sta     $d1e3,x
        lda     $86
        sta     $d1dc,x
        lda     $87
        sta     $d1dd,x
        dey2
        plx
        rts
@e60b:  ldx     $78
        stz     $d1e3,x
        plx
        rts

; ---------------------------------------------------------------------------

_c1e612:
        lda     $d1dd,x
        beq     @e61c
        dey5
@e61c:  rts

; ---------------------------------------------------------------------------

_c1e61d:
        lda     $d1dd,x
        beq     @e631
        dey4
        lda     $a2
        lsr3
        and     #$01
        sta     $d1e3,x
        rts
@e631:  stz     $d1e3,x
        rts

; ---------------------------------------------------------------------------

_c1e635:
        iny
        lda     [$70],y
        sta     $7e
        phx
        jsr     $fc96       ; generate random number
        sta     $80
        jsr     $feba       ; +$82 = $7e * $80
        plx
        lda     $83
        lsr     $7e
        sec
        sbc     $7e
        sta     $d1dc,x
        rts
        iny
        lda     [$70],y
        asl
        phx
        tax
        lda     $c1e665,x
        sta     $80
        lda     $c1e666,x
        sta     $81
        plx
        jmp     ($0080)

; ---------------------------------------------------------------------------

_c1e665:
        .addr   $e6d5,$e699,$e6a6,$e66f,$e67c

; ---------------------------------------------------------------------------

_c1e66f:
        lda     $db50
        and     #$40
        jeq     _c1e687
        jmp     _c1e690

; ---------------------------------------------------------------------------

_c1e67c:
        lda     $db50
        jpl     _c1e687
        jmp     _c1e690

; ---------------------------------------------------------------------------

_c1e687:
@e687:  lda     #$20
        sta     $84
        sta     $86
        jmp     _c1e721

; ---------------------------------------------------------------------------

_c1e690:
@e690:  lda     #$30
        sta     $84
        sta     $86
        jmp     _c1e721

; ---------------------------------------------------------------------------

_c1e699:
        lda     $db50
        and     #$40
        jeq     _c1e6c2
        jmp     _c1e6b1

; ---------------------------------------------------------------------------

_c1e6a6:
        lda     $db50
        jpl     _c1e6c2
        jmp     _c1e6b1

; ---------------------------------------------------------------------------

_c1e6b1:
@e6b1:  lda     #$a0
        sta     $84
        stz     $85
        lda     #$70
        sta     $86
        lda     #$30
        sta     $87
        jmp     _c1e6e4

; ---------------------------------------------------------------------------

_c1e6c2:
@e6c2:  lda     #$40
        sta     $84
        lda     #$b0
        sta     $85
        lda     #$70
        sta     $86
        lda     #$30
        sta     $87
        jmp     _c1e6e4

; ---------------------------------------------------------------------------

_c1e6d5:
        lda     #$ff
        sta     $84
        stz     $85
        lda     #$90
        sta     $86
        stz     $87
        jmp     _c1e6e4

; ---------------------------------------------------------------------------

_c1e6e4:
@e6e4:  lda     $84
        sta     $7e
        phx
        jsr     $fc96       ; generate random number
        sta     $80
        jsr     $feba       ; +$82 = $7e * $80
        plx
        lda     $83
        clc
        adc     $85
        sta     $d1df,x
        lda     $d1e0,x
        adc     #$00
        sta     $d1e0,x
        lda     $86
        sta     $7e
        phx
        jsr     $fc96       ; generate random number
        sta     $80
        jsr     $feba       ; +$82 = $7e * $80
        plx
        lda     $83
        clc
        adc     $87
        sta     $d1e1,x
        lda     $d1e2,x
        adc     #$00
        sta     $d1e2,x
        rts

; ---------------------------------------------------------------------------

_c1e721:
@e721:  lda     $84
        sta     $7e
        phx
        jsr     $fc96       ; generate random number
        sta     $80
        jsr     $feba       ; +$82 = $7e * $80
        plx
        lsr     $84
        lda     $83
        sec
        sbc     $84
        longa
        clc
        adc     $d5dc,x
        and     #$00ff
        sta     $d1df,x
        shorta0
        lda     $86
        sta     $7e
        phx
        jsr     $fc96       ; generate random number
        sta     $80
        jsr     $feba       ; +$82 = $7e * $80
        plx
        lda     $83
        lsr     $86
        sec
        sbc     $86
        longa
        clc
        adc     $d5de,x
        and     #$00ff
        sta     $d1e1,x
        shorta0
        rts

; ---------------------------------------------------------------------------

; [ animation command $88: set animation speed]

; b1 = speed

_c1e76a:
        iny
        lda     [$70],y
        sta     $d3dd,x
        sta     $d3de,x
        rts

; ---------------------------------------------------------------------------

_c1e774:
        iny
        lda     [$70],y
        sta     $d3de,x
        rts
        iny
        lda     [$70],y
        sta     $80
        phx
        jsr     $fc96       ; generate random number
        sta     $7e
        jsr     $feba       ; +$82 = $7e * $80
        lda     $83
        inc
        plx
        sta     $d3de,x
        rts

; ---------------------------------------------------------------------------

_c1e791:
        iny
        lda     [$70],y
        lsr4
        and     #$fe
        phx
        tax
        lda     $c1e7b3,x
        sta     $80
        lda     $c1e7b4,x
        sta     $81
        lda     [$70],y
        and     #$1f
        inc
        sta     $82
        plx
        jmp     ($0080)

; ---------------------------------------------------------------------------

_c1e7b3:
        .addr   $e7c3,$e7c9,$e7cc,$e7d2,$e7d5,$e7d8,$e7de,$e7e1

; ---------------------------------------------------------------------------

_c1e7c3:
        jsr     $e7fb
        jmp     _c1e7f1

; ---------------------------------------------------------------------------

_c1e7c9:
        jmp     _c1e7f1

; ---------------------------------------------------------------------------

_c1e7cc:
        jsr     $e7e7
        jmp     _c1e7f1

; ---------------------------------------------------------------------------

_c1ecd2:
        jmp     _c1e7fb

; ---------------------------------------------------------------------------

_c1e7d5:
        jmp     _c1e7e7

; ---------------------------------------------------------------------------

_c1e7d8:
        jsr     $e7fb
        jmp     _c1e805

; ---------------------------------------------------------------------------

_c1e7de:
        jmp     _c1e805

; ---------------------------------------------------------------------------

_c1e7e1:
        jsr     $e7e7
        jmp     _c1e805

; ---------------------------------------------------------------------------

_c1e7e7:
@e7e7:  lda     $d1dc,x
        clc
        adc     $82
        sta     $d1dc,x
        rts

; ---------------------------------------------------------------------------

_c1e7f1:
@e7f1:  lda     $d1dd,x
        clc
        adc     $82
        sta     $d1dd,x
        rts

; ---------------------------------------------------------------------------

_c1e7fb:
@e7fb:  lda     $d1dc,x
        sec
        sbc     $82
        sta     $d1dc,x
        rts

; ---------------------------------------------------------------------------

_c1e805:
@e805:  lda     $d1dd,x
        sec
        sbc     $82
        sta     $d1dd,x
        rts

; ---------------------------------------------------------------------------

_c1e80f:
        rts

; ---------------------------------------------------------------------------

_c1e810:
@e810:  clr_ax
        lda     #$aa
@e814:  sta     $0402,x
        inx
        cpx     #$000e
        bne     @e814
        rts

; ---------------------------------------------------------------------------

_c1e81e:
@e81e:  lda     #$08
        sta     $db3a
        stz     $db39
        lda     $d1bc
        and     #$80
        sta     $db3b
        rts

; ---------------------------------------------------------------------------

; [  ]

_c1e82f:
        jsr     $b7bc
        jsr     $e810
        jsr     $e81e
        inc     $d110
        jsr     $02f2       ; wait one frame
        lda     #$01
        sta     $db69
        lda     $db75
        sta     $db74
@e849:  lda     #$01
        sta     $db38
        jsr     $02f2       ; wait one frame
        lda     $d1bc
        and     #$80
        beq     @e867
        clr_ax
        lda     #$08
        jsr     $c409
        lda     $74
        cmp     #$08
        bne     @e849
        bra     @e884
@e867:  clr_ax
        lda     #$04
        jsr     $c409
        lda     $74
        pha
        jsr     $02f2       ; wait one frame
        ldx     #$0040
        lda     #$04
        jsr     $c409
        pla
        clc
        adc     $74
        cmp     #$08
        bne     @e849
@e884:  jsr     $02f2       ; wait one frame
        lda     $db69
        ora     $db74
        bne     @e884
        stz     $db38
        stz     $d110
        jsr     $67d3
        jsr     _c1fc6d
        stz     $db3c
        lda     $d1bc
        and     #$3f
        cmp     #$1c
        beq     @e8c1
        cmp     #$08
        beq     @e8c1
        cmp     #$11
        bne     @e8c4
        longa
        lda     $eb
        clc
        adc     #$0015
        sta     $eb
        shorta0
        lda     $db53
        beq     @e8d1
@e8c1:  jsr     $e8d8
@e8c4:  lda     $d1bc
        and     #$3f
        cmp     #$2a
        beq     @e8d5
        cmp     #$2b
        beq     @e8d2
@e8d1:  rts
@e8d2:  jmp     _c19dcb
@e8d5:  jmp     _c19e0a

; ---------------------------------------------------------------------------

_c1e8d8:
@e8d8:  jsr     $02f2       ; wait one frame
        lda     $d111
        and     #$1f
        sta     $7e
        lda     $d112
        and     #$1f
        ora     $7e
        lda     $d113
        and     #$1f
        ora     $7e
        beq     @e8f6
        cmp     #$01
        bne     @e8d8
@e8f6:  clr_ax
@e8f8:  phx
        clr_a
        sta     $7e
        txa
        jsr     $7b02
        plx
        inx
        cpx     #$0008
        bne     @e8f8
        rts

; ---------------------------------------------------------------------------

; [  ]

_c1e908:
@e908:  jsr     $b7bc
        jsr     $e810
        jsr     $e81e
        inc     $d110
        jsr     $02f2       ; wait one frame
        stz     $db5f
        stz     $db39
        stz     $f869
        lda     #$01
        sta     $db69
        lda     $db75
        sta     $db74
        rts

; ---------------------------------------------------------------------------

; [  ]

_c1e92c:
        jsr     $e908
@e92f:  lda     #$02
        sta     $db38
        ldx     #$0000
        lda     #$10
        jsr     $c409
        lda     $74
        sta     $f869
        jsr     $02f2       ; wait one frame
        ldx     #$0100
        lda     #$10
        jsr     $c409
        lda     $f869
        clc
        adc     $74
        sta     $f869
        jsr     $02f2       ; wait one frame
        lda     $f869
        cmp     #$20
        bne     @e92f
        jmp     _e97b

; ---------------------------------------------------------------------------

_c1e962:
        jsr     $e908
@e965:  jsr     $02f2       ; wait one frame
        lda     #$02
        sta     $db38
        ldx     #$0000
        lda     #$20
        jsr     $c409
        lda     $74
        cmp     #$20
        bne     @e965
_e97b:  jsr     $02f2       ; wait one frame
        lda     $db69
        ora     $db74
        bne     _e97b
        stz     $db38
        stz     $d110
        stz     $db5d
        jsr     $67d3
        jsr     _c1fc6d
        stz     $db3c
        rts

; ---------------------------------------------------------------------------

; [ show game stats (unknown cave psychic) ]

_c1e999:
        longi
        shorta
        jsr     $0888       ; init hardware registers
        jsr     $f88c
        jsr     $eafb
        lda     #$53
        sta     $ce
        clr_ax
@e9ac:
.if LANG_EN
        lda     $e75800,x
.else
        lda     $d0defa,x
.endif
        sta     $dbf6,x
        inx
        cpx     #$0100
        bne     @e9ac
        clr_ax
@e9bb:  lda     $c1eaf3,x
        sta     $bc6d,x
        inx
        cpx     #$0008
        bne     @e9bb
        clr_ax
@e9ca:  sta     $8009,x
        inx
        cpx     #$0800
        bne     @e9ca
        jsr     $3ed3
        ldx     #$dbf6
        stx     $bca0
        ldx     #$8093
        stx     $bca2
        lda     #$20
        sta     $bca4
        stz     $bca5
        jsr     $2dac
        clr_axy
        lda     #$20
        sta     $70
@e9f4:  lda     $8009,y
        sta     $7f8000,x
        dec     $70
        bne     @ea0e
        lda     #$20
        sta     $70
        longa
        txa
        clc
        adc     #$00c0
        tax
        shorta0
@ea0e:  inx2
        iny2
        cpy     #$0800
        bne     @e9f4
        ldx     #$8000
        stx     $70
        ldx     #$8000
        clr_ay
        lda     #$7f
        jsr     $fdca       ; copy data to vram
        clr_ay
        lda     #$03
        jsr     $aa3e       ; load attack palette (16-colors)
        clr_ax
        stx     $bc77
        ldx     #$ffd0
        stx     $bc79
        ldx     #$0080
        stx     $f9e7
        lda     #$07        ; mode 7
        sta     $bc81
        lda     #$01
        sta     $ff05
        stz     $db4c
        stz     $f9eb
        lda     #$fe
        sta     $f9ec
        stz     $db4a
        lda     #$04
        sta     $db4b
        lda     #$01
        sta     $fefb
        sta     f:$00212c
        sta     f:$00212e
@ea68:  lda     f:$004210
        bpl     @ea68
        lda     #$81
        sta     f:$004200
        cli
        lda     #$0f
        sta     $bc7f
@ea7a:  jsr     $fd1d       ; wait for vblank
        longa
        lda     $f9e7
        clc
        adc     #$0020
        sta     $f9e7
        tax
        shorta0
        cpx     #$0200
        bne     @ea7a
@ea92:  jsr     $fd1d       ; wait for vblank
        lda     $db4c
        beq     @eaac
@ea9a:  lda     $f9eb
        cmp     $db4a
        bcs     @eaa7
        jsr     $eae8
        bra     @eaac
@eaa7:  dec     $f9eb
        bra     @eac2
@eaac:  lda     $f9eb
        cmp     $db4b
        bcc     @eabf
        jsr     $eae8
        dec     $db4b
        inc     $db4a
        bra     @ea9a
@eabf:  inc     $f9eb
@eac2:  lda     $db4a
        cmp     #$02
        bne     @ea92
        lda     #$1e        ; 30 * 2 = 60 frames (1 second)
@eacb:  pha
        jsr     $02f2       ; wait one frame
        inc     $f9eb
        jsr     $02f2       ; wait one frame
        dec     $f9eb
        pla
        dec
        bne     @eacb
@eadc:  jsr     $fd1d       ; wait for vblank
        lda     $00
        ora     $01
        beq     @eadc       ; wait for keypress
        jmp     _c1f790       ; fade out and return

; ---------------------------------------------------------------------------

; [  ]

_c1eae8:
@eae8:  pha
        lda     $db4c
        eor     #$01
        sta     $db4c
        pla
        rts

; ---------------------------------------------------------------------------

_c1eaf3:
        .byte   $09,$80,$03,$00,$1a,$0e,$00,$00

; ---------------------------------------------------------------------------

_c1eafb:
@eafb:  phb
        lda     #$d1
        pha
        plb
        clr_axy
@eb03:  lda     #$08
        sta     $78
@eb07:  longa
        lda     $f000,y
        sta     $70
        shorta0
        lda     #$08
        sta     $76
@eb15:  clr_a
        asl     $71
        rol
        asl     $70
        rol
        sta     $7f8001,x
        clr_a
        sta     $7f8000,x
        inx2
        dec     $76
        bne     @eb15
        iny2
        dec     $78
        bne     @eb07
        cpy     #$1000
        bne     @eb03
        plb
        rts

; ---------------------------------------------------------------------------

; [  ]

_c1eb38:
@eb38:  phx
        ldx     #$2000
        stx     $70
        plx
        lda     #$7f
        phy
        jsr     $ed01
        ply
        longa
        tya
        clc
        adc     #$1000
        tay
        shorta0
        rts

; ---------------------------------------------------------------------------

; [  ]

_c1eb52:
@eb52:  clr_ayx
        jsr     $eb38
        ldx     #$2000
        jsr     $eb38
        ldx     #$2000
        jsr     $eb38
        ldx     #$2000
        jsr     $eb38
        clr_ax
@eb6c:  lda     $ed76,x
        sta     $7e29,x
        lda     $ed96,x
        sta     $7e09,x
        lda     $edb6,x
        sta     $7e49,x
        lda     $edd6,x
        sta     $7e69,x
        inx
        cpx     #$0020
        bne     @eb6c
        ldx     #$0040
        stx     $bc8e
        stx     $bc94
        clr_ax
        stx     $bc90
        stx     $bc92
        inx
        stx     $bc77
        stx     $bc79
        ldx     #$0081
        stx     $bc96
        ldx     #$ffeb
        stx     $bc98
        lda     #$11
        sta     $fefb
        lda     #$07        ; mode 7
        sta     $bc81
        lda     #$04
        sta     $dbf5
        inc     $bc8d
        clr_ax
        lda     #$f0
@ebc4:  sta     $0200,x
        inx
        cpx     #$0100
        bne     @ebc4
@ebcd:  jsr     $fd1d       ; wait for vblank
        jsr     $f5f6
        jsr     $fd1d       ; wait for vblank
        jsr     $f5f6
        ldx     $bc8e
        inx
        stx     $bc8e
        stx     $bc94
        cpx     #$0080
        bne     @ebcd
        rts

_c1ebe9:
@ebe9:  clr_axy
@ebec:  lda     $2000,x
        and     #$07
        sta     $cfc6,y
        lda     $2001,x
        sta     $cfca,y
        iny
        longa
        txa
        clc
        adc     #$0080
        tax
        shorta0
        cpx     #$0200
        bne     @ebec
        jsr     $24e2       ; load character graphics
        inc     $ff2b
        jsr     $2607       ; load character palettes
        clr_ax
@ec16:  lda     $7f09,x
        sta     $ed76,x
        inx
        cpx     #$0080
        bne     @ec16
        clr_ax
        stx     $ed76
        stx     $ed96
        stx     $edb6
        stx     $edd6
@ec30:  lda     $7fd000,x
        sta     $7fd8c0,x
        lda     $7fe000,x
        sta     $7fd980,x
        lda     $7fe800,x
        sta     $7fda40,x
        inx
        cpx     #$00c0
        bne     @ec30
        ldx     #$0300
        stx     $7e
        jsr     $95bf
        clr_ax
@ec58:  lda     $7fe000,x
        sta     $7f0000,x
        clr_a
        sta     $7f2000,x
        inx
        cpx     #$2000
        bne     @ec58
        clr_ax
        stz     $70
        ldy     #$0180
@ec72:  lda     $7f0081,x
        ora     $70
        sta     $7f0081,x
        dey
        bne     @ec89
        ldy     #$0180
        lda     $70
        clc
        adc     #$10
        sta     $70
@ec89:  inx2
        cpx     #$0c00
        bne     @ec72
        lda     #$0f
        sta     $70
        stz     $73
        clr_a
        jsr     $ecc1
        lda     #$0f
        sta     $70
        lda     #$08
        sta     $73
        lda     #$01
        jsr     $ecc1
        lda     #$0a
        sta     $70
        lda     #$04
        sta     $73
        lda     #$02
        jsr     $ecc1
        lda     #$14
        sta     $70
        lda     #$04
        sta     $73
        lda     #$03
        jmp     _c1ecc1

; ---------------------------------------------------------------------------

_c1ecc1:
@ecc1:  tax
        lda     $c1ecfd,x
        sta     $74
        lda     $70
        stz     $71
        stz     $72
        lda     $72
        longa
        asl     $70
        lda     $70
        clc
        adc     $72
        tax
        shorta0
        lda     $74
        sta     $7f0000,x
        inc
        sta     $7f0002,x
        inc
        sta     $7f0100,x
        inc
        sta     $7f0102,x
        inc
        sta     $7f0200,x
        inc
        sta     $7f0202,x
        rts

; ---------------------------------------------------------------------------

_c1ecfd:
        .byte   $01,$07,$0d,$13

; ---------------------------------------------------------------------------

_c1ed01:
@ed01:  phx
        phy
        pha
        ldx     $70
        phx
@ed07:  lda     $d0d6
        beq     @ed14
        jsr     $fd1d       ; wait for vblank
        jsr     $f5f6
        bra     @ed07
@ed14:  plx
        stx     $d0de
        pla
        sta     $d0d9
        ply
        sty     $d0da
        plx
        stx     $d0d7
        stz     $d0e0
@ed27:  longa
        lda     $d0de
        cmp     #$0800
        beq     @ed3b
        bcc     @ed3b
        lda     #$0800
        sta     $d0dc
        bra     @ed41
@ed3b:  sta     $d0dc
        inc     $d0e0
@ed41:  shorta0
        inc     $d0d6
        jsr     $fd1d       ; wait for vblank
        jsr     $f5f6
        longa
        lda     $d0d7
        clc
        adc     #$0800
        sta     $d0d7
        lda     $d0da
        clc
        adc     #$0400
        sta     $d0da
        lda     $d0de
        sec
        sbc     #$0800
        sta     $d0de
        shorta0
        lda     $d0e0
        beq     @ed27
        rts

; ---------------------------------------------------------------------------

; [  ]

_c1ed76:
@ed76:  lda     #$d0        ; ??? (d0/e4cb)
        sta     $74
        ldx     #$e4cb
        stx     $72
        jsr     $fb77       ; decompress
        phb
        lda     #$7f
        pha
        plb
        clr_axy
@ed8a:  lda     #$08
        sta     $78
@ed8e:  longa
        lda     $c000,y
        sta     $70
        lda     $c010,y
        sta     $72
        shorta0
        lda     #$08
        sta     $76
@eda1:  clr_a
        asl     $73
        rol
        asl     $72
        rol
        asl     $71
        rol
        asl     $70
        rol
        sta     $d081,x
        stz     $d080,x
        inx2
        dec     $76
        bne     @eda1
        iny2
        dec     $78
        bne     @ed8e
        longa
        tya
        clc
        adc     #$0010
        tay
        shorta0
        cpy     #$0800
        bne     @ed8a
        clr_ax
@edd2:  sta     $d000,x
        inx
        cpx     #$0080
        bne     @edd2
        ldx     #$dc10
        stx     $70
        stz     $72
@ede2:  clr_ay
@ede4:  inc     $72
        lda     $72
        sta     ($70),y
        iny2
        cpy     #$0020
        bne     @ede4
        longa
        lda     $70
        clc
        adc     #$0100
        sta     $70
        shorta0
        lda     $72
        cmp     #$40
        bne     @ede2
        plb
        rts

; ---------------------------------------------------------------------------

; [  ]

_c1ee06:
@ee06:  ldx     #$00e0
@ee09:  lda     $b454,x
        sta     $b455,x
        dex
        cpx     #$0070
        bne     @ee09
        clr_ax
@ee17:  lda     $b456,x
        sta     $b455,x
        inx
        cpx     #$0070
        bne     @ee17
        rts

; ---------------------------------------------------------------------------

; [  ]

_c1ee24:
@ee24:  jsr     $fd1d       ; wait for vblank
        jmp     _c1f5f6

; ---------------------------------------------------------------------------

; [  ]

_c1ee2a:
        ldx     #$0200
        stx     $70
        ldx     #$e220
        ldy     #$7000
        lda     #$d0
        jsr     $fd27
        jsr     $f3ba
        jsr     _c1fc6d
        jsr     $ebe9
        jsr     $ed76
        clr_ax
@ee48:  lda     $7fa9,x
        sta     $7f09,x
        inx
        cpx     #$0020
        bne     @ee48
        clr_ax
@ee56:  lda     $0203,x
        and     #$f1
        sta     $0203,x
        inx4
        cpx     #$0100
        bne     @ee56
        clr_ax
@ee69:  sta     $0410,x
        inx
        cpx     #$0010
        bne     @ee69
        ldx     #$0100
@ee75:  phx
        jsr     $ee24
        jsr     $ef50
        plx
        dex
        bne     @ee75
        lda     #$10
        sta     $fefb
        ldx     #$0070
@ee88:  phx
        jsr     $ee24
        jsr     $ee06
        plx
        dex
        bne     @ee88
        stz     $bc84
        jsr     $eb52
        lda     #$78
        jsr     $ef26
        ldx     #$0100
@eea1:  phx
        jsr     $ee24
        jsr     $ef30
        plx
        dex
        bne     @eea1
        lda     #$10
        sta     $fefb
        clr_ax
@eeb3:  lda     $d0e48b,x
        sta     $7e09,x
        lda     $d0e4ab,x
        sta     $7f89,x
        inx
        cpx     #$0020
        bne     @eeb3
        ldx     #$2080
        stx     $70
        ldx     #$d000
        clr_ay
        lda     #$7f
        jsr     $ed01
        ldx     #$0800
        stx     $70
        ldx     #$c800
        ldy     #$6000
        lda     #$7f
        jsr     $ed01
        ldx     #$1f80
        stx     $70
        ldx     #$2000
        ldy     #$1040
        lda     #$7f
        jsr     $ed01
        jsr     $f54d
        jsr     $f4da
        ldx     #$0000
        stx     $bc77
        stx     $bc79
        ldx     #$0080
        stx     $bc96
        ldx     #$0070
        stx     $bc98
        jsr     $f0b4
        lda     #$ff
        sta     $dbf5
        lda     #$07        ; mode 7
        sta     $bc81
        lda     #$11
        sta     $fefb
        jmp     _c1f413

; ---------------------------------------------------------------------------

; [  ]

_c1ef26:
@ef26:  tax
@ef27:  phx
        jsr     $ee24
        plx
        dex
        bne     @ef27
        rts

; ---------------------------------------------------------------------------

; [  ]

_c1ef30:
@ef30:  lda     $a2
        and     #$07
        bne     @ef4f
        clr_ax
        longa
@ef3a:  lda     $7e09,x
        jsr     $ef70
        lda     $70
        sta     $7e09,x
        inx2
        cpx     #$0080
        bne     @ef3a
        shorta0
@ef4f:  rts

; ---------------------------------------------------------------------------

; [  ]

_c1ef50:
@ef50:  lda     $a2
        and     #$07
        bne     @ef6f
        clr_ax
        longa
@ef5a:  lda     $7e29,x
        jsr     $ef70
        lda     $70
        sta     $7e29,x
        inx2
        cpx     #$0040
        bne     @ef5a
        shorta0
@ef6f:  rts

; ---------------------------------------------------------------------------

; [  ]

_c1ef70:
        .a16
@ef70:  sta     $70
        and     #$001f
        beq     @ef7f
        lda     $70
        sec
        sbc     #$0001
        sta     $70
@ef7f:  lda     $70
        and     #$03e0
        beq     @ef8e
        lda     $70
        sec
        sbc     #$0020
        sta     $70
@ef8e:  lda     $70
        and     #$7c00
        beq     @ef9d
        lda     $70
        sec
        sbc     #$0400
        sta     $70
@ef9d:  rts
        .a8

; ---------------------------------------------------------------------------

_c1ef9e:
@ef9e:  shorti
        clr_ax
@efa2:  lda     $a209,x
        beq     @efad
        dec     $a209,x
        jmp     @f015
@efad:  lda     $9809,x
        bne     @efde
        ldy     $e6
        inc     $e6
        lda     $a289,y
        sta     $9889,x
        adc     #$40
        sta     $9909,x
        lda     $a28a,y
        and     #$3f
        adc     #$08
        sta     $9989,x
        lda     $a28b,y
        and     #$3f
        sta     $9c09,x
        stz     $9a89,x
        lda     #$03
        sta     $9809,x
        sta     $9b89,x
@efde:  lda     $9c89,x
        clc
        adc     $9c09,x
        sta     $9c89,x
        bcc     @efee
        inc     $9b89,x
        clc
@efee:  lda     $9a89,x
        adc     $9b89,x
        sta     $9a89,x
        lda     $9989,x
        clc
        adc     $9b89,x
        sta     $9989,x
        bcc     @f006
        stz     $9809,x
@f006:  lda     $9a89,x
        lsr5
        tay
        lda     $a389,y
        sta     $a109,x
@f015:  inx
        cpx     #$40
        bne     @efa2
        longi
        rts

; ---------------------------------------------------------------------------

; [  ]

_c1f01d:
@f01d:  clr_axy
        shorti
@f022:  lda     $9809,y
        bne     @f031
        lda     #$f0
        sta     $0300,x
        sta     $0301,x
        bra     @f0a7
@f031:  stx     $74
        lda     $9989,y
        sta     f:$004202
        ldx     $9889,y
        lda     $cef600,x   ; sine table
        bmi     @f052
        sta     f:$004203
        nop4
        lda     f:$004217
        jmp     @f062
@f052:  eor     #$ff
        sta     f:$004203
        nop4
        lda     f:$004217
        eor     #$ff
@f062:  sta     $70
        ldx     $9909,y
        lda     $cef600,x   ; sine table
        bmi     @f07c
        sta     f:$004203
        nop4
        lda     f:$004217
        jmp     @f08c
@f07c:  eor     #$ff
        sta     f:$004203
        nop4
        lda     f:$004217
        eor     #$ff
@f08c:  ldx     $74
        adc     $9e09,y
        sta     $0301,x
        lda     $70
        adc     $9d09,y
        sta     $0300,x
        lda     $a109,y
        sta     $0302,x
        lda     #$2d
        sta     $0303,x
@f0a7:  iny
        inx4
        jne     @f022
        longi
        rts

_c1f0b4:
@f0b4:  longa
        lda     $d0ddcd
        sta     $f9e3
        lda     $d0ddcf
        sta     $f9e5
        lda     $d0ddd1
        sta     $f9e7
        lda     $d0ddd3
        sta     $f9e9
        lda     $d0ddd5
        sta     $bc77
        lda     $d0ddd7
        sta     $bc79
        shorta0
        lda     $d0ddd9
        sta     $f9eb
        jsr     $f0ff
        clr_ax
        stx     $ff06
        sta     $ff28
@f0f5:  sta     $ff08,x
        inx
        cpx     #$0020
        bne     @f0f5
        rts

; ---------------------------------------------------------------------------

; [  ]

_c1f0ff:
@f0ff:  clr_ax
        stx     $18
        stx     $1a
        stx     $1e
        stx     $20
        lda     $f9eb
        clc
        adc     #$40
        tax
        lda     $cef600,x   ; sine table
        bpl     @f11f
        ldx     #$ffff
        stx     $18
        inc     $1e
        eor     #$ff
@f11f:  asl
        sta     $7a
        lda     $f9eb
        tax
        lda     $cef600,x   ; sine table
        bpl     @f135
        ldx     #$ffff
        stx     $1a
        inc     $20
        eor     #$ff
@f135:  asl
        sta     $7c
        longa
        lda     $f9e7
        cmp     $f9e9
        jcs     @f1ea
        lda     $f9e7
        sta     $70
        lda     $f9e9
        sec
        sbc     $f9e7
        sta     f:$004204
        shorta0
        lda     #$70
        sta     f:$004206
        phb
        lda     #$00
        tay
        pha
        plb
        longa
        shorti
        lda     $7ef9e3
        sta     $4204
        lda     $4214
        sta     $76
@f174:  sty     $1c
        shorta
        lda     $71
        asl
        sta     $4206
        longa
        lda     $70
        clc
        adc     $76
        sta     $70
        ldx     $7a
        stx     $4202
        lda     $4214
        tax
        stx     $4203
        sta     $7e
        stz     $82
        ldx     $7f
        ldy     $4217
        stx     $4203
        sty     $82
        ldx     $7c
        stz     $84
        lda     $4216
        stx     $4202
        ldx     $7e
        stx     $4203
        clc
        adc     $82
        eor     $18
        adc     $1e
        ldx     $4217
        stx     $84
        ldx     $7f
        stx     $4203
        ldy     $1c
        sta     $0ca0,y
        sta     $0f40,y
        lda     $4216
        clc
        adc     $84
        eor     $1a
        adc     $20
        sta     $0d80,y
        eor     #$ffff
        inc
        sta     $0e60,y
        iny2
        cpy     #$e0
        bne     @f174
        shorta0
        longi
        plb
        rts
@f1ea:  longa
        lda     $f9e7
        sta     $70
        lda     $f9e7
        sec
        sbc     $f9e9
        sta     f:$004204
        shorta0
        lda     #$70
        sta     f:$004206
        phb
        lda     #$00
        tay
        pha
        plb
        longa
        nop2
        lda     $4214
        asl
        sta     $76
        shorti
        lda     $7ef9e3
        sta     $4204
@f21e:  sty     $1c
        shorta
        lda     $71
        asl
        sta     $4206
        longa
        lda     $70
        sec
        sbc     $76
        sta     $70
        ldx     $7a
        stx     $4202
        lda     $4214
        tax
        stx     $4203
        sta     $7e
        stz     $82
        ldx     $7f
        ldy     $4217
        stx     $4203
        sty     $82
        ldx     $7c
        stz     $84
        lda     $4216
        stx     $4202
        ldx     $7e
        stx     $4203
        clc
        adc     $82
        eor     $18
        adc     $1e
        ldx     $4217
        stx     $84
        ldx     $7f
        stx     $4203
        ldy     $1c
        sta     $0ca0,y
        sta     $0f40,y
        lda     $4216
        clc
        adc     $84
        eor     $1a
        adc     $20
        sta     $0d80,y
        eor     #$ffff
        inc
        sta     $0e60,y
        iny2
        cpy     #$e0
        bne     @f21e
        shorta0
        longi
        plb
        rts

; ---------------------------------------------------------------------------

_c1f294:
        .addr   $f2bc,$f2c0,$f2c4,$f2cb,$f2f4,$f2fc,$f304,$f30c
        .addr   $f314,$f31c,$f324,$f32c,$f334,$f33c,$f344,$f34c
        .addr   $f2d2,$f2df,$f2ec,$f2f0

; ---------------------------------------------------------------------------

_c1f2bc:
        inc     $f9eb
        rts

; ---------------------------------------------------------------------------

_c1f2c0:
        dec     $f9eb
        rts

; ---------------------------------------------------------------------------

_c1f2c4:
        inc     $f9e4
        inc     $f9e6
        rts

; ---------------------------------------------------------------------------

_c1f2cb:
        dec     $f9e4
        dec     $f9e6
        rts

; ---------------------------------------------------------------------------

_c1f2d2:
        inc     $f9e4
        inc     $f9e4
        inc     $f9e4
        inc     $f9e4
        rts

; ---------------------------------------------------------------------------

_c1f2df:
        dec     $f9e4
        dec     $f9e4
        dec     $f9e4
        dec     $f9e4
        rts

; ---------------------------------------------------------------------------

_c1f2ce:
        inc     $f9e6
        rts

; ---------------------------------------------------------------------------

_c1f2f0:
        dec     $f9e6
        rts

; ---------------------------------------------------------------------------

_c1f2f4:
        ldx     $f9e7
        inx
        stx     $f9e7
        rts

; ---------------------------------------------------------------------------

_c1f2fc:
        ldx     $f9e7
        dex
        stx     $f9e7
        rts

; ---------------------------------------------------------------------------

_c1f304:
        ldx     $f9e9
        inx
        stx     $f9e9
        rts

; ---------------------------------------------------------------------------

_c1f30c:
        ldx     $f9e7
        dex
        stx     $f9e7
        rts

; ---------------------------------------------------------------------------

_c1f314:
        lda     $f9e8
        inc
        sta     $f9e8
        rts

; ---------------------------------------------------------------------------

_c1f31c:
        lda     $f9e8
        dec
        sta     $f9e8
        rts

; ---------------------------------------------------------------------------

_c1f324:
        lda     $f9ea
        inc
        sta     $f9ea
        rts

; ---------------------------------------------------------------------------

_c1f32c:
        lda     $f9ea
        dec
        sta     $f9ea
        rts

; ---------------------------------------------------------------------------

_c1f334:
        ldx     $bc77
        inx
        stx     $bc77
        rts

; ---------------------------------------------------------------------------

_c1f33c:
        ldx     $bc77
        dex
        stx     $bc77
        rts

; ---------------------------------------------------------------------------

_c1f344:
        ldx     $bc79
        inx
        stx     $bc79
        rts

; ---------------------------------------------------------------------------

_c1f34c:
        ldx     $bc79
        dex
        stx     $bc79
        rts

; ---------------------------------------------------------------------------

_c1f354:
@f354:  lda     $ff28
        beq     @f35e
        dec     $ff28
        sec
        rts
@f35e:  ldx     $ff06
@f361:  lda     $d0ddda,x
        cmp     #$ff
        beq     @f390
        cmp     #$fe
        beq     @f38a
        cmp     #$fd
        bne     @f37b
        lda     $d0dddb,x
        sta     $ff28
        jmp     @f385
@f37b:  and     #$1f
        tay
        lda     $d0dddb,x
        sta     $ff08,y
@f385:  inx2
        jmp     @f361
@f38a:  inx
        stx     $ff06
        sec
        rts
@f390:  clc
        rts

; ---------------------------------------------------------------------------

; [  ]

_c1f392:
@f392:  clr_ax
@f394:  lda     $ff08,x
        beq     @f3b0
        dec     $ff08,x
        phx
        txa
        asl
        tax
        lda     $c1f294,x
        sta     $74
        lda     $c1f295,x
        sta     $75
        jsr     $f3b7
        plx
@f3b0:  inx
        cpx     #$0020
        bne     @f394
        rts
@f3b7:  jmp     ($0074)

; ---------------------------------------------------------------------------

; [  ]

_c1f3ba:
@f3ba:  stz     $f9dc
        stz     $e6
        clr_ax
        sta     $70
@f3c3:  stz     $9809,x
        lda     $70
        clc
        adc     #$02
        sta     $70
        sta     $a209,x
        lda     #$7c
        sta     $9d09,x
        lda     #$6c
        sta     $9e09,x
        lda     #$07
        sta     $a109,x
        inx
        cpx     #$0040
        bne     @f3c3
        clr_ax
@f3e7:  lda     $c0fec0,x   ; random number table
        sta     $a289,x
        inx
        cpx     #$0100
        bne     @f3e7
        clr_ax
@f3f6:  lda     $c1f6a9,x
        sta     $a389,x
        inx
        cpx     #$0010
        bne     @f3f6
        clr_ax
@f405:  lda     $d0e320,x
        sta     $7fc9,x
        inx
        cpx     #$0020
        bne     @f405
        rts

; ---------------------------------------------------------------------------

; [  ]

_c1f413:
@f413:  jsr     $ee24
        jsr     $f0ff
        jsr     $f354
        bcs     @f413
        clr_ax
        longa
        lda     #$0100
@f425:  sta     $0ca0,x
        sta     $0f40,x
        stz     $0d80,x
        stz     $0e60,x
        inx2
        cpx     #$0070
        bne     @f425
        shorta0
        lda     #$e0
        sta     $bc88
        sta     $bc89
        sta     $bc8a
        sta     f:$002132
        lda     #$01
        sta     f:$00212d
        lda     #$02
        sta     f:$002130
        lda     #$10
        sta     f:$002131
        jsr     $f4bd
        ldx     #$0e10
@f462:  phx
        jsr     $f475
        plx
        dex
        bne     @f462
        lda     #$08
        sta     $ff04
@f46f:  jsr     $f475
        jmp     @f46f

; ---------------------------------------------------------------------------

; [  ]

_c1f475:
@f475:  jsr     $fd1d       ; wait for vblank
        jsr     $f5f6
        jsr     $fc96       ; generate random number
        and     #$7f
        jeq     @f486
        rts
@f486:  lda     #$02
        sta     $d111
@f48b:  jsr     $fd1d       ; wait for vblank
        jsr     $f5f6
        jsr     $fd1d       ; wait for vblank
        jsr     $f5f6
        clr_ax
@f499:  sta     $7f89,x
        inx
        cpx     #$0020
        bne     @f499
        lda     $d111
        asl
        tax
        longa
        lda     #$7fff
        sta     $7f89,x
        shorta0
        inc     $d111
        lda     $d111
        cmp     #$0a
        bne     @f48b
        rts

; ---------------------------------------------------------------------------

; [  ]

_c1f4bd:
@f4bd:  clr_ax
@f4bf:  lda     $d0e198,x
        sta     $0200,x
        inx
        cpx     #$0040
        bne     @f4bf
        clr_ax
        lda     #$aa
@f4d0:  sta     $0400,x
        inx
        cpx     #$0010
        bne     @f4d0
        rts

; ---------------------------------------------------------------------------

; [  ]

_c1f4da:
@f4da:  phb
        lda     #$00
        pha
        plb
        lda     #$42
        sta     $4300
        sta     $4310
        sta     $4330
        sta     $4370
        lda     #$1b        ; hdma to m7a through m7d
        sta     $4301
        lda     #$1c
        sta     $4311
        lda     #$1d
        sta     $4331
        lda     #$1e
        sta     $4371
        ldx     #$bcb1
        stx     $4302
        ldx     #$bf52
        stx     $4312
        ldx     #$c1f3
        stx     $4332
        ldx     #$c494
        stx     $4372
        lda     #$7e
        sta     $4304
        lda     #$7e
        sta     $4314
        lda     #$7e
        sta     $4334
        lda     #$7e
        sta     $4374
        lda     #$00
        sta     $4307
        lda     #$00
        sta     $4317
        lda     #$00
        sta     $4337
        lda     #$00
        sta     $4377
        lda     $7ebc84
        ora     #$8b
        sta     $7ebc84
        plb
        rts

; ---------------------------------------------------------------------------

; [  ]

_c1f54d:
@f54d:  ldy     #$0ca0
        clr_ax
@f552:  lda     #$02
        sta     $bcb1,x
        sta     $bcb4,x
        longa
        tya
        sta     $bcb2,x
        sta     $bcb5,x
        txa
        clc
        adc     #$0006
        tax
        shorta0
        iny2
        cpy     #$0d80
        bne     @f552
        clr_a
        sta     $bcb1,x
        ldy     #$0d80
        clr_ax
@f57c:  lda     #$02
        sta     $bf52,x
        sta     $bf55,x
        longa
        tya
        sta     $bf53,x
        sta     $bf56,x
        txa
        clc
        adc     #$0006
        tax
        shorta0
        iny2
        cpy     #$0e60
        bne     @f57c
        clr_a
        sta     $bf52,x
        ldy     #$0e60
        clr_ax
@f5a6:  lda     #$02
        sta     $c1f3,x
        sta     $c1f6,x
        longa
        tya
        sta     $c1f4,x
        sta     $c1f7,x
        txa
        clc
        adc     #$0006
        tax
        shorta0
        iny2
        cpy     #$0f40
        bne     @f5a6
        clr_a
        sta     $c1f3,x
        ldy     #$0f40
        clr_ax
@f5d0:  lda     #$02
        sta     $c494,x
        sta     $c497,x
        longa
        tya
        sta     $c495,x
        sta     $c498,x
        txa
        clc
        adc     #$0006
        tax
        shorta0
        iny2
        cpy     #$1020
        bne     @f5d0
        clr_a
        sta     $c494,x
        rts

; ---------------------------------------------------------------------------

; [  ]

_c1f5f6:
@f5f6:  jsr     $f01d
        jmp     _c1ef9e

; ---------------------------------------------------------------------------

; [  ]

_c1f5fc:
@f5fc:  clr_axy
@f5ff:  lda     $a209,y
        beq     @f60a
        dec
        sta     $a209,y
        bra     @f686
@f60a:  lda     $9809,y
        bne     @f644
        jsr     $fc96       ; generate random number
        sta     $9889,y
        clc
        adc     #$40
        sta     $9909,y
        jsr     $fc96       ; generate random number
        and     #$7f
        clc
        adc     #$08
        longa
        sta     $9989,x
        shorta0
        lda     #$01
        sta     $9809,y
        lda     #$03
        sta     $9b89,y
        jsr     $fc96       ; generate random number
        and     #$3f
        sta     $9c09,y
        clr_a
        sta     $9a89,x
        sta     $9a8a,x
@f644:  lda     $9c09,y
        sta     $8c
        lda     $9c89,y
        clc
        adc     $8c
        sta     $9c89,y
        bcc     @f65b
        lda     $9b89,y
        inc
        sta     $9b89,y
@f65b:  lda     $9b89,y
        longa
        sta     $8a
        lda     $9989,x
        clc
        adc     $8a
        sta     $9989,x
        sta     $88
        lda     $9a89,x
        clc
        adc     $8a
        sta     $9a89,x
        shorta0
        phx
        ldx     $88
        cpx     #$0120
        bcc     @f685
        clr_a
        sta     $9809,y
@f685:  plx
@f686:  phx
        longa
        lda     $9a89,x
        lsr5
        tax
        shorta0
        lda     $c1f6a9,x
        plx
        sta     $a109,x
        iny
        inx2
        cpy     #$0060
        jne     @f5ff
        rts

; ---------------------------------------------------------------------------

_c1f6a9:
        .byte   $07,$06,$05,$04,$03,$02,$02,$01,$01,$00,$00,$00

; ---------------------------------------------------------------------------

_c1f6b5:
@f6b5:  clr_axy
@f6b8:  lda     $9809,y
        bne     @f6cd
        longa
        lda     #$00f0
        sta     $a009,x
        sta     $9f09,x
        shorta0
        bra     @f71d
@f6cd:  phx
        lda     $9889,y
        tax
        lda     $cef600,x   ; sine table
        sta     $88
        lda     $9909,y
        tax
        lda     $cef600,x   ; sine table
        sta     $89
        plx
        lda     $9989,x
        sta     f:$00211b
        lda     $998a,x
        sta     f:$00211b
        lda     $88
        sta     f:$00211c
        longa
        lda     f:$002135
        clc
        adc     $9e09,x
        sta     $a009,x
        shorta0
        lda     $89
        sta     f:$00211c
        longa
        lda     f:$002135
        clc
        adc     $9d09,x
        sta     $9f09,x
        shorta0
@f71d:  iny
        inx2
        cpy     #$0060
        bne     @f6b8
        clr_axy
@f728:  lda     $9f0a,x
        ora     $a00a,x
        and     #$01
        beq     @f73c
        lda     #$f0
        sta     $0200,y
        sta     $0201,y
        bra     @f753
@f73c:  lda     $9f09,x
        sta     $0200,y
        lda     $a009,x
        sta     $0201,y
        lda     $a109,x
        sta     $0202,y
        lda     #$30
        sta     $0203,y
@f753:  iny4
        inx2
        cpy     #$0180
        bne     @f728
        rts

; ---------------------------------------------------------------------------

; [ epilogue cutscene ]

; show the warp speed cutscene with epilogue text, "in the beginning, there was void..."

_c1f75f:
        longi
        shorta
        jsr     $0888       ; init hardware registers
        jsr     $f88c
        jsr     $f8f9
        lda     #$14
        sta     f:$00212c
        sta     f:$00212e
@f776:  lda     f:$004210
        bpl     @f776
        lda     #$81
        sta     f:$004200
        cli
        lda     #$0f
        sta     $bc7f
        lda     #$b4        ; 180 frames (3 seconds)
        jsr     $f883       ; wait
        jsr     $f82b
; fallthrough

; ---------------------------------------------------------------------------

; [ fade out and return ]

_c1f790:
@f790:  jsr     $fd1d       ; wait for vblank
        jsr     $fd1d       ; wait for vblank
        jsr     $fd1d       ; wait for vblank
        jsr     $fd1d       ; wait for vblank
        dec     $bc7f       ; decrement screen brightness
        lda     $bc7f
        bne     @f790
        clr_a
        sta     f:$00420c
        sta     f:$004200
        lda     #$80
        sta     f:$002100
        stz     $bc84
        rtl

; ---------------------------------------------------------------------------

; [  ]

_c1f7b7:
@f7b7:  lda     $f9dc
        beq     @f7f0
        stz     $f9dc
        longa
        lda     $f9dd
        sta     f:$002116
        lda     #$a937
        sta     f:$004342
        lda     #$0200
        sta     f:$004345
        shorta0
        lda     #$7e
        sta     f:$004344
        clr_a
        sta     f:$004340
        lda     #$19
        sta     f:$004341
        lda     #$10
        sta     f:$00420b
@f7f0:  rts

; ---------------------------------------------------------------------------

; [  ]

_c1f7f1:
@f7f1:  phx
        stz     $74
        ldx     $bca0
        stx     $70
        lda     $bca2
        sta     $72
        clr_ay
@f800:  lda     [$70],y
        beq     @f815
        cmp     #$01
        beq     @f815
        cmp     #$20
        bcc     @f80e
        bra     @f80f
@f80e:  iny
@f80f:  iny
        inc     $74
        jmp     @f800
@f815:  lda     #$10
        sec
        sbc     $74
.if LANG_EN
        stz     $7e
        lda     #$00
.else
        sta     $7e
        lda     #$0d
.endif
        sta     $80
        jsr     $feba       ; +$82 = $7e * $80
        lda     $82
        lsr
        sta     $f507
        plx
        rts

; ---------------------------------------------------------------------------

; [  ]

_c1f82b:
@f82b:  lda     #$02
        sta     $dbf1
.if LANG_EN
        ldx     #$73a0
.else
        ldx     #$e340
.endif
        stx     $f9df
        clr_ax
        stx     $f9dd
        inc     $dbf4
        lda     #$28
@f840:  pha
        clr_ax
@f843:
.if LANG_EN
        jsl     $e031e6
        nop5
        ldx     $f9df
        stx     $bca0
        lda     #$e7
        sta     $bca2
        jsr     $f7f1
        jsr     $2971       ; draw big text string
        jsl     $e031f7
.else
        sta     $a937,x
        inx
        cpx     #$0200
        bne     @f843
        ldx     $f9df
        stx     $bca0
        lda     #$d0
        sta     $bca2
        jsr     $f7f1
        jsr     $2971       ; draw big text string
        ldx     a:$00b8
        inx
.endif
        stx     $f9df
        inc     $f9dc
        lda     #$3f        ; 63 frames
        jsr     $f883       ; wait
        longa
        lda     $f9dd
        clc
        adc     #$0200
        and     #$1fff
        sta     $f9dd
        shorta0
        pla
        dec
        bne     @f840
        rts

; ---------------------------------------------------------------------------

; [ wait ]

; a: number of frames to wait

_c1f883:
@f883:  pha
        jsr     $fd1d       ; wait for vblank
        pla
        dec
        bne     @f883
        rts

; ---------------------------------------------------------------------------

; [  ]

_c1f88c:
@f88c:  lda     #$c1
        sta     $1f03
        ldx     #$faef      ; nmi = c1/faef
        stx     $1f01
        lda     #$5c
        sta     $1f00
        sta     $1f04
        lda     #$c1
        sta     $1f07
        ldx     #$fa0d      ; irq = c1/fa0d (rti)
        stx     $1f05
        clr_ax
@f8ac:  stz     $0400,x     ; clear hi-sprite data
        inx
        cpx     #$0020
        bne     @f8ac
        clr_ax
        ldy     #$4000
        jsr     $fdbb
        clr_axy
        stz     $70
@f8c2:  stz     $9809,x
        lda     $70
        clc
        adc     #$02
        sta     $70
        sta     $a209,x
        longa
        lda     #$007c
        sta     $9d09,y
        lda     #$006c
        sta     $9e09,y
        lda     #$0007
        sta     $a109,y
        shorta
        inx
        iny2
        cpx     #$0060
        bne     @f8c2
        stz     $f9dc
        jsr     $f9e3
        jsr     $f9f3
        jmp     _c1fd22       ; clear sprite data

; ---------------------------------------------------------------------------

; [  ]

_c1f8f9:
@f8f9:  jsr     $f953
        stz     $ff05
        clr_a
        sta     f:$00210c
        stz     $dbf4
        lda     #$48
        sta     f:$002109
        ldx     #$0010
        stx     $fefe
        ldx     #$ffe8
        stx     $fefc
        lda     #$09
        sta     f:$002105
        jsr     $f9ab
        lda     #$84
        sta     f:$002131
        phb
        lda     #$00
        pha
        plb
        lda     #$40
        sta     $4320
        lda     #$32
        sta     $4321
        ldx     #$dd7a
        stx     $4322
        lda     #$d0
        sta     $4324
        lda     #$7e
        sta     $4327
        lda     $7ebc84
        ora     #$04
        sta     $7ebc84
        plb
        rts

; ---------------------------------------------------------------------------

; [  ]

_c1f953:
@f953:  ldx     #$c000
        stx     $70
        lda     #$7f
        sta     $72
        sta     $76
        ldx     #$c040
        stx     $74
        longa
        stz     $78
@f967:  clr_ay
        lda     $78
@f96b:  ora     #$2000
        sta     [$70],y
        inc
        sta     [$74],y
        inc
        iny2
        cpy     #$0040
        bne     @f96b
        lda     $70
        clc
        adc     #$0080
        sta     $70
        lda     $74
        clc
        adc     #$0080
        sta     $74
        lda     $78
        clc
        adc     #$0040
        sta     $78
        cmp     #$0800
        bne     @f967
        shorta0
        ldx     #$0800
        stx     $70
        ldx     #$c000
        ldy     #$4800
        lda     #$7f
        jmp     _c1fdca       ; copy data to vram

; ---------------------------------------------------------------------------

; [  ]

_c1f9ab:
@f9ab:  clr_ax
        lda     #$ff
@f9af:  sta     $b455,x
        inx
        cpx     #$0010
        bne     @f9af
@f9b8:  sta     $b455,x
        dec
        inx
        cpx     #$0030
        bne     @f9b8
        lda     #$e0
@f9c4:  sta     $b455,x
        inx
        cpx     #$00b0
        bne     @f9c4
@f9cd:  sta     $b455,x
        inc
        inx
        cpx     #$00d0
        bne     @f9cd
        lda     #$ff
@f9d9:  sta     $b455,x
        inx
        cpx     #$00e0
        bne     @f9d9
        rts

; ---------------------------------------------------------------------------

_c1f9e3:
@f9e3:  ldx     #$0200
        stx     $70
        ldx     #$e220
        ldy     #$6000
        lda     #$d0
        jmp     _c1fdca       ; copy data to vram

; ---------------------------------------------------------------------------

; [  ]

_c1f9f3:
@f9f3:  clr_ax
@f9f5:  lda     $d0e320,x
        sta     $7f09,x
        lda     #$ff
        sta     $7e09,x
        inx
        cpx     #$0020
        bne     @f9f5
        clr_ax
        stx     $7e09
        rts

; ---------------------------------------------------------------------------

; [ epilogue/stats screen irq ]

_c1fa0d:
        rti

; ---------------------------------------------------------------------------

; [  ]

_c1fa0e:
@fa0e:  clr_ax
        stx     $88
        stx     $8a
        lda     $f9e7
        sta     f:$00211b
        lda     $f9e8
        sta     f:$00211b
        lda     $f9eb
        clc
        adc     $f9ec
        sta     $98
        clc
        adc     #$40
        tax
        lda     $cef600,x   ; sine table
        bpl     @fa3c
        ldx     #$ffff
        stx     $88
        eor     #$ff
@fa3c:  sta     f:$00211c
        longa
        lda     f:$002135
        eor     $88
        sta     $bc8e
        sta     $bc94
        shorta0
        lda     $98
        tax
        lda     $cef600,x   ; sine table
        bpl     @fa61
        ldx     #$ffff
        stx     $8a
        eor     #$ff
@fa61:  sta     f:$00211c
        longa
        lda     f:$002135
        eor     $8a
        sta     $bc90
        eor     #$ffff
        inc
        sta     $bc92
        shorta0
        jsr     $fa87
        jsr     $fff4
        inc     $a2
        stz     $a5
        stz     $a4
        rts

; ---------------------------------------------------------------------------

; [  ]

_c1fa87:
@fa87:  lda     $bc81
        sta     f:$002105
        lda     $fefb
        sta     f:$00212c
        lda     $bc84
        sta     f:$00420c
        lda     $bc77
        sta     f:$00210d
        lda     $bc78
        sta     f:$00210d
        lda     $bc79
        sta     f:$00210e
        lda     $bc7a
        sta     f:$00210e
        longa
        lda     $bc77
        clc
        adc     #$0080
        sta     $bc96
        lda     $bc79
        clc
        adc     #$0070
        sta     $bc98
        shorta0
        jsr     $12e8
        lda     $bc7f
        sta     f:$002100
        rts

; ---------------------------------------------------------------------------

; [  ]

_c1fadc:
        jsr     $fd9c
        jsr     $fa87
        jsr     $f392
        inc     $a2
        jsr     $0b81       ; play queued song
        stz     $a5
        stz     $a4
        rts

; ---------------------------------------------------------------------------

; [ epilogue/stats screen nmi ]

_c1faef:
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
        bne     @fb6e
        inc     $a4
        clr_a
        sta     f:$002100
        jsr     $fdc0
        jsr     $fdc5
        lda     $ff05
        beq     @fb23
        jsr     $fa0e
        jmp     @fb68
@fb23:  jsr     $f7b7
        lda     $bc84
        sta     f:$00420c
        lda     $fefc
        sta     f:$002111
        lda     $fefd
        sta     f:$002111
        lda     $fefe
        sta     f:$002112
        lda     $feff
        sta     f:$002112
        lda     $bc7f
        sta     f:$002100
        jsr     $f6b5
        jsr     $f5fc
        lda     $dbf4
        beq     @fb68
        lda     $a2
        and     #$03
        bne     @fb68
        ldx     $fefe
        inx
        stx     $fefe
@fb68:  stz     $a5
        stz     $a4
        inc     $a2
@fb6e:  longai
        pld
        plb
        ply
        plx
        pla
        plp
        rti
        .a8

; ---------------------------------------------------------------------------

; [ decompress ]

_c1fb77:
@fb77:  phx
        phb
        ldx     $04f0
        phx
        ldx     $04f2
        phx
        ldx     $04f4
        phx
        lda     $74
        sta     $04f2
        ldx     $72
        stx     $04f0
        lda     #$7f
        sta     $04f5
        ldx     #$c000
        stx     $04f3
        jsl     $c30002     ; decompress
        plx
        stx     $04f4
        plx
        stx     $04f2
        plx
        stx     $04f0
        plb
        plx
        rts

; ---------------------------------------------------------------------------

; [ play system sound effect $10 ]

_c1fbad:
@fbad:  pha
        lda     #$10
        sta     $dbb8
        inc     $dbb7
        pla
        rts

; ---------------------------------------------------------------------------

; [ play system sound effect $11 ]

_c1fbb8:
        pha
        lda     #$11
        sta     $dbb8
        inc     $dbb7
        pla
        rts

; ---------------------------------------------------------------------------

; [ play system sound effect $11 ]

_c1fbc3:
        pha
        lda     #$11
        sta     $dbb8
        inc     $dbb7
        pla
        rts

; ---------------------------------------------------------------------------

; [ play system sound effect $12 ]

_c1fbce:
        pha
        lda     #$12
        sta     $dbb8
        inc     $dbb7
        pla
        rts

; ---------------------------------------------------------------------------

; [ play sound effect ]

_c1fbd9:
@fbd9:  cmp     #$ff
        beq     @fbe3
        sta     $dbb5
        inc     $dbb4
@fbe3:  rts

; ---------------------------------------------------------------------------

; [ play animation sound effect ]

_c1fbe4:
@fbe4:  sta     $dbb5       ; sound effect id
        lda     ($eb)
        and     #$08
        beq     @fbf2
        lda     #$52        ; different sound effect ???
        sta     $dbb5
@fbf2:  lda     ($eb)
        and     #$40
        beq     @fbfc
        lda     #$33        ; volume 3
        bra     @fbfe
@fbfc:  lda     #$dd        ; volume 13
@fbfe:  sta     $dbb6
        inc     $dbb4
        rts

; ---------------------------------------------------------------------------

; [ play queued game sound effect/set volume ]

_c1fc05:
        lda     $dbb4
        beq     @fc2c       ; branch if no sound effect
        lda     $dbd3
        bne     @fc2c       ;
        lda     #$02        ; spc interrupt $02 (play game sound effect)
        sta     $1d00
        lda     $dbb5       ; sound effect id
        sta     $1d01
        lda     #$0f        ; no envelope
        sta     $1d02
        lda     $dbb6       ; volume
        sta     $1d03
        jsl     $c40004     ; execute spc command
        stz     $dbb4
@fc2c:  lda     $ff2e       ; fade out sound ???
        beq     @fc43
        clc
        adc     #$80        ; spc interrupt $80/$81/$82 (set volume)
        sta     $1d00
        lda     #$f0        ; volume zero, max envelope duration
        sta     $1d01
        jsl     $c40004     ; execute spc command
        stz     $ff2e
@fc43:  rts

; ---------------------------------------------------------------------------

; [ play queued system sound effect ]

_c1fc44:
        lda     $dbb7
        beq     @fc56
        lda     $dbb8
        sta     $1d00
        jsl     $c40004
        stz     $dbb7
@fc56:  rts

; ---------------------------------------------------------------------------

; [  ]

_c1fc57:
@fc57:  longa
        asl
        ora     #$8000
        sta     $cd45
        shorta0
        rts

; ---------------------------------------------------------------------------

_c1fc64:
@fc64:  phx
        ldx     #$8080
        stx     $cd45
        plx
        rts

; ---------------------------------------------------------------------------

_c1fc6d:
@fc6d:  stz     $cd45
        stz     $cd46
        rts

; ---------------------------------------------------------------------------

; [ get monster mask ]

_c1fc74:
@fc74:  tax
        lda     $d97d25,x
        rts

; ---------------------------------------------------------------------------

; [  ]

_c1fc7a:
@fc7a:  phx
        ldx     #$0000
@fc7e:  asl
        bcs     @fc87
        inx
        cpx     #$0008
        bne     @fc7e
@fc87:  txa
        and     #$07
        plx
        rts

; ---------------------------------------------------------------------------

; [ wait for keypress ]

_c1fc8c:
@fc8c:  lda     $00
        bmi     @fc95
        jsr     $02f2       ; wait one frame
        bra     @fc8c
@fc95:  rts

; ---------------------------------------------------------------------------

; [ generate random number ]

_c1fc96:
@fc96:  phx
        lda     $e6
        tax
        inc     $e6
        lda     $c0fec0,x   ; random number table
        plx
        rts

; ---------------------------------------------------------------------------

_c1fca2:
        phb
        sta     $74
        clr_a
        pha
        plb
        sty     $2116
        stx     $72
        ldy     #$0000
@fcb0:  longa
        ldx     #$0008
@fcb5:  lda     [$72],y
        sta     $2118
        iny2
        dex
        bne     @fcb5
        ldx     #$0008
@fcc2:  lda     [$72],y
        and     #$00ff
        sta     $2118
        iny
        dex
        bne     @fcc2
        shorta0
        dec     $70
        bne     @fcb0
        plb
        rts

; ---------------------------------------------------------------------------

; [  ]

_c1fcd7:
        jsl     _d0dc2a
        rts

; ---------------------------------------------------------------------------

; [ init battle hdma ]

_c1fcdc:
        jsl     _d0dca5
        rts

; ---------------------------------------------------------------------------

; [ move data ]

;  a: source bank
; +x: source address
; +y: destination address (bank $7e)

_c1fce1:
        sta     $b44f       ; set source bank
        jsl     $7eb448
        rts

; ---------------------------------------------------------------------------

; [ init move data subroutine in ram ]

_c1fce9:
        ldx     #$0000
@fcec:  lda     $c1fcfa,x   ; copy subroutine below into ram
        sta     $b448,x
        inx
        cpx     #$000d
        bne     @fcec
        rts

; ---------------------------------------------------------------------------

; [  ]

_c1fcfa:
        phb
        longa
        lda     $70
        mvn     #$00,#$7e     ; this $00 is at $b44f
        shorta0
        plb
        rtl

; ---------------------------------------------------------------------------

; [ go to previous menu ]

_c1fd07:
        lda     $cd3b
        sta     $cd3a
        lda     $cd3c
        sta     $cd3b
        lda     $cd3d
        sta     $cd3c
        stz     $cd3d
        rts

; ---------------------------------------------------------------------------

; [ wait for vblank ]

_c1fd1d:
@fd1d:  jsl     _d97caa
        rts

; ---------------------------------------------------------------------------

; [ clear sprite data ]

_c1fd22:
@fd22:  jsl     _d97cb4
        rts

; ---------------------------------------------------------------------------

; [  ]

_c1fd27:
@fd27:  inc     $d110
        phx
        phy
        pha
        ldx     $70
        phx
@fd30:  lda     $d0d6
        beq     @fd3a
        jsr     $02f2       ; wait one frame
        bra     @fd30
@fd3a:  plx
        stx     $d0de
        pla
        sta     $d0d9
        ply
        sty     $d0da
        plx
        stx     $d0d7
        stz     $d0e0
@fd4d:  longa
        lda     $d0de
        cmp     #$0800
        beq     @fd61
        bcc     @fd61
        lda     #$0800
        sta     $d0dc
        bra     @fd67
@fd61:  sta     $d0dc
        inc     $d0e0
@fd67:  shorta0
        inc     $d0d6
        jsr     $02f2       ; wait one frame
        longa
        lda     $d0d7
        clc
        adc     #$0800
        sta     $d0d7
        lda     $d0da
        clc
        adc     #$0400
        sta     $d0da
        lda     $d0de
        sec
        sbc     #$0800
        sta     $d0de
        shorta0
        lda     $d0e0
        beq     @fd4d
        stz     $d110
        rts

; ---------------------------------------------------------------------------

; [  ]

_c1fd9c:
@fd9c:  lda     $d0d6
        beq     @fdb5
        ldx     $d0dc
        stx     $88
        ldx     $d0d7
        ldy     $d0da
        lda     $d0d9
        jsr     $fdb6       ; copy data to vram
        stz     $d0d6
@fdb5:  rts

; ---------------------------------------------------------------------------

; [  ]

_c1fdb6:
@fdb6:  jsl     _d0de40     ; copy data to vram (channel 4)
        rts

; ---------------------------------------------------------------------------

; [  ]

_c1fdbb:
@fdbb:  jsl     _d0ded1     ; clear vram
        rts

; ---------------------------------------------------------------------------

; [  ]

_c1fdc0:
@fdc0:  jsl     _d0de8c
        rts

; ---------------------------------------------------------------------------

; [  ]

_c1fdc5:
@fdc5:  jsl     _d0de66     ; copy color palettes to vram
        rts

; ---------------------------------------------------------------------------

; [  ]

_c1fdca:
@fdca:  jsl     _d0de1a     ; copy data to vram (channel 5)
        rts

; ---------------------------------------------------------------------------

; [  ]

_c1fdcf:
        jsr     $fde7
        rtl

; ---------------------------------------------------------------------------

; [  ]

_c1fdd3:
        jsr     $feba       ; +$82 = $7e * $80
        rtl

; ---------------------------------------------------------------------------

; [  ]

_c1fdd7:
        jsr     $fe67       ; ++$82 = +$7e * +$80
        rtl

; ---------------------------------------------------------------------------

; [  ]

_c1fddb:
        jsr     $fe4b
        rtl

; ---------------------------------------------------------------------------

; [  ]

_c1fddf:
        jsr     $fe90
        rtl

; ---------------------------------------------------------------------------

; [  ]

_c1fde3:
        jsr     $fed5
        rtl

; ---------------------------------------------------------------------------

; [  ]

_c1fde7:
@fde7:  phx
        longa
        stz     $82
        stz     $84
        lda     $7e
        beq     @fe12
        lda     $80
        beq     @fe12
        ldx     #$0010
@fdf9:  rol     $7e
        rol     $84
        lda     $84
        sec
        sbc     $80
        sta     $84
        bcs     @fe0d
        lda     $84
        adc     $80
        sta     $84
        clc
@fe0d:  rol     $82
        dex
        bne     @fdf9
@fe12:  lda     #$0000
        shorta
        plx
        rts

; ---------------------------------------------------------------------------

; [  ]

_c1fe19:
        phx
        longa
        stz     $9c
        stz     $9e
        lda     $98
        beq     @fe44
        lda     $9a
        beq     @fe44
        ldx     #$0010
@fe2b:  rol     $98
        rol     $9e
        lda     $9e
        sec
        sbc     $9a
        sta     $9e
        bcs     @fe3f
        lda     $9e
        adc     $9a
        sta     $9e
        clc
@fe3f:  rol     $9c
        dex
        bne     @fe2b
@fe44:  lda     #$0000
        shorta
        plx
        rts

; ---------------------------------------------------------------------------

; [  ]

_c1fe4b:
@fe4b:  phx
        ldx     #$0008
        stz     $9c
        stz     $9d
@fe53:  ror     $9a
        bcc     @fe5e
        lda     $98
        clc
        adc     $9d
        sta     $9d
@fe5e:  ror     $9d
        ror     $9c
        dex
        bne     @fe53
        plx
        rts

; ---------------------------------------------------------------------------

; [ ++$82 = +$7e * +$80 ]

_c1fe67:
@fe67:  phx
        longa
        stz     $86
        stz     $82
        stz     $84
        ldx     #$0010
@fe73:  lsr     $7e
        bcc     @fe84
        clc
        lda     $82
        adc     $80
        sta     $82
        lda     $84
        adc     $86
        sta     $84
@fe84:  asl     $80
        rol     $86
        dex
        bne     @fe73
        shorta0
        plx
        rts

; ---------------------------------------------------------------------------

; [  ]

_c1fe90:
@fe90:  phx
        longa
        pha
        stz     $a0
        stz     $9c
        stz     $9e
        ldx     #$0010
@fe9d:  lsr     $98
        bcc     @feae
        clc
        lda     $9c
        adc     $9a
        sta     $9c
        lda     $9e
        adc     $a0
        sta     $9e
@feae:  asl     $9a
        rol     $a0
        dex
        bne     @fe9d
        pla
        shorta
        plx
        rts

; ---------------------------------------------------------------------------

; [ +$82 = $7e * $80 ]

_c1feba:
@feba:  lda     $7e
        sta     f:$004202
        lda     $80
        sta     f:$004203
        longa
        nop3
        lda     f:$004216
        sta     $82
        shorta0
        rts

; ---------------------------------------------------------------------------

; [ +$82 = +$7e / $80 (unused) ]

_c1fed5:
@fed5:  lda     $7e
        sta     f:$004204
        lda     $7f
        sta     f:$004205
        lda     $80
        sta     f:$004206
        longa
        pha
        nop
        pha
        nop
        pla
        lda     f:$004214
        sta     $82
        lda     f:$004216
        sta     $84
        pla
        shorta
        rts

; ---------------------------------------------------------------------------

_c1fefe:
        ldx     #$0000
@ff01:  lda     $c4,x
        cmp     $ce
        bne     @ff0d
        inx
        cpx     #$0007
        bne     @ff01
@ff0d:  rts

; ---------------------------------------------------------------------------

_c1ff0e:
        lda     #$68
        bra     _ff14

_c1ff12:
        lda     #$ff
_ff14:  sta     $cd43
        phx
        clr_ax
@ff1a:  lda     $c4,x
        sec
        sbc     $ce
        bne     @ff2c
        lda     $cd43
        sta     $c4,x
        inx
        cpx     #$0003
        bne     @ff1a
@ff2c:  plx
        rts

; ---------------------------------------------------------------------------

; [  ]

_c1ff2e:
        longa
        stz     $7e
        stz     $80
        stz     $82
        stz     $84
        txa
@ff39:  sec
        sbc     #$03e8
        bcc     @ff44
        inc     $7e
        jmp     @ff39
@ff44:  clc
        adc     #$03e8
@ff48:  sec
        sbc     #$0064
        bcc     @ff53
        inc     $80
        jmp     @ff48
@ff53:  clc
        adc     #$0064
@ff57:  sec
        sbc     #$000a
        bcc     @ff62
        inc     $82
        jmp     @ff57
@ff62:  clc
        adc     #$000a
        sta     $84
        shorta0
        lda     $7e
        clc
        adc     $ce
        sta     $c4
        lda     $80
        clc
        adc     $ce
        sta     $c5
        lda     $82
        clc
        adc     $ce
        sta     $c6
        lda     $84
        clc
        adc     $ce
        sta     $c7
        rts

; ---------------------------------------------------------------------------

; [ convert hex to decimal digits ]

_c1ff88:
        clr_ax
@ff8a:  sta     $c4,x
        inx
        cpx     #$0008
        bne     @ff8a
        ldx     #$0000
@ff95:  phx
        txa
        asl2
        tax
        lda     $d97d09,x   ; hex to decimal conversion constants
        sta     $74
        lda     $d97d0a,x
        sta     $75
        lda     $d97d0b,x
        sta     $76
        jsr     $ffc5
        plx
        lda     $78
        clc
        adc     $ce
        sta     $c4,x
        inx
        cpx     #$0007
        bne     @ff95
        lda     $70
        clc
        adc     $ce
        sta     $cb
        rts

; ---------------------------------------------------------------------------

; [  ]

_c1ffc5:
@ffc5:  stz     $78
@ffc7:  lda     $70
        sec
        sbc     $74
        sta     $70
        lda     $71
        sbc     $75
        sta     $71
        lda     $72
        sbc     $76
        sta     $72
        inc     $78
        bcs     @ffc7
        dec     $78
        lda     $70
        clc
        adc     $74
        sta     $70
        lda     $71
        adc     $75
        sta     $71
        lda     $72
        adc     $76
        sta     $72
        rts

; ---------------------------------------------------------------------------

; [ update joypad input ]

_c1fff4:
@fff4:  lda     $3eef       ; no input if credits
        bmi     @fffd
        jsl     $c2a006     ; update joypad input
@fffd:  rts

; ---------------------------------------------------------------------------

.segment "misc_code_far"

; ---------------------------------------------------------------------------

; [  ]

_d0dc2a:
        phb
        lda     #$00
        pha
        plb
        lda     $7ef9a1
        beq     @dca0
        cmp     #$01
        beq     @dc5f
        lda     #$41
        sta     $4330
        lda     #$26        ; window position
        sta     $4331
        ldx     #$dd81
        stx     $4332
        lda     #$d0
        sta     $4334
        lda     #$7e
        sta     $4337
        lda     $7ebc84
        ora     #$08
        sta     $7ebc84
        bra     @dca0
@dc5f:  lda     #$40
        sta     $4360
        lda     #$31
        sta     $4361
        lda     $7edbd3
        beq     @dc74
        ldx     #$dd9f
        bra     @dc77
@dc74:  ldx     #$ddac
@dc77:  stx     $4362
        lda     #$d0
        sta     $4364
        lda     #$7e
        sta     $4367
        bra     @dca0
        lda     #$40
        sta     $4360
        lda     #$00
        sta     $4361
        ldx     #$dd7a
        stx     $4362
        lda     #$d0
        sta     $4364
        lda     #$7e
        sta     $4367
@dca0:  plb
        stz     $f9a1
        rtl

; ---------------------------------------------------------------------------

; [ init battle hdma ]

_d0dca5:
        phb
        lda     #$00
        pha
        plb
        lda     #$43        ; 2-address, write twice, indirect
        sta     $4300
        sta     $4310
        sta     $4320
        lda     #$0d        ; dma channel 0: bg1 scroll
        sta     $4301
        lda     #$0f        ; dma channel 1: bg2 scroll
        sta     $4311
        lda     #$11        ; dma channel 2: bg3 scroll
        sta     $4321
        ldx     #$a897
        stx     $4302
        ldx     #$a8b0
        stx     $4312
        ldx     #$a930
        stx     $4322
        lda     #$7e
        sta     $4304
        sta     $4314
        sta     $4324
        sta     $4307
        sta     $4317
        sta     $4327
        lda     $7edbd3
        beq     @dd0a
        lda     #$40
        sta     $4320
        lda     #$32        ; dma channel 2: fixed color
        sta     $4321
        ldx     #$dd7a
        stx     $4322
        lda     #$d0
        sta     $4324
        lda     #$7e
        sta     $4327
@dd0a:  lda     #$40
        sta     $4330
        lda     #$05        ; dma channel 3: bg mode
        sta     $4331
        lda     $7edbd3
        beq     @dd1f
        ldx     #$dd92
        bra     @dd22
@dd1f:  ldx     #$dd88
@dd22:  stx     $4332
        lda     #$d0
        sta     $4334
        lda     #$7e
        sta     $4337
        lda     #$40
        sta     $4360
        lda     #$00        ; dma channel 6: screen brightness
        sta     $4361
        ldx     #$dd7a
        stx     $4362
        lda     #$d0
        sta     $4364
        lda     #$7e
        sta     $4367
        lda     #$40
        sta     $4370
        lda     #$08        ; dma channel 7: bg2 base address
        sta     $4371
        lda     $7edbd3
        beq     @dd5e
        ldx     #$ddc0
        bra     @dd61
@dd5e:  ldx     #$ddb6
@dd61:  stx     $4372
        lda     #$d0
        sta     $4374
        lda     #$7e
        sta     $4377
        lda     $7ebc84     ; enable hdma channels 2,3,4,6,7
        ora     #$ce
        sta     $7ebc84
        plb
        rtl

; ---------------------------------------------------------------------------

; hdma tables

; fixed color / screen brightness
_d0dd7a:
        .byte   $f0,$55,$b4
        .byte   $f0,$c5,$b4
        .byte   $80

; window position
_d0dd81:
        .byte   $f0,$f0,$f9
        .byte   $f0,$d0,$fa
        .byte   $80

; bg mode
_d0dd88:
        .byte   $50,$82,$bc
        .byte   $50,$82,$bc
        .byte   $40,$83,$bc
        .byte   $00

; bg mode
_d0dd92:
        .byte   $20,$83,$bc
        .byte   $50,$82,$bc
        .byte   $50,$82,$bc
        .byte   $20,$83,$bc
        .byte   $00

; color math
_d0dd9f:
        .byte   $20,$86,$bc
        .byte   $50,$86,$bc
        .byte   $50,$86,$bc
        .byte   $20,$86,$bc
        .byte   $00

; color math
_d0ddac:
        .byte   $50,$86,$bc
        .byte   $50,$86,$bc
        .byte   $40,$87,$bc
        .byte   $00

; bg2 base address
_d0ddb6:
        .byte   $50,$c2,$db
        .byte   $50,$c2,$db
        .byte   $40,$c3,$db
        .byte   $00

; bg2 base address
_d0ddc0:
        .byte   $20,$c3,$db
        .byte   $50,$c2,$db
        .byte   $50,$c2,$db
        .byte   $20,$c3,$db
        .byte   $00

; ---------------------------------------------------------------------------

_d0ddcd:
        .word   $0010,$0010,$0010,$008f,$0080,$0000

_d0ddd9:
        .byte   $c0

; ---------------------------------------------------------------------------

_d0ddda:
        .byte   $0d,$80,$fd,$40,$fe,$02,$40,$01,$ff
        .byte   $fd,$80,$fe,$0f,$40,$fe,$01,$ff
        .byte   $fd,$80,$fe,$08,$60,$0b,$60,$01,$ff
        .byte   $0e,$60,$fd,$b0,$fe,$01,$ff
        .byte   $fe,$09,$60,$0a,$60,$01,$ff
        .byte   $fd,$80,$fe,$08,$40,$0b,$40,$03,$50,$01,$62,$0f,$20,$fd,$90,$fe
        .byte   $01,$28,$10,$28,$fd,$28,$fe,$ff

; ---------------------------------------------------------------------------

; [ copy data to vram (channel 5) ]

;    a: source bank
;   +x: source address
;   +y: destination address (vram)
; +$70: size

_d0de1a:
        phb
        pha
        lda     #$00
        pha
        plb
        pla
        sty     $2116
        stx     $4352
        sta     $4354
        lda     #$01
        sta     $4350
        lda     #$18
        sta     $4351
        ldx     $70
        stx     $4355
        lda     #$20
        sta     $420b
        plb
        rtl

; ---------------------------------------------------------------------------

; [ copy data to vram (channel 4) ]

;    a: source bank
;   +x: source address
;   +y: destination address (vram)
; +$88: size

_d0de40:
        phb
        pha
        lda     #$00
        pha
        plb
        pla
        sty     $2116
        stx     $4342
        sta     $4344
        lda     #$01
        sta     $4340
        lda     #$18
        sta     $4341
        ldx     $88
        stx     $4345
        lda     #$10
        sta     $420b
        plb
        rtl

; ---------------------------------------------------------------------------

; [ copy color palettes to vram ]

_d0de66:
        phb
        lda     #$00
        pha
        plb
        sta     $2121
        ldx     #$2202
        stx     $4340
        ldx     #$7e09      ; color palettes
        stx     $4342
        lda     #$7e
        sta     $4344
        ldx     #$0200
        stx     $4345
        lda     #$10
        sta     $420b
        plb
        rtl

; ---------------------------------------------------------------------------

; [  ]

_d0de8c:
        lda     $bc75
        bne     @ded0
        phb
        lda     #$00
        pha
        plb
        ldx     #$0000
        stx     $2102
        ldx     #$0400
        stx     $4340
        ldx     #$0200
        stx     $4342
        lda     #$00
        sta     $4344
        sta     $4347
        ldx     #$0220
        stx     $4345
        lda     #$10
        sta     $420b
        lda     $7ecd46
        bpl     @decf
        lda     $7ecd45
        sta     $2102
        lda     $7ecd46
        sta     $2103
@decf:  plb
@ded0:  rtl

; ---------------------------------------------------------------------------

; [ clear vram ]

; +x: vram address
; +y: size

_d0ded1:
        phb
        lda     #$00
        pha
        plb
        stx     $2116
        ldx     #$def8      ; d0/def8 (16-bit constant zero)
        stx     $4352
        lda     #$09
        sta     $4350
        lda     #$18
        sta     $4351
        lda     #$d0
        sta     $4354
        sty     $4355
        lda     #$20
        sta     $420b
        plb
        rtl

; ---------------------------------------------------------------------------

; [ validate inventory ]

_d0ef78:
        clr_ax
@ef7a:  lda     $0640,x     ; item id
        bne     @ef82
        stz     $0740,x
@ef82:  lda     $0740,x     ; item quantity
        bne     @ef8a
        stz     $0640,x
@ef8a:  inx
        cpx     #$0100
        bne     @ef7a
        rtl

; ---------------------------------------------------------------------------

.segment "btlgfx_code_far"

; ---------------------------------------------------------------------------

; [ wait for vblank ]

_d97caa:
        inc     $a5
@7cac:  lda     $a5
        ora     $db9a
        bne     @7cac
        rtl

; ---------------------------------------------------------------------------

; [ clear sprite data ]

_d97cb4:
        ldx     #$0000
        lda     #$f0
@7cb9:  sta     $0200,x
        inx
        cpx     #$0200
        bne     @7cb9
        ldx     #$0000
        lda     #$00
@7cc7:  sta     $0400,x
        inx
        cpx     #$0020
        bne     @7cc7
        rtl

; ---------------------------------------------------------------------------
