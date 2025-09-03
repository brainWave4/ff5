; +-------------------------------------------------------------------------+
; |                                                                         |
; |                             FINAL FANTASY V                             |
; |                                                                         |
; +-------------------------------------------------------------------------+
; | file: menu/menu-main.asm                                                |
; |                                                                         |
; | description: menu code                                                  |
; +-------------------------------------------------------------------------+

.p816

.include "macros.inc"
.include "hardware.inc"
.include "const.inc"

.export ExecMenu_ext, UpdateJoypad_ext, _c2a006, _c2a008

.segment "menu_code"

; ---------------------------------------------------------------------------

        .a8
        .i16

; c2/a000
ExecMenu_ext:
        bra ExecMenu

UpdateJoypad_ext:
        jsr     _c2ff7d
        rtl

_c2a006:
        bra     _a00a

_c2a008:
        bra     _a00f

_a00a:  jsr     _c2ff56
        bra     _a012
_a00f:  jsr     _c2ff68
_a012:  jsr     _c2fe5b
        rtl

; ---------------------------------------------------------------------------

ExecMenu:

        stz     $0139
        lda     $0134
        bne     :+
        lda     #$f0                    ; hack to force use a tent
        sta     $0139
:       rtl

; @a016:  jsr     InitMenu
;         stz     $39
;         lda     $34
;         and     #7
;         asl
;         tax
;         lda     $c0e600,x
;         sta     $c7
;         shorta
;         jmp     ($01c7)

; ---------------------------------------------------------------------------

CommonReturn:
@a02d:  jsr _c2b2bd

_c2a030:
@a030:  shorta
        rtl

; ---------------------------------------------------------------------------

; [ menu command $00: main menu ]

_c2a033:
_a033:  lda $35
        sta $44
        lda #$01
        bra _a06b       ; show menu

; ---------------------------------------------------------------------------

; [ menu command $01: collect items after battle ]

_c2a03b:
_a03b:  lda #$0a
        bra _a06b       ; show menu

; ---------------------------------------------------------------------------

; [ menu command $02: shop ]

_c2a03f:
_a03f:  lda #$06
        bra _a06b       ; show menu

; ---------------------------------------------------------------------------

; [ menu command $03: init menu settings ]

_c2a043:
_a043:  jsr _c2a1f0     ; init config settings
        jsr _c2ff7d     ; update joypad config
        jsr _c2d447     ; update window color
        jsr _c2f5a9     ; update mono/stereo setting
        lda #$0c
        bra _a06b       ; show menu

; ---------------------------------------------------------------------------

; [ menu command $04: tutorial ]

_c2a053:
_a053:  lda #$80
        tsb $45         ; enable tutorial mode
        stz $49         ; clear pause counter
        stz $41
        jsr _c2a394     ; init tutorial script
        lda #$01
        bra _a06b       ; show menu

; ---------------------------------------------------------------------------

; [ menu command $06: transfer galuf's stats to krile ]

_c2a062:
_a062:  stz $35
        jsr _c2d958
        bra _c2a030

; ---------------------------------------------------------------------------

; [ menu command $05: name change ]

_c2a069:
_a069:  lda #$0d

; ---------------------------------------------------------------------------

; [ show menu ]

_c2a06b:
_a06b:  shorta
        sta $43         ; menu state
        lda #$7e
        pha
        plb
        longa
        jsr _c2c16a     ; load tilemap/???/cursor data
        jsr _c2a16e     ; reset sprite data
        lda $43         ; menu state
        and #$00ff
        dec
        asl
        tax
        lda $c0e60e,x
        sta $c7
        per $a08e
        jmp ($01c7)
        longa
        lda $43         ; menu state
        and #$00ff
        cmp #$000c
        bne @a0a2
        jmp _c2a030
@a0a2:  shorta
        lda #$00
        pha
        plb
        stz $2121
        longa
        stz $2102
        stz $2116
        ldx #$f5b2      ; 02 04 00 02 00 20 02 (sprite data)
        jsr _c2a0f6
        ldx #$f5b9      ; 02 22 00 73 7E 00 02 (color palettes)
        jsr _c2a0f6
        ldx #$f58b      ; 01 18 00 30 7E 00 40 (vram)
        jsr _c2a0f6
        shorta
        lda #$04
        sta $ca
        lda #$00
        sta $7e7511
        jsr _c2a106       ; wait for vblank
        lda $7e750e
        sta $420c
        lda $4210
        lda #$81
        sta $4200
        lda #$00
        sta $7e7522
        sta $7e7525
        lda #$03
        sta $7e7513
        jmp _a2e9

; ---------------------------------------------------------------------------

; [ dma ]

; +X: address of dma parameters (+$C00000)

_c2a0f6:
_a0f6:  ldy #$4300
        lda #$0006
        mvn $00,$c0
        lda #$0001
        sta $420b
        rts

; ---------------------------------------------------------------------------

; [ wait for vblank ]

_c2a106:
_a106:  php
        shorta
@a109:  lda $004210
        bmi @a109
@a10f:  lda $004210
        bpl @a10f
        lda $004210
        plp
        rts

; ---------------------------------------------------------------------------

; c2/a11b
InitMenu:
@a11b:  longai
        lda #$0100      ; set direct page to $0100
        tcd
        ldx #$f533      ; copy interrupt jump code
        ldy #$1f00
        lda #$0007
        mvn $7e,$c0
        stz $8e
        shorta
        lda #$80
        sta $002100
        stz $44
        stz $45
        stz $46
        stz $47
        stz $48
        jsr _c2a18a
        jsr _c2d230
        jsr _c2d37b
        jsr _c2d3db
        jsr _c2a247
        jsr _c2a1cf
        jsr _c2ff7d     ; update joypad config
        jsr _c2d447     ; update window color
        jsr _c2f5a9     ; update mono/stereo setting
        jsr _c2a16e     ; reset sprite data
        longa
        ldx #$f573
        ldy #$750f
        lda #$0017
        mvn $7e,$c0
        rts

; ---------------------------------------------------------------------------

; [ reset sprite data ]

_c2a16e:
_a16e:  php
        longa
        ldx #$0220
@a174:  stz $01fe,x
        dex2
        bne @a174
        ldx #$0020
        lda #$aaaa
@a181:  sta $03fe,x
        dex2
        bne @a181
        plp
        rts

; ---------------------------------------------------------------------------

_c2a18a:
_a18a:  phb
        php
        shorta
        lda #$00
        pha
        plb
        lda #$01
        sta $4200
        lda #$01
        sta $2101
        lda #$00        ; mode 0
        sta $2105
        sta $2106
        lda #$80
        sta $2115
        ldx #$0008
@a1ac:  stz $210c,x
        stz $210c,x
        dex
        bne @a1ac
        longa
        ldx #$f53b
        ldy #$2107
        lda #$0005
        mvn $00,$c0
        ldy #$212c
        lda #$0005
        mvn $00,$c0
        plp
        plb
        rts

_c2a1cf:
        phb
        php
        longa
        lda $8e
        sta $00420c
        ldx #$f547
@a1dc:  lda $c00000,x
        beq @a1ed
        tay
        inx2
        lda #$0004
        mvn $00,$c0
        bra @a1dc
@a1ed:  plp
        plb
        rts

; ---------------------------------------------------------------------------

; [ init config settings ]

_c2a1f0:
_a1f0:  phb
        php
        longa
        ldx #$f342      ; C0/F342 (default config settings)
        ldy #$0970
        lda #$001f
        mvn $00,$c0
        lda #$0100      ; set character cursor positions
        sta $042d
        lda #$0302
        sta $042f
        shorta
        stz $59
        stz $5d
        stz $5f
        stz $61
        stz $62
        stz $5e
        stz $5c
        stz $5b
        lda #$02
        sta $60
        lda #$08
        sta $5a
        stz $63
        stz $64
        stz $65
        stz $66
        lda #$07
        sta $67
        sta $68
        sta $69
        Sta $6a
        plp
        plb
        rts

; ---------------------------------------------------------------------------

_c2a23b:
_a23b:  sta ($e0),y
        clc
        adc $e4
        iny2
        cpy $e2
        bne _a23b
        rts

; ---------------------------------------------------------------------------

; [ init rom data pointers (data in bank $D1) ]

_c2a247:
_a247:  php
        longa
        ldx #$d000
        stx $e0
        ldx #$0100
        stx $e2
        ldx #$000c
        stx $e4
        ldy $8e
        lda #$0000
        jsr _c2a23b
        ldx #$01c0
        stx $e2
        lda #$0600
        jsr _c2a23b
        ldx #$0008
        stx $e4
        ldx #$0200
        stx $e2
        lda #$0a80
        jsr _c2a23b
        ldx #$d200
        stx $e0
        ldx #$0009
        stx $e4
        ldy $8e
        lda #$1380      ; D1/1380 (item names)
        jsr _c2a23b
        ldx #$d400
        stx $e0
        ldx #$00ae
        stx $e0
        ldx #$00ae
        stx $e2
        ldx #$0006
        stx $e4
        ldy $8e
        lda #$1c80      ; D1/1C80 (spell names)
        jsr _c2a23b
        ldx #$0200
        stx $e2
        ldx #$0009
        stx $e4
        jsr _c2a23b
        ldx #$d600
        stx $e0
        ldx #$00a2
        stx $e2
        ldx #$0005
        stx $e4
        ldy $8e
        lda #$5800
        jsr _c2a23b
        ldx #$0100
        stx $e2
        ldx $8e
        stz $e4
        lda $8e
        jsr _c2a23b
        ldx #$0142
        stx $e2
        ldx #$0008
        stx $e4
        lda #$6200
        jsr _c2a23b
        plp
        rts

; ---------------------------------------------------------------------------

; [ get next input ]

_c2a2e9:
_a2e9:  shorta
        longi
        jsr _c2e66f
        jsr _c2fc2f
        pea $7e7e
        plb
        plb
        bit $45
        bmi @a301       ; branch if in tutorial mode
        jsr _c2a33a     ; get pressed button index
        bra @a320
@a301:  ldx $49         ; decrement pause counter
        bmi @a30c
        dex
        stx $49
        lda $8e
        bra @a320
@a30c:  lda $48
        bne @a314       ; branch if tutorial script pointer is valid
        lda #$08        ; exit menu
        bra @a320
@a314:  lda [$46]       ; tutorial script
        ldx $46
        inx
        stx $46
        ldx #$000f
        stx $49
@a320:  sta $4b
        bit #$10
        beq @a328       ; branch if not a pause
        lda #$07        ; use pause command
@a328:  longa
        and #$000f
        asl
        tax
        lda $c0e628,x
        sta $c7
        shorta
        jmp ($01c7)

; ---------------------------------------------------------------------------

; [ get pressed button index ]

_c2a33a:
_a33a:  php
        longa
        ldx $8e
@a33f:  lda $0a         ; buttons pressed
        and $c0e7d2,x   ; button mask
        bne @a34f       ; branch if buttons are pressed
        inx3            ; next button
        cpx #$0012
        bne @a33f
@a34f:  lda $c0e7d4,x   ; button index
        and #$00ff
        plp
        rts

; ---------------------------------------------------------------------------

; [ menu state $14: pause (tutorial) ]

_c2a358:
_a358:  lda $ab
        longa
        and #$000f
        asl
        tax
        lda $c0f592,x   ; pause duration
        sta $49
        jmp _c2a4f0

; ---------------------------------------------------------------------------

; [ menu state $0E: A button pressed ]

_c2a36a:
_a36a:  jsr _c2e0b0
        lda $54
        longa
        and #$007f
        asl2
        bra _a386

; ---------------------------------------------------------------------------

; [ menu state $0F: B button pressed ]

_c2a378:
_a378:  jsr _c2e0b8     ; play sound effect
        lda $54
        longa
        and #$007f
        asl2
        inc2
_a386:  tax
        lda $c08724,x
        sta $c7
        lda $8e
        shorta
        jmp ($01c7)

; ---------------------------------------------------------------------------

; [ init tutorial script ]

_c2a394:
_a394:  php
        longa
        ldx #$0500      ; copy sram data to $7E2000 ($0600 bytes)
        ldy #$2000
        lda #$05ff
        mvn $7e,$7e
        ldx #$0159      ; copy $12 bytes from $0159 to $7E2600 (cursor memory positions ???)
        ldy #$2600
        lda #$0011
        mvn $7e,$7e
        lda $35         ; tutorial index
        and #$0007
        asl2
        tax
        lda $c0e841,x   ; pointer to tutorial script
        sta $46
        lda $c0e843,x
        shorta
        sta $48
        xba             ; tutorial flags
        and #$0f
        tsb $45
        longa
        ldx #$e8df      ; set available abilities for tutorial
        ldy #$08f7      ; copy 20 bytes from $C0E8DF -> $7E08F7
        lda #$0013
        mvn $7e,$c0
        shorta
        lda #$e0        ; set available jobs for tutorial
        sta $0840
        lda #$64
        sta $0841
        lda #$04
        sta $0842
        lda #$05
        trb $0973
        lda #$06
        sta $08f3
        lda #$40
        trb $0500
        stz $051a
        ldx $8e
@a3fd:  lda $c0e8f8,x
        beq @a40f
        xba
        lda #$01
        xba
        phx
        jsr _c2e2ce
        plx
        inx
        bra @a3fd
@a40f:  stz $7e
        jsr _c2d4c5
        jsr _c2daa4
        longa
        lda $35
        and #$0007
        tax
        shorta
        lda $c0e8f0,x
        sta $d8
        jsr _c2e47d
        lda $da
        sta $053a
        lda $d8
        sta $0501
        ldx $dc
        stx $053b
        jsr _c2eb82
        jsr _c2e6d6
        plp
        rts

; ---------------------------------------------------------------------------

; [ menu state $15: exit menu (tutorial) ]

_c2a441:
_a441:  longa
        ldx #$2000      ; restore sram data
        ldy #$0500
        lda #$05ff
        mvn $7e,$7e
        ldx #$2600
        ldy #$0159
        lda #$0011
        mvn $7e,$7e
        jmp CommonReturn

; ---------------------------------------------------------------------------

; [ menu state $10: move cursor up ]

_c2a45e:
_a45e:  jsr _c2e4df     ; get pointer to current cursor data
        lda $7604,x
        bra @a47c

; ---------------------------------------------------------------------------

; [ menu state $10: move cursor down ]

_c2a466:
_a466:  jsr _c2e4df     ; get pointer to current cursor data
        lda $7605,x
        bra @a47c

; ---------------------------------------------------------------------------

; [ menu state $10: move cursor left ]

_c2a46e:
_a46e:  jsr _c2e4df     ; get pointer to current cursor data
        lda $7606,x
        bra @a47c

; ---------------------------------------------------------------------------

; [ menu state $10: move cursor right ]

_c2a476:
_a476:  jsr _c2e4df     ; get pointer to current cursor data
        lda $7607,x
@a47c:  pea $7e7e
        plb
        plb
        jsr _c2e0a8     ; play sound effect
        shorta
        stz $4f
        sta $56         ; target cursor position
        jsr _c2e4e1     ; get pointer to cursor data
        lda $7601,x
        sta $58
        lda $7600,x
        sta $57
        bmi @a4bb
        cmp $54
        beq @a4a1
        lda #$40
        tsb $4f
@a4a1:  lda $53
        sta $50
        lda $54
        sta $51
        lda $55
        sta $52
        lda $56
        sta $53
        lda $57
        sta $54
        lda $58
        sta $55
        bra @a4bf
@a4bb:  lda #$80
        tsb $4f
@a4bf:  bit $4f
        bmi @a4c7
        bvs @a4d1
        bra @a4e5
@a4c7:  ldx #$e63a
        lda $57
        jsr _c2a4f3
        bra @a4e5
@a4d1:  ldx #$e6af
        lda $51
        jsr _c2a4f3
        bit $4f
        bvc @a4e5
        ldx #$e652
        lda $54
        jsr _c2a4f3
@a4e5:  ldx #$e6e8
        lda $54
        jsr _c2a4f3
        jsr _c2e6ab     ; update cursor sprite

; fall through

; ---------------------------------------------------------------------------

; [ menu state $0D: name change ]

_c2a4f0:
_a4f0:  jmp _c2a2e9     ; get next input

; ---------------------------------------------------------------------------

; [  ]

_c2a4f3:
_a4f3:  shorta
        sta $e0
        ldy $8e
@a4f9:  lda $c00000,x
        beq @a516
        cmp $e0
        beq @a508
        inx3
        bra @a4f9
@a508:  longa
        lda $c00001,x
        sta $c7
        per $4515
        jmp ($01c7)
        shorta
        rts

; ---------------------------------------------------------------------------

; [  ]

_c2a519:
_a519:  jsr _c2a55f
        bcs @a549
        ldy $8e
@a520:  lda $29ac,y
        clc
        adc $6b
        tax
        lda $7a00,x
        and #$ff
        brk $be
        bcs @a559
        jsr _c2d8e4
        iny2
        cpy #$0004
        bne @a520
        jsr _c2e367
        jsr _c2fe05
        jsr _c2e66f
        jsr _c2fc2f
        jsr _c2a54a
@a549:  rts
        shorta
        lda $58
        cmp #$03
        bmi @a55e
        lsr
        and #$02
        dec
        clc
        adc $53
@a559:  sta $53
        jsr _c2e6ab     ; update cursor sprite
@a55e:  rts

; ---------------------------------------------------------------------------

; [  ]

_c2a55f:
_a55f:  shorta
        lda $7512
        bne @a5b3
        longa
        lda $58
        and #$0007
        dec
        and #$0001
        asl
        tay
        ldx $298a,y
        ldy #$29a0
        lda #$0015
        mvn $7e,$c0
        lda $6b
        clc
        adc $29a0
        bmi @a5b3
        cmp $6d
        beq @a58d
        bcs @a5b3
@a58d:  sta $6b
        shorta
        lda #$01
        sta $7512
        stz $7528
        longa
        ldx $29a6
        ldy $29a8
        lda $29aa
        bpl $a5ae
        and #$7fff
        mvn $7e,$7e
        clc
        rts
@a5b3:  sec
        rts

; ---------------------------------------------------------------------------

; [ job menu, at first job, pressed left, go to last job ]

_c2a5b5:
_a5b5:  shorta
        lda $6f
        bne @a5e1
        lda $53
        sta $50
        lda $54
        sta $51
        lda $55
        sta $52
        ldx $8e
@a5c9:  lda $7a00,x     ; find the last available job
        bmi @a5d6
        inx
        cpx #$0017
        bpl @a5dc
        bra @a5c9
@a5d6:  dex
        txa
        and #$1f
        sta $53
@a5dc:  jsr _c2e6ab     ; update cursor sprite
        bra @a5e5
@a5e1:  lda $53
        sta $50
@a5e5:  rts

; ---------------------------------------------------------------------------

; [  ]

_c2a5e6:
_a5e6:  lda $70
        and #$ff
        brk $d0
        ora ($20,s),y
        eor $0eb0a5,x
        jsr _c2a607
        jsr _c2fe05
        jsr _c2e66f
        jsr _c2fc2f
        bra @a606
        shorta
        lda $53
        sta $50
@a606:  rts

; ---------------------------------------------------------------------------

; [  ]

_c2a607:
_a607:  lda $29ac
        clc
        adc $6b
        tax
        ldy $29b0
        jsr _c2e3e3
        jsr _c2e367
        rts

; ---------------------------------------------------------------------------

; [  ]

_c2a618:
_a618:  lda $2802
        bpl @a61e
        rts
@a61e:  lda $2814
        and #$00ff
        sta $85
        lda $58
        and #$000f
        dec
        tax
        shorta
        lda $c0f3c1,x
        clc
        adc $85
        cmp $2813
        bmi @a642
        beq @a642
        lda $2813
        bra @a648
@a642:  cmp #$01
        bpl @a648
        lda #$01
@a648:  sta $2814
        jsr _c2f0e6
        shorta
        ldx #$2821
        ldy #$2819
        jsr _c2eec8
        bcs @a65f
@a65b:  lda $85
        bra @a648
@a65f:  lda $2804
        bmi @a671
        ldx #$2815
        ldy #$2819
        jsr _c2eec8
        bcc @a65b
        bra @a671
@a671:  longa
        jsr _c2a67a
        jsr _c2a693
        rts

; ---------------------------------------------------------------------------

; [  ]

_c2a67a:
_a67a:  ldx #$42a4
        ldy #$2819
        lda #$7e73
        jsr _c2e4ed
        ldx #$429a
        ldy #$2814
        lda #$7e21
        jsr _c2e4ed
        rts

; ---------------------------------------------------------------------------

; [  ]

_c2a693:
_a693:  ldx #$f3f9
        bra @a6a0
        ldx #$f402
        bra @a6a0
        ldx #$f40b
@a6a0:  longa
        ldy #$7514
        lda #$0008
        mvn $7e,$c0
        shorta
        lda #$01
        sta $7511
        jsr _c2e66f
        jsr _c2fc2f
        rts

; ---------------------------------------------------------------------------

; [  ]

_c2a6b9:
_a6b9:  jsr _c2a55f
        bcs @a6dd
        php
        shorta
        lda $29a3
        sta $7528
        plp
        jsr _c2a6de
        jsr _c2fe05
        jsr _c2e66f
        jsr _c2fc2f
        jsr _c2e66f
        jsr _c2fc2f
        jsr _c2a54a
@a6dd:  rts

; ---------------------------------------------------------------------------

; [  ]

_c2a6de:
_a6de:  lda $29ac
        clc
        adc $6b
        tax
        ldy $29b0
        jsr _c2e3f3
        lda $29ae
        clc
        adc $6b
        tax
        ldy $29b2
        jsr _c2e3f3
        jsr _c2e367
        rts

; ---------------------------------------------------------------------------

; [  ]

_c2a6fc:
_a6fc:  lda $2b66
        tay
@a700:  lda $58
        dec
        and #$0003
        asl
        tax
        lda $c0f3ab,x
        stz $2b6e
        shorta
        ldx $8e
@a713:  clc
        adc $2b66,x
        jsr _c2a780
        sta $2b66,x
        xba
        inx
        cpx #$0002
        bne @a713
        lda $2b67
        sta $004202
        lda $2b68
        sta $004203
        nop4
        lda $004216
        clc
        adc $2b66
        longa
        and #$00ff
        tax
        lda $7a00,x
        and #$00ff
        cmp #$00ff
        beq @a700
        txa
        inc
        shorta
        ldx $2b6a
        sta $7601,x
        lda $2b66
        and #$0f
        tax
        lda $2b67
        and #$0f
        tay
        shorta
        lda $2b70,x
        ldx $2b6a
        sta $7602,x     ; cursor x position
        lda $2b80,y
        sta $7603,x     ; cursor y position
        jsr _c2e6ab     ; update cursor sprite
        bra @a77f
        tya
        sta $2b66
@a77f:  rts

; ---------------------------------------------------------------------------

; [  ]

_c2a780:
_a780:  bpl @a794
        bit $2b6c,x
        bpl @a78e
        inc $2b6e,x
        lda #$00
        bra @a79b
@a78e:  lda $2b68,x
        dec
        bra @a79b
@a794:  cmp $2b68,x
        bmi @a79b
        lda #$00
@a79b:  rts

; ---------------------------------------------------------------------------

; [  ]

_c2a79c:
_a79c:  lda $55
        and #$00ff
        dec
        tax
        lda $58
        and #$00ff
        dec2
        shorta
        clc
        adc $2c9c,x
        bmi @a7bd
        cmp $c0f076,x
        bmi @a7bf
        lda $2c9c,x
        bra @a7bf
@a7bd:  lda #$00
@a7bf:  sta $2c9c,x
        stx $2c94
        cpx #$000a
        bmi @a7cf
        cpx #$000d
        bmi @a7dc
@a7cf:  jsr _c2f7a6
        lda $54
        cmp #$21
        beq @a7f5
        cmp #$22
        beq @a7ed
@a7dc:  jsr _c2f810
        jsr _c2f71c     ; update config settings
        jsr _c2d447     ; update window color
        jsr _c2a698
        jsr _c2faf0
        bra @a7fb
@a7ed:  longa
        lda #$b77a
        jsr _c2c1b8
@a7f5:  jsr _c2a693
        jsr _c2f71c     ; update config settings
@a7fb:  rts

; ---------------------------------------------------------------------------

; [  ]

_c2a7fc:
_a7fc:  shorta
        stz $750f
        stz $751e
        jsr _c2c0e2
        lda $59
        sta $53
        lda #$02
        trb $7500
        lda #$08
        trb $7509
        lda #$04
        tsb $ca
        jsr _c2e6ab     ; update cursor sprite
        rts

; ---------------------------------------------------------------------------

; [  ]

_c2a81d:
_a81d:  stz $6f
        shorta
        lda $50
        sta $59
        rts
        stz $6f
        shorta
        lda #$02
        tsb $7500
        lda #$08
        tsb $7509
        lda #$04
        tsb $ca
        jsr _c2e67c
        jsr _c2e6ab     ; update cursor sprite
        jsr _c2a85a
        ldx #$adc7
        jsr _c2a8f0
        rts
        php
        longa
        lda $55
        and #$000f
        dec
        asl
        tax
        lda $c0ea64,x
        tax
        plp
        rts
@a85a:  jsr _c2a848
        bit $0500,x
        bvc @a877
        lda $55
        cmp #$04
        bne @a870
        dec $53
        dec $53
        dec $53
        dec $53
@a870:  inc $53
        jsr _c2e6ab     ; update cursor sprite
        bra @a85a
@a877:  rts
        lda $53
        and #$03
        sta $e0
        lda $50
        and #$03
        inc
        and #$03
        cmp $e0
        beq @a88d
        lda #$ff
        bra @a88f
@a88d:  lda #$01
@a88f:  sta $e2
        rts
        php
        shorta
        jsr _c2a878
@a898:  jsr _c2a848
        bit $0500,x
        bvc @a8bf
        lda $55
        clc
        adc $e2
        beq @a8af
        cmp #$05
        bra @a8b3
        lda $e2
        bra @a8b5
@a8af:  lda #$03
        bra @a8b5
@a8b3:  lda #$fd
@a8b5:  clc
        adc $53
        sta $53
        jsr _c2e6ab     ; update cursor sprite
        bra @a898
@a8bf:  plp
        rts
        shorta
        lda $6f
        bne @a8ca
        jsr _c2a892
@a8ca:  rts
        lda $50
        sta $53
        jsr _c2e6ab     ; update cursor sprite
        rts
        shorta
        lda $6f
        beq @a8e2
        jsr _c2a8cb
        lda #$40
        trb $4f
        bra @a8ef
@a8e2:  ldx #$add8
        jsr _c2a8f0
        stz $7510
        lda $50
        sta $5a
@a8ef:  rts
        longa
        txa
        jsr _c2c1b8
        jsr _c2a693
        rts
        lda $59
        jsr _c2c0c0
        shorta
        lda #$01
        sta $7510
        jsr _c2e67c
        lda $53
        and #$03
        ora #$0c
        sta $53
        jsr _c2e6ab     ; update cursor sprite
        jsr _c2a85a
        rts
        jsr _c2a892
        rts
        shorta
        lda $50
        and #$0b
        sta $5a
        rts
        jsr _c2d717
        jsr _c2a698
        lda #$02
        tsb $7500
        lda #$04
        tsb $ca
        rts
        lda $55
        and #$ff
        brk $3a
        tax
        shorta
        lda $2b5f,x
        beq @a947
        lda $50
        sta $53
@a947:  rts
        shorta
        lda $50
        sta $60
        lda #$02
        trb $7500
        lda #$04
        tsb $ca
        rts
        lda #$62
        ldx $b820
        cmp ($20,x)
        adc [$e3]
        jsr _c2a698
        rts
        jsr _c2d760
        jsr _c2a698
        rts
        stz $6f
        rts
        lda $55
        and #$ff
        brk $3a
        tax
        shorta
        lda $6f
        bne @a98e
        lda $7a00,x
        bpl @a992
        lda $53
        sec
        sbc $50
        cmp #$01
        bne @a98e
        stz $53
        bra @a992
@a98e:  lda $50
        sta $53
@a992:  jsr _c2e6ab     ; update cursor sprite
        longa
        lda $52
        and #$00ff
        dec
        asl2
        tay
        asl
        tax
        shorta
        lda $0293,x
        and #$f1
        ora #$0c
        sta $0293,x
        sta $0297,x
        lda $0363,y
        and #$f1
        ora #$0c
        sta $0363,y
        sta $0363,y
        jsr _c2cd57
        lda #$01
        sta $7511
        jsr _c2fad4     ; copy sprite data to vram
        jsr _c2faf0
        jsr _c2e66f
        jsr _c2a9d9
        jsr _c2cd08
        jsr _c2a69d
        rts

; ---------------------------------------------------------------------------

; [  ]

_c2a9d9:
_a9d9:  php
        longa
        lda #$af1a
        jsr _c2c1b8
        lda $55         ; cursor position ???
        and #$00ff
        dec
        tax
        lda $7a00,x     ; job index
        and #$001f
        asl
        tax
        lda $d17140,x   ; pointers to job/ability descriptions
        sta $2ceb
        jsr _c2da16
        plp
        rts

; ---------------------------------------------------------------------------

_c2a9fd:
_a9fd:  lda #$36
        bcs @aa21
        clv
        cmp ($49,x)
        cop $00
        tsb $7500
        lda #$04
        brk $04
        dex
        jsr _c2a693
        rts
        stz $6f
        shorta
        lda #$02
        tsb $7500
        lda #$04
        tsb $ca
        lda $74
@aa21:  cmp #$04
        beq @aa29
        cmp #$03
        beq @aa2e
@aa29:  ldx #$b065
        bra @aa31
@aa2e:  ldx #$b07d
@aa31:  jsr _c2a8f0
        rts
        jsr _c2e367
        jsr _c2a698
        stz $72
        stz $73
        lda #$08
        tsb $7500
        lda #$0c
        tsb $7502
        lda #$04
        tsb $ca
        rts
        stz $0208
        stz $020a
        lda #$fa
        lda $c1b820
        jsr _c2a698
        stz $70
        lda #$08
        trb $7500
        lda #$0c
        trb $7502
        lda #$04
        tsb $ca
        rts
        lda $55
        and #$ff
        brk $3a
        clc
        adc $6b
        tax
        shorta
        lda $7a00,x
        beq @aa84
        jsr @aa89
        bra @aa88
@aa84:  lda $50
        sta $53
@aa88:  rts
@aa89:  sta $72
        jsr _c2e0f7
        lda $90
        bne @aaaf
        jsr _c2e178
        jsr _c2e211
        lda $73
        jsr _c2e286
        lda $90
        bne @aaaf
        jsr _c2e1a6
        jsr _c2e7b3
        jsr _c2e7cc
        jsr _c2cbf8
        bra @aab7
@aaaf:  longa
        lda #$b005
        jsr _c2c1b8
@aab7:  jsr _c2a698
        rts
        lda #$b26a
        jsr _c2c1b8
        lda #$0004
        jsr _c2eee7
        jsr _c2a16e     ; reset sprite data
        jsr _c2fad4     ; copy sprite data to vram
        jsr _c2e66f
        rts
        shorta
        lda $2801
        and #$07
        bne @aae8
        lda $53
        cmp #$01
        bne @aae8
        lda $50
        and #$03
        eor #$02
        sta $53
@aae8:  rts
        lda #$42
        lda ($20)
        clv
        cmp ($e2,x)
        jsr $01ad
        plp
        and #$03
        cmp #$03
        bne @ab01
        stz $2886
        longa
        bra @ab0f
@ab01:  longa
        jsr _c2ef89
        jsr _c2ef16
        lda #$b25f
        jsr _c2c1b8
@ab0f:  jsr _c2f10e
        lda #$0000
        jsr _c2eee7
        rts
        lda #$b254
        jsr _c2c1b8
        rts
        jsr _c2ab36
        lda $2801
        and #$c903
        ora $f0,s
        ora #$8920
        sbc $ef1620
        jsr _c2fad4     ; copy sprite data to vram
        rts
        lda $55
        and #$000f
        dec
        tax
        shorta
        lda $2826,x
        bne @ab4b
        jsr _c2a8cb
        lda #$01
        trb $ca
        rts
        jsr _c2a67a
        ldx #$435a
        ldy #$2812
        jsr _c2e4ed
        lda #$e0
        lda ($20),y
        clv
        cmp ($ad,x)
        bpl $ab92
        and #$ff
        brk $0a
        tax
        lda $d14000,x
        sta $2ceb
        jsr _c2da16
        shorta
        lda $2809
        ldy #$4286
        jsr _c2e44e
        lda #$02
        tsb $7500
        lda #$04
        tsb $ca
        jsr _c2a693
        rts
        jsr @ab4c
        lda #$05
        jsr _c2eee7
        lda $2886
        sta $750f
        rts
@aba0:  shorta
        lda #$02
        trb $7500
        lda #$04
        tsb $ca
        stz $750f
        stz $751e
        rts
        jsr @aba0
        lda $2807
        clc
        adc #$03
        sta $53
        jsr _c2e6ab     ; update cursor sprite
        rts
        lda #$75
        lda ($20)
        clv
        cmp ($20,x)
        asl $a9f1
        brk $00
        jsr _c2eee7
        rts
        lda #$54
        lda ($20)
        clv
        cmp ($20,x)
        tya
        ldx $60
        jsr _c2ab36
        rts
        lda #$a9
        lda ($20,s),y
        clv
        cmp ($20,x)
        tya
        ldx $49
        php
        trb $7506
        lda #$04
        tsb $ca
        rts
        shorta
        lda $2d15
        beq @abfd
        lda $50
        sta $35
@abfd:  jsr _c2a698
        rts
        jsr _c2ac0e
        lda #$08
        tsb $7506
        lda #$04
        tsb $ca
        rts
        lda #$b4
        lda ($20,s),y
        clv
        cmp ($20,x)
        lda $20c7,x
        sta $20a6,x
        adc [$e3]
        rts
        jsr _c2ac90
        shorta
        stz $29a3
        stz $7528
        jsr @ac5e
        jsr _c2a698
        lda $2889
        beq @ac5d
        lda $6f
        longa
        and #$00ff
        sec
        sbc $6b
        bmi @ac55
        clc
        adc #$0004
        jsr _c2c0c9
        shorta
        lda #$01
        sta $7510
        bra @ac5d
@ac55:  jsr _c2c0e2
        shorta
        stz $7510
@ac5d:  rts
@ac5e:  php
        longa
        lda #$b349
        jsr _c2c1b8
        lda $55
        and #$00ff
        dec
        clc
        adc $6b
        tax
        shorta
        lda $7a00,x
        beq @ac8e
        lda $288a,x
        beq @ac8e
        longa
        and #$007f
        asl
        tax
        lda $d14000,x
        sta $2ceb
        jsr _c2da16
@ac8e:  plp
        rts
        lda $08
        and #$00
        bpl $ac86
        pld
        lda $4b
        and #$07
        brk $c9
        ora $00,s
        beq $acab
        cmp #$04
        brk $d0
        trb $16a9
        brk $80
        ora $a9,s
        nop
        sbc $6b6518,x
        bpl @acb5
        lda $8e
@acb5:  cmp $6d
        bmi @acbd
        beq @acbd
        lda $6d
@acbd:  sta $6b
        jsr _c2ac0e
        rts
        lda #$34
        ldy $20,x
        clv
        cmp ($20,x)
        sta ($46,s),y
        jsr _c2a69d
        ldx $7e
        lda $63,x
        sta $53
        rts
        lda #$99
        ldy $20,x
        clv
        cmp ($a9,x)
        ldy $b4
        jsr _c2c1b8
        lda $7e29e2
        and #$07
        brk $0a
        tax
        lda $c0f3b3,x
        jsr _c2c1b8
        jsr _c2a693
        jsr _c2a698
        ldx $7e
        lda $50
        sta $63,x
        rts
        lda #$fe
        lda ($20,s),y
        clv
        cmp ($20,x)
        rol $20de,x
        eor $20df
        sta $a5a6,x
        mvn $c9,$13
        bne @ad37
        lda $29e2
        cmp #$04
        beq @ad37
        ldx $7e
        lda $0973
        and #$04
        bne @ad28
@ad24:  lda #$07
        sta $67,x
@ad28:  lda $67,x
        cmp #$07
        bmi @ad24
        cmp #$19
        bpl @ad24
        sta $53
        jsr _c2e6ab     ; update cursor sprite
@ad37:  jsr _c2c6ba
        jsr _c2a698
        rts

; ---------------------------------------------------------------------------

_c2ad3e:
_ad3e:  lda #$b413
        jsr _c2cab8
        jsr _c2a69d     ; (this does a shorta)
        lda $51
        cmp #$13
        bne @ad5a
        lda $29e2
        cmp #$04
        beq @ad5a
        ldx $7e
        lda $50
        sta $67,x
@ad5a:  rts

; ---------------------------------------------------------------------------

_c2ad5b:
_ad5b:
        lda $29e2
        and #$00ff
        cmp #$0006
        beq @adaf
        lda $55
        and #$00ff
        dec
        tax
        lda $7a00,x
        and #$00ff
        cmp #$00ff
        beq @ada9
        pha
        lda #$b48e
        jsr _c2c1b8
        pla
        cmp #$00fe
        beq @ada4
        pha
        and #$00ff
        ldy #$60d2      ; destination: 7E/60D2
        jsr _c2e42c       ; draw spell name
        lda #$b409
        jsr _c1c1b8
        pla
        clc
        adc #$2a9d
        tay
        ldx #$60f4
        lda #$7e31
        jsr _c2e4ed
        jsr _c2a69d
        bra @adaf
@ada9:  shorta
        lda $50
        sta $53
@adaf:  rts

; ---------------------------------------------------------------------------

_c2adb0:
_adb0:  lda #$1e
        ldy $20,x
        clv
        cmp ($20,x)
        rol $20de,x
        eor $a2df
        cpx $a0b8
        bra @ae33
        jsr _c2c1fd
        jsr _c2a69d
        stz $2b66
        rts
        lda #$29
        ldy $20,x
        clv
        cmp ($a2,x)
        inc $b8
        ldy #$7180
        jsr _c2c1fd
        jsr _c2a69d
        rts
        lda #$fe
        lda ($20)
        clv
        cmp ($20,x)
        lda $20c7,x
        sta $a9a6,x
        php
        tsb $7500
        lda #$1c
        tsb $7502
        lda #$32
        sta $7505
        lda #$04
        tsb $750e
        lda #$04
        tsb $ca
        lda $2806
        sta $53
        jsr _c2e367
        lda #$07
        jsr _c2eee7
        rts
        lda #$10
        lda ($20,s),y
        clv
        cmp ($e2,x)
        jsr $08a9
        trb $7500
        stz $7502
        stz $7505
        lda #$04
        trb $750e
        lda #$04
        tsb $ca
        jsr _c2a698
        rts
        lda $55
        and #$0f
        brk $c9
        ora #$00
        beq @ae40
        jsr _c2f3f6
        bra @ae43
@ae40:  jsr _c2f450
@ae43:  jsr _c2faf0
        rts
        stz $2b6e
        rts
        shorta
        lda $2b6f
        beq @ae5b
        lda $2b65
        and #$01
        eor #$01
        sta $53
@ae5b:  rts

; ---------------------------------------------------------------------------

_c2ae5c:
_ae5c:  jsr _c2ab4c
        lda #$08
        jsr _c2eee7
        lda $2886
        sta $750f
        rts

; ---------------------------------------------------------------------------

_c2ae6b:
_ae6b:  jsr _c2aba0
        rts

; ---------------------------------------------------------------------------

_c2ae6f:
_ae6f:  jsr _c2b2bd
        longa
        ldx #$0500
        ldy #$2000
        lda #$05ff
        mvn $7e,$7e
        jsr _c2bf7d     ; get pointer to save slot in sram
        tax
        ldy #$0500
        lda #$05ff
        phb
        mvn $00,$30     ; load sram
        plb
        jsr _c2d230
        jsr _c2d3db
        jsr _c2d447     ; update window color
        jsr _c2a16e     ; reset sprite data
        ldx #$f394
        jsr _c2d04c
        jsr _c2d4db
        ldx #$66ee
        jsr _c2d658
        ldx #$6630
        ldy #$094a
        jsr _c2d662
        lda #$b5b8
        jsr _c2c1b8
        lda $43         ; menu state
        and #$00ff
        cmp #$000c
        beq @aec8
        lda #$b5df
        bra @aecb
@aec8:  lda #$b5cf
@aecb:  jsr _c2c1b8
        ldx #$2000
        ldy #$0500
        lda #$05ff
        mvn $7e,$7e
        shorta
        jsr _c2a106
        lda $750e
        sta $00420c
        lda $004210
        lda #$81
        sta $004200
        lda #$00
        sta $7522
        sta $7525
        lda #$03
        sta $7513
        jsr _c2a698
        jsr _c2fad4     ; copy sprite data to vram
        jsr _c2faf0
        lda #$02
        trb $7500
        lda #$04
        tsb $ca
        jsr _c2a69d
        rts

; ---------------------------------------------------------------------------

_c2af1b:
_af1b:  phb
        php
        ldx #$f384
        jsr _c2d04c
        ldx $8e
@af25:  lda $0242,x
        ora #$00
        jsr $429d
        cop $bd
        jsl $06f002
        ora #$00
        jsr $229d
        cop $e8
        inx3
        cpx #$0020
        bne @af25
        lda #$0d
        lda $20,x
        clv
        cmp ($a2,x)
        ror
        sbc ($49,s),y
        ora ($00),y
        jsr _c2da9d
        stz $7e
        lda $7e
        asl
        tax
        lda $c0f362,x
        sta $2bba
        jsr _c2ddd7
        lda $7e
        inc
        sta $7e
        cmp #$04
        brk $d0
        inx
        jsr _c2a693
        longa
        jsr _c2fad4     ; copy sprite data to vram
        jsr _c2faf0
        shorta
        lda $53
        sta $50
        lda $55
        sta $52
        lda $54
        sta $51
        plp
        plb
        rts
        lda $71
        and #$0f
        brk $85
        ror $c520,x
        pei ($49)
        clc
        lda $20,x
        clv
        cmp ($20,x)
        sta ($a6,s),y
        stz $7510
        longa
        ldx $8e
@afa1:  stz $0200,x
        inx2
        cpx #$0060
        bne @afa1
        jsr _c2fad4     ; copy sprite data to vram
        jsr _c2e66f
        rts
        stz $29ea
        stz $29ec
        stz $0206
        stz $020a
        stz $020e
        stz $0212
        lda $55
        and #$00ff
        cmp #$0005
        beq @aff4
@afce:  shorta
        lda $52
        cmp #$05
        bne @afde
        lda $29ee
        sta $53
        jsr _c2d210
@afde:  jsr _c2a892
        longa
        lda $55
        and #$000f
        dec
        tax
        shorta
        inc $29ea,x
        stz $7510
        bra @b04e
@aff4:  shorta
        lda $29e6
        and #$20
        bne @b005
        jsr _c2e0c0     ; play sound effect (error)
        jsr _c2a8cb
        bra @afce
@b005:  ldy $8e
@b007:  longa
        tya
        asl
        tax
        lda $c0ea64,x
        tax
        lda $0500,x
        and #$0040
        bne @b036
        tya
        asl
        tax
        lda $c0f37c,x
        pha
        tya
        asl2
        tax
        pla
        sta $0204,x
        lda #$2e02
        sta $0206,x
        shorta
        lda #$01
        sta $29ea,y
@b036:  iny
        cpy #$0004
        bne @b007
        shorta
        lda #$05
        sta $7510
        lda $52
        cmp #$05
        beq @b04e
        lda $50
        sta $29ee
@b04e:  rts
        jsr _c2af1b
        shorta
        lda #$08
        trb $7500
        lda #$02
        tsb $7500
        lda #$04
        tsb $ca
        rts
        shorta
        lda #$08
        tsb $7500
        lda #$02
        trb $7500
        lda #$04
        tsb $ca
        longa
        jsr _c2af91
        rts
        lda #$b7e9
        jsr _c2c1b8
        ldx #$ea04
        lda #$0009
        jsr _c2da9d
        jsr _c2f5c0
        ldx #$b91d
        ldy #$7080
        jsr _c2c1fd
        ldx #$ea1e
        ldy #$0240
        lda #$001f
        mvn $7e,$c0
        stz $7e
@b0a2:  jsr _c2d4c5
        ldy $80
        lda $0500,y
        and #$0040
        beq @b0c1
        lda $7e
        asl3
        tax
        stz $0240,x
        stz $0242,x
        stz $0244,x
        stz $0246,x
        lda $7e
        inc
        sta $7e
        cmp #$0004
        bne @b0a2
        stz $6f
        stz $71
        lda #$0020
        jsr _c2b154
        rts
        lda #$b739
        jsr _c2c1b8
        jsr _c2a693
        lda #$1c02
        brk $75
        lda #$1c04
        ora #$a975
        jsr _c20e1c
        adc $a9,x
        tsb $04
        dex
        jsr _c2a16e     ; reset sprite data
        jsr _c2fad4     ; copy sprite data to vram
        jsr _c2e66f
        lda #$8f00
        bpl $b121
        brk $8f
        bpl $b125
        brk $60
        lda #$b710
        jsr _c2c1b8
        lda #$0014
        sta $2c94
        stz $7e
@b114:  jsr _c2d4c5
        ldy $80
        lda $7e
        asl
        tax
        lda $c0ea8e,x
        tax
        lda $0500,y
        and #$0040
        bne @b133
        txy
        jsr _c2d533
        jsr _c2f7a6
        bra @b13d
@b133:  txy
        ldx #$ea96
        lda #$0031
        mvn $7e,$c0
@b13d:  inc $2c94
        inc $7e
        lda $7e
        cmp #$0004
        bmi @b114
        lda #$0000
        jsr _c2b154
        lda #$850e
        bvc @b1b4
        shorta
        tsb $750e
        jsr _c2a693
        lda #$02
        tsb $7500
        lda #$04
        tsb $ca
        jsr _c2e66f
        rts
        shorta
        jsr _c2a878
        lda $55
        sec
        sbc #$15
        sta $7e
@b17a:  jsr _c2d4c5
        ldx $80
        bit $0500,x
        bvc @b18f
        lda $7e
        clc
        adc $e2
        and #$03
        sta $7e
        bra @b17a
@b18f:  lda $7e
        clc
        adc #$0f
        sta $53
        jsr _c2e6ab     ; update cursor sprite
        rts
        lda #$40
        lda [$20],y
        clv
        cmp ($a2,x)
        and $b9,x
        ldy #$7080
        jsr _c2c1fd
        lda #$28
        brk $8d
        sty $2c,x
        jsr _c2f7a6
        inc $2c94
        lda $2c94
        cmp #$2f
        brk $30
        sbc ($49)
        ply
        lda [$20],y
        clv
        cmp ($a9,x)
        jsr $2000
        mvn $b1,$60
        shorta
        lda $71
        and #$0f
        bne @b1d6
        lda $52
        sta $71
@b1d6:  dec
        sta $7e
        jsr _c2d4c5
        ldx $80
        bit $0500,x
        bvc @b1eb
        jsr _c2e0c0     ; play sound effect (error)
        stz $71
        jsr _c2a8cb
@b1eb:  rts

; ---------------------------------------------------------------------------

_c2b1ec:
        .a16
_b1ec:  lda #$b3c2
        jsr _c2c1b8
        lda $2d1b
        ldy #$4284
        jsr _c2e44e
        jsr _c2cecc     ; get list of available jobs
        stz $85
@b200:  ldy $85
        lda $7a00,y
        and #$00ff
        cmp #$00ff
        beq @b251
        cmp #$0015
        beq @b251
        asl2
        tax
        lda $85
        asl
        tay
        lda $d15708,x   ; job equipment types
        and $2d1d
        sta $2d21,y
        lda $d1570a,x
        and $2d1f
        ora $2d21,y
        pha
        tyx
        lda $c0e901,x
        sta $99
        ldy $85
        lda $7a00,y
        and #$00ff
        ldy $99
        jsr $e4c7
        pla
        bne @b24d
        lda #$0108
        ldx $99
        jsr _c2d6dc
@b24d:  inc $85
        bra @b200
@b251:  lda $8e
        jsr _c2b154
        rts

; ---------------------------------------------------------------------------

_c2b257:
_b257:  jsr _c2b0d6
        rts

; ---------------------------------------------------------------------------

; [  ]

_c2b25b:
_b25b:  jmp _c2a4f0

; ---------------------------------------------------------------------------

; [  ]

_c2b25e:
_b25e:  lda $53
        sta $59
        cmp #$00
        beq @b29e
        cmp #$01
        beq @b2b1
        cmp #$03
        beq @b28a
        cmp #$04
        beq @b28a
        cmp #$05
        beq @b28a
        cmp #$02
        beq @b293
        cmp #$07
        beq @b28f
        cmp #$06
        beq @b293
        bra @b287
@b284:  jsr _c2e0c0     ; play sound effect (error)
@b287:  jmp _c2a4f0
@b28a:  lda #$0c
        jmp _c2a47c
@b28f:  lda $44
        bpl @b284
@b293:  jsr _c2b2bd
        jsr _c2c0e2
        lda $55
        jmp _c2a06b     ; show menu
@b29e:  longa
        lda $0840       ; available jobs
        bne @b2ad
        lda $0842
        and #$00f8
        beq @b284
@b2ad:  shorta
        bra @b28a
@b2b1:  longa
        lda $08f3
        ora $08f5
        bne @b2ad
        bra @b284

_c2b2bd:
        shorta
        lda #$00
        sta $7e7510
        sta $7e750f
        sta $7e751d
        sta $7e751e
        stz $ca
        lda #$04
        sta $7e7513
@b2d9:  jsr _c2e66f
        jsr _c2fc2f
        lda $7e7513
        bne @b2d9
        lda #$01
        sta $004200
        jsr _c2a106
        lda #$00
        sta $00420c
        lda #$80
        sta $002100
        rts
        lda $53
        sta $59
        jmp _c2a02d     ; exit menu

; ---------------------------------------------------------------------------

; [ order/row A button pressed ]

_c2b302:
_b302:  lda $6f
        bne @b317       ; branch if first selection is made
        lda $55
        sta $6f         ; select first character
        lda $53
        jsr _c2c0c4
        lda #$01
        sta $7510
        jmp _c2a4f0
@b317:  lda $55
        sta $70
        cmp $6f
        bne @b345       ; branch if not the same character
        dec
        sta $7e
        jsr _c2d4c5
        ldx $80
        lda $0500,x     ; toggle character row
        eor #$80
        sta $0500,x
        ldx #$f394
        jsr _c2d04c
        jsr _c2e6ab     ; update cursor sprite
        jsr _c2c0e2
        stz $6f
        shorta
        stz $7510
        jmp _c2a4f0
@b345:  dec $6f
        dec $70
        stz $7510
        longa
        lda $6f
        jsr _c2b3e9
        lda $70
        jsr _c2b3e9
        jsr _c2fad4     ; copy sprite data to vram
        jsr _c2e66f
        phb
        shorta
        lda #$c0
        pha
        plb
        longa
        lda $6f
        and #$0003
        asl
        tax
        lda $70
        and #$0003
        asl
        tay
        lda $effb,x
        sta $e0
        lda $effb,y
        sta $e2
        lda #$f053
        sta $e4
@b384:  lda ($e0)
        tax
        lda ($e2)
        tay
        lda ($e4)
        beq @b39f
        jsr _c2e610
        inc $e0
        inc $e0
        inc $e2
        inc $e2
        inc $e4
        inc $e4
        bra @b384
@b39f:  plb
        longa
        lda $6f
        jsr _c2b3d8
        ldx #$f394
        jsr _c2d04c
        jsr _c2c0e2
        lda $70
        jsr _c2b3db
        jsr _c2faf0
        jsr _c2e6ab     ; update cursor sprite
        jsr _c2e66f
        jsr _c2d4db
        stz $ca
        jsr _c2a698
        lda $6f
        sta $0000
        lda $70
        sta $0001
        jsl $c10009     ; swap character saved cursor positions
        stz $6f
        stz $70
        jmp _c2a4f0

; ---------------------------------------------------------------------------

; [  ]

_c2b3d8:
_b3d8:  and #$0003
        asl
        tax
        lda $c0f3cd,x
        tax
        jsr _c2a6a0
        rts
        and #$0003
        asl
        tax
        lda $c0eb08,x
        tax
        stz $0000,x
        stz $0002,x
        stz $0004,x
        stz $0006,x
        txa
        sec
        sbc #$0020
        tax
        stz $0000,x
        stz $0002,x
        rts

; ---------------------------------------------------------------------------

; [ order/row B button pressed ]

_c2b40c:
_b40c:  jsr _c2c0e2
        stz $7510
        jsr _c2fad4     ; copy sprite data to vram
        lda $6f
        bne @b422
        lda $53
        sta $5a
        lda $59
        jmp _c2a47c
@b422:  stz $6f
        stz $70
        jmp _c2a4f0

; ---------------------------------------------------------------------------

; [  ]

_c2b429:
_b429:  lda $55
        dec
        sta $71
        longa
        and #$000f
        asl
        tax
        lda $c0ea64,x
        tay
        shorta
        lda $59
        jsr _c2e4e1     ; get pointer to cursor data
        lda $7601,x
        cmp #$05
        beq @b463
        cmp #$02
        bne @b45c
        lda $55
        dec
        longa
        and #$000f
        tax
        shorta
        lda $08f3,x
        beq @b47a
@b45c:  lda $051a,y
        and #$c2
        bne @b47a
@b463:  lda $53
        and #$0b
        sta $5a
        jsr _c2c0e2
        jsr _c2b2bd
        lda $59
        jsr _c2e4e1     ; get pointer to cursor data
        lda $7601,x
        jmp _c2a06b     ; show menu
@b47a:  jsr _c2e0c0     ; play sound effect (error)
        jmp _c2a4f0
        stz $7510
        lda $53
        sec
        sbc #$04
        sta $5a
        lda $59
        jmp _c2a47c
        lda $55
        cmp #$04
        beq @b4a8
        lda #$01
        sta $7510
        lda $55
        sta $6f
        lda $53
        jsr _c2c0c0
        lda #$04
        jmp _c2a47c
@b4a8:  lda $45
        bpl @b4b0
        and #$02
        bne @b4d4
@b4b0:  longa
        stz $0200
        stz $0202
        jsr _c2fad4     ; copy sprite data to vram
        shorta
        lda $2d12
        ora $2d11
        beq @b4cc
        jsr _c2b676
        lda #$04
        bra @b4d1
@b4cc:  jsr _c2b2bd
        lda #$01
@b4d1:  jmp _c2a06b     ; show menu
@b4d4:  jmp _c2a4f0

; ---------------------------------------------------------------------------

; [  ]

_c2b4d7:
_b4d7:  longa
        lda $55
        and #$00ff
        dec
        clc
        adc $6b
        tax
        ldy $80
        lda $0501,y     ; job
        and #$00ff
        tay
        lda $6f
        and #$00ff
        cpy #$0014
        beq @b4f7       ; branch if mimic
        dec
@b4f7:  clc
        adc $80
        tay
        shorta
        lda $7a00,x
        sta $0516,y
        lda #$01
        sta $2d12
        jsr _c2e973
        jsr _c2cfa4
        jsr _c2a698
        jsr _c2c0e2
        stz $7510
        lda $6f
        dec
        stz $6f
        stz $70
        jmp _c2a47c

; ---------------------------------------------------------------------------

_c2b521:
_b521:  lda $6f
        beq @b528
        jmp @b56d
@b528:  lda $55
        sta $6f
        longa
        and #$00ff
        dec
        asl3
        tax
        lda $0292,x
        and #$fe00
        sta $0290,x
        sta $0296,x
        lda $0290,x
        sta $0240
        lda $0294,x
        sta $0244
        lda #$0b8c
        sta $0246
        shorta
        jsr _c2faf0
        stz $751e
        stz $751d
        lda #$01
        sta $750f
        jmp _c2a4f0
@b56d:  lda $55
        sta $70
        lda #$01
        sta $2d11
        stz $750f
        stz $751e
        longa
        jsr _c2d503
        jsr _c2e464
        lda $6f
        and #$00ff
        dec
        tax
        lda $7a00,x
        and #$001f
        sta $d8
        jsr _c2e47d
        ldy $80
        lda $dc
        sta $053b,y
        shorta
        lda $da
        sta $053a,y
        lda $d8
        sta $0501,y
        longa
        jsr _c2cdc6
        jsr _c2d45f
        jsr _c2d298
        longa
        stz $6f
        stz $0240
        stz $0242
        stz $0244
        stz $0246
        lda $7e
        jsr _c2b3d8
        jsr _c2cde3     ; init job sprites
        jsr _c2cd57
        jsr _c2fad4     ; copy sprite data to vram
        jsr _c2faf0
        jsr _c2e66f
        stz $ca
        jsr _c2a698
        jsr _c2daa4
        phx
        ldx $7e
        inc $0420,x
        plx
        jsr _c2eb82
        lda $6f
        bne @b637
        lda $45
        bpl @b5f9
        and #$01
        beq @b5f9
        jmp _c2a4f0
@b5f9:  lda $2d11
        bne @b606
        jsr _c2b2bd
        lda #$01
        jmp _c2a06b
@b606:  ldx $7e
        lda $08f3,x
        beq @b62f
        longa
        lda #$2b
        lda $c1b820
        jsr _c2a693
        lda #$02
        tsb $7500
        lda #$04
        tsb $ca
        ldx #$0028
        jsr _c2e65b
        jsr _c2b2bd
        lda #$02
        jmp _c2a06b
@b62f:  jsr _c2b676
        lda #$04
        jmp _c2a06b
@b637:  stz $750f
        stz $750e
        longa
        stz $0242
        stz $0246
        lda $6f
        and #$00ff
        dec
        tay
        lda $7a00,y
        and #$00ff
        tax
        lda $c0ee6a,x
        and #$00ff
        ora #$0b00
        pha
        tya
        asl3
        tay
        pla
        sta $0292,y
        clc
        adc #$0020
        sta $0296,y
        jsr _c2fad4     ; copy sprite data to vram
        stz $6f
        jmp $a4f0
        php
        shorta
        lda $0973
        and #$01
        longa
        bne @b687
        lda #$aec8
        bra @b68a
@b687:  lda #$aed9
@b68a:  jsr _c2c1b8
        jsr _c2a693
        lda #$0c02
        brk $75
        lda #$0404
        dex
        jsr _c2e658
        jsr _c2b2bd
        jsr _c2daa4
        ldx $7e
        inc $0420,x
        jsr _c2e6d6
        lda $0973
        and #$d001
        asl $20
        lda $20fa
        adc #$28f8
        rts
        lda $74
        cmp #$f003
        ora [$c9]
        tsb $f0
        bmi @b710
        beq @b66a
        lda $55
        sta $6f
        stz $70
        jsr _c2e178
        jsr _c2e211
        lda $73
        jsr _c2e286
        lda $90
        beq @b6e0
        jsr _c2e0c0     ; play sound effect (error)
        bra @b6e8
@b6e0:  lda #$eb01
        lda $73
        jsr _c2e2ce
@b6e8:  jsr _c2e18f
        jsr _c2b7a0
        stz $6f
        jmp _c2a4f0
        lda $55
        sta $6f
        stz $70
        lda $6f
        cmp #$1003
        ora $20
        sta [$ed]
        bra @b707
        jsr _c2ed5e
@b707:  ldx $75
        beq @b745
        jsr _c2e66f
        jsr _c2ee94
        longa
        lda $75
        sec
        sbc #$0009
        bpl @b71e
        lda #$0000
@b71e:  sta $6d
        sta $6b
        jsr _c2caa5
        lda $6f
        and #$00ff
        dec
        jsr _c2c0c0
        lda $0204
        sta $0208
        lda $0206
        sta $020a
        jsr _c2c0e2
        jsr _c2a69d
        lda #$0a
        jmp _c2a47c
@b745:  jsr _c2e0c0
        jmp _c2a4f0
        stz $6f
        lda #$05
        jmp _c2a47c
        lda $55
        sta $74
        cmp #$04
        beq @b76c
        cmp #$03
        beq @b76a
        cmp #$02
        beq @b771
        cmp #$01
        beq @b77c
        cmp #$05
        beq @b769
@b76a:  beq @b791
@b76c:  lda #$00
        jmp _c2a47c
        jsr _c2daa4
        jsr _c2e66f
        jsr _c2b7a0
        bra @b791
@b77c:  jsr _c2daa4
        jsr _c2e66f
        jsr _c2faad
        jsr _c2e66f
        jsr _c2f869
        jsr _c2e66f
        jsr _c2b7a0
@b791:  lda #$05
        jmp _c2a47c
        jsr _c2b2bd
        stz $74
        lda #$01
        jmp _c2a06b
@b7a0:  jsr _c2e76c
        jsr _c2cac8
        jsr _c2cc9e
        jsr _c2a698
        rts
        jsr _c2e0f7
        lda $90
        bne @b7f6
        jsr _c2e286
        lda $90
        bne @b7f6
        jsr _c2e178
        jsr _c2e211
        lda #$01
        xba
        lda $73
        jsr _c2e2ce
        jsr _c2e1a6
        lda #$eb01
        lda $72
        jsr _c2e328
        jsr _c2e18f
        longa
        lda #$b005
        jsr _c2c1b8
        jsr _c2b7a0
        stz $2d11
        stz $2d12
        stz $70
        stz $73
        stz $72
        lda $6f
        dec
        and #$4c07
        jmp ($20a4,x)
        cpy #$4ce0
        beq @b7a0
        longa
        lda #$b005
        jsr _c2c1b8
        jsr _c2a698
        stz $70
        lda $6f
        dec
        and #$4c07
        jmp ($a5a4,x)
        adc ($1a),y
        and #$8503
        adc ($85),y
        ror $7f64,x
        jsr $d4c5
        ldx $80
        lda $0500,x
        and #$d040
        sbc #$20c2
        lda #$b095
        jsr _c2c1b8
        lda #$b0d3
        jsr _c2c1b8
        jsr _c2c8a0
        jsr _c2fad4     ; copy sprite data to vram
        jsr _c2a698
        jsr _c2a69d
        jmp _c2a4f0
        jsr _c2b2bd
        lda #$4c01
        rtl

        ldy #$55a5
        cmp #$f001
        phd
        cmp #$f001
        phd
        cmp #$f002
        clc
        cmp #$f003
        asl $f04c,x
        ldy $9c
        tsb $28
        lda $2802
        bmi @b86a
        lda #$8003
        cop $a9
        bpl @b8b9
        jmp ($a9a4,x)
        bra @b7ff
        tsb $28
        lda #$4c18
        jmp ($4ca4,x)
        and $a5a0
        eor $3a,x
        sta $2807
        stz $2808
        ldx $2807
        lda $2826,x
        sta $2809
        lda $287e,x
        sta $2810
        longa
        txa
        asl
        tax
        asl
        tay
        lda $284e,x
        sta $280a
        lda $282e,y
        sta $280c
        lda $2830,y
        sta $280e
        rts
        jsr $b87c
        jsr _c2f070
        shorta
        lda $2813
@b8b9:  beq @b8d0
        ldx #$2815
        ldy #$2819
        jsr _c2eec8
        bcc @b8dc
        bit $2805
        bmi @b8fd
        lda #$0b
        jmp _c2a47c
@b8d0:  jsr _c2e0c0     ; play sound effect (error)
        lda #$03
        jsr _c2eee7
        lda #$01
        bra @b8f2
@b8dc:  jsr _c2e0c0     ; play sound effect (error)
        lda #$02
        jsr _c2eee7
        lda $2801
        cmp #$03
        bne @b8f0
        jsr _c2e658
        bra @b8f5
@b8f0:  lda #$00
@b8f2:  jsr _c2eefd
@b8f5:  lda #$00
        jsr _c2eee7
        jmp _c2a4f0
@b8fd:  lda #$01
        sta $39
        jsr _c2b922
        jsr _c2e0c0     ; play sound effect (error)
        longa
        lda #$b349
        jsr _c2c1b8
        jsr _c2a698
        lda #$2000
        sbc $20ee,x
        cli
        inc $4c
        and $a9a0
        brk $4c
        jmp ($ada4,x)
        ora $8d28,x
        ora $28,x
        sta $0947
        lda $281e
        sta $2816
        sta $0948
        lda $281f
        sta $2817
        sta $0949
        lda $2814
        xba
        lda $2809
        jsr _c2e2ce
        rts
@b948:  lda #$0001
        jsr _c2eee7
        lda #$0038
        jsr _c2e0d9     ; play sound effect
        rts
        ldx #$2815
        ldy #$2819
        jsr _c2eec8
        bcc @b97e
        jsr _c2b922
        longa
        ldx #$51e8
        ldy #$2815
        lda #$7e73
        jsr _c2e4ed
        jsr _c2b948
        jsr _c2e658
        shorta
        lda #$03
        jmp _c2a47c
@b97e:  jsr _c2e0c0     ; play sound effect (error)
        lda #$02
        jsr _c2eee7
        lda #$00
        jsr _c2eefd
        lda #$00
        jsr _c2eee7
        jmp _c2a4f0
        lda #$03
        jmp _c2a47c
        jsr _c2b87c
        jsr _c2f03e
        shorta
        lda $2811
        bne @b9e1
        ldx #$2815
        ldy #$2819
        jsr _c2eec8
        bcc @b9ee
        lda $281d
        sta $2815
        sta $0947
        lda $281e
        sta $2816
        sta $0948
        lda $281f
        sta $2817
@b9c8:  sta $0949
        jsr _c2efe3
        longa
        ldx #$51e8
        ldy #$2815
        lda #$7e73
        jsr _c2e4ed
        jsr @b948
        bra @b9f9
@b9e1:  longa
        jsr _c2e0c0     ; play sound effect (error)
        lda #$006
        jsr _c2eee7
        bra @b9f9
@b9ee:  longa
        jsr _c2e0c0     ; play sound effect (error)
        lda #$0002
        jsr _c2eee7
@b9f9:  jsr _c2e658
        lda #$0000
        jsr _c2eee7
        jmp _c2a4f0
        lda #$4c00
        jmp ($64a4,x)
        adc $a97064
        brk $8d
        bit #$a528
        eor $c9,x
        ora ($f0,x)
        phd
        cmp #$f003
        inc
        cmp #$f004
        and $4c,s
        beq @b9c8
        lda $0973
        and #$d004
        tsb $a9
        tsb $80
        ora $a5
        tcd
        clc
        adc #$4c04
        jmp ($c2a4,x)
        jsr $0220
        cpx #$0e20
        ldy $00a9
        jmp _c2a47c
        longa
        lda #$b3b4
        jsr _c2c1b8
        lda #$b360
        jsr _c2c1b8
        jsr _c2c73d
        jsr _c2a69d
        jsr _c1a698
        lda #$8d01
        ora $2d,x
        jmp _c2a4f0
        lda $2d15
        beq @ba75
        stz $2d15
        longa
        jsr _c2ac0e
        lda #$4c00
        jmp ($20a4,x)
        lda $a9b2,x
        ora ($4c,x)
        rtl
        ldy #$89ad
        plp
        bne @baa1
        longa
        lda $55
        and #$00ff
        dec
        clc
        adc $6b
        shorta
        sta $6f
        lda $53
        jsr _c2c0c9
        lda #$01
        sta $7510
        sta $2889
        jmp _c2a4f0
@baa1:  longa
        lda $55
        and #$00ff
        dec
        clc
        adc $6b
        shorta
        sta $70
        cmp $6f
        beq @baf8
        longa
        lda $6f
        and #$00ff
        tax
        lda $70
        and #$00ff
        tay
        shorta
        lda $0640,x
        xba
        lda $0640,y
        sta $0640,x
        xba
        sta $0640,y
        lda $0740,x
        xba
        lda $0740,y
        sta $0740,x
        xba
        sta $0740,y
        stz $7510
        jsr _c2c0e2
        jsr _c2c7bd
        jsr _c2a69d
        stz $6f
        stz $70
        stz $2889
        lda $53
        jmp _c2a47c
@baf8:  longa
        lda $70
        and #$00ff
        tax
        shorta
        lda $7a00,x
        sta $29e7
        phx
        jsr _c2dada
        plx
        lda $29e7
        bne @bb15
@bb12:  jmp _c2bbac
@bb15:  lda #$40
        sta $29e6
        lda $7b00,x
        bmi @bb12
        beq @bb12
        cmp #$64
        bpl @bb12
        sta $29e8
        stz $29e9
        lda $29e7
        cmp #$f0
        beq @bb90
        cmp #$f1
        beq @bb90
        longa
        and #$00ff
        cmp #$00f8
        bmi @bb47
        cmp #$00fc
        bpl @bb47
        bra @bb66
@bb47:  asl
        tax
        lda $d000,x
        tax
        ldy #$29f3
        lda #$0007
        mvn $7e,$d1
        shorta
        lda $55
        dec
        sta $5b
        lda $6b
        sta $5c
        lda #$1c
        jmp _c2a47c

        .a16
_bb66:  and #$00ff
        sec
        sbc #$00f8      ; subtract 248 from item index
        tax
        lda $c0eeae,x   ; spells learned from items (ifrit, ramuh, shoat, golem)
        jsr _c2f00b     ; give spell
        lda $c0eeb2,x   ; sound effect to play
        jsr _c2e0d9     ; play sound effect
        lda $29e7
        and #$00ff
        ora #$0100
        jsr _c2e328
        jsr _c2c7bd
        jsr _c2a69d
        bra @bbeb
@bb90:  sta $39
        stz $3a
        bit $44
        bpl @bba6
        longa
        and #$00ff
        ora #$0100
        jsr _c2e328
        jmp _c2a02d     ; exit menu
@bba6:  stz $39
        stz $3a
        bra @bbeb
        lda $7a00,x
        longa
        and #$00ff
        beq @bbeb
        cmp #$00e0
        bpl @bbeb
        sta $2d1b
        jsr _c2d9ab
        lda $9d
        and #$003f
        asl2
        tax
        lda $d12480,x   ; item equipment
        sta $2d1d
        lda $d12482,x
        sta $2d1f
        stz $6f
        jsr _c2c0e2
        shorta
        stz $2889
        lda $55
        dec
        sta $5b
        lda #$22
        jmp _c2a47c
@bbeb:  shorta
        stz $6f
        stz $70
        stz $2889
        jsr _c2c0e2
        jmp _c2a4f0
        lda $2889
        bne _c2bc14
        stz $6f
        stz $70
        stz $2889
        lda $55
        dec
        sta $5b
        lda $6b
        sta $5c
        lda #$00
        jmp _c2a47c
        stz $6f
        stz $70
        stz $2889
        stz $7510
        jsr _c2c0e2
        jsr _c2fad4     ; copy sprite data to vram
        jmp _c2a4f0
        jmp _c2a4f0
        jmp _c2a4f0
        ldx $7e
        lda $53
        sta $63,x
        lda $55
        dec
        sta $29e2
        longa
        and #$0007
        tax
        lda $c0f3a4,x
        shorta
        jmp _c2a47c
        jsr _c2b2bd
        lda #$00
        xba
        lda $71
        tax
        ;da $53
        sta $63,x
        lda $71
        tax
        lda $53
        sta $63,x
        lda $71
        sta $5d
        lda #$01
        jmp _c2a06b     ; show menu
        longa
        lda $55
        and #$00ff
        dec
        tax
        lda $7a00,x
        and #$00ff
        tax
        shorta
        bit $29fb,x
        bvc @bca9
        sta $29e7
        lda $29fb,x
        sta $29e6
        lda $2a9d,x
        sta $29e8
        stz $29e9
        lda $29e7
        cmp #$3e
        beq @bcb1
        longa
        txa
        asl3
        clc
        adc #$0b80
        tax
        ldy #$29f3
        lda #$0007
        mvn $7e,$d1
        shorta
        lda #$1f
        jmp _c2a47c
@bca9:  stz $39
        jsr _c2e0c0     ; play sound effect (error)
        jmp _c2a4f0
@bcb1:  sta $39
        lda $44
        and #$02
        beq @bca9
        stz $3a
        longa
        lda $71
        and #$000f
        sta $7e
        jsr _c2d4c5
        ldy $80
        lda $050a,y
        sec
        sbc $29e8
        sta $050a,y
        sta $29df
        jmp _c2a02d     ; exit menu
        ldx $7e
        lda $63,x
        jmp _c2a47c

; ---------------------------------------------------------------------------

; [  ]

_c2bce0:
_bce0:  longa
        lda $55
        and #$00ff
        dec
        clc
        adc $6b
        tax
        shorta
        lda $7a00,x     ; item index
        beq @bd37       ; branch if no item
        sta $2809
        lda $288a,x
        sta $2810
        lda $53
        sta $2806
        stz $2825
        jsr _c2f29f     ; get item price
        bit $280a
        bmi @bd37       ; branch if item can't be sold
        bvc @bd1c       ; branch if item doesn't sell for 5gp
        lda #$0a
        sta $280c       ; price is 10gp
        stz $280d
        stz $280e
        stz $280f
@bd1c:  longa
        lsr $280e       ; divide price by 2
        ror $280c
        jsr _c2f070
        shorta
        lda $2811
        sta $2813
        stz $2886
        lda #$32
        jmp _c2a47c
@bd37:  jsr _c2e0c0     ; play sound effect (error)
        jmp _c2a4f0

; ---------------------------------------------------------------------------

; [  ]

_c2bd3d:
_bd3d:  lda $53
        sta $2806
        lda #$00
        jmp _c2a47c
        lda $55
        cmp #$05
        bpl _c2bd72
        dec
        sta $6f
        lda $53
        sta $62
        jsr @bda5
        beq @bd64
        jsr _c2bef7     ; save sram
        jsr _c2b2bd
        lda #$0b
        jmp _c2a06b     ; show menu
@bd64:  shorta
        lda $53
        sta $62
        stz $2d13
        lda #$04
        jmp _c2a47c
        cmp #$09
        beq @bd90
        dec
        and #$03
        sta $6f
        jsr @bda5
        bne @bd9f
        shorta
        lda $53
        sta $62
        lda #$01
        sta $2d13
        lda #$05
        jmp _c2a47c
@bd90:  stz $62
        longa
        stz $39
        jsr _c2a1f0     ; init config settings
        jsr _c2ff7d     ; update joypad config
        jmp _c2a02d     ; exit menu
@bd9f:  jsr _c2e0c0     ; play sound effect (error)
        jmp _c2a4f0
@bda5:  longa
        and #$0003
        asl5
        tax
        lda $7e2c14,x
        rts

_c2bdb5:
        lda $43         ; menu state
        cmp #$0c
        bne @bdbe
        jmp _c2a4f0
@bdbe:  jsr _c2b2bd
        lda #$01
        jmp _c2a06b

_c2bdc6:
        lda $55
        cmp #$03
        beq @bddb
        dec
        sta $2b65
        jsr _c2c4da
        jsr _c2a69d
        lda #$03
        jmp _c2a47c
@bddb:  ldx $8e
@bddd:  lda $0990,x
        cmp #$ff
        bne @bdf0
        inx
        cpx #$0006
        bne @bddd
        jsr _c2e0c0       ; play sound effect (error)
        jmp _c2a4f0

@bdf0:  jmp _c2a02d     ; exit menu
        jmp _c2a4f0
        longa
        lda $55
        and #$00ff
        dec
        tax
        shorta
        jsr _c2c51d
        cmp #$ff
        beq @be2b
        ldy $29b2
        sta $0990,y
        cpy #$0005
        bpl @be14
        iny
@be14:  sty $2b92
        jsr _c2c551
        longa
        ldx #$51c4
        ldy #$0990      ; butz's name
        lda #$0006
        jsr _c2e59d
        jsr _c2a698
@be2b:  jmp _c2a4f0

; ---------------------------------------------------------------------------

_c2be2e:
_be2e:  ldx $2b92
        lda $0990,x
        cmp #$f0ff
        ora [$a9]
        sbc $09909d,x
        bra @be4a
        cpx #$0000
        beq @be4a
        dex
        lda #$9dff
        bcc $be53
@be4a:  stx $2b92
        jsr _c2c551
        longa
        ldx #$51c4
        ldy #$0990
        lda #$0006
        jsr _c2e59d
        jsr _c2a698
        jmp _c2a4f0
        longa
        lda $2815
        clc
        adc $2819
        sta $2815
        lda $2817
        adc $281b
        sta $2817
        shorta
        ldx #$2821
        ldy #$2815
        jsr _c2eec8
        bcs @be94
        longa
        lda $2821
        sta $2815
        lda $2823
        sta $2817
@be94:  shorta
        lda $2814
        xba
        lda $2809
        jsr _c2e328
        longa
        ldx #$51e8
        ldy #$2815
        lda #$7e73
        jsr _c2e4ed
        lda $2815
        sta $0947
        lda $2817
        sta $0949
        jsr _c2b948
        jsr _c2e658
        lda #$0000
        jsr _c2eee7
        shorta
        lda #$18
        jmp _c2a47c
        lda $55
        cmp #$01
        beq @beda
        cmp #$02
        beq @bef1
        jmp _c2a4f0
@beda:  ldy $8e
        lda $2b9a,y
        beq @beeb
        xba
        lda $2ba2,y
        beq @beeb
        xba
        jsr _c2e2ce
@beeb:  iny
        cpy #$0008
@bef1:  jmp _c2a02d     ; exit menu
        jmp _c2a4f0

; ---------------------------------------------------------------------------

; [ save sram ]

_c2bef7:
_bef7:  php
        longa
        inc $09c2
        jsr _c2bf7d     ; get pointer to save slot in sram
        phx
        tay
        ldx #$0500      ; copy $0600 bytes from 00/0500
        lda #$05ff
        phb
        phy
        mvn $30,$00     ; save sram
        ply
        plb
        sty $fc
        jsr _c2f588
        plx
        sta $307ff0,x
        lda #$e41b
        sta $307ff8,x
        lda $6f
        and #$0003
        sta $307fe0
        jsr _c2e0c8
        plp
        rts

; ---------------------------------------------------------------------------

; [ load sram ]

_c2bf2e:
_bf2e:  lda $55
        cmp #$01
        beq @bf37
        jmp _c2bf37
@bf37:  lda $2d13
        bne @bf47
        jsr _c2bef7     ; save sram
        jsr _c2b2bd
        lda #$0b
        jmp _c2a06b     ; show menu
@bf47:  jsr _c2a1f0     ; init config settings
        lda $094a
        pha
        php
        longa
        jsr _c2bf7d     ; get pointer to save slot in sram
        tax
        ldy #$0500
        lda #$05ff
        phb
        mvn $00,$30     ; load sram
        plb
        plp
        pla
        clc
        adc $0af9       ; update random
        sta $0af9
        lda $6f
        sta $62
        longa
        lda #$0001
        sta $39
        jsr _c2ff7d     ; update joypad config
        jsr _c2f5a9     ; update mono/stereo setting
        jmp _c2a02d     ; exit menu

; ---------------------------------------------------------------------------

; [ get pointer to save slot in sram ]

_c2bf7d:
_bf7d:  lda $6f
        and #$0003      ; save slot
        asl
        tax
        lda $c0f8ef,x   ; pointer to save slot in sram
        rts

; ---------------------------------------------------------------------------

_c2bf89:
_bf89:  jsr _c2d447     ; update window color
        jsr _c2b2bd
        lda $2d13
        bne @bf98
        lda #$0b
        bra @bf9a
@bf98:  lda #$0c
@bf9a:  jmp _c2a06b     ; show menu

; ---------------------------------------------------------------------------

_c2bf9d:
_bf9d:  jsr _c2dc1b
        longa
        lda $71
        and #$000f
        sta $7e
        jsr _c2d4c5
        jsr _c2c6ba
        shorta
        jsr _c2af1b
        jsr _c2a698
        ldx #$0005
        jsr _c2e65b
        longa
        lda $29df
        cmp $29e8
        bmi @bfca
        jmp _c2a4f0
@bfca:  jsr _c2e653
        shorta
        lda #$07
        jmp _c2a47c
        jsr _c2daef
        jsr _c2c7bd
        jsr _c2a69d
        jsr _c2af1b
        jsr _c2a698
        ldx #$0005
        jsr _c2e65b
        lda $29e8
        beq @bff1
        jmp _c2a4f0
@bff1:  jsr _c2e653
        stz $6f
        stz $70
        stz $2889
        lda $5b
        clc
        adc #$04
        jmp _c2a47c
        lda $55
        cmp #$05
        beq @c01c
        sta $71
        longa
        and #$00ff
        dec
        asl2
        clc
        adc #$0021
        shorta
        jmp _c2a47c
@c01c:  longa
@c01e:  ldx #$f352
        ldy #$2cb4
        lda #$000f
        mvn $7e,$c0
        stz $6f
        jsr _c2c0ed
        ldx $8e
@c031:  inc $0420,x
        inx
        cpx #$0004
        bne @c031
        stz $71
        lda #$4c1b
        jmp ($a9a4,x)
        ora $4c,s
        jmp ($a9a4,x)
        brk $eb
        lda $55
        dec
        tax
        lda $2c9c,x
        beq @c05b
        lda $c0f069,x
        beq @c05b
        jmp _c2a47c
@c05b:  jmp _c2a4f0
        jsr _c2f71c     ; update config settings
        jsr _c2b2bd
        lda #$4c01
        rtl
        ldy #$f04c
        ldy $49
        ora #$7c4c
        ldy $a5
        eor $c9,x
        ora ($f0,x)
        ora $4c,s
        beq @c01e
        ldx $8e
        txa
@c07d:  ora $2ca9,x
        inx
        cpx #$0007
        bmi @c07d
        and #$c9fc
        jsr ($0bd0,x)
        jsr _c2f71c     ; update config settings
        jsr _c2ff7d     ; update joypad config
        lda #$4c08
        jmp ($20a4,x)
        cpy #$c2e0
        jsr _c2d2a9
        lda [$20],y
        clv
        cmp ($20,x)
        sta ($a6,s),y
        jsr _c2a16e     ; reset sprite data
        jsr _c2fad4     ; copy sprite data to vram
        ldx #$0078
        jsr _c2e65b
        longa
        jsr _c2b19a
        shorta
        lda $53
        jmp _c2a47c
        jmp _c2a4f0

; ---------------------------------------------------------------------------

; [  ]

_c2c0c0:
_c0c0:  ldy $8e
        bra @c0cc
        ldy #$fc04
        bra @c0cc
        ldy #$ff02
@c0cc:  jsr $e4e1       ; get pointer to cursor data
        php
        longa
        tya
        clc
        adc $7602,x
        sta $0204
        lda #$2e02
        sta $0206
        plp
        rts

; ---------------------------------------------------------------------------

; [  ]

_c2c0e2:
_c0e2:  php
        longa
        stz $0204
        stz $0206
        plp
        rts
        jsr _c2f5c0
        jsr _c2a693
        jsr _c2e66f
        rts
        lda $6f
        bne @c10c
        lda #$01
        sta $7510
        lda $55
        sta $6f
        lda $53
        jsr _c2c0c9
@c109:  jmp _c2a4f0
@c10c:  lda $55
        cmp $6f
        beq @c109
        dec
        longa
        and #$000f
        tax
        lda $6f
        dec
        and #$000f
        tay
        shorta
        lda $2cb4,x
        xba
        lda $2cb4,y
        sta $2cb4,x
        xba
        sta $2cb4,y
        stz $7510
        jsr _c2c0ed
        longa
        lda $71
        and #$000f
        dec
        tax
        shorta
        inc $0420,x
        bra @c155
        lda $6f
        bne @c155
        lda $71
        dec
        and #$03
        clc
        adc #$1b
        jmp _c2a47c
@c155:  longa
        stz $6f
        jsr _c2c0e2
        jsr _c2fad4     ; copy sprite data to vram
        jmp _c2a4f0

; ---------------------------------------------------------------------------

_c2c162:
_c162:  lda $5b
        clc
        adc #$04
        jmp _c2a47c

; ---------------------------------------------------------------------------

; [  ]

_c2c16a:
_c16a:  phb
        lda $43         ; menu state
        and #$00ff
        dec
        asl
        tax
        lda $c0f5e7,x   ; pointer to ??? ($+C00000)
        tax
        ldy #$2bdc      ; copy 24 bytes to 7E/BD2C
        lda #$0017
        mvn $7e,$c0
        ldx $8e
@c183:  lda $c0f5cf,x   ; mvn destination address (+$7E0000)
        sta $e6
        phx
        lda $c0e7e7,x   ; jump address
        sta $c7
        lda $2bdc,x     ; pointer to data
        per $c198
        jmp ($01c7)

; ---------------------------------------------------------------------------

_c2c199:
_c199:  plx
        inx2
        cpx #$0018
        bne @c183
        plb
        jsr _c2a18a
        rts

; ---------------------------------------------------------------------------

; [ load menu cursor/??? data ]

_c2c1a6:
_c1a6:  phb
        tax
        beq @c1b6
        ldy $e6         ; pointer to cursor data ($+7E0000)
        lda $c30000,x   ; length of cursor data
        dec
        inx2
        mvn $7e,$c3
@c1b6:  plb
        rts

; ---------------------------------------------------------------------------

; [ load menu tilemap ]

_c2c1b8:
_c1b8:  phb
        pea $c3c3
        plb
        plb
        tax
        beq @c1ed
        pea $c3c3
        plb
        plb
        lda $0000,x
        inx
        and #$000f
        beq @c1f5
        asl
        tay
        lda $ad31,y
        beq @c1de
        phy
        ldy #$01e0
        mvn $00,$c3
        ply
@c1de:  pea $7e7e
        plb
        plb
        phx
        php
        tyx
        jsr ($ffea,x)
        plp
        plx
        bra _c2c1c1
@c1ed:  pea $7e7e
        plb
        plb
        jsr _c2c25f
@c1f5:  plb
        rts

; ---------------------------------------------------------------------------

; [ load other menu data ??? ]

_c2c1f7:
_c1f7:  ldy $e6
        tax
        bne @c1fd
        rts
@c1fd:  phb
        php
        stz $85
@c201:  shorta
        lda $c30000,x
        beq @c23a
        beq @c221
@c20b:  sta $0000,y
        longa
        lda $85
        sta $0001,y
        clc
        adc #$0004
        sta $85
        iny3
        inx
        bra @c201
@c221:  pha
        lda #$7f
        sta $0000,y
        lda $85
        sta $0001,y
        lda #$00
        sta $0002,y
        iny3
        pla
        and #$1a7f
        bra @c20b
@c23a:  lda #$00
        sta $0000,y
        plp
        plb
        rts

; ---------------------------------------------------------------------------

; [  ]

_c2c242:
_c242:  pha
        php
        lda $e3
        and #$3f
        brk $eb
        lsr2
        sta $e8
        lda $e2
        and #$1f
        brk $0a
        clc
        adc $e8
        clc
        adc $e6
        sta $e8
        plp
        pla
        rts
        stz $e0
        lda $e0
        ldy #$1000
@c266:  dey2
        sta ($e6),y
        bne @c266
        rts
        lda $e0
        sta $e6
        rts
@c272:  sta $0000,x
        inx2
        dey
        bne @c272
        rts
@c27b:  dey2
        dec
        sta $0000,x
        inx2
        inc
        jsr _c2c272
        inc
        sta $0000,x
        rts
@c28c:  pha
        ldy $8e
@c28f:  lda $01,s
        sta ($ec),y
        txa
        sta ($ee),y
        dec $ea
        beq @c2a2
        tya
        clc
        adc #$40
        brk $a8
        bra @c28f
@c2a2:  pla
        rts
        jsr _c2c242
        lda $e5
        and #$ff
        brk $85
        nop
        ldx $e8
        lda $e4
        and #$7f
        brk $a8
        phx
        phy
        lda $e0
        jsr _c2c272
        ply
        plx
        dec $ea
        beq @c2cb
        txa
        clc
        adc #$40
        brk $aa
        bra @c2c2b6
@c2cb:  rts
        jsr _c2c2e8
        lda #$ff
        brk $85
        cpx #$20e2
        inc $e2
        inc $e3
        dec $e4
        dec $e4
        dec $e5
        dec $e5
        longa
        jsr _c2c2a4
        rts
        jsr _c2c242
        lda $e8
        tax
        clc
        adc #$0040
        sta $ec
        lda $e4
        and #$003f
        tay
        lda $e0
        jsr $c27b
        txa
        clc
        adc #$0040
        sta $ee
        lda $e5
        and #$007f
        dec2
        sta $ea
        lda #$0004
        ldx #$0005
        jsr @c28c
        tya
        clc
        adc #$0080
        adc $e8
        tax
        lda $e4
        and #$003f
        tay
        lda #$0007
        jsr @c27b
        rts
        jsr _c242
        lda $e0
        and #$00ff
        asl
        tax
        lda $c0f987,x
        tay
        ldx $e8
        lda $e4
        and #$00ff
        ora #$c000
        jsr $e59d
        rts

; ---------------------------------------------------------------------------

; [ menu state $08:  ]

_c2c34a:
_c34a:  jsr _c2f63d
        lda $8e
        sta $7e2c94
@c353:  jsr _c2f7a6
        lda $7e2c94
        inc
        sta $7e2c94
        cmp #$000a
        bne @c353
        jsr _c2f810
        shorta
        stz $53
        jsr _c2d210
        rts

; ---------------------------------------------------------------------------

; [ menu state $09:  ]

_c2c36f:
_c36f:  pea $7e7e
        plb
        plb
        shorta
        stz $53
        jsr _c2d210
        ldx #$0008
@c37e:  stz $2b99,x
        stz $2ba1,x
        stz $2ba9,x
        stz $2bb1,x
        dex
        bne @c37e
        ldy $8e
@c38f:  lda $013b,y
        beq @c3b1
        ldx $8e
@c396:  lda $2b9a,x
        beq @c3a8
        cmp $013b,y
        beq @c3ae
        inx
        cpx #$0008
        bne @c396
        bra @c3b1
@c3a8:  lda $013b,y
        sta $2b9a,x
@c3ae:  inc $2ba2,x
@c3b1:  iny
        cpy #$0008
        bne @c38f
        ldy $8e
@c3b9:  lda $2b9a,y
        beq @c3c8
        jsr _c2c419
        sta $2baa,y
        xba
        sta $2bb2,y
@c3c8:  iny
        cpy #$0008
        bne @c3b9
        jsr _c2c3d2
        rts
        phb
        php
        pea $7e7e
        plb
        plb
        shorta
        ldx #$5246
        stx $99
        ldx #$0008
        stx $85
        ldx $8e
        jsr _c2c3fd
        ldx #$5264
        stz $99
        ldx #$0008
        stx $85
        ldx #$0010
        jsr _c2c3fd
        plp
        plb
        rts
@c3fd:  lda $2b9a,x
        xba
        lda $2ba2,x
        xba
        php
        phx
        ldy $99
        jsr _c2e3a6
        longa
        jsr _c2cb8c
        plx
        plp
        inx
        dec $85
        bne @c3fd
        rts
        php
        ldx $8e
@c41c:  cmp $0640,x
        beq @c43b
        inx
        cpx #$0100
        bne @c41c
        ldx $8e
@c429:  lda $0640,x
        beq @c435
        inx
        cpx #$0100
        bne @c429
        dex
@c435:  longa
        lda $8e
        bra @c440
@c43b:  xba
        lda $0740,x
        xba
@c440:  plp
        rts

; ---------------------------------------------------------------------------

; [ menu state $0C:  ]

_c2c442:
_c442:  pea $7e7e
        plb
        plb
        shorta
        lda #$01
        sta $2b65
        stz $2b66
        stz $2b67
        lda #$0a
        sta $2b68
        sta $2b69
        lda #$80
        sta $2b6d
        stz $2b6e
        stz $2b6f
        stz $53
        jsr _c2d210
        jsr _c2c4da
        longa
        stz $2b92
        jsr _c2c551
        lda #$ffff
        sta $0990
        sta $0992
        sta $0994
        ldx #$51c4
        ldy #$0990
        lda #$0006
        jsr _c2e59d
        ldx #$ec07
        ldy #$2b70
        lda #$0009
        mvn $7e,$c0
        ldx #$ec11
        ldy #$2b80
        lda #$0009
        mvn $7e,$c0
        lda #$0018
        sta $2b6a
        ldx #$0080
@c4b3:  stz $79fe,x
        dex2
        bne @c4b3
        lda #$ffff
        sta $7a62
        stz $7e
@c4c2:  jsr _c2d4c5
        ldx $80
        lda $0500,x
        and #$0007
        beq @c4d3
        inc $7e
        bra @c4c2
@c4d3:  lda #$3c1c
        jsr _c2c8de
        rts
        phb
        php
        pea $7e7e
        plb
        plb
        shorta
        ldx #$6194
        stx $99
        longa
        ldx $8e
@c4ec:  ldy $8e
@c4ee:  jsr _c2c544
        cpy #$000a
        bne @c4ee
        lda #$00ff
        sta $2b3f,y
        iny
@c4fd:  jsr _c2c544
        cpy #$0015
        bmi @c4fd
        phx
        ldx $99
        ldy #$2b3f
        lda #$7e14
        jsr _c2e59d
        jsr _c2cb8c
        plx
        cpx #$0064
        bne @c4ec
        plp
        plb
        rts
        php
        longa
        lda $c0f414,x
        and #$00ff
        cmp #$0048
        beq @c53f
        cmp #$0053
        bmi @c53b
        cmp #$0060
        bmi @c53f
        cmp #$00c4
        bpl @c53f
@c53b:  clc
        adc $2b65
@c53f:  and #$00ff
        plp
        rts
        jsr _c2c51d
        ora #$00
        sbc $2b3f99,x
        iny2
        inx
        rts
        php
        phb
        longa
        lda #$b62b
        jsr _c2c1b8
        plb
        longa
        lda $2b92
        asl
        tax
        lda #$00e0
        sta $5204,x
        plp
        rts

; ---------------------------------------------------------------------------

; [ menu state $0B:  ]

_c2c56b:
_c56b:  phb
        php
        stz $39
        jsr _c2f4d4
        ldx $8e
@c574:  lda $7e2c14,x
        beq @c587
        txa
        clc
        adc #$0020
        tax
        cpx #$0080
        bne @c574
        bra @c599
@c587:  inc $39
        shorta
        lda $307fe0
        and #$03
        inc
        sta $53
        jsr _c2c59c
        stz $6f
@c599:  plp
        plb
        rts

; ---------------------------------------------------------------------------

_c2c59c:
_c59c:  jsr _c2d210
        jsr _c2f463
        jsr _c2f450
        jsr _c2f3f6
        jsr _c2f39c
        longa
        lda #$6000
        sta $e6
        lda #$ada6
        jsr _c2c1b8
        rts

; ---------------------------------------------------------------------------

; [ menu state $0A: collect items after battle ]

_c2c5b9:
_c5b9:  jsr _c2f4d4
        shorta
        lda $62
        sta $53
        jsr _c2c59c
        stz $6f
        rts

; ---------------------------------------------------------------------------

; [ menu state $07:  ]

_c2c5c8:
        .a16
_c5c8:  lda $71
        and #$0007
        sta $7e
        jsr _c2d4c5
        jsr _c2c6ba
        lda #$b434
        jsr _c2c1b8
        pea $7e7e
        plb
        plb
        ldx #$0950      ; known spells
        ldy #$29b8
        lda #$001f
        mvn $7e,$7e
        ldx $80
        ldy $8e
        shorta
@c5f2:  lda $053d,x     ; spell level
        pha
        and #$f0
        lsr4
        pha
        asl
        clc
        adc $01,s
        sta $29d8,y
        pla
        pla
        iny
        cpy #$0005
        beq @c61b
        and #$0f
        pha
        asl
        clc
        adc $01,s
        sta $29d8,y
        pla
        iny
        inx
        bra @c5f2
@c61b:  lda #$20
        sta $29d8,y
        lda #$08
        sta $29d9,y
        ldx #$00a2
@c628:  stz $29f9,x
        stz $2a9b,x
        dex
        bne @c628
        ldy $8e
@c633:  tya
        jsr _c2f01d
        and $29b8,x
        beq @c63e
        lda #$80
@c63e:  sta $29fb,y
        tya
        longa
        and #$00ff
        asl3
        tax
        shorta
        lda $d20b83,x
        and #$7f
        sta $2a9d,y
        lda $d10b80,x
        and #$c0
        lsr2
        ora $29fb,y
        sta $29fb,y
        iny
        cpy #$00a0
        bne @c633
        shorta
        stz $29e2
        stz $6f
        stz $70
        ldx $7e
        lda $0973
        and #$04
        bne @c682
        stz $63,x
        lda #$07
        sta $67,x
@c682:  lda $63,x
        sta $53
        jsr _c2d210
        lda #$03
        sta $2b68
        longa
        stz $2b6c
        stz $2b6e
        ldx #$ebfa
        ldy #$2b70
        lda #$0002
        mvn $7e,$c0
        ldx #$ebfd
        ldy #$2b80
        lda #$0009
        mvn $7e,$c0
        lda #$00c8
        sta $2b6a
        rts
        phb
        php
        longa
        ldx #$ef85
        lda #$0017
        jsr _c2da9d
        lda #$5000
        sta $2bba
        jsr _c2ddd7
        lda #$3012
        jsr _c2c8de
        ldx $80
        lda $050a,x
        sta $29df
        shorta
        lda $051a,x
        sta $29e1
        plp
        plb
        rts
        php
        longa
        ldy #$2ce5
        lda #$0005
        mvn $7e,$c0
        plp
        rts

; ---------------------------------------------------------------------------

; [ menu state $06: shop ]

_c2c6f7:
_c6f7:  shorta
        lda #$7e
        pha
        plb
        lda $0973
        and #$04
        bne @c708
        stz $5c
        stz $5b
@c708:  longa
        lda $5c
        and #$00ff
        sta $6b
        jsr _c2c7bd
        shorta
        lda $5b
        clc
        adc #$04
        sta $53
        jsr _c2d210
        stz $2d15
        stz $2887
        stz $2889
        lda #$02
        sta $29b6
        jsr _c2e367
        ldx #$e94e
        jsr _c2c6e9
        longa
        jsr _c2ac5e
        rts
        phb
        php
        pea $7e7e
        plb
        plb
        longa
        ldy $8e
        stz $85
@c74a:  phy
        tya
        shorta
        jsr _c2f01d
        and $0a4a,x
        beq @c776
        longa
        ldx $85
        lda $c0e974,x
        sec
        sbc #$00c2
        inx2
        stx $85
        tax
        tya
        asl3
        clc
        adc #$e500
        tay
        lda #$c008
        jsr _c2e59d
@c776:  ply
        iny
        cpy #$0020
        bne @c74a
        plp
        plb
        rts
@c780:  php
        ldx $8e
@c783:  shorta
        lda $7a00,x
        bne @c792
        stz $7b00,x
        stz $288a,x
        bra @c7b5
@c792:  phx
        longa
        and #$00ff
        pha
        jsr _c2d9ab
        pla
        cmp #$00e0
        shorta
        bmi @c7aa
        lda $9e
        and #$3f
        bra @c7b1
@c7aa:  lda $9f
        and #$3f
        clc
        adc #$00
@c7b1:  plx
        sta $288a,x
@c7b5:  inx
        cpx #$0100
        bne @c783
        plp
        rts
        phb
        php
        longa
        lda #$00ea
        sta $6d
        stz $6f
        ldx #$0640
        ldy #$7a00
        lda #$01ff
        mvn $7e,$7e
        jsr @c780
        ldx $8e
        lda $6b
        and #$00ff
        tay
        lda $c0ed8f,x
        phx
        phy
        tyx
        tay
        jsr _c2e3f3
        ply
        plx
        inx2
        iny
        cpx #$0030
        bne $c7df
        ldx #$f250
        ldy #$298a
        lda #$0015
        mvn $7e,$c0
        plp
        plb
        rts

; ---------------------------------------------------------------------------

; [ menu state $05:  ]

_c2c803:
_c803:  shorta
        lda #$7e
        pha
        plb
        lda $35
        sta $2800
        stz $39
        stz $2805
        lda $2800
        cmp #$3e
        beq @c81e
        cmp #$3f
        bne @c823
@c81e:  lda #$80
        sta $2805
@c823:  stz $2804
        jsr _c2f18f
        longa
        ldx $8e
@c82d:  stz $2807,x
        inx2
        cpx #$001e
        bne @c82d
        lda $0947
        sta $2815
        lda $0949
        and #$00ff
        sta $2817
        lda #$967f
        sta $2821
        lda #$0098
        sta $2823
        ldx #$51e8
        ldy #$2815
        lda #$7e73
        jsr _c2e4ed
        jsr _c2f15b
        shorta
        lda #$0b
        jsr _c2cfbd
        .a16
        shorta
        stz $5c
        stz $5b
        lda #$18
        sta $2806
        longa
        stz $6b
        stz $6f
        lda #$0003
        sta $29b6
        ldx #$e954
        jsr _c2c6e9
        ldy $8e
@c887:  sty $7e
        jsr _c2d4c5
        ldx $80
        lda $0500,x
        and #$1f07
        phy
        jsr _c2d492
        ply
        iny
        cpy #$0004
        bne @c887
        rts

; ---------------------------------------------------------------------------

; [ menu state $04:  ]

_c2c8a0:
_c8a0:  shorta
        lda #$0a
        jsr _c2cfbd
        .a16
        jsr _c2e76c
        jsr _c2c954
        ldy $80
        lda $051a,y
        and #$7f
        brk $f0
        ora $a9
        plp
        tsc
        bra @c8bf
        lda #$3c
        tsc
@c8bf:  jsr _c2c8de
        ldx $8e
        ldy $80
@c8c6:  phx
        phy
        lda $c0ee4b,x
        tax
        lda $0516,y
        jsr _c2d8e4
        ply
        plx
        iny
        inx2
        cpx #$0008
        bne @c8c6
        rts

; ---------------------------------------------------------------------------

; [  ]

_c2c8de:
_c8de:  phb
        php
        longa
        pha
        jsr _c2d0b2
        lda $7e
        asl
        tax
        lda $c0eb08,x
        tax
        phx
        ldy #$0348
        lda #$0007
        mvn $7e,$7e
        plx
        stz $0000,x
        stz $0002,x
        stz $0004,x
        stz $0006,x
        lda $0348
        clc
        adc $01,s
        sta $0348
        lda $034c
        clc
        adc $01,s
        sta $034c
        txa
        sec
        sbc #$0020
        tax
        lda $0002,x
        beq @c93d
        phx
        ldy #$0340
        lda #$0003
        mvn $7e,$7e
        plx
        lda $0340
        clc
        adc $01,s
        sta $0340
        stz $0000,x
        stz $0002,x
@c93d:  pla
        plp
        plb
        rts
        php
        lda $80
        clc
        adc #$00
        ora $aa
        ldy #$2700
        lda #$45
        brk $54
        ror $287e,x
        rts
        phb
        php
        longa
        ldx #$ef9d
        lda #$0017
        jsr _c2da9d
        lda #$5000
        sta $2bba
        jsr _c2ddd7
        jsr _c2c941
        lda $2702
        and #$00ff
        pha
        asl
        clc
        adc $01,s
        tax
        pla
        lda $2703
        sta $2746
        lda $2705
        and #$00ff
        sta $2748
        lda $d15000,x
        sec
        sbc $2746
        sta $2746
        lda $d15002,x
        and #$00ff
        sbc $2748
        sta $2748
        lda 2702
        and #$00ff
        cmp #$0063
        bmi @c9b2
        stz $2746
        stz $2748
@c9b2:  ldx $7e
        lda $08f3,x
        and #$00ff
        sta $274a
        ldx $8e
@c9bf:  phx
        lda $c0ee03,x
        tay
        lda $c0ee1b,x
        pha
        lda $c0ee33,x
        tax
        pla
        jsr _c2e4ed
        plx
        inx2
        cpx #$0018
        bne @c9bf
        lda $2702
        and #$00ff
        cmp #$0063
        bmi @c9f2
        ldx #$edf5
        ldy #$5510
        lda #$000d
        mvn $7e,$c0
@c9f2:  lda $2715
        and #$00ff
        cmp #$00ff
        beq @ca18
        pha
        lda #$b195
        jsr _c2c1b8
        pla
        asl3
        clc
        adc #$5c00      ; D0/5C00 (monster names)
        tay
        ldx #$56c8      ; copy 8 bytes to 7E/56C8
        lda #$d008
        jsr _c2e59d
        bra @ca34
@ca18:  lda #$b185
        jsr _c2c1b8
        lda $2740
        sta $f9
        lda $2742
        sta $fb
        ldy #$5686
        jsr _c2d802
        ldy #$56c6
        jsr _c2d7f6
@ca34:  plp
        plb
        rts

; ---------------------------------------------------------------------------

; [ menu state $03:  ]

_c2ca37:
_ca37:  lda $71
        sta $7e
        jsr _c2d4c5
        stz $6f
        stz $72
        shorta
        lda $2d12
        ora $2d11
        beq @ca57
        lda $0973
        and #$01
        bne @ca57
        lda #$06
        bra @ca59
@ca57:  lda #$05
@ca59:  sta $53
        jsr _c2e6ab     ; update cursor sprite
        longa
        lda #$b036
        jsr _c2c1b8
        lda #$1e98
        jsr _c2c8de
        ldy #$51ac
        jsr _c2d533
        ldy #$522c
        jsr _c2d554
        jsr _c2e76c
        jsr _c2cac8
        jsr _c2cc9e
        ldy #$52ae
        jsr _c2d7ca
        longa
        stz $6b
        lda #$00f6
        sta $6d
        longa
        ldx #$f2d4
        ldy #$298a
        lda #$0015
        mvn $7e,$c0
        lda #$0001
        sta $29b6
        rts

; ---------------------------------------------------------------------------

; [  ]

_c2caa5:
_caa5:  phb
        php
        pea $7e7e
        plb
        plb
        longa
        ldx $8e
        lda #$63c4
        sta $99
@cab5:  phx
        ldy $99
        jsr _c2cb8c
        jsr _c2e3e3
        plx
        inx
        cpx #$000a
        bne @cab5
        plp
        plb
        rts

; ---------------------------------------------------------------------------

; [  ]

_c2cac8:
_cac8:  phb
        php
        longa
        stz $2cdf
        stz $2ce1
        lda #$0001
        sta $2ce3
        ldx $80
        shorta
        ldy $8e
        lda #$20
        and $0521,x
        beq @caeb
        lda #$91
        sta $2cdf,y
        iny
@caeb:  lda #$01
        and $0521,x
        beq @caf7
        lda #$92
        sta $2cdf,y
@caf7:  ldx $80
        lda $0513,x
        bne @cb04
        lda $0511,x
        jsr _c2cbf1
@cb04:  sta $f0
        lda $0514,x
        bne @cb11
        lda $0512,x
        jsr _c2cbf1
@cb11:  sta $f1
        lda $050e,x
        jsr _c2cbf1
        sta $f2
        lda $050f,x
        jsr _c2cbf1
        sta $f3
        lda $0510,x
        jsr _c2cbf1
        sta $f4
        lda $f0
        bne @cb35
        lda $f1
        beq @cb6b
        bra @cb39
@cb35:  lda $f1
        bne @cb6b
@cb39:  lda $f0
        ora $f1
        jsr _c2d9ab
        lda $9f
        bit #$80
        bne @cb53
        bit #$40
        beq @cb6b
        lda $80
        lda $0521,x
        and #$20
        beq @cb6b
@cb53:  lda $f0
        beq @cb61
        lda #$02
        sta $2ce1
        inc $2ce4
        bra @cb6b
@cb61:  lda #$02
        sta $2ce3
        inc $2ce2
        bra @cb6b
@cb6b:  longa
        ldx $8e
        lda #$5192
        sta $99
@cb74:  phx
        ldy $99
        jsr _c2cb8c
        lda $f0,x
        jsr _c2e44e
        plx
        inx
        cpx #$0005
        bne @cb74
        jsr _c2cb95
        plp
        plb
        rts

; ---------------------------------------------------------------------------

; [  ]

_c2cb8c:
_cb8c:  lda $99
        clc
        adc #$80
        brk $85
        sta $c260,y
        jsr _c2dfad
        bit $ff29
        brk $f0
        asl $a2
        plp
        eor ($20,s),y
        sbc ($cb,x)
        lda $2ce0
        and #$ff
        brk $f0
        asl $a2
        tay
        eor ($20,s),y
        sbc ($cb,x)
        ldx $8e
@cbb5:  phx
        lda $c0ea44,x
        sta $e6
        lda $2ce1,x
        pha
        and #$0f
        brk $0a
        tax
        lda $c0ea3e,x
        jsr _c2c1b8
        pla
        and #$00
        sbc $000409,x
        ldx $e6
        jsr _c2d6dc
        plx
        inx2
        cpx #$0004
        bne @cbb5
        rts
        phx
        asl
        tax
        lda $7ed600,x
        tay
        plx
        lda #$08
        cmp ($20),y
        sta $60e5,x
        cmp #$80
        bne @cbf7
        lda #$00
@cbf7:  rts
        phb
        php
        lda $f1
        sta $2723
        lda $f2
        sta $272c
        lda $f3
        sta $272d
        lda $f5
        sta $272f
        longa
        lda $eb
        sta $2728
        lda $ed
        sta $272a
        lda $f6
        sta $2744
        ldx $8e
@cc21:  phx
        lda $c0ee09,x
        sta $f6
        tay
        lda $c0edbf,x
        sta $fe
        lda $c0ee21,x
        sta $f8
        lsr4
        and #$000f
        sta $fc
        lda $c0ede3,x
        sta $fa
        tax
        lda $f8
        jsr _c2e4ed
        lda $fe
        clc
        adc $80
        tax
        lda $01,s
        tay
        lda $0000,x
        cpy #$0008
        beq @cc5e
        and #$00ff
@cc5e:  and #$01ff
        sta $fe
        ldy $f6
        lda $01,s
        tax
        lda $0000,y
        cpx #$0008
        beq @cc73
        and #$00ff
@cc73:  and #$01ff
        cmp $fe
        beq @cc93
        bpl @cc81
        lda #$8100
        bra @cc84
@cc81:  lda #$8200
@cc84:  cpx #$0010
        bne @cc8c
        eor #$0300
@cc8c:  ora $fc
        ldx $fa
        jsr _c2d6dc
@cc93:  plx
        inx2
        cpx #$0012
        bne @cc21
        plp
        plb
        rts
        php
        phb
        pea $7e7e
        plb
        plb
        longa
        jsr _c2c941
        ldx $8e
@ccac:  phx
        lda $c0ee09,x
        tay
        lda $c0ee21,x
        pha
        lda $c0edd1,x
        tax
        pla
        jsr _c2e4ed
        plx
        inx2
        cpx #$0012
        bne @ccac
        plp
        plb
        rts

; ---------------------------------------------------------------------------

; [ menu state $02: job menu ]

_c2cccb:
_cccb:  phb
        shorta
        lda #$06
        jsr _c2cfbd
        .a16
        stz $53
        jsr _c2d210     ; init cursor ???
        stz $6f
        jsr _c2d503
        jsr _c2e464
        jsr _c2cdc6     ; update current character data
        jsr _c2d388
        jsr _c2cecc     ; get list of available jobs
        jsr _c2cde3     ; update job sprites
        jsr _c2cd57     ; update selected job palette
        phb
        ldx #$ee53
        jsr _c2d9fb
        plb
        stz $2d11
        ldx #$e95a
        jsr _c2c6e9
        jsr _c2a9d9
        jsr _c2cd08     ; update job name, level, and equipment
        plb
        rts

; ---------------------------------------------------------------------------

; [  ]

_c2cd08:
_cd08:  php
        longa
        lda $55
        and #$00ff
        dec
        tax
        lda $7a00,x
        and #$001f
        shorta
        sta $d8
        jsr _c2e47d
        longa
        ldy #$65c4
        lda $d8
        jsr $e4c7
        ldy #$65d4
        jsr _c2d93f
        ldy #$65d6
        jsr _c2d588
        ldy #$65da
        jsr _c2d59d
        lda $d8
        and #$001f
        asl2
        tax
        lda $d15708,x   ; job equipment types
        sta $f9
        lda $d1570a,x
        sta $fb
        ldy #$65f2
        jsr _c2d7d8
        plp
        rts

; ---------------------------------------------------------------------------

; [ update selected job palette ]

_c2cd57:
_cd57:  php
        longa
        lda $55
        and #$00ff
        dec
        tay
        ldx $80
        shorta
        lda $7a00,y
        sta $eb
        lda $0500,x
        and #$07
        sta $ea
        longa
        lda #$c180
        sta $ea
        jsr _c2d2db
        lda #$000c
        ldx #$ed31
        jsr _c2d304
        ldx #$ee53
        ldy #$7514
        lda #$0008
        mvn $7e,$c0
        longa
        lda $ea
        and #$1f07
        ldy #$0005
        jsr _c2d492
        lda $55
        and #$00ff
        dec
        asl2
        tay
        asl
        tax
        shorta
        lda $0293,x
        and #$f1
        ora #$0a
        sta $0293,x
        sta $0297,x
        lda $0363,y
        and #$f1
        ora #$08
        sta $0363,y
        sta $0363,y
        plp
        rts

; ---------------------------------------------------------------------------

; [ update current character data ]

_c2cdc6:
_cdc6:  php
        longa
        ldx #$efc7
        lda #$0011
        jsr _c2da9d
        lda #$5000
        sta $2bba
        jsr _c2ddd7
        lda #$1016
        jsr _c2c8de
        plp
        rts

; ---------------------------------------------------------------------------

; [ update job sprites ]

_c2cde3:
_cde3:  phb
        plp
        pea $7e7e
        plb
        plb
        longa
        lda $80
        clc
        adc #$054a      ; job stat modifiers
        tay
        ldx #$e92b      ; C0/E92B (default stat modifiers)
        lda #$0005
        mvn $7e,$c0     ; copy to ram
        stz $85
        stx $d8
        ldx #$0090      ; start at sprite 36
        stx $ec
        ldy $8e
@ce07:  shorta
        lda $7a00,y
        bmi @ce54       ; branch if at end of available job list
        longa
        and #$00ff
        sta $d8         ; job index
        tax
        lda $c0ee6a,x   ; tile offset
        and #$00ff
        ora #$0d00      ; priority 0, palette 6, tile offset msb set
        sta $e2
        clc
        adc #$0020
        sta $e6
        tya
        asl
        tax
        lda $c0ee82,x   ; sprite xy position
        sta $e0
        clc
        adc #$1000
        sta $e4
        ldx $ec
        lda $e0
        sta $0200,x     ; top sprite
        lda $e2
        sta $0202,x
        lda $e4
        sta $0204,x     ; bottom sprite
        lda $e6
        sta $0206,x
        txa
        clc
        adc #$0008
        sta $ec
@ce54:  jsr _c2ce5d     ; update character sprite
        iny
        bra @ce07       ; next job
        plp
        plb
        rts

; ---------------------------------------------------------------------------

; [ update character sprite ]

_c2ce5d:
_ce5d:  jsr _c2e47d     ; get character job data
        ldx $d8
        cpx #$0015
        bne @ce70       ; branch if not freelancer
        lda $85
        cmp #$0015
        beq @ce7b
        bra @ce9d
@ce70:  lda $d152ea,x   ; number of abilities for each job
        and #$00ff
        cmp $da
        bne @ce9d
@ce7b:  lda #$0c04      ; xy position
        sta $e2
        lda $e0
        sec
        sbc #$0900      ; switch to palette 4
        sta $e0
        tya
        asl2
        tax
        lda $e0
        sta $0360,x
        lda $e2
        sta $0362,x
        inc $85
        phy
        jsr _c2ce9e     ; udpate job stats and abilities
        ply
@ce9d:  rts

; ---------------------------------------------------------------------------

; [ update job stats and abilities ]

_c2ce9e:
_ce9e:  lda $de         ; job index
        and #$001f
        asl2
        tax
        ldy #$054a
        shorta
@ceab:  lda $d156b0,x   ; stat modifiers for each job
        cmp ($80),y     ; compare to current stat modifier
        bmi @ceb5
        sta ($80),y     ; set stat modifier if greater
@ceb5:  inx
        iny
        cpy #$054e
        bne @ceab
        longa
        lda $d8
        jsr _c2e916     ; get job innate abilities
        ldy $80
        ora $054e,y
        sta $054e,y
        rts

; ---------------------------------------------------------------------------

; [ get list of available jobs ]

_c2cecc:
_cecc:  phb
        php
        shorta
        ldx #$0100
        lda #$ff
@ced5:  sta $79ff,x
        dex
        bne @ced5
        ldx $8e
        ldy #$0840      ; available jobs
        lda #$00        ; start at 0
        sta $e3
        lda #$16        ; 22 jobs
        jsr _c2d8b1     ; build list from ram bits
        plp
        plb
        rts

; ---------------------------------------------------------------------------

; [ menu state $01: ability menu ]

_c2ceec:
_ceec:  shorta
        lda #$04
        jsr _c2cfbd
        .a16
        ldx #$efb5
        lda #$0011
        jsr _c2da9d
        lda #$5000
        sta $2bba
        jsr _c2ddd7
        jsr _c2cfa4
        lda #$1016
        jsr _c2c8de
        lda #$08f3      ; number of abilities
        clc
        adc $7e         ; character index
        tay
        ldx #$51f6
        lda #$0031
        jsr _c2e4ed
        lda $7e         ; character index
        asl
        tax
        lda $c0f33a,x   ; pointer to character abilities
        tax
        ldy $80
        shorta
        lda $0501,y     ; job
        cmp #$14
        bne @cf39       ; branch if not mimic
        lda #$48        ; include fight and item
        ora $0000,x
        bra @cf3e
@cf39:  lda #$b7        ; remove fight and item
        and $0000,x
@cf3e:  sta $0000,x
        longa
        stz $6b
        lda #$0040
        sta $6d
        jsr _c2d851     ; get list of available abilities
        jsr _c2d837
        ldx #$f292
        ldy #$298a
        lda #$0015
        mvn $7e,$c0
        stz $29b6
        jsr _c2e367
        ldx $80
        lda $0501,x
        and #$001f
        tax
        lda $c0ed61,x   ; ability menu to use for each job
        and #$00ff
        asl2
        tax
        shorta
        lda $c0ed77,x
        sta $53
        longa
        lda $c0ed78,x
        and #$000f
        sta $2b63
        lda $c0ed79,x
        tax
        ldy #$2b5f
        lda #$0003
        mvn $7e,$c0
        jsr _c2d210
        jsr _c2d717
        ldx #$e960
        jsr _c2c6e9
        rts

; ---------------------------------------------------------------------------

; [  ]

_c2cfa4:
_cfa4:  phb
        php
        longa
        ldx #$ee5c
        ldy #$51d2
        lda #$000d
        mvn $7e,$c0
        ldy #$51d2
        jsr _c2d7ca
        plp
        plb
        rts

; ---------------------------------------------------------------------------

; [  ]

_c2cfbd:
_cfbd:  shorta
        sta $54
        jsr _c2e67c
        jsr _c2d210
        longa
        lda $8e
        sta $0204
        sta $0206
        lda $71
        and #$00ff
        sta $7e
        jsr _c2d4c5
        rts

; ---------------------------------------------------------------------------

; [ menu state $00: main menu ]

_c2cfdc:
_cfdc:  jsr _c2d230
        jsr _c2d3db
        ldx #$f394
        jsr _c2d04c
        jsr _c2d4db
        ldx #$66ee
        jsr _c2d658
        ldx #$6630
        ldy #$094a
        jsr _c2d662
        lda $44
        and #$0080
        bne @d00a
        ldx #$64f2
        lda #$0103
        jsr _c2d6dc
@d00a:  pea $7e7e
        plb
        plb
        lda $0840       ; available jobs
        bne @d025
        lda $0842
        and #$00f8
        bne @d025
        ldx #$60f2
        lda #$0103
        jsr _c2d6dc
@d025:  lda $08f3       ; number of abilities
        ora $08f5
        bne @d036
        ldx #$6172
        lda #$0105
        jsr _c2d6dc
@d036:  stz $0204
        stz $0206
        stz $2d11
        shorta
        lda #$01
        sta $54
        jsr _c2e67c
        jsr _c2d210
        rts

; ---------------------------------------------------------------------------

; [  ]

_c2d04c:
_d04c:  phb
        pea $7e7e
        plb
        plb
        shorta
        lda #$c0
        stx $82
        sta $84
        longa
        stz $7e
@d05e:  shorta
        jsr _c2d4c5
        ldx $80
        bit $0500,x
        bvs @d0a5
        jsr @d0b2
        longa
        lda $7e
        asl3
        tay
        lsr
        ldx $80
        shorta
        bit $0500,x
        longa
        bpl @d083
        inc2
@d083:  tyx
        tay
        lda [$82],y
        clc
        adc $0240,x
        sta $0240,x
        lda [$82],y
        clc
        adc $0244,x
        sta $0244,x
        lda $0222,x
        beq @d0a5
        lda [$82],y
        clc
        adc $0220,x
        sta $0220,x
@d0a5:  longa
        inc $7e
        lda $7e
        cmp #$0004
        bne @d05e
        plb
        rts
        phb
        php
        jsr _c2d4c5
        ldx $80
        shorta
        lda #$7e
        pha
        plb
        lda $051a,x
        sta $e8
        lda $0500,x
        sta $ea
        lda $0501,x
        sta $eb
        ldx $8e
        lda $e8
        bpl @d0d5
        inx
@d0d5:  and #$30
        beq @d0db
        inx2
@d0db:  longa
        txa
        asl2
        tax
        lda $c0eac8,x
        sta $e0
        lda $c0eaca,x
        sta $e4
        ldx $7e
        shorta
        lda $e8
        and #$30
        beq @d0ff
        ldx #$0004
        and #$20
        beq @d0ff
        inx
@d0ff:  longa
        txa
        asl3
        tax
        shorta
        lda $e8
        beq @d11a
        bmi @d114
        and #$45
        bne @d116
        bra @d11a
@d114:  inx2
@d116:  inx4
@d11a:  lda $c0ead8,x
        sta $e2
        lda $c0ead9,x
        sta $e6
        jsr _c2d45f
        lda $7e
        asl
        and #$0e
        sta $e3
        sta $e7
        longa
        lda $7e
        asl
        tax
        lda $c0eb08,x
        tay
        ldx #$01e0
        lda #$0007
        mvn $7e,$00
        lda $7e
        asl
        tax
        lda $c0f23e,x
        tay
        shorta
        lda #$04
        and $e8
        beq @d167
        longa
        lda #$7edb
        sta $0008,y
        lda #$4dd3
        sta $0010,y
        shorta
@d167:  lda #$02
        and $e8
        beq @d181
        longa
        lda #$3af5
        sta $0008,y
        lda #$3210
        sta $0010,y
        lda #$7fff
        sta $0006,y
@d181:  longa
        stz $e2
        shorta
        lda $e8
        bit #$01
        beq @d1f1
        bit #$a0
        bne @d1f1
        bit #$10
        longa
        beq @d19e
        ldx #$000a
        lda $8e
        bra @d1ab
@d19e:  lda $ea
        and #$0007
        asl
        tax
        lda $eb
        and #$00ff
        asl
@d1ab:  clc
        adc $c0eb10,x
        tax
        shorta
        lda $c0eb1c,x
        clc
        adc $e0
        sta $e0
        lda $c0eb1d,x
        clc
        adc $e1
        sta $e1
        lda $ea
        and #$07
        beq @d1d9
        cmp #$01
        bne @d1ea
        lda $eb
        and #$1f
        cmp #$0a
        beq @d1e5
        bra @d1ea
@d1d9:  lda $eb
        and #$1f
        cmp #$04
        beq @d1e5
        cmp #$0a
        bne @d1ea
@d1e5:  ldx #$4e20
        bra @d1ed
@d1ea:  ldx #$0e20
@d1ed:  stx $e2
        bra @d1f5
@d1f1:  stz $e0
        stz $e1
@d1f5:  longa
        lda $7e
        asl
        tax
        lda $c0eb08,x
        sec
        sbc #$0020
        tay
        ldx #$01e0
        lda #$0003
        mvn $00,$00
        plp
        plb
        rts

; ---------------------------------------------------------------------------

; [ init cursor ??? ]

_c2d210:
_d210:  php
        shorta
        jsr _c2e6ab     ; update cursor sprite
        lda #$01
        trb $ca
        lda $53
        sta $50
        lda $55
        sta $52
        lda $54
        sta $51
        stz $4f
        stz $56
        stz $57
        stz $58
        plp
        rts

; ---------------------------------------------------------------------------

; [  ]

_c2d230:
_d230:  phb
        php
        longa
        ldx #$2000
        lda $8e
@d239:  dex2
        stz $9000,x
        bne @d239
        stz $7e
@d242:  jsr _c2d298
        lda $7e
        inc
        sta $7e
        cmp #$0004
        bne @d242
        jsr _c2d25b
        ldx #$efeb
        jsr _c2d9fb
        plp
        plb
        rts

; ---------------------------------------------------------------------------

_c2d2b5:
_d2b5:  ldx $8e
        phx
        lda $c0ecc3,x
        sta $e0
        lda $c0ecc5,x
        sta $e2
        lda $c0ecc7,x
        sta $e4
        lda $c0ecc9,x
        pha
        lda $c0eccb,x
        plx
        jsr _c2d304
        pla
        clc
        adc #$000a
        tax
        cpx #$001e
        bne $d25d
        jsr _c2d34c
        ldx #$b9a0
        ldy #$9080
        lda #$003f
        mvn $7e,$c3
        rts

; ---------------------------------------------------------------------------

_c2d298:
_d298:  phb
        php
        lda $7e
        asl
        tax
        lda $c0ec1b,x
        sta $e4
        jsr _c2d4c5
        ldx $80
        lda $000500,x
        sta $ea
        jsr _c2d2db
        lda #$0018
        ldx #$ec37
        jsr _c2d304
        lda $ea
        and #$0007
        asl2
        tax
        lda $c0ec97,x
        sta $e0
        lda $c0ec99,x
        sta $e2
        lda #$0006
        ldx #$ecab
        jsr _c2d304
        plp
        plb
        rts

; ---------------------------------------------------------------------------

_c2d2db:
_d2db:  php
        longa
        lda $eb
        and #$001f
        asl
        pha
        asl
        adc $01,s
        xba
        sta $01,s
        lda $ea
        and #$0007
        asl2
        tax
        pla
        adc $c0ec23,x
        sta $e0
        lda $8e
        adc $c0ec25,x
        sta $e2
        plp
        rts

; ---------------------------------------------------------------------------

_c2d304:
_d304:  phb
        php
        sta $e8
@d308:  phx
        lda $e4
        clc
        adc $c00002,x
        tay
        lda $e0
        clc
        adc $c00000,x
        tax
        lda $e2
        adc $8e
        and #$00ff
        cmp #$00d4
        beq $d33a
        cmp #$00d3
        beq @d332
        lda #$001f
        mvn $7e,$d2
        bra $d340
@d332:  lda #$001f
        mvn $7e,$d3
        bra @d33e
        lda #$001f
        mvn $7e,$d4
@d33e:  plx
; hexes d33f and d340 are missing here!
        inx4
        dec $e8
        bne @d308
        plp
        plb
        rts

; ---------------------------------------------------------------------------

_c2d34c:
_d34c:  ldx $8e
@d34e:  phx
        txa
        clc
        adc #$0017
        tax
        clc
        adc #$0007
        tay
        lda #$0008
        sta $85
@d35f:  lda $9000,x
        and #$00ff
        sta $9000,y
        dex
        dey2
        dec $85
        bne @d35f
        pla
        clc
        adc #$0020
        tax
        cmp #$00
        php
        bne @d34e
        rts

; ---------------------------------------------------------------------------

_c2d37b:
_d37b:  phb
        php
        longa
        ldx #$efe2
        jsr _c2d9fb
        plp
        plb
        rts

; ---------------------------------------------------------------------------

; [  ]

_c2d388:
_d388:  phb
        php
        longa
        ldx #$1800
@d38f:  stz $affe,x
        dex2
        bne @d38f
        ldx $80
        lda $0500,x
        and #$0007
        sta $ea
        ldy #$0016
@d3a3:  longa
        lda $eb
        and #$0018
        asl2
        ora $eb
        and #$0067
        asl
        xba
        lsr3
        adc #$b000
        sta $e4
        phy
        jsr _c2d2db
        lda #$0006
        ldx #$ed31
        jsr _c2d304
        ply
        shorta
        inc $eb
        dey
        bne @d3a3
        longa
        ldx #$efd9
        jsr _c2d9fb
        plp
        plb
        rts

; ---------------------------------------------------------------------------

; [  ]

_c2d3db:
_d3db:  phb
        php
        longa
        stz $7e
@d3e1:  jsr _c2d45f
        lda $7e
        inc
        sta $7e
        cmp #$0004
        bne @d3e1
        ldx #$b9e0
        ldy #$7480
        lda #$001f
        mvn $7e,$c3
        ldx #$f867
        ldy #$74c0
        lda #$001f
        mvn $7e,$c0
        ldx #$b960
        ldy #$74e0
        lda #$001f
        mvn $7e,$c3
        jsr _c2d42e
        ldx #$eff4
        ldy #$4300
        lda #$0006
        mvn $00,$c0
        shorta
        stz $2121
        lda #$01
        sta $420b
        plp
        plb
        rts
        lda #$04
        brk $85
        inx
        ldy #$7300
@d436:  ldx #$f827
        lda #$3f
        brk $54
        ror $c6c0,x
        inx
        bne @d436
        jsr _c2d447     ; update window color
        rts

; ---------------------------------------------------------------------------

; [ update window color ]

_c2d447:
_d447:  php
        longa
        ldy $8e
@d44c:  lda $0971       ; window color
        sta $7302,y
        tya
        clc
        adc #$0008
        tay
        cmp #$0100
        bne @d44c
        plp
        rts

; ---------------------------------------------------------------------------

_c2d45f:
_d45f:  phb
        php
        shorta
        jsr _c2d4c5
        ldx $80
        lda $0500,x
        and #$07
        xba
        lda $0501,x
        and #$1f
        ldy $7e
        bit $051a,x
        bvs @d484
        bpl @d47e
        lda #$15
@d47e:  xba
        jsr _c2d492
        bra @d48f
@d484:  ldx #$f807
        longa
        jsr _c2d4b4
        mvn $7e,$c0
@d48f:  plp
        plb
        rts
        phb
        php
        phx
        longa
        pha
        and #$0007
        asl
        tax
        pla
        and #$1f00
        lsr3
        clc
        adc $c0f246,x
        tax
        jsr _c2d4b4
        mvn $7e,$d4
        plx
        plp
        plb
        rts
        tya
        and #$07
        brk $eb
        lsr3
        clc
        adc #$00
        stz $a8,x
        lda #$1f
        brk $60
        phx
        php
        longa
        lda $7e
        and #$0003
        sta $7e
        asl
        tax
        lda $c0ea64,x
        sta $80
        plp
        plx
        rts
        phb
        longa
        ldx #$ef6d
        lda #$0017
        jsr _c2da9d
        stz $7e
@d4e9:  lda $7e
        asl
        tax
        lda $c0ea5c,x
        sta $2bba
        jsr _c2ddd7
        lda $7e
        inc
        sta $7e
        cmp #$0004
        bne @d4e9
        plb
        rts

; ---------------------------------------------------------------------------

; [  ]

_c2d503:
_d503:  ldx $80
        lda $0501,x
        and #$001f
        sta $d8
        lda $053a,x
        and #$000f
        sta $da
        lda $053b,x
        and #$0fff
        sta $dc
        lda $d8
        asl
        tax
        lda $da
        asl
        clc
        adc $da
        adc $d152c0,x   ; pointers to job ability data
        tax
        lda $d10000,x
        sta $de
        rts

; ---------------------------------------------------------------------------

; [  ]

_c2d533:
_d533:  ldx $80
        lda $0500,x
        and #$0007
        asl
        tax
        lda $c0ea50,x
        tyx
        tay
        lda #$0006
        jsr _c2e59d
        rts
        ldx $80
        lda $051a,x
        and #$007f
        bne @d55c
        ldx $80
        lda $0501,x
        jsr _c2e4c7
@d55c:  rts
        lda $7e
        and #$0003
        asl
        tax
        lda $c0ea48,x
        tyx
        tay
        lda #$0021
        jsr _c2e4ed
        rts
        tyx
        lda $d8
        cmp #$0015
        beq @d57e
        ldy #$ea74
        bra @d581
@d57e:  ldy #$ea81
@d581:  lda #$c08c
        jsr _c2e59d
        rts
        lda $d8
        cmp #$0015
        beq @d59c
        tyx
        lda $da
        and #$000f
        clc
        adc #$0053
        sta $0000,x
@d59c:  rts
        ldx $d8
        cpx #$0015
        beq @d5d2
        lda $d263ea,x
        and #$00ff
        cmp $da
        beq @d5c8
        tyx
        ldy #$01dc
        lda #$0032
        jsr _c2e4ed
        inx8
        iny2
        jsr _c2e4ed
        bra @d5d2
@d5c8:  tyx
        ldy #$ea6c
        lda #$c087
        jsr _c2e59d
@d5d2:  rts
        tyx
        lda $80
        clc
        adc #$0506
        tay
        lda #$7e42
        jsr _c2e4ed
        pha
        txa
        clc
        adc #$000a
        tax
        pla
        iny2
        jsr _c2e4ed
        rts
        tyx
        lda $80
        clc
        adc #$050a
        tay
        lda #$7e32
        jsr _c2e4ed
        pha
        txa
        clc
        adc #$000a
        tax
        pla
        iny2
        jsr _c2e4ed
        rts
        phb
        php
        ldx $80
        lda $051a,x
        xba
        asl
        and #$fe00
        beq @d655
        sta $e0
        tyx
        lda #$003a
        sta $e4
        lda #$0008
        sta $e2
        tay
        dey
@d628:  asl $e0
        bcc @d63c
        lda $e4
        sta $0000,x
        lda #$00ff
        sta $7dffc0,x
        inx2
        dec $e2
@d63c:  inc $e4
        dey
        bne @d628
        ldy $e2
        iny
        lda #$00ff
@d647:  dey
        beq @d655
        sta $0000,x
        sta $7dffc0,x
        inx2
        bra @d647
@d655:  plp
        plb
        rts
        ldy #$0947
        lda #$73
        brk $20
        sbc $60e4
        php
        shorta
        lda #$3c
        sta $8d
        cpy #$2d17
        beq @d674
        jsr @d6a4
        ldy #$0189
@d674:  jsr @d6a4
        ldy #$0189
        jsr @d6a4
        sta $8b
        longa
        lda #$0032
        ldy $89
        cpy #$03e8
        bmi @d68e
        ora #$0080
@d68e:  ldy #$0189
        jsr _c2e4ed
        iny2
        txa
        clc
        adc #$0008
        tax
        lda #$00a1
        jsr _c2e4ed
        plp
        rts
        phx
        iny3
        lda #$00
        ldx #$0004
@d6ad:  sta $004205
        lda $0000,y
        sta $004204
        dey
        lda $8d
        sta $004206
        nop8
        lda $004214
        sta $88,x
        lda $004216
        dex
        bne @d6ad
        pha
        lda #$3c
        sta $8d
        pla
        plx
        rts

; ---------------------------------------------------------------------------

; [ set font color ??? ]

; $E0: text length
;   A: palette index
;  +X: text address

_c2d6dc:
_d6dc:  phb
        php
        shorta
        sta $e0
        lda $e0
        beq @d714
        xba
        pha
        and #$07
        asl2
        sta $e1
        pla
        and #$80
        sta $e2
        inx
@d6f4:  lda $0000,x
        and #$e3
        ora $e1
        sta $0000,x
        bit $e2
        bmi @d70e
        lda $7dffc0,x
        and #$e3
        ora $e1
        sta $7dffc0,x
@d70e:  inx2
        dec $e0
        bne @d6f4
@d714:  plp
        plb
        rts

; ---------------------------------------------------------------------------

_c2d717:
_d717:  phb
        php
        lda $2b63
        and #$0f
        brk $0a
        asl
        tax
        lda $c0f316,x
        phx
        jsr _c2c1b8
        plx
        lda $c0f318,x
        tax
        ldy #$7100
        jsr _c0c1fd
        lda $2b63
        and #$0f
        brk $0a
        asl2
        tax
        lda #$04
        brk $85
        sta $a4
        bra $d707
        jsl $f0c0f3
        ora #$da
        tax
        lda $0516,y
        jsr _c2d8e4
        plx
        inx2
        iny
        dec $85
        bne $d747
        plp
        plb
        rts
        lda #$53
        ldx $b820
        cmp ($a5,x)
        eor $29,x
        sbc $183a00,x
        adc $6b
        tax
        lda $7a00,x
        and #$ff
        brk $e2
        jsr _c28089
        beq @d781
        and #$7f
        clc
        adc #$4e
@d781:  longa
        and #$00ff
        pha
        asl
        tax
        lda $d1716c,x
        sta $7e2ceb
        jsr _c2da26
        pla
        tax
        shorta
        lda $c0f739,x
        beq @d7c9
        pha
        and #$1f
        sta $e0
        pla
        and #$e0
        lsr5
        sta $e1
        lda $e0
        ldy #$568c
        jsr _c2e4c7
        longa
        ldx #$56a4
        ldy #$01e1
        lda #$0011
        jsr _c2e4ed
        lda #$ae37
        jsr _c2c1b8
@d7c9:  rts
        ldx $80
        lda $000540,x
        sta $f9
        lda $000542,x
        sta $fb
        lda $f9
        cmp #$ffff
        bne @d7f2
        lda $fb
        cmp #$ffff
        bne @d7f2
        tyx
        ldy #$f7a8
        lda #$c004
        jsr _c2e59d
        bra @d7f5
@d7f2:  jsr _c2d802
@d7f5:  rts

; ---------------------------------------------------------------------------

; [  ]

_c2d7f6:
_d7f6:  lda #$0005
        sta $85
        ldx #$0041
        jsr _c2d80d
        rts

; ---------------------------------------------------------------------------

_c2d802:
_d802:  lda #$000d
        sta $85
        ldx $8e
        jsr _c2d80d
        rts

; ---------------------------------------------------------------------------

_c2d80d:
_d80d:  lda $f9
        and $c0f7ad,x
        sta $fd
        lda $fb
        and $c0f7af,x
        ora $fd
        beq @d82d
        lda $c0f7b1,x
        and #$00ff
        beq @d82d
        sta $0000,y
        iny2
@d82d:  inx5
        dec $85
        bne _d80d
        rts

; ---------------------------------------------------------------------------

; [  ]

_c2d837:
_d837:  ldy $6b
        ldx $8e
@d83b:  phx
        lda $c0f478,x
        tax
        lda $7a00,y
        jsr _c2d8e4
        plx
        iny
        inx2
        cpx #$0020
        bne @d83b
        rts

; ---------------------------------------------------------------------------

; [ get list of available abilities ]

_c2d851:
_d851:  php
        ldx #$0200
@d855:  dex2
        stz $7a00,x
        bne @d855
        lda $7e
        asl
        tax
        lda $c0f33a,x   ; pointer to character abilities
        tay
        shorta
        ldx $8e
        inx
        stz $e0
        lda #$01        ; start at $01
        sta $e3
        lda #$2c        ; end at $2C
        jsr _c2d8b1     ; build list from ram bits
        lda #$80
        sta $e0
        iny
        lda #$32
        jsr _c2d8b1     ; build list from ram bits
        lda #$80
        sta $e0
        iny
        lda #$32
        jsr _c2d8b1     ; build list from ram bits
        iny
        lda #$38
        jsr _c2d8b1     ; build list from ram bits
        iny
        lda #$3e
        jsr _c2d8b1     ; build list from ram bits
        iny
        lda #$44
        jsr _c2d8b1     ; build list from ram bits
        iny
        lda #$49
        jsr _c2d8b1     ; build list from ram bits
        iny
        lda #$4c
        jsr _c2d8b1     ; build list from ram bits
        iny
        lda #$4e
        jsr _c2d8b1     ; build list from ram bits
        iny
        lda #$80        ; start at $80
        sta $e3
        lda #$a1        ; end at $A1
        jsr _c2d8b1     ; build list from ram bits
        plp
        rts

; ---------------------------------------------------------------------------

; [ build list from ram bits ]

_c2d8b1:
_d8b1:  sta $e4         ; end bit
@d8b3:  lda $0000,y
        sta $e2
        lda #$08        ; 8 bits
        sta $e5
@d8bc:  asl $e2
        bcc @d8ca
        lda $e3         ; start bit
        sta $7a00,x
        bit $e0
        bmi @d8ca
        inx
@d8ca:  inc $e3
        lda $e3
        cmp $e4
        bpl @d8d9
        dec $e5         ; next bit
        bne @d8bc
        iny             ; next byte
        bra @d8b3
@d8d9:  bit $e0
        bpl @d8e3
        lda $7a00,x
        beq @d8e3
        inx
@d8e3:  rts

; ---------------------------------------------------------------------------

; [  ]

_c2d8e4:
_d8e4:  phb
        phy
        php
        pea $7e7e
        plb
        plb
        longa
        and #$00ff
        pha
        phx
        asl
        tax
        lda $7ed600,x
        tay
        plx
        pla
        bit #$0080
        beq @d909
        lda #$d108
        jsr _c2e59d
        bra @d93b
@d909:  phx
        phy
        pha
        ldx #$f4a3
        ldy #$2b3f
        lda #$0007
        mvn $7e,c0
        pla
        ply
        plx
        and #$007f
        beq @d926
        lda #$00c9
        sta $2b3f
@d926:  phx
        tyx
        ldy #$2b40
        lda #$0004
        mvn $7e,$d1
        plx
        ldy #$2b3f
        lda #$7e08
        jsr _c2e59d
@d93b:  plp
        ply
        plb
        rts
        tyx
        longa
        lda $d8
        cmp #$0015
        beq @d94e
        ldy #$f498
        bra @d951
@d94e:  ldy #$f4a3
@d951:  lda #$c08a
        jsr _c2e59d
        rts

; ---------------------------------------------------------------------------

; [ menu command $06: transfer galuf's stats to krile ]

_c2d958:
_d958:  php
        phb
        stz $7e
@d95c:  jsr _c2d4c5
        ldx $80
        lda $0500,x
        and #$07
        cmp #$04
        beq @d974
        inc $7e
        lda $7e
        cmp #$04
        beq @d9a8
        bra @d95c
@d974:  longa
        jsr _c2d503
        jsr _c2e464
        jsr _c2daa4
        shorta
        ldx $7e
        inc $0420,x
        lda #$15
        sta $d8
        jsr _c2ea7d     ; get character job data
        ldx $80
        lda $da
        sta $053a,x     ; job level
        lda $d8
        sta $0501,x     ; job
        longa
        lda $dc
        sta $053b,x
        shorta
        jsr _c2eb82
        jsr _c2e6d6
@d9a8:  plb
        plp
        rts

; ---------------------------------------------------------------------------

_c2d9ab:
_d9ab:  php
        phb
        phy
        longa
        and #$00ff
        pha
        asl
        tax
        lda $7ed000,x
        tax
        phx
        ldy #$019b
        lda #$000b
        mvn $00,$d1
        plx
        pla
        cmp #$0061
        beq @d9d3
        cmp #$0063
        beq @d9ef
        bra @d9f7
@d9d3:  lda $09b5
        and #$00ff
        pha
        lda $a2
        and #$00ff
        sec
        sbc $01,s
        sta $01,s
        pla
        bpl @d9e9
        lda $8e
@d9e9:  shorta
        sta $a2
        bra @d9f7
@d9ef:  shorta
        lda $09b5
        lsr
        sta $a2
@d9f7:  ply
        plb
        plp
        rts

; ---------------------------------------------------------------------------

; [  ]

_c2d9fb:
_d9fb:  lda $c00000,x
        sta $002116
        inx2
        ldy #$4300
        lda #$06
        brk $54
        brk $c0
        shorta
        lda #$01
        sta $420b
        rts
        phb
        php
        pea $7e7e
        plb
        plb
        longa
        lda $2ce5
        sta $2ced
        stz $2cef
        ldx $2ceb
@da28:  ldy #$2cf1
        lda $2ce7
        dec
        mvn $7e,$d1
        inc
        sta $0000,y
        ldx $8e
        shorta
@da3d:  lda $2cf1,x
        cmp #$01
        beq @da4c
        inx
        cpx $2ce7
        bne @da3d
        bra @da4f
@da4c:  stz $2cf1,x
@da4f:  longa
        ldx $2ced
        ldy #$2cf1
        lda $2ce7
        and #$00ff
        ora #$7e00
        jsr _c2e59d
        tya
        sec
        sbc #$2cf1
        clc
        adc $2ceb
        tax
        lda $d10000,x
        and #$00ff
        beq @da9a
        cmp #$0001
        bne @da7c
        inx
@da7c:  stx $2ceb
        lda $2ced
        clc
        adc #$0080
        sta $2ced
        lda $2ce7
        clc
        adc $2cef
        sta $2cef
        cmp $2ce9
        beq @da9a
        bra @da28
@da9a:  plp
        plb
        rts
        ldy #$2bbe
        mvn $7e,$c0
        rts
        phb
        php
        longa
        lda $6f
        pha
        shorta
        jsr _c2e178
        lda #$01
@dab2:  sta $6f
        jsr _c2e211
        lda $73
        jsr _c2e286
        lda $90
        bne @dac8
        lda #$01
        xba
        lda $73
        jsr _c2e2ce
@dac8:  lda $6f
        inc
        cmp #$06
        bne @dab2
        jsr _c2e18f
        longa
        pla
        sta $6f
        plp
        plb
        rts
        ldx $8e
@dadc:  lda $c0eed2,x
        beq @daeb
        cmp $29e7
        beq @daee
        inx2
        bra @dadc
@daeb:  stz $29e7
@daee:  rts
        phb
        php
        pea $7e7e
        plb
        plb
        longa
        stz $29f1
        shorta
        lda $29f8
        sta $004202
        lda $29f9
        sta $004203
        nop3
        longa
        lda $004216
        sta $29ef
        shorta
        lda $29e7
        jsr _c2dada
        lda $29e7
        beq @db63
        longa
        lda $c0e82b,x
        sta $c7
        shorta
        ldy $8e
@db30:  lda $29ea,y
        bne @db3d
        iny
        cpy #$0004
        bne @db30
        bra @db63
@db3d:  sty $7e
        jsr _c2d4c5
        ldy $80
        per $db49
        jmp ($01c7)
        lda $29f1
        beq @db63
        longa
        lda $29e7
        and #$00ff
        ora #$0100
        jsr _c2e328
        dec $29e8
        jsr _c2e0c8
@db63:  plp
        plb
        rts
        php
        lda $052a,y
        bit #$c2
        longa
        bne @db90
        lda $050a,y
        cmp $050c,y
        beq @db90
        lda $29ef
        clc
        adc $050a,y
        sta $050a,y
        lda $050c,y
        cmp $050a,y
        bpl @db8d
        sta $050a,y
@db8d:  inc $29f1
@db90:  plp
        rts
        php
        lda $051a,y
        bit #$c2
        longa
        bne @dbbb
        lda $0508,y
        cmp $0506,y
        bne @dbac
        lda $050c,y
        cmp $050a,y
        beq @dbbb
@dbac:  lda $0508,y
        sta $0506,y
        lda $050c,y
        sta $050a,y
        inc $29f1
@dbbb:  plp
        rts
        lda $051a,y
        bit #$20
        beq @dbcd
        and $29f8
        sta $021a,y
        inc $29f1
@dbcd:  rts
        php
        lda $051a,y
        bit #$02
        beq @dbe6
        and #$fd
        sta $051a,y
        longa
        lda #$0001
        sta $0506,y
        inc $29f1
@dbe6:  plp
        rts
        lda $051a,y
        bit #$01
        beq @dbf8
        and $29f8
        sta $051a,y
        inc $29f1
@dbf8:  rts
        lda $051a,y
        bit #$40
        beq @dc09
        and $29f8
        sta $051a,y
        inc $29f1
@dc09:  rts
        lda $051a,y
        bit #$10
        beq @dc1a
        and $29f8
        sta $051a,y
        inc $29f1
@dc1a:  rts
        phb
        php
        pea $7e7e
        plb
        plb
        longa
        stz $29f1
        lda $71
        and #$000f
        sta $7e
        jsr _c2d4c5
        ldx $80
        shorta
        lda $0502,x
        sta $004202
        lda $052b,x
        sta $004203
        nop4
        lda $004217
        clc
        adc #$04
        sta $004202
        lda $29f9
        sta $004203
        nop3
        longa
        lda $004216
        tay
        lda $55
        and #$000f
        cmp #$0005
        bne @dc70
        tya
        lsr
        tay
        sty $29ef
        shorta
        ldx $8e
@dc77:  lda $c0eeba,x
        beq @dccf
        cmp $29e7
        beq @dc86
        inx2
        bra @dc77
@dc86:  longa
        lda $c0e815,x
        sta $c7
        shorta
        ldy $8e
@dc92:  lda $29ea,y
        beq @dca6
        phy
        sty $7e
        jsr _c2d4c5
        ldy $80
        per $dca4
        jmp ($01c7)
        ply
@dca6:  iny
        cpy #$0004
        bne @dc92
        lda $29f1
        beq @dccf
        longa
        lda $71
        and #$000f
        sta $7e
        jsr _c2d4c5
        ldy $80
        lda $050a,y
        sec
        sbc $29e8
        sta $050a,y
        sta $29df
        jsr _c2e0c8
@dccf:  plp
        plb
        rts
        php
        lda $051a,y
        bit #$c2
        longa
        bne @dcfc
        lda $0506,y
        cmp $0508,y
        beq @dcfc
        lda $29ef
        clc
        adc $0506,y
        sta $0506,y
        lda $0508,y
        cmp $0506,y
        bpl $dcf9
        sta $0506,y
        inc $29f1
@dcfc:  plp
        rts
        lda $051a,y
        bit #$04
        beq @dd0e
        and $29f8
        sta $051a,y
        inc $29f1
@dd0e:  rts
        lda $051a,y
        bit #$c2
        bne @dd1f
        eor $29fa
        sta $051a,y
        inc $29f1
@dd1f:  rts
        php
        lda $051a,y
        bit #$80
        beq @dd58
        and #$7f
        sta $051a,y
        longa
        lda $0508,y
        shorta
        sta $00211b
        xba
        sta $00211b
        lda $29fa
        sta $00211c
        sta $00211c
        longa
        lda $002134
        lsr4
        sta $0506,y
        inc $29f1
@dd58:  plp
        rts
        lda $051a,y
        bit #$75
        beq @dd6a
        and $29f8
        sta $051a,y
        inc $29f1
@dd6a:  rts
        lda $55
        cmp #$05
        bne @dd74
        jmp @dcd2
@dd74:  lda $051a,y
        bit #$c2
        bne @dd8d
        php
        longa
        lda $0508,y
        cmp $0506,y
        beq @dd8c
        sta $0506,y
        inc $29f1
@dd8c:  plp
@dd8d:  rts
        php
        lda $051a,y
        bit #$80
        beq @dda6
        and #$7f
        sta $051a,y
        longa
        lda $0508,y
        sta $0506,y
        inc $29f1
@dda6:  plp
        rts
        lda $051a,y
        and $29f8
        sta $051a,y
        inc $29f1
        rts
        lda $051a,y
        bit #$c0
        bne @ddc5
        eor $29fa
        sta $051a,y
        inc $29f1
@ddc5:  rts
        lda $051a,y
        bit #$c2
        bne @ddd6
        ora $29fa
        sta $051a,y
        inc $29f1
@ddd6:  rts
        phb
        php
        pea $7e7e
        plb
        plb
        longa
        lda $2bba
        sta $e6
        lda $2bbe
        beq @dded
        jsr _c2c1b8
@dded:  jsr _c2d4c5
        jsr _c2d503
        ldx $80
        lda $0500,x
        and #$0040
        bne @de3b
        lda $2bba
        sta $e6
        lda $2bc0
        beq @de0a
        jsr _c2c1b8
@de0a:  lda $2bc2
        sta $2bbc
        ldx $8e
        txy
@de13:  lsr $2bbc
        bcc @de34
        lda $2bba
        clc
        adc $2bc4,y
        phx
        phy
        php
        tay
        lda $c0e7ff,x
        sta $c7
        per $de2e
        jmp ($01c7)
        plp
        ply
        plx
        iny2
@de34:  inx2
        cpy #$0016
        bne @de13
@de3b:  plp
        plb
        rts

; ---------------------------------------------------------------------------

_c2de3e:
_de3e:  phb
        php
        pea $7e7e
        plb
        plb
        longa
        ldx #$0200
        lda #$ffff
@de4d:  sta $79fe,x
        dex2
        bne @de4d
        lda #$7a00
        sta $e0
        lda $29e2
        and #$00ff
        asl2
        tax
        lda $c0ef1a,x
        and #$00ff
        sta $e4
        lda $c0ef1b,x
        and #$00ff
        sta $e6
        lda $c0ef19,x
        and #$00ff
        tax
@de7c:  shorta
        ldy $e6
        sty $85
        ldy $8e
@de84:  lda $29fb,x
        bpl @de94
        txa
        sta ($e0),y
        iny
        phx
        phy
        jsr _c2dec7
        ply
        plx
@de94:  shorta
        inx
        dec $85
        bne @de84
        lda $29e2
        cmp #$06
        beq @deb8
        lda #$fe
@dea4:  cpy $e6
        beq @dead
        sta ($e0),y
        iny
        bra @dea4
@dead:  longa
        lda $e0
        clc
        adc $e6
        sta $e0
        bra @dec0
@deb8:  longa
        tya
        clc
        adc $e0
        sta $e0
@dec0:  dec $e4
        bne @de7c
        plp
        plb
        rts

; ---------------------------------------------------------------------------

_c2dec7:
_dec7:  php
        longa
        and #$00ff
        sta $29e4
        cmp #$0048
        bpl @df3e
        cmp #$0012
        bmi @df3e
        shorta
        ldx $8e
@dede:  lda $c0eef4,x
        cmp #$ff
        beq @df3e
        cmp $29e4
        beq @def0
        inx3
        bra @dede
@def0:  longa
        lda $c0eef5,x
        and #$000f
        tay
        lda $c0eef6,x
        shorta
        cmp $29d8,y
        beq @df07
        bpl @df3e
@df07:  longa
        ldx $29e4
        lda $2a9d,x
        and #$00ff
        cmp $29df
        beq @df1b
        bmi @df1b
        bra @df3e
@df1b:  shorta
        lda $29e1
        bit #$c2
        bne @df3e
        bit #$20
        beq @df2f
        lda $29e4
        cmp #$29
        bne @df3e
@df2f:  shorta
        ldx $29e4
        lda $29fb,x
        ora #$40
        sta $29fb,x
        bra @df4b
@df3e:  shorta
        ldx $29e4
        lda $29fb,x
        and #$bf
        sta $29fb,x
@df4b:  plp
        rts

; ---------------------------------------------------------------------------

; [  ]

_c2df4d:
_df4d:  phb
        php
        pea $7e7e
        plb
        plb
        longa
        lda $29e2
        and #$00ff
        tax
        lda $29d8,x
        and #$00ff
        sta $f0
        txa
        asl
        tax
        lda $c0ef43,x   ; source bank and string length
        sta $ed
        lda $c0ef35,x   ; number of spells ???
        sta $85
        lda $c0e966,x
        tax
        ldy $8e
        stz $f2
        inc $f2

; ---------------------------------------------------------------------------

; start of loop
_c2df7f:
_df7f:  lda $c00000,x
        sta $eb
        inx2
        lda $7a00,y
        and #$00ff
        cmp #$00ff
        beq @dff6
        cmp #$00fe
        beq @dff6
        phx
        phy
        tax
        shorta
        lda $29fb,x
        sta $e8
        longa
        txa
        asl
        tax
        lda $d400,x     ; pointer to spell name
        sta $e9
        ldx $eb
        lda $29e2
        and #$00ff
        cmp #$0005
        bne @dfbc
        dex2
        stx $eb
@dfbc:  ldy $e9
        lda $ed
        jsr _c2e59d     ; draw text
        ldx $eb
        lda $29e2
        and #$00ff
        beq @dfd2
        cmp #$0004
        bmi @dfda
@dfd2:  lda $f0
        cmp $f2
        bpl @dff4
        bra @dfe9
@dfda:  lda $e8
        and #$0040
        bne @dff4
        lda $f0
        cmp $f2
        bmi @dfe9
        inx2
@dfe9:  lda $ed
        and #$007f
        ora #$0100
        jsr _c2d6dc     ; set font color
@dff4:  ply
        plx
@dff6:  iny
        longa
        inc $f2
        dec $85
        bne _df7f
        plp
        plb
        rts

; ---------------------------------------------------------------------------

_c2e002:
_e002:  phb
        php
        pea $7e7e
        plb
        plb
        longa
        ldx $8e
@e00d:  stz $7f00,x
        inx2
        cpx #$0300
        bne @e00d
        longa
        ldy $8e
        lda #$00e0
        ldx #$0100
        jsr _c2e050
        lda $8e
        ldx #$0080
        jsr _c2e050
        lda #$0080
        ldx #$00e0
        jsr _c2e050
        ldx #$8000
        ldy #$0640
        lda #$01ff
        mvn $7e,$7e
        ldx #$7f00
        ldy #$288a
        lda #$00ff
        mvn $7e,$7e
        plp
        plb
        rts
        sta $93
        stx $95
        ldx $8e
@e056:  lda $0640,x
        and #$ff
        brk $f0
        and $01c9,x
        brk $f0
        sec
        cmp #$80
        brk $f0
        and ($85,s),y
        cpx #$40bd
        ora [$29]
        sbc $29f000,x
        cmp #$64
        brk $30
        ora $a9,s
        adc $00,s
        sta $e2
        lda $e0
        cmp $93
        bmi @e09b
        cmp $95
        bpl @e09b
        shorta
        lda $e0
        sta $8000,y
        lda $e2
        sta $8100,y
        lda $288a,x
        sta $7f00,y
        iny
        longa
@e09b:  inx
        cpx #$0100
        bne @e056
        tya
        inc
        and #$fffe
        tay
        rts

; ---------------------------------------------------------------------------

; [ play sound effect ]

_c2e0a8:
_e0a8:  pha
        php
        shorta
        lda #$11        ; cursor 1
        bra @e0ce

_c2e0b0:
        pha
        php
        shorta
        lda #$10        ; cursor 2
        bra @e0ce
        pha
        php
        shorta
        lda #$11        ; cursor 1
        bra @e0ce
        pha
        php
        shorta
        lda #$12        ; error
        bra @e0ce
        pha
        php
        shorta
        lda #$13        ; system sound effect $13
@e0ce:  sta $001d00
        jsl $c40004     ; execute spc interrupt
        plp
        pla
        rts

; ---------------------------------------------------------------------------

; [ play sound effect ]

; a: game sound effect id

_c2e0d9:
_e0d9:  phb
        php
        longa
        pha
        ldx #$eeb6      ; C0/EEB6: $02, $5B, $0F, $88
        ldy #$1d00
        lda #$0003
        mvn $7e,$c0     ; this is a pretty roundabout way of copying 4 bytes
        pla
        shorta
        sta $1d01
        jsl $c40004
        plp
        plb
        rts

; ---------------------------------------------------------------------------

_c2e0f7:
_e0f7:  phb
        php
        shorta
        lda #$7e
        pha
        plb
        stz $90
        lda $6f
        cmp #$03
        bpl @e167
        dec
        longa
        and #$0001
        asl2
        tax
        lda $c0ef53,x
        clc
        adc $80
        tay
        lda $72
        sta $e0
        shorta
        lda $0500,y
        bne @e126
        lda $04ef,y
@e126:  sta $e2
        jsr @e16a
        sta $e3
        lda $e0
        jsr @e16a
        sta $e1
        ldy $80
        lda $e0
        bmi @e155
        lda $e2
        bmi @e14f
        beq @e167
        cmp #$01
        beq @e167
        lda $0521,y
        and #$01
        beq @e165
        lda $e3
        bmi @e165
@e14f:  lda $e1
        bmi @e165
        bra @e167
@e155:  lda $e2
        bmi @e165
        beq @e167
        cmp #$01
        beq @e167
        lda $e3
        bmi @e165
        bra @e167
@e165:  inc $90
@e167:  plp
        plb
        rts
@e16a:  bmi @e175
        and #$7f
        jsr _c2d9ab
        lda $9f
        bra @e177
@e175:  lda #$00
@e177:  rts
        phb
        php
        longa
        lda $80
        clc
        adc #$050e
        tax
        ldy #$01e0
        lda #$0006
        mvn $7e,$7e
        plp
        plb
        rts
        phb
        php
        longa
        lda $80
        clc
        adc #$050e
        tay
        ldx #$01e0
        lda #$0006
        mvn $7e,$7e
        plp
        plb
        rts
        phb
        php
        shorta
        lda #$7e
        pha
        plb
        lda $6f
        cmp #$01
        beq @e1ca
        cmp #$02
        beq @e1ca
        dec3
        longa
        and #$0003
        tay
        shorta
        lda $72
        sta $01e0,y
        bra @e20e
@e1ca:  dec
        longa
        and #$0001
        tay
        shorta
        lda $72
        bmi @e1e1
        sta $01e5,y
        lda #$00
        sta $01e3,y
        bra @e1e9
@e1e1:  sta $01e3,y
        lda #$00
        sta $01e5,y
@e1e9:  longa
        tya
        inc
        and #$0001
        tax
        shorta
        lda $01e5,y
        beq @e202
        lda $e5,x
        cmp #$01
        bne @e20e
        stz $e5,x
        bra @e20e
@e202:  lda $e5,x
        ora $e3,x
        bne @e20e
        lda #$01
        sta $e5,x
        stz $e3,x
@e20e:  plp
        plb
        rts
        phb
        php
        shorta
        lda #$7e
        pha
        plb
        stz $73
        lda $6f
        cmp #$01
        beq @e240
        cmp #$02
        beq @e240
        dec3
        longa
        and #$0003
        tax
        shorta
        lda $e0,x
        beq @e283
        cmp #$80
        beq @e283
        sta $73
        lda #$80
        sta $e0,x
        bra @e283
@e240:  dec
        longa
        and #$0001
        tay
        shorta
        lda $01e5,y
        bne @e253
        lda $01e3,y
        beq @e262
@e253:  cmp #$01
        beq @e262
        sta $73
        lda #$00
        sta $01e3,y
        inc
        sta $01e5,y
@e262:  longa
        tya
        inc
        and #$0001
        tax
        shorta
        lda $e5,x
        beq @e27b
        cmp #$01
        beq @e283
        lda #$00
        sta $01e5,y
        bra @e283
@e27b:  lda $e3,x
        bne @e283
        lda #$01
        sta $e5,x
@e283:  plp
        plb
        rts
        phb
        phx
        php
        pea $7e7e
        plb
        plb
        shorta
        stz $90
        cmp #$00
        beq @e2ca
        cmp #$01
        beq @e2ca
        cmp #$80
        beq @e2ca
        ldx $8e
@e2a0:  cmp $0640,x
        beq @e2ad
        inx
        cpx #$0100
        beq @e2b9
        bra @e2a0
@e2ad:  lda $0740,x
        inc
        cmp #$64
        bmi @e2ca
        inc $90
        bra $e2ca
@e2b9:  ldx $8e
@e2bb:  lda $0640,x
        beq @e2ca
        inx
        cpx #$0100
        bne @e2bb
        inc $90
        inc $90
@e2ca:  plp
        plx
        plb
        rts

; ---------------------------------------------------------------------------

; [  ]

_c2e2ce:
_e2ce:  phb
        phx
        php
        pea $7e7e
        plb
        plb
        shorta
        stz $90
        cmp #$00
        beq @e324
        cmp #$01
        beq @e324
        cmp #$80
        beq @e324
        ldx $8e
        cmp $0640,x
        beq @e2f5
        inx
        cpx #$0100
        beq @e305
        bra @e2e8
@e2f5:  xba
        clc
        adc $0740,x
        cmp #$64
        bmi @e300
        lda #$63
@e300:  sta $0740,x
        bra @e324
@e305:  ldx $8e
        pha
@e308:  lda $0640,x
        beq @e315
        inx
        cpx #$0100
        beq @e31f
        bra @e308
@e315:  pla
        sta $0640,x
        xba
        sta $0740,x
        bra @e324
@e31f:  pla
        inc $90
        inc $90
@e324:  plp
        plx
        plb
        rts

; ---------------------------------------------------------------------------

; [  ]

_c2e328:
_e328:  phb
        phx
        php
        pea $7e7e
        plb
        plb
        shorta
        stz $90
        ldx $8e
@e336:  cmp $0640,x
        beq @e343
        inx
        cpx #$0100
        beq @e361
        bra @e336
@e343:  xba
        pha
        sec
        lda $0740,x
        sbc $01,s
        bpl @e350
        pla
        bra @e361
@e350:  sta $0740,x
        pla
        lda $0740,x
        bne @e363
        stz $0640,x
        stz $288a,x
        bra @e363
@e361:  inc $90
@e363:  plp
        plx
        plb
        rts
        php
        longa
        lda $6d
        beq @e394
        ldy $8e
        lda $6b
        beq @e37a
        cmp $6d
        beq @e379
        iny
@e379:  iny
@e37a:  tya
        asl2
        tay
        lda $7e29b6
        and #$000f
        asl2
        tax
        phx
        jsr @e396
        iny2
        plx
        inx2
        jsr @e396
@e394:  plp
        rts
@e396:  lda $c0e9c6,x
        pha
        tyx
        lda $c0e9d6,x
        plx
        sta $7e0000,x
        rts
@e3a6:  phb
        php
        pea $7e7e
        plb
        plb
        shorta
        sta $91
        xba
        sta $92
        lda $92
        beq @e3d4
        lda $91
        beq @e3d4
        jsr _c2e44e
        longa
        lda #$00cf
        sta $0000,x
        inx2
        ldy #$0192
        lda #$0021
        jsr _c2e4ed
        bra @e3e0
@e3d4:  longa
        tyx
        ldy #$ef59
        lda #$c00c
        jsr _c2e59d
@e3e0:  plp
        plb
        rts
@e3e3:  php
        shorta
        lda $7a00,x
        xba
        lda $7b00,x
        xba
        jsr @e3a6
        plp
        rts
        phy
        jsr @e3e3
        ply
        php
        longa
        lda $54
        and #$00ff
        cmp #$0016
        beq @e42a
        lda $91
        and #$00ff
        cmp #$00e0
        bmi @e421
        shorta
        ldx $8e
@e413:  lda $c0eed2,x
        beq @e421
        cmp $91
        beq @e42a
        inx2
        bra @e413
@e421:  tyx
        longa
        lda #$010c
        jsr _c2d6dc
@e42a:  plp
        rts

; ---------------------------------------------------------------------------

; [ draw spell name ]

;  A: spell id
; +Y: destination address

_c2e42c:
_e42c:  php
        longa
        and #$00ff
        pha
        asl
        tax
        lda $7ed400,x   ; pointer to spell name ???
        tyx
        tay
        pla
        cmp #$0057
        bpl $e446
        lda #$d106      ; spells $00-$56: 6 bytes each
        bra @e449
        lda #$d108      ; spells $57-...: 8 bytes each
@e449:  jsr _c2e59d
        rts

; ---------------------------------------------------------------------------

; [ draw item name ]

_c2e44e:
_e44e:  php
        longa
        and #$00ff
        asl
        tax
        lda $7ed200,x   ; pointer to item name ???
        tyx
        tay
        lda #$d109
        jsr _c2e59d
        plp
        rts

; ---------------------------------------------------------------------------

_c2e464:
_e464:  phb
        php
        lda $d8
        jsr _c2e4b2
        lda $da
        and #$0f
        brk $0a
        asl3
        xba
        ora $dc
        sta $0843,x
        plp
        plb
        rts

; ---------------------------------------------------------------------------

; [ get character job data ]

; +$7E: character index
; +$D8: job index
; +$DA: job level (out)
; +$DC: current abp (out)
; +$DE: abp to next level (out)

_c2e47d:
_e47d:  phb
        php
        longa
        lda $d8
        jsr _c2e4b2     ; get pointer to character job data
        lda $0843,x     ; job level/abp
        pha
        and #$0fff      ; abp
        sta $dc
        pla
        xba
        lsr4
        and #$000f
        sta $da
        lda $d8
        asl
        tax
        lda $da
        asl
        clc
        adc $da
        adc $d152c0,x   ; pointers to job ability data
        tax
        lda $d10000,x   ; number of ability points to next level
        sta $de
        plp
        plb
        rts

; ---------------------------------------------------------------------------

; [ get pointer to character job data ]

_c2e4b2:
_e4b2:  php
        longa
        and #$00ff
        pha
        lda $7e
        asl
        tax
        pla
        asl
        clc
        adc $c0ef65,x   ; pointers to character job data (+$0843)
        tax
        plp
        rts

; ---------------------------------------------------------------------------

_c2e4c7:
_e4c7:  php
        longa
        and #$001f
        asl3
        clc
        adc #$5600
        tax
        tyx
        tay
        lda #$d107
        jsr _c2e59d
        plp
        rts

; ---------------------------------------------------------------------------

; [ get pointer to current cursor data ]

_c2e4df:
_e4df:  lda $53         ; current cursor position
        php
        longa
        and #$00ff
        asl3            ; 8 bytes each
        tax
        plp
        rts

; ---------------------------------------------------------------------------

; [  ]

_c2e4ed:
_e4ed:  phb
        pha
        phx
        phy
        php
        longai
        stz $d2
        stz $d4
        stz $d6
        shorta
        xba
        pha
        plb
        xba
        tax
        lsr4
        and #$07
        sta $ce
        txa
        and #$0f
        sta $cd
        txa
        eor #$80
        sta $d1
        ldx $8e
@e515:  lda $0000,y
        phy
        longa
        and #$00ff
        sta $cb
        ldy #$0008
@e523:  lsr $cb
        bcc @e53a
        sed
        clc
        lda $c0f887,x
        adc $d2
        sta $d2
        lda $c0f889,x
        adc $d4
        sta $d4
        cld
@e53a:  inx4
        dey
        bne @e523
        ply
        shorta
        iny
        dec $cd
        bne @e515
        jsr _c2e552
        plp
        ply
        plx
        pla
        plb
        rts

; ---------------------------------------------------------------------------

; [  ]

_c2e552:
_e552:  shorta
        lda #$7e
        pha
        plb
        ldy $d6
        lda #$00
        xba
        lda $ce
        dec
        and #$07
        lsr
        tax
        bcc @e56f
@e566:  lda $d2,x
        lsr4
        jsr @e57f
@e56f:  cpx #$0000
        bne @e576
        stz $d1
@e576:  lda $d2,x
        jsr _c2e57f
        dex
        bpl @e566
        rts
@e57f:  and #$0f
        bne @e58b
        bit $d1
        bpl @e58b
        lda #$ff
        bra @e590
@e58b:  stz $d1
        clc
        adc #$53
@e590:  longa
        and #$00ff
        sta $0000,y
        iny2
        shorta
        rts

; ---------------------------------------------------------------------------

; [ draw text ]

;  A: text length (msb does something)
;  B: source bank
; +Y: source address
; +X: destination address

_c2e59d:
_e59d:  phb
        php
        shorta
        xba
        pha
        plb
        xba
        pha
        and #$7f
        sta $7b         ; length
        stz $7c
        pla
        stz $79
        stz $7a
        and #$80
        sta $7d
        bmi @e5b9
        dec $7a
@e5b9:  shorta
        lda $0000,y
        beq @e5ea
        iny
        bit $7d
        bmi @e5db
        jsr _c2e5ed     ; get dakuten
        pha
        and #$00ff
        sta $7e0000,x
        pla
        xba
        and #$00ff
        sta $7dffc0,x   ; dakuten
        bra @e5e4
@e5db:  longa
        and #$00ff
        sta $7e0000,x
@e5e4:  inx2
        dec $7b
        bne @e5b9
@e5ea:  plp
        plb
        rts

; ---------------------------------------------------------------------------

; [ get dakuten ]

_c2e5ed:
_e5ed:  longa
        and #$00ff
        cmp #$0053
        bpl @e60d
        cmp #$0049
        bpl @e607
        cmp #$0020
        bmi @e60d
        clc
        adc #$5140
        bra @e60f
@e607:  clc
        adc #$5217
        bra @e60f
@e60d:  ora $79
@e60f:  rts

; ---------------------------------------------------------------------------

_c2e610:
_e610:  phb
        php
        pea $7e7e
        plb
        plb
        longa
        sta $85
        lda $85
@e61d:  beq @e650
        cmp #$0001
        beq @e640
        lda $0000,x
        sta $87
        lda $0000,y
        sta $0000,x
        lda $87
        sta $0000,y
        inx2
        iny2
        lda $85
        dec2
        sta $85
        bra @e61d
@e640:  shorta
        lda $0000,x
        xba
        lda $0000,y
        sta $0000,x
        xba
        sta $0000,y
@e650:  plp
        plb
        rts

; ---------------------------------------------------------------------------

; [  ]

_c2e653:
_e653:  lda #$0014
        bra @e65b
        ldx #$0028
@e65b:  php
        longa
        pha
@e65f:  jsr _c2e66f
        lda $0a
        and #$8080
        bne @e66c
        dex
        bne @e65f
@e66c:  pla
        plp
        rts

; ---------------------------------------------------------------------------

; [  ]

_c2e66f:
_e66f:  php
        shorta
        lda #$80
        sta $c9
@e676:  bit $c9
        bmi @e676
        plp
        rts

; ---------------------------------------------------------------------------

; [  ]

_c2e67c:
_e67c:  php
        longa
        lda $54
        and #$00ff
        tax
        shorta
        lda $000973     ; cursor setting (reset/memory)
        and #$04
        bne @e697
@e68f:  lda $c0e9e2,x
        sta $53
        bra @e6a9
@e697:  lda $c0e9f3,x
        beq @e68f
        longa
        and #$00ff
        tax
        shorta
        lda $00,x
        sta $53         ; current cursor position
@e6a9:  plp
        rts

; ---------------------------------------------------------------------------

; [ update cursor sprite ]

_c2e6ab:
_e6ab:  phb
        php
        shorta
        lda #$7e
        pha
        plb
        jsr _c2e4df     ; get pointer to current cursor data
        longa
        lda $7602,x     ; xy position
        sta $0200
        lda #$2e02      ; priority 2, palette 7, tile 2
        sta $0202
        shorta
        lda $7600,x
        sta $54
        lda $7601,x
        sta $55
        jsr _c2fad4     ; copy sprite data to vram
        plp
        plb
        rts

; ---------------------------------------------------------------------------

; [  ]

_c2e6d6:
_e6d6:  jsr _c2ebbd
        jsr _c2e76c
        jsr _c2e9ce
        rts

; ---------------------------------------------------------------------------

; [ update spell levels ]

_c2e6e0:
_e6e0:  phb
        php
        shorta
        lda #$7e
        pha
        plb
        stz $e0         ; clear all spell levels
        stz $e1
        stz $e2
        stz $e3
        stz $e4
        stz $e5
        lda #$04        ; loop through all 4 battle command slots
        sta $e6
        ldy $80
        ldx $8e
@e6fc:  lda $0516,y     ; battle command
        bmi @e746
        cmp #$2c
        bmi @e746
        cmp #$49
        bpl @e72b

; spellblade, white, black, time, summon magic
        sec
        sbc #$2c
        longa
        and #$00ff
        tax
        lda $c0e931,x   ; spell level / spell type (lo/hi nybble)
        and #$000f
        pha
        lda $c0e931,x
        lsr4
        and #$000f
        tax
        pla
        shorta
        bra @e743

@e72b:  cmp #$4c        ; x-magic
        beq @e73f
        bpl @e746

; red magic
        sec
        sbc #$48        ; red mage spell level
@e734:  ldx #$0001      ; white
        jsr $e765
        ldx #$0002      ; black
        bra @e743

; x-magic
@e73f:  lda #$03        ; use spell level 3 (black and white)
        bra @e734
@e743:  jsr _c2e765
@e746:  iny             ; next command slot
        dec $e6
        bne @e6fc
        ldy $80
        ldx $8e
@e74f:  lda $e0,x
        asl4
        ora $e1,x
        sta $053d,y     ; spell level
        iny
        inx2
        cpx #$0006
        bne @e74f
        plp
        plb
        rts

; ---------------------------------------------------------------------------

; [ set spell level ]

_c2e765:
_e765:  cmp $e0,x       ; use highest level found so far
        bmi @e76b
        sta $e0,x
@e76b:  rts

; ---------------------------------------------------------------------------

; [ update character properties ]

_c2e76c:
_e76c:  phb
        php
        shorta
        lda #$7e
        pha
        plb
        jsr _c2e973
        jsr _c2e933
        jsr _c2e879
        jsr _c2d4c5
        jsr _c2e178
        jsr _c2e7b3
        jsr _c2e7cc
        ldy $80
        longa
        lda $eb         ; update stats
        sta $0528,y
        lda $ed
        sta $052a,y
        lda $f2
        sta $052c,y
        lda $f4
        sta $052e,y
        lda $f6         ; update attack power
        sta $0544,y
        shorta
        lda $f1         ; update equipment weight
        sta $0523,y
        jsr _c2e6e0     ; update spell levels
        plp
        plb
        rts

; ---------------------------------------------------------------------------

; [  ]

_c2e7b3:
_e7b3:  php
        ldx $80
        longa
        lda $000524,x   ; get base stats
        sta $e7
        lda $000523,x
        sta $e9
        lda $000520,x
        sta $ef
        plp
        rts

; ---------------------------------------------------------------------------

; [  ]

_c2e7cc:
_e7cc:  phb
        php
        shorta
        stz $f1
        stz $f2
        stz $f3
        stz $f4
        stz $f5
        ldx $8e
@e7dc:  lda $e0,x
        phx
        jsr _c2d9ab
        txy
        plx
        lda $9c
        clc
        adc $f1
        sta $f1
        lda $a1
        clc
        adc $f2
        sta $f2
        lda $a2
        clc
        adc $f3
        sta $f3
        lda $a3
        clc
        adc $f4
        sta $f4
        lda $a4
        clc
        adc $f5
        sta $f5
        inx
        cpx #$0005
        bne @e7dc
        stz $f8
        lda $f0
        and #$20
        beq @e827
        lda $e3
        ora $e4
        bne @e827
        lda $e5
        beq @e823
        lda $e6
        bne @e827
@e823:  lda #$80
        sta $f8
@e827:  stz $f6
        stz $f7
        ldx $8e
@e82d:  lda $e5,x
        phx
        jsr _c2d9ab
        txy
        plx
        lda $a2
        sta $f6,x
        bit $9f
        bvc @e845
        lda $f8
        bpl @e845
        ora #$01
        sta $f8
@e845:  inx
        cpx #$0002
        bne @e82d
        shorta
        lda $e5
        cmp #$01
        bne @e85b
        lda $e6
        cmp #$01
        bne @e85b
        stz $f7
@e85b:  lda $f6
        clc
        adc $f7
        sta $f6
        lda $8e
        rol
        and #$01
        sta $f7
        lda $f8
        cmp #$81
        bne @e873
        asl $f6
        rol $f7
@e873:  jsr _c2ec76
        plp
        plb
        rts
        phb
        php
        shorta
        stz $e0
        stz $e1
        stz $e2
        stz $e3
        stz $e4
        stz $e5
        stz $e6
        stz $e7
        jsr _c2d4c5
        lda #$05
        sta $85
        ldx $80
@e896:  phx
        lda $00050e,x
        jsr _c2d9ab
        lda $9e
        bmi @e8a4
        tsb $e0
@e8a4:  lda $a0
        tsb $e2
        lda $a5
        longa
        and #$00ff
        pha
        asl2
        clc
        adc $01,s
        tax
        pla
        lda $d12580,x
        tsb $e3
        lda $d12582,x
        tsb $e5
        shorta
        lda $d12584,x
        tsb $e7
        plx
        inx
        dec $85
        bne @e896
        ldx $80
        lda #$02
        sta $85
@e8d7:  lda $000513,x
        phx
        jsr _c2d9ab
        plx
        lda $9e
        bmi @e8e6
        tsb $e0
@e8e6:  lda $a0
        tsb $e1
        inx
        dec $85
        bne @e8d7
        shorta
        lda #$7e
        pha
        plb
        ldy $80
        lda $e0
        sta $0522,y
        phy
        ldx $8e
@e8ff:  lda $e3,x
        sta $0530,y
        inx
        iny
        cpx #$0005
        bne @e8ff
        ply
        longa
        lda $e1
        sta $0538,y
        plp
        plb
        rts

; ---------------------------------------------------------------------------

; [ get job innate abilities ]

_c2e916:
_e916:  phy
        phx
        and #$001f
        cmp #$0014
        bmi @e92a       ; branch if not mimic or freelancer
        ldy $80
        lda $054e,y
        and #$f7ff
        bra @e930
@e92a:  asl
        tax
        lda $d157b8,x   ; innate abilities
@e930:  plx
        ply
        rts

; ---------------------------------------------------------------------------

; [  ]

_c2e933:
_e933:  phb
        php
        pea $7e7e
        plb
        plb
        longa
        jsr _c2a4c5
        ldy $80
        lda $0501,y
        jsr _c2e916     ; get job innate abilities
        sta $ef
        lda #$0004
        sta $85
@e94e:  shorta
        lda $0516,y     ; battle command
        longa
        bpl @e962
        and #$007f
        asl
        tax
        lda $d1638c,x
        tsb $ef
@e962:  iny
        dec $85
        bne @e94e
        ldy $80
        longa
        lda $ef
        sta $0520,y
        plp
        plb
        rts

; ---------------------------------------------------------------------------

; [  ]

_c2e973:
_e973:  phb
        php
        pea $7e7e
        plb
        plb
        longa
        jsr _c2d4c5
        ldy $80
        lda $0501,y
        and #$001f
        asl2
        tax
        lda $d15708,x
        sta $e0
        lda $d1570a,x
        sta $e2
        lda #$0004
        sta $85
@e99b:  shorta
        lda $0516,y
        bpl @e9b8
        longa
        and #$007f
        asl2
        tax
        lda $d163ce,x
        tsb $e0
        lda $d163d0,x
        tsb $e2
        shorta
@e9b8:  iny
        dec $85
        bne @e99b
        ldy $80
        longa
        lda $e0
        sta $0540,y
        lda $e2
        sta $0542,y
        plp
        plb
        rts

; ---------------------------------------------------------------------------

; [  ]

_c2e9ce:
_e9ce:  phb
        php
        pea $7e7e
        plb
        plb
        jsr _c2d4c5
        longa
        ldy $80
        lda $0502,y
        and #$00ff
        dec
        asl
        tax
        lda $d15129,x
        sta $e0
        stz $e2
        shorta
        lda $0526,y
        sta $e9
        jsr _c2eaac
        lda $e0
        and #$ff
        adc $2710c9,x
        bmi $ea04
        lda #$0f
        and [$99]
        php
        ora $bf
        sbc $85d151
        cpx #$e264
        shorta
        lda $0527,y
        sta $e9
        jsr _c2eaac
        lda $e0
        and #$ff
        adc $03e8c9,x
        bmi $ea26
        lda #$e7
        ora $99,s
        tsb $a405
        bra $e9e7
        shorta
        lda #$04
        sta $85
@ea32:  lda $0516,y
        cmp #$8b
        beq @ea4b
        cmp #$8c
        beq @ea4b
        cmp #$8d
        beq @ea4b
        cmp #$8e
        beq @ea68
        cmp #$8f
        beq @ea68
        bra @ea68
@ea4b:  sec
        sbc #$8a
        sta $e8
        longa
        lda $0508,x
        jsr _c2eaee
        and #$7fff
        cmp #$2710
        bmi @ea63
        lda #$270f
@ea63:  sta $0508,x
        bra @ea88
@ea68:  sec
        sbc #$8d
        cmp #$02
        bne @ea70
        inc
@ea70:  sta $e8
        longa
        lda $050c,x
        jsr _c2eaee
        and #$7fff
        cmp #$03e8
        bmi @ea85
        lda #$03e7
@ea85:  sta $050c,x
@ea88:  shorta
        iny
        dec $85
        bne @ea32
        longa
        ldx $80
        lda $0508,x
        cmp $0506,x
        bpl @ea9e
        sta $0506,x
@ea9e:  lda $050c,x
        cmp $050a,x
        bpl @eaa9
        sta $050a,x
@eaa9:  plp
        plb
        rts
        lda $e0
        sta $00211b
        lda $e1
        sta $00211b
        lda $e9
        clc
        adc #$20
        sta $00211c
        sta $00211c
        longa
        lda $002134
        sta $e0
        lda $002136
        and #$00ff
        sta $e2
        asl $e0
        rol $e2
        asl $e0
        rol $e2
        asl $e0
        rol $e2
        lda $e1
        sta $e0
        lda $e3
        and #$00ff
        sta $e2
        rts
        php
        longa
        sta $e0
        stz $e2
        shorta
        lda $e8
        asl3
        clc
        adc $e8
        adc $e8
        sta $e8
        stz $e4
        stz $e5
        stz $e6
        stz $e7
        lda $e0
        sta $00211b
        lda $e1
        sta $00211b
        lda $e8
        sta $00211c
        sta $00211c
        lda $002135
        sta $004204
        lda $002136
        sta $004205
        lda #$64
        sta $004206
        nop8
        lda $004214
        sta $e5
        lda $004215
        sta $e6
        lda $002134
        sta $004204
        lda $004216
        sta $004205
        lda #$64
        sta $004206
        nop8
        lda $004214
        sta $e4
        longa
        lda $e0
        clc
        adc $e4
        sta $e0
        lda $e2
        adc $e6
        sta $e2
        lda $e0
        plp
        rts

; ---------------------------------------------------------------------------

; [  ]

_c2eb82:
_eb82:  phb
        php
        pea $7e7e
        plb
        plb
        longa
        ldy $80
        lda $0501,y     ; job
        and #$001f
        pha
        asl2
        tax
        pla
        jsr _c2e916     ; get job innate abilities
        sta $0520,y     ; innate abilities
        lda $d15760,x
        sta $0516,y     ; battle commands
        lda $d15762,x
        sta $0518,y
        lda $d15708,x
        sta $0540,y     ; equipment types
        lda $d1570a,x
        sta $0542,y
        plp
        plb
        rts

; ---------------------------------------------------------------------------

; [  ]

_c2ebbd:
_ebbd:  phb
        php
        shorta
        lda #$7e
        pha
        plb
        jsr _c2d4c5
        stz $e7
        stz $e8
        stz $e9
        stz $ea
        lda #$d1
        sta $84
        lda #$04
        sta $85
        ldx $80
@ebda:  lda $0516,x
        pha
        bmi @ebe5
        ldy #$5e00
        bra @ebe8
@ebe5:  ldy #$6308
@ebe8:  sty $82
        pla
        and #$7f
        jsr _c2ec54
        inx
        dec $85
        bne @ebda
        ldy #$56b0      ; D1/56B0 (job stat modifiers)
        sty $82
        lda #$d1
        sta $84
        ldx $80
        lda $0501,x
        and #$1f
        cmp #$14
        bmi @ec18       ; branch if not mimic or freelancer
        longa
        txa
        clc
        adc #$054a
        sta $82
        shorta
        stz $84
        lda #$00
@ec18:  jsr _c2ec54
        ldy #$551e      ; D1/551E (character stat modifiers)
        sty $82
        lda #$d1
        sta $84
        longa
        lda $0500,x     ; character index
        and #$0007
        asl2
        tay
        shorta
        ldx $8e
@ec33:  lda [$82],y
        clc
        adc $e7,x
        sta $e7,x
        iny
        inx
        cpx #$0004
        bne @ec33
        ldx $8e
        ldy $80
@ec45:  lda $e7,x
        sta $0524,y
        iny
        inx
        cpx #$0004
        bne @ec45
        plp
        plb
        rts

; ---------------------------------------------------------------------------

; [ apply stat bonus ]

_c2ec54:
_ec54:  phx
        phy
        php
        longa
        and #$00ff
        asl2
        tay
        shorta
        ldx $8e
@ec63:  lda [$82],y
        cmp $e7,x
        bmi @ec6b       ; branch if less than current bonus
        sta $e7,x
@ec6b:  iny
        inx
        cpx #$0004
        bne @ec63
        plp
        ply
        plx
        rts

; ---------------------------------------------------------------------------

; [  ]

_c2ec76:
_ec76:  phb
        php
        shorta
        stz $eb
        stz $ec
        stz $ed
        stz $ee
        ldx $8e
@ec84:  lda $e0,x
        phx
        jsr _c2d9ab
        plx
        lda $9e
        bpl @ecbd
        phx
        pha
        longa
        and #$0007
        asl
        tax
        lda $d12880,x
        sta $f9
        shorta
        pla
        and #$78
        asl
        ldx $8e
@eca6:  asl
        xba
        bcc @ecae
        lda $fa
        bra @ecb0
@ecae:  lda $f9
@ecb0:  clc
        adc $eb,x
        sta $eb,x
        xba
        inx
        cpx #$0004
        bne @eca6
        plx
@ecbd:  inx
        cpx #$0007
        bne @ec84
        ldx $8e
@ecc5:  lda $e7,x
        clc
        adc $eb,x
        bpl @ecce
        lda #$00
@ecce:  sta $eb,x
        inx
        cpx #$0004
        bne @ecc5
        plp
        plb
        rts
        pea $7e7e
@ecd9:  plb
        plb
        longa
        stz $75
        ldy $80
        lda $0540,y
        sta $e0
        lda $0542,y
        sta $e2
        stz $e6
        stz $e8
        rts
@ecf3:  ldy $8e
@ecf5:  longa
        lda $0740,y
        and #$00ff
        beq @ed47
        sta $e8
        lda $0640,y
        and #$00ff
        sta $e6
        cmp $93
        bmi @ed47
        cmp $95
        bpl @ed47
        jsr _c2d9ab
        lda $e4
        bmi @ed1e
        lda $9b
        and $e4
        beq @ed47
@ed1e:  lda $9d
        and #$003f
        asl2
        tax
        lda $d12480,x   ; item equipment types
        and $e0
        bne @ed36
        lda $d12482,x
        and $e2
        beq @ed47
@ed36:  shorta
        ldx $75
        lda $e6
        sta $7a00,x
        lda $e8
        sta $7b00,x
        inx
        stx $75
@ed47:  iny
        cpy #$0100
        bne @ecf5
        shorta
        ldx $75
@ed51:  stz $7a00,x
        stz $7b00,x
        inx
        cpx #$0100
        bne @ed51
        rts
        phb
        php
        jsr @ecd9
        lda #$89
        brk $85
        sta ($a9,s),y
        cpx #$8500
        sta $e2,x
        jsr _c26fa5
        dec3
        longa
        and #$0003
        asl
        tax
        lda $c0f5c9,x
        sta $e4
        jsr @ecf3
        plp
        plb
        rts
        phb
        php
        jsr @ecd9
        lda #$02
        brk $85
        sta ($a9,s),y
        bra @ed94
@ed94:  sta $95
        lda #$00
        bra $ed1f
        cpx $20
        sbc ($ec,s),y
        longa
        lda #$0080
        sta $93
        lda #$00e0
        sta $95
        lda #$0008
        sta $e4
        jsr _c2ecf3
        plp
        plb
        rts

_c2edb5:
        ldy $8e
@edb7:  shorta
        lda $7a00,y
        beq @edd2
        jsr _c2d9ab
        lda $a2
        sta $7e00,y
        cpy $75
        beq @edd2
        cpy #$00ff
        beq @edd2
        iny
        bra @edb7
@edd2:  rts
@edd3:  longa
        ldx #$0100
@edd8:  dex2
        stz $7f00,x
        bne @edd8
        shorta
        ldy $8e
@ede3:  lda $7a00,y
        beq @ee02
        lda $7e00,y
        longa
        and #$00ff
        tax
        shorta
        inc $7f00,x
        cpy $75
        beq @ee02
        cpy #$00ff
        beq @ee02
        iny
        bra @ede3
@ee02:  rts
        shorta
        ldy #$00fe
@ee08:  lda $7f00,y
        clc
        adc $7f01,y
        sta $7f00,y
        cpy #$0000
        beq @ee1a
        dey
        bra @ee08
@ee1a:  rts
        shorta
        ldy $8e
@ee1f:  lda $7a00,y
        beq @ee62
        lda $7e00,y
        beq @ee56
        cmp #$ff
        bne @ee32
        ldx #$0000
        bra @ee40
@ee32:  inc
        longa
        and #$00ff
        tax
        lda $7f00,x
        and #$00ff
        tax
@ee40:  shorta
@ee42:  lda $8000,x
        beq @ee4a
        inx
        bra @ee42
@ee4a:  lda $7a00,y
        sta $8000,x
        lda $7b00,y
        sta $8100,x
@ee56:  cpy $75
        beq @ee62
        cpy #$00ff
        beq @ee62
        iny
        bra @ee1f
@ee62:  rts

_c2ee63:
        longa
        lda $7f01
        and #$00ff
        tax
        shorta
        ldy $8e
@ee70:  lda $7a00,y
        beq @ee93
        lda $7e00,y
        bne @ee87
        lda $7a00,y
        sta $8000,x
        lda $7b00,y
        sta $8100,x
        inx
@ee87:  cpy $75
        beq @ee93
        cpy #$00ff
        beq @ee93
        iny
        bra @ee70
@ee93:  rts
        phb
        php
        shorta
        lda #$7e
        pha
        plb
        longa
        ldx #$0400
@eea1:  dex2
        stz $7e00,x
        bne @eea1
        jsr _c2edb5
        jsr @edd3
        jsr _c2ee03
        jsr _c2ee1b
        jsr _c2ee63
        longa
        ldx #$8000
        ldy #$7a00
        lda #$01ff
        mvn $7e,$7e
        plp
        plb
        rts
        phb
        pea $7e7e
        plb
        plb
        stx $f2
        sty $f4
        lda #$04
        sta $f6
        ldy $8e
        sec
@eed9:  lda ($f2),y
        sbc ($f4),y
        sta $281d,y
        iny
        dec $f6
        bne @eed9
        plb
        rts
        phb
        php
        longa
        and #$000f
        asl
        tax
        lda $c0f208,x
        jsr _c2c1b8
        jsr _c2a698
        plp
        plb
        rts
        jsr _c2efc5
        jsr _c2ef16
        jsr _c2fad4     ; copy sprite data to vram
        jsr _c2e658
        jsr _c2ef89
        jsr _c2ef16
        jsr _c2fad4     ; copy sprite data to vram
        jsr _c2e66f
        rts
        phb
        php
        pea $7e7e
        plb
        plb
        longa
        stz $f1
        stz $7e
@ef23:  jsr _c2d4c5
        ldx $80
        lda $0500,x
        and #$0040
        bne @ef75
        lda $0540,x
        sta $eb
        lda $0542,x
        sta $ed
        lda $55
        dec
        and #$000f
        asl2
        tay
        lda $eb
        and $285e,y
        bne @ef53
        lda $ed
        and $2860,y
        bne @ef53
        bra @ef75
@ef53:  lda $7e
        asl3
        tay
        lda $0240,y
        sec
        sbc #$000c
        sta $0240,y
        lda $0244,y
        sec
        sbc #$000c
        sta $0244,y
        ldx $7e
        lda $c0f204,x
        tsb $f1
@ef75:  lda $7e
        inc
        sta $7e
        cmp #$0004
        bne @ef23
        shorta
        lda $f1
        sta $2886
        plp
        plb
        rts

_c2ef89:
        phb
        php
        longa
        ldx #$f4b4
        ldy #$0240
        lda #$001f
        mvn $7e,$c0
        jsr _c2ef9f
        plp
        plb
        rts

_c2ef9f:
        .a16
        stz $7e
@efa1:  jsr _c2d4c5
        ldy $80
        lda $7e
        asl3
        tax
        lda $0500,y
        and #$0040
        beq @efba
        stz $0242,x
        stz $0246,x
@efba:  lda $7e
        inc
        sta $7e
        cmp #$0004
        bne @efa1
        rts

_c2efc5:
        phb
        php
        longa
        and #$0001
        inc
        asl
        tax
        lda $c0f4ae,x
        tax
        ldy #$0240
        lda #$001f
        mvn $7e,$c0
        jsr _c2ef9f
        plp
        plb
        rts

; ---------------------------------------------------------------------------

; [  ]

_c2efe3:
_efe3:  phb
        php
        pea $7e7e
        plb
        plb
        lda $2809
        jsr _c2f00b     ; give spell
        ldx $8e
@eff2:  lda $d12890,x
        beq @f008
        cmp $2809
        beq @f001
        inx2
        bra @eff2
@f001:  lda $d12891,x
        jsr _c2f00b     ; give spell
@f008:  plp
        plb
        rts

; ---------------------------------------------------------------------------

; [ give spell ]

_c2f00b:
_f00b:  phx
        php
        shorta
        jsr _c2f01d
        ora $000950,x   ; known spells
        sta $000950,x
        plp
        plx
        rts

; ---------------------------------------------------------------------------

_c2f01d:
_f01d:  php
        phy
        longa
        and #$00ff
        pha
        lsr3
        tax
        pla
        and #$0007
        tay
        shorta
        lda #$80
@f032:  cpy #$0000
        beq @f03b
        dey
        lsr
        bra $f032
@f03b:  ply
        plp
        rts

; ---------------------------------------------------------------------------

; [  ]

_c2f03e:
_f03e:  phb
        php
        pea $7e7e
        plb
        plb
        shorta
        stz $2811
        stz $2812
        stz $2813
        lda $2809
        longa
        and #$00ff
        jsr _c2f01d
        shorta
        and $0950,x     ; spells known
        beq @f065       ; branch if spell is not known
        inc $2811
@f065:  lda #$01
        sta $2814
        jsr _c2f0e6
        plp
        plb
        rts

; ---------------------------------------------------------------------------

; [  ]

_c2f070:
_f070:  phb
        php
        pea $7e7e
        plb
        plb
        shorta
        lda $2809
        ldx $8e
@f07e:  cmp $0640,x     ; item index
        beq @f08b
        inx
        cpx #$0100
        beq @f093
        bra @f07e
@f08b:  lda $0740,x     ; item quantity
        sta $2811
        bra @f096
@f093:  stz $2811
@f096:  stz $2812
        ldy $8e
@f09b:  sty $7e
        jsr _c2d4c5
        ldx $80
        bit $0500,x
        bvs @f0bb       ; branch if character is not present
        phy
        ldy #$0007
@f0ab:  lda $050e,x
        cmp $2809
        bne @f0b6
        inc $2812
@f0b6:  inx
        dey
        bne @f0ab
        ply
@f0bb:  iny
        cpy #$0004
        bne @f09b
        lda #$63
        sec
        sbc $2811
        sbc $2812
        bpl @f0ce
        lda #$00
@f0ce:  sta $2813
        lda $2805
        bpl @f0db
        lda #$01
        sta $2813
@f0db:  lda #$01
        sta $2814
        jsr _c2f0e6
        plp
        plb
        rts

; ---------------------------------------------------------------------------

; [  ]

_c2f0e6:
_f0e6:  php
        shorta
        lda $7e2814
        sta $e0
        longa
        lda $7e280c
        sta $e1
        lda $7e280e
        sta $e3
        jsr _c2f2fb
        lda $e5
        sta $7e2819
        lda $e7
        sta $7e281b
        plp
        rts

; ---------------------------------------------------------------------------

; [  ]

_c2f10e:
_f10e:  phb
        php
        pea $7e7e
        plb
        plb
        shorta
        ldy $8e
@f119:  tya
        asl
        tax
        lda $c0f1f4,x
        tax
        lda $2826,y
        and #$00ff
        beq @f158
        phy
        phx
        txy
        bit $2802
        bmi @f136
        jsr _c2e44e     ; draw item name
        bra @f139
@f136:  jsr _c2e42c     ; draw spell name
@f139:  pla
        clc
        adc #$0014
        tax
        lda #$01,s
        and #$000f
        asl2
        clc
        adc #$282e
        tay
        lda #$7e73
        jsr _c2e4ed
        ply
        iny
        cpy #$0008
        bne @f119
@f158:  plp
        plb
        rts

; ---------------------------------------------------------------------------

; [ draw shop type name ]

_c2f15b:
_f15b:  phb
        php
        pea $7e7e
        plb
        plb
        longa
        lda $2801       ; shop type
        and #$0007
        asl3
        clc
        adc #$2d00      ; D1/2D00 (shop type names)
        tay
        ldx #$50c4
        lda #$d105
        jsr _c2e59d
        bit $2802
        bmi @f18c
        ldx #$51ce
        ldy #$f514
        lda #$c002
        jsr _c2e59d
@f18c:  plp
        plb
        rts

; ---------------------------------------------------------------------------

; [ load shop properties ]

_c2f18f:
_f18f:  phb
        php
        shorta
        lda #$7e
        pha
        plb
        lda $2800       ; shop index
        longa
        and #$00ff
        pha
        asl3            ; multiply by 9
        clc
        adc $01,s
        tax
        pla
        shorta
        lda $d12d40,x   ; shop properties
        sta $2801       ; shop type
        inx
        txy
        and #$07
        xba
        lda #$00
        xba
        tax
        lda $c0f1ec,x
        pha
        xba
        pla
        longa
        sta $2802
        tya
        clc
        adc #$2d40      ; pointer to items
        tax
        ldy #$2826      ; copy to 7E/2826
        lda #$0007      ; copy 8 bytes
        mvn $7e,$d1
        shorta
        lda $2802
        sta $2825
        ldx $8e
@f1df:  shorta
        lda $2826,x     ; item index
        sta $2809
        jsr _c2f29f     ; get item price
        longa
        txa
        asl
        tay
        lda $280a       ; item price
        sta $284e,y
        lda $2801
        and #$0080
        beq @f212       ; branch if no discount
        shorta
        bit $2805
        longa
        bpl @f20c
        lsr $280e       ; divide price by 4
        ror $280c
@f20c:  lsr $280e       ; divide price by 2
        ror $280c
@f212:  txa
        asl2
        tay
        lda $280c
        sta $282e,y
        lda $280e
        sta $2830,y
        inx
        cpx #$0008
        bne @f1df
        ldx $8e
@f22a:  stz $285e,x
        stz $2860,x
        inx4
        cpx #$0020
        bne @f22a
        lda $2801
        and #$0007
        beq @f29c       ; branch if a magic shop
        ldy $8e
@f243:  longa
        lda $2826,y
        jsr _c2d9ab
        lda $2826,y
        and #$00ff
        beq @f290
        cmp #$00e0
        shorta
        bpl @f283
        lda $9d
        longa
        and #$003f
        asl2
        tax
        phy
        tya
        asl2
        tay
        lda $d12480,x   ; item equipment types
        sta $285e,y
        lda $d12482,x
        sta $2860,y
        ply
        shorta
        lda $9f
        and #$3f
        clc
        adc #$00
        bra @f287
@f283:  lda $9e
        and #$3f
@f287:  sta $287e,y
        iny
        cpy #$0008
        bne @f243
@f290:  tyx
@f291:  cpx #$0008
        beq @f29c
        stz $287e,x
        inx
        bra @f291
@f29c:  plp
        plb
        rts

; ---------------------------------------------------------------------------

; [ get item price ]

_c2f29f:
_f29f:  phb
        phx
        php
        pea $7e7e
        plb
        plb
        longa
        lda $2800
        and #$00ff
        asl
        tax
        lda $2825
        and #$0080
        bne @f2bf
        lda $d12a00,x   ; item price
        bra @f2c3
@f2bf:  lda $d12c00,x   ; spell price
@f2c3:  sta $280a
        jsr _c2f2cd
        plp
        plx
        plb
        rts

; ---------------------------------------------------------------------------

; [  ]

_c2f2cd:
_f2cd:  php
        shorta
        lda $280b
        sta $e0
        lda $280a
        longa
        and #$001f
        asl2
        tax
        lda $c0f517,x   ; price multiplier
        sta $e1
        lda $c0f519,x
        sta $e3
        jsr _c2f2fb     ; multiply
        lda $e5
        sta $280c       ; set item price
        lda $e7
        sta $280e
        plp
        rts

; ---------------------------------------------------------------------------

_c2f2fb:
_f2fb:  php
        longa
        stz $e5
        stz $e7
        shorta
        lda $e0
        sta $004202
        ldx $8e
@f30c:  shorta
        lda $e1,x
        sta $004203
        nop3
        longa
        lda $004216
        clc
        adc $e5,x
        sta $e5,x
        inx
        cpx #$0003
        bne @f30c
        plp
        rts
        phb
        php
        lda $2bf4
        bne $f393
        lda #$9e
        lda $20,x
        clv
        cmp ($a6,x)
        inc $a0
        tsb $2c
        lda #$06
        ror $9d20,x
        sbc $a5
        inc $18
        adc #$34
        brk $aa
        ldy #$2bf6
        lda #$21
        ror $ed20,x
        cpx $a5
        inc $18
        adc #$a6
        brk $aa
        ldy #$2bf8
        jsr _c2d5db
        lda $e6
        clc
        adc #$80
        brk $aa
        ldy #$2c0c
        jsr _c2d662
        lda $2c0a
        asl3
        tax
        lda $2c12
        sta $7362,x
        lda $e6
        sec
        sbc #$82
        brk $aa
        lda $2c0a
        inc4
        xba
        and #$00
        ora [$09]
        cpy #$2080
        jml [$80d6]
        asl $a9
        lda ($b5),y
        jsb _c2c1b8
        plp
        plb
        rts
        phb
        php
        pea $7e7e
        plb
        plb
        longa
        ldx $8e
        ldy #$2c14
@f3aa:  phx
        phy
        lda $c0f3c5,x
        sta $e6
        tyx
        ldy #$2bf4
        lda #$001f
        mvn $7e,$7e
        jsr _c2f32a
        ply
        plx
        inx2
        tya
        clc
        adc #$0020
        tay
        cpx #$0008
        bne @f3aa
        plp
        plb
        rts
        and #$0f
        brk $3a
        and #$03
        brk $eb
        lsr3
        rts
        asl
        pha
        lda $0293,x
        and #$f1
        ora $01,s
        sta $0293,x
        sta $0297,x
        pla
        inx8
        rts
        phb
        php
        pea $7e7e
        plb
        plb
        longa
        lda $52
        and #$00ff
        cmp #$0009
        beq @f41a
        jsr _c2f3d1
        tax
        shorta
        ldy #$0004
@f412:  lda #$06
        jsr _c2f3dd
        dey
        bne @f412
@f41a:  longa
        lda $55
        jsr _c2f3d1
        tay
        pha
        stz $85
@f425:  lda $2c1c,y
        and #$1f07
        phy
        ldy $85
        jsr _c2d492
        ply
        iny2
        lda $85
        inc
        sta $85
        cmp #$0004
        bne @f425
        plx
        shorta
        ldy $8e
@f443:  tya
        jsr _c2f3dd
        iny
        cpy #$0004
        bne @f443
        plp
        plb
        rts
        phb
        php
        longa
        ldx #$f907
        ldy #$0290
        lda #$007f
        mvn $7e,$c0
        plp
        plb
        rts
        phb
        php
        pea $7e7e
        plb
        plb
        longa
        ldx #$1800
        lda $8e
@f471:  sta $affe,x
        dex2
        bne @f471
        stz $f6
@f47a:  lda $f6
        asl5
        tay
        lda $2c14,y
        bne @f4c1
        lda $f6
        asl
        tax
        lda $c0f8ff,x
        sta $e4
        lda #$0004
        sta $85
@f496:  lda $2c1c,y
        bit #$0040
        bne @f4b3
        and #$1f07
        sta $ea
        phy
        phb
        jsr _c2d2db
        lda #$0006
        ldx #$ed31
        jsr _c2d304
        plb
        ply
@f4b3:  iny2
        lda $e4
        clc
        adc #$0040
        sta $e4
        dec $85
        bne @f496
@f4c1:  lda $f6
        inc
        sta $f6
        cmp #$0004
        bne @f47a
        ldx #$efd9
        jsr _c2d9fb
        plp
        plb
        rts
        phb
        php
        pea $3030
        plb
        plb
        longa
        stz $f6
@f4df:  jsr _c2f4ef
        lda $f6
        inc
        sta $f6
        cmp #$0004
        bne @f4df
        plp
        plb
        rts
        lda $f6
        asl
        tax
        lda $c0f8e7,x
        clc
        adc #$00
        rts
        sta $fc
        tax
        lda $044a,x
@f501:  sta $f8
        lda $044c,x
        sta $fa
        lda $0490,x
        sta $f0
        lda $0492,x
        sta $f2
        lda $0494,x
        sta $f4
        lda $0471,x
        sta $fe
        jsr @f561
        ldy $fc
        ldx $8e
@f523:  lda $0000,y
        sta $e8,x
        and #$07
        brk $d0
        ora $0002b9
        sta $e2
        lda $0006,y
        sta $e4
        lda $0008,y
        sta $e6
        tya
        clc
        adc #$50
        brk $a8
        inx2
        cpx #$0008
        bne @f523
        lda $f6
        and #$03
        brk $0a
        tax
        lda $c0f8f7,x
        tay
        ldx #$01e0
        lda #$1f
        brk $8b
        mvn $7e,$00
        plb
        rts
@f561:  lda $f6
        and #$03
        brk $0a
        tax
        lda $7ff8,x
        cmp #$1b
        cpx $d0
        ora $8820
        sbc $dd,x
        beq $f5f5
        bne $f582
        lda #$00
        brk $80
        php
        lda #$00
        bra @f501
        ora $a9,s
        brk $40
        sta $e0
        rts
        phb
        phx
        phy
        php
        pea $3030
        plb
        plb
        longa
        ldx $fc
        ldy #$0600
        lda $8e
        clc
@f59b:  adc $0000,x
        inx2
        dey2
        bne @f59b
        plp
        ply
        plx
        plb
        rts

; ---------------------------------------------------------------------------

; [ update mono/stereo setting ]

_c2f5a9:
_f5a9:  php
        shorta
        lda $000973
        and #$02
        lsr
        clc
        adc #$f3        ; $F3 = stereo, $F4 = mono
        sta $001d00
        jsl $c40004
        plp
        rts

; ---------------------------------------------------------------------------

_c2f5c0:
_f5c0:  phb
        php
        pea $7e7e
        plb2
        longa
        stz $85
        sta $7e
@f5cd:  lda $7e
        asl
        tax
        lda $c0ea0e,x
        sta $2bba
        jsr _c2d4c5
        jsr _c2ddd7
        ldx $80
        lda $0500,x
        and #$0040
        beq @f5f2
        lda $85
        clc
        adc #$0004
        sta $85
        bra @f631
@f5f2:  txa
        clc
        adc #$0516
        sta $82
        ldx $8e
@f5fb:  phx
        lda $c0ea16,x
        clc
        adc $2bba
        pha
        ldx $85
        lda $2cb4,x
        inx
        stx $85
        and #$0003
        tay
        lda ($82),y
        and #$00ff
        plx
        phx
        pha
        jsr _c2d8e4
        pla
        plx
        cmp #$0080
        bmi @f629
        lda #$0108
        jsr _c2d6dc
@f629:  plx
        inx2
        cpx #$0008
        bne @f5fb
@f631:  inc $7e
        lda $85
        cmp #$0010
        bne @f5cd
        plp
        plb
        rts
        phb
        php
        pea $7e7e
        plb
        plb
        shorta
        ldx #$002f
@f649:  stz $2c9b,x
        dex
        bne @f649
        longa
        lda $8e
        shorta
        ldx $8e
@f657:  phx
        lda $c0f0a5,x
        tay
        lda $c0f0a7,x
        pha
        lda $c0f0a6,x
        tax
        pla
        and $0970,y
        beq @f670
        inc $2c9c,x
@f670:  plx
        inx3
        cpx #$0018
        bne @f657
        shorta
        lda $0970
        pha
        and #$07
        sta $2c9d
        pla
        lsr4
        and #$07
        sta $2c9e
        longa
        lda $0971
        ldx $8e
@f695:  jsr _c2f709
        cpx #$0003
        bne @f695
        ldx #$0975
        ldy #$2ca9
        lda #$001a
        mvn $7e,$7e
        jsr _c2f6af
        plp
        plb
        rts
        phb
        php
        pea $7e7e
        plb
        plb
        shorta
        ldx $8e
@f6ba:  ldy $8e
        lda $2ca9,x
@f6bf:  asl
        bcs $f6c9
        iny
        cpy #$0006
        bmi @f6bf
        dey
        tya
        sta $2cc4,x
        inx
        cpx #$0007
        bmi @f6ba
        plp
        plb
        rts
        phb
        php
        pea $7e7e
        plb
        plb
        shorta
        ldx $8e
@f6e1:  ldy $8e
        lda $2cc4,x
        xba
        lda #$80
        xba
@f6ea:  cmp #$00
        beq @f6fc
        dec
        xba
        lsr
        xba
        iny
        cpy #$0006
        bmi @f6ea
        xba
        lda #$04
        xba
@f6fc:  xba
        sta $2ca9,x
        inx
        cpx #$0007
        bmi @f6e1
        plp
        plb
        rts
        pha
        php
        and #$1f
        brk $e2
        jsr _c2a69d
        bit $6828
        lsr5
        inx
        rts

; ---------------------------------------------------------------------------

; [ update config settings ]

_c2f71c:
_f71c:  phb
        php
        pea $7e7e
        plb
        plb
        longa
        ldx $8e
@f727:  stz $0970,x
        inx2
        cpx #$0020
        bne @f727
        ldx $8e
        txa
        shorta
        phx
        lda $c0f0a5,x
        tay
        lda $c0f0a6,x
        tax
        lda $2c9c,x
        beq @f753
@f736:  plx
        lda $c0f0a7,x
        ora $0970,y
        sta $0970,y
        bra @f754
@f753:  plx
@f754:  inx3
        cpx #$0018
        bne @f736
        shorta
        lda $2c9e
        asl4
        ora $2c9d
        and #$77
        ora $0970
        sta $0970
        jsr _c2f5a9     ; update mono/stereo setting
        longa
        ldx #$0002
        ldy $8e
@f77a:  lda $0971
        asl5
        sta $0971
        lda $2ca6,x
        and #$001f
        ora $0971
        sta $0971
        dex
        bpl @f77a
        jsr _c2f6d6
        ldx #$2ca9
        ldy #$0975
        lda #$001a
        mvn $7e,$7e
        plp
        plb
        rts

; ---------------------------------------------------------------------------

; [  ]

_c2f7a6:
_f7a6:  phb
        php
        pea $7e7e
        plb
        plb
        longa
        ldx $2c94
        lda $c0f1bd,x
        tay
        lda $c0f18e,x
        sta $2c9a
        lda $c0f0c3,x
        and #$00ff
        sta $2c96
        asl
        tax
        lda $c0f0f2,x
        tax
        tya
        and #$00ff
        ora #$0100
        jsr _c2f7fc
        ldy $2c9a
        ldx $2c94
        lda $2c9c,x
        and #$00ff
        clc
        adc $2c96
        asl
        tax
        lda $c0f0f2,x
        tax
        lda $2c9a
        and #$00ff
        jsr @f7fc
        plp
        plb
        rts
@f7fc:  ldy $2c94
        cpy #$0001
        beq @f809
        cpy #$0002
        bne $f80c
@f809:  ora #$00
        bra @f82d
        jmp [$60d6]
        phb
        php
        pea $7e7e
        plb
        plb
        longa
        ldy $8e
@f81b:  tya
        asl
        tax
        lda $c0f0bd,x
        tax
        phy
        lda $2ca6,y
        pha
        and #$001c
        lsr2
@f82d:  tay
        beq @f83d
        phy
        lda #$00fe
@f834:  sta $0000,x
        inx2
        dey
        bne @f834
        ply
@f83d:  pla
        and #$0003
        beq @f84f
        dec
        asl
        clc
        adc #$00f8
        sta $0000,x
        inx2
        iny
@f84f:  lda #$000c
@f852:  cpy #$0008
        beq @f85f
        sta $0000,x
        inx2
        iny
        bra @f852
@f85f:  ply
        iny
        cpy #$0003
        bne @f81b
        plp
        plb
        rts
        phb
        php
        pea $7e7e
        plb
        plb
        longa
        stz $2cd1
        stz $2cd3
        stz $2cd5
        stz $2cd7
        shorta
        lda #$01
        sta $6f
        jsr _c2ed87
        ldx $75
        beq @f8ae
        jsr _c2ee94
        ldx $8e
        ldy $80
        lda $0521,y
        bit #$21
        beq @f8a4
        inx
        bit #$01
        beq @f8a4
        inx
@f8a4:  longa
        txa
        asl
        tax
        shorta
        jsr ($fff8,x)
@f8ae:  plp
        plb
        rts
        php
        shorta
        stx $2ccd
        and #$03
        dec
        sta $2ccf
        stz $2cd0
        stz $2ccb
        stz $2ccc
        ldy $8e
@f8c8:  lda $7b00,y
        beq @f8f5
        lda $7a00,y
        bmi @f8f5
        and #$7f
        jsr _c2d9ab
        lda $9f
        and $2ccd
        eor $2cce
        beq @f8f5
        lda $a2
        sta $2ccc
        lda $7a00,y
        sta $2ccb
        lda $7b00,y
        dec
        sta $7b00,y
        bra @f8fa
@f8f5:  iny
        cpy $75
        bmi @f8c8
@f8fa:  ldx $2ccf
        lda $2ccb
        sta $2cd1,x
        lda $2ccc
        sta $2cd5,x
        plp
        rts
        php
        shorta
        and #$03
        dec
        sta $2ccf
        stz $2cd0
        ldx $2ccf
        ldy $8e
@f91c:  lda $7b00,y
        beq @f92b
        lda $7a00,y
        bpl @f92b
        sta $2cd1,x
        bra @f930
@f92b:  iny
        cpy $75
        bmi @f91c
@f930:  plp
        rts

; ---------------------------------------------------------------------------

_c2f932:
_f932:  ldy $75
        dey
@f835:  lda $7a00,y
        bmi @f93f
        sta $2cd1
        bra @f942
@f93f:  sta $2cd2
@f942:  dey
        bpl @f835
        jsr _c2fa75
        rts

; ---------------------------------------------------------------------------

_c2f949:
_f949:  ldx #$0040
        lda #$01
        jsr _c2f8b1
        ldx #$c0c0
        lda #$02
        jsr _c2f8b1
        lda #$03
        jsr _c2f90b
        longa
        lda $2cd6
        and #$00ff
        pha
        lda $2cd5
        and #$00ff
        asl
        cmp $01,s
        beq @f979
        bmi @f979
        stz $2cd2
        bra @f97f
@f979:  lda $2cd2
        sta $2cd1
@f97f:  plx
        jsr _c2fa75
        rts

; ---------------------------------------------------------------------------

_c2f984:
_f984:  ldx #$0080
        lda #$2001
        lda ($f8),y
        ldx #$8080
        lda #$2002
        lda ($f8),y
        ldx #$8080
        lda #$2003
        lda ($f8),y
        lda $2cd3
        bne $f9a6
        lda #$2003
        phd
        sbc $20c2,y
        lda $2cd6
        and #$00ff
        pha
        lda $2cd7
        and #$00ff
        clc
        adc $01,s
        sta $01,s
        lda $2cd5
        and #$00ff
        cmp $01,s
        beq @f9cb
        bmi @f9cb
        stz $2cd2
        bra @f9d1
@f9cb:  lda $2cd2
        sta $2cd1
@f9d1:  plx
        jsr _c2fa75
        rts

; ---------------------------------------------------------------------------

_c2f9d6:
_f9d6:  ldx #$0040
        lda #$2001
        lda ($f8),y
        ldx #$0080
        lda #$2002
        lda ($f8),y
        ldx #$8080
        lda #$2003
        lda ($f8),y
        lda $2cd1
        bne @fa14
        lda $2cd3
        sta $2cd1
        lda $2cd7
        sta $2cd3
        ldx #$8080
        lda #$2003
        lda ($f8),y
        longa
        lda $2cd5
        and #$00ff
        sta $2cd9
        bra @fa20
@fa14:  longa
        lda $2cd5
        and #$00ff
        asl
        sta $2cd9
@fa20:  lda $2cd6
        and #$00ff
        sta $2cdb
        lda $2cd5
        and #$00ff
        sta $2cdd
        lda $2cd7
        and #$00ff
        clc
        adc $2cdd
        sta $2cdd
        cmp $2cdb
        beq @fa4d
        bmi @fa4d
        cmp $2cd9
        bmi @fa6c
        bra @fa62
@fa4d:  lda $2cdb
        cmp $2cd9
        bmi @fa6c
        shorta
        lda $2cd2
        sta $2cd1
        stz $2cd2
        bra @fa71
@fa62:  shorta
        lda $2cd3
        sta $2cd2
        bra @fa71
@fa6c:  shorta
        stz $2cd2
@fa71:  jsr _c2fa75
        rts
        shorta
        lda #$01
        sta $6f
        lda $2cd1
        beq @fa85
        sta $72
        jsr @fa92
@fa85:  lda $2cd2
        beq @fa91
        sta $72
        inc $6f
        jsr @fa92
@fa91:  rts
@fa92:  php
        jsr _c2e0f7
        lda $90
        bne @faab
        jsr _c2e178
        jsr _c2e1a6
        jsr _c2e18f
        lda #$01
        xba
        lda $72
        jsr _c2e328
@faab:  plp
        rts
        phb
        php
        shorta
        lda #$03
        sta $6f
@fab5:  jsr _c2ed5e
        ldx $75
        beq @fac8
        jsr _c2ee94
        lda $7e7a00
        sta $72
        jsr _c2fa92
@fac8:  lda $6f
        inc
        sta $6f
        cmp #$06
        bne @fab5
        plp
        plb
        rts

; ---------------------------------------------------------------------------

; [ copy sprite data to vram ]

_c2fad4:
_fad4:  phb
        php
        longa
        ldx #$f5b2      ; 02 04 00 02 00 20 02 (sprite data)
        ldy #$4300
        lda #$0006
        mvn $00,$c0
        stz $2102
        shorta
        lda #$01
        tsb $ca
        plp
        plb
        rts

; ---------------------------------------------------------------------------

_c2faf0:
_faf0:  phb
        php
        longa
        ldx #$f5b9
        ldy #$4310
        lda #$0006
        mvn $00,$c0
        shorta
        stz $2121
        lda #$02
        tsb $ca
        plp
        plb
        rts

; ---------------------------------------------------------------------------

; [ menu nmi ]

_c2fb0c:
_fb0c:  phb
        phd
        php
        longa
        pha
        php
        phx
        phy
        shorta
        lda #$00
        pha
        plb
        lda $4210
        lda #$01
        sta $4200
        stz $420c
        lda #$80
        sta $2100
        pea $0100       ; set dp
        pld
        lda $c9
        bne @fb36
        jmp @fbe7
@fb36:  stz $c9
        lda $ca
        and #$03
        beq @fb43
        trb $ca
        sta $420b
@fb43:  lda #$04
        bit $fb90
        trb $ca
        phd
        pea $2100       ; use video register dp
        pld
        ldx #$7500
        stx $81
        stz $83
        lda $80
        sta $2c
        lda $80
        sta $2d
        lda $80
        sta $2e
        lda $80
        sta $2f
        lda $80
        sta $23
        lda $80
        sta $24
        lda $80
        sta $25
        lda $80
        sta $2a
        lda $80
        sta $2b
        lda $80
        sta $31
        lda $80
        sta $30
        lda $80
        sta $32
        lda $80
        sta $32
        lda $80
        sta $32
        pld
        stz $0c
        stz $0d         ; selected character (multi controller)
        jsr _c2fe5b     ; update joypad input
        shorta
        lda #$7e
        pha
        plb
        lda #$ff
        bit $750f
        beq @fba7
        dec $751d
@fba7:  bit $7510
        beq @fbaf
        dec $751f
@fbaf:  lda $7511
        beq @fbe7
        longa
        lda $7514
        sta $002116
        lda $7516
        sta $004300
        lda $7518
        sta $004302
        lda $751a
        sta $004304
        lda $751b
        sta $004305
        shorta
        lda $7511
        and #$01
        sta $00420b
        stz $7511
@fbe7:  longa
        lda #$0001
        clc
        adc $094a
        sta $094a
        lda $8e
        adc $094c
        sta $094c
        lda $0afb
        and #$00ff
        cmp #$0002
        bne @fc0f
        lda $0afc
        beq @fc0f
        dec
        sta $0afc
@fc0f:  shorta
        lda $7e750e
        sta $00420c
        lda #$81
        sta $004200
        lda $7e7525
        sta $002100
        ply
        plx
        plp
        pla
        plp
        pld
        plb

; ---------------------------------------------------------------------------

; [ menu irq ]

_c2fc2e:
_fc2e:  rti

; ---------------------------------------------------------------------------

; [  ]

_c2fc2f:
_fc2f:  phb
        shorta
        lda #$7e
        pha
        plb
        lda $7512
        beq @fc3e
        jsr _c2fd75
@fc3e:  lda $750f
        beq @fc53
        lda $751d
        bpl @fc53
        lda #$10
        sta $751d
        jsr _c2fcb1
        jsr _c2fad4
@fc53:  lda $7510
        beq @fc68
        lda $751f
        bpl @fc68
        lda #$01
        sta $751f
        jsr _c2fd09
        jsr _c2fad4
@fc68:  lda $7513
        beq @fc70
        jsr _c2fd2e
@fc70:  lda $43         ; menu state
        cmp #$01
        bne @fcaf
        lda $0afb
        cmp #$02
        beq @fc82
        ldy #$094a
        bra @fc92
@fc82:  longa
        lda $0afc
        sta $2d17
        stz $2d19
        ldy #$2d17
        shorta
@fc92:  php
        ldx #$6630
        jsr _c2d662
        longa
        ldx #$f5c0
        ldy #$7514
        lda #$0008
        mvn $7e,$c0
        shorta
        lda #$01
        sta $7511
        plp
@fcaf:  plb
        rts
        lda $751e
        longa
        and #$0001
        asl
        tax
        ldy $8e
        shorta
        lda $750f
@fcc2:  lsr
        bcc @fcf3
        pha
        lda $0241,y
        clc
        adc $c0f21a,x
        sta $0241,y
        lda $0242,y
        clc
        adc $c0f21b,x
        sta $0242,y
        lda $0245,y
        clc
        adc $c0f21a,x
        sta $0245,y
        lda $0246,y
        clc
        adc $c0f21b,x
        sta $0246,y
        pla
@fcf3:  iny8
        cpy #$0020
        bne @fcc2
        lda $751e
        eor #$01
        sta $751e
        rts
        shorta
        lda $7510
        longa
        and #$0007
        asl2
        sta $7520
        shorta
        ldx $8e
@fd1c:  lda $0206,x
        eor #$02
        sta $0206,x
        inx4
        cpx $7520
        bne @fd1c
        rts
        shorta
        lda $7522
        bne @fd54
        lda $7513
        longa
        and #$0007
        dec
        asl2
        tax
        lda $c0f21e,x
        sta $7523
        lda $c0f220,x
        sta $7525
        shorta
        inc $7522
@fd54:  lda $7523
        beq @fd68
        dec $7523
        lda $7524
        clc
        adc $7525
        sta $7525
        bra @fd74
@fd68:  lda $7526
        sta $7525
        stz $7522
        stz $7513
@fd74:  rts
        shorta
        lda $7527
        cmp #$04
        beq @fd8c
        cmp #$03
        beq @fd90
        cmp #$02
        beq @fd94
        cmp #$01
        beq @fd90
        bra @fd9c
@fd8c:  lda #$00
        bra @fd99
@fd90:  lda #$02
        bra @fd99
@fd94:  jsr _c2fe41
        lda #$02
@fd99:  jsr _c2fdca
@fd9c:  shorta
        lda $7528
        beq @fdbd
        ldx $8e
@fda5:  lda $0205,x
        beq @fdb1
        clc
        adc $7528
        sta $0205,x
@fdb1:  inx4
        cpx #$0020
        bne @fda5
        jsr _c2fad4
@fdbd:  lda $7527
        dec
        sta $7527
        bne @fdc9
        stz $7512
@fdc9:  rts
        php
        longa
        clc
        adc $29a2
        and #$000f
        asl2
        tax
        ldy $29b4
        shorta
        lda $0000,y
        clc
        adc $c0f22e,x
        sta $0000,y
        iny3
@fdea:  shorta
        lda $0000,y
        beq @fe03
        iny
        longa
        lda $0000,y
        clc
        adc $c0f230,x
        sta $0000,y
        iny2
        bra @fdea
@fe03:  plp
        rts
        php
        longa
        ldx #$298e
        ldy #$7514
        lda #$0008
        mvn $7e,$7e
        shorta
        lda $7528
        beq @fe35
        ldx $8e
@fe1d:  lda $0205,x
        beq @fe29
        clc
        adc $7528
        sta $0205,x
@fe29:  inx4
        cpx #$0020
        bne @fe1d
        jsr _c2fad4
@fe35:  lda #$01
        sta $7511
        lda #$04
        sta $7527
        plp
        rts

; ---------------------------------------------------------------------------

; [  ]

_c2fe41:
_fe41:  php
        longa
        ldx #$2997
        ldy #$7514
        lda #$0008
        mvn $7e,$7e
        shorta
        lda #$01
        sta $7511
        stz $ca
        plp
        rts

; ---------------------------------------------------------------------------

; [ update joypad input ]

_c2fe5b:
        php
        longa
        pha
        php
        phx
        phy
        phb
        phd
        shorta
        longi
        lda     #$00
        pha
        plb
        pea     $0100
        pld
        lda     #$01
@fe72:  bit     $4212
        bne     @fe72
        ldy     #$0000
        lda     $4d
        beq     @fe97
        lda     $0974
        and     #$80
        beq     @fe97       ; branch if single controller
        lda     $010d
        longa
        and     #$0003
        tax
        lda     $097c,x     ; character assigned to controller
        and     #$00ff
        beq     @fe97
        iny
@fe97:  longa
        sty     $12
        tya
        asl
        tax
        lda     $4218,x     ; joypad register
        sta     $06
        and     #$000f
        beq     @feaa
        stz     $06
@feaa:  lda     $14,x
        sta     $0e
        jsr     _c2fed0
        lda     $12
        asl
        tax
        lda     $0e
        sta     $14,x
        pld                 ; pull previous direct page
        lda     $010a
        sta     $00
        lda     $0108
        sta     $02
        lda     $0106
        sta     $04
        plb
        ply
        plx
        plp
        pla
        plp
        rts

; ---------------------------------------------------------------------------

; [  ]

_c2fed0:
@fed0:  .a16
        lda     $0974
        and     #$0040
        bne     @fede       ; branch if custom button config
        lda     $06
        sta     $08
        bra     @fefb
@fede:  lda     $06
        and     #$1f0f
        sta     $08
        ldx     #$0000
@fee8:  lda     $06
        and     f:_c0e7b8,x
        beq     @fef4
        lda     $26,x
        tsb     $08
@fef4:  inx2
        cpx     #$000e
        bne     @fee8
@fefb:  lda     $0e
        eor     #$ffff
        and     $08
        sta     $0a
        lda     $08
        and     $0e
        shorta
        bit     $010c
        longa
        bmi     @ff14
        and     #$7f7f
@ff14:  sta     $10
        lda     $08
        sta     $0e
        ldx     #$0000
        ldy     $12
@ff1f:  longa
        lda     f:_c0e7c6,x
        bit     $0a
        bne     @ff43       ; branch if already in repeat mode
        and     $10
        beq     @ff45
        shorta
        lda     $011a,y     ; decrement delay counter
        dec
        beq     @ff37
        bpl     @ff45
@ff37:  longa
        lda     f:_c0e7c6,x
        tsb     $0a         ; set repeat mode
        lda     $19
        bra     @ff45
@ff43:  lda     $18
@ff45:  shorta
        sta     $011a,y
        iny2                ; next button
        inx2
        cpx     #$000c
        bne     @ff1f
        longa
        rts

; ---------------------------------------------------------------------------

; [ set controller settings (battle) ]

_c2ff56:
        php
        longa
        pha
        lda     #$0310      ; delay = 16 frames, rate = 3 frames
        sta     f:$000118     ; repeat settings
        sta     f:$00014d     ; allow multipler controllers
        pla
        plp
        rts

; ---------------------------------------------------------------------------

; [ set controller settings (field) ]

_c2ff68:
        php
        longa
        pha
        lda     #$0416      ; delay = 22 frames, rate = 4 frames
        sta     f:$000118     ; repeat settings
        lda     #$0000
        sta     f:$00014d     ; single controller
        pla
        plp
        rts

; ---------------------------------------------------------------------------

; [ update joypad config ]

_c2ff7d:
        phb
        phd
        pha
        phx
        phy
        php
        pea     $0000
        plb
        plb
        longai
        pea     $0100
        pld
        lda     #$0416      ; delay = 22 frames, rate = 4 frames
        sta     $18
        stz     $4d         ; single controller
        ldy     #$0000
        tyx
@ff99:  lda     $0975,y     ; joypad config
        jsr     _c2ffc2
        sta     $26,x
        iny
        inx2
        cpy     #$0007
        bne     @ff99
        stz     $0e
        stz     $14
        stz     $16
        lda     #$0101
        ldx     #$000c
@ffb5:  dex2
        sta     $1a,x
        bne     @ffb5
        plp
        ply
        plx
        pla
        pld
        plb
        rts

; ---------------------------------------------------------------------------

; [  ]

_c2ffc2:
@ffc2:  .a16
        phx
        and     #$00fc
        xba
        ldx     #$0000
@ffca:  asl
        bcs     @ffd7
        inx2
        cpx     #$000c
        bne     @ffca
        ldx     #$0000
@ffd7:  lda     f:_c0e7b8,x
        plx
        rts

; ---------------------------------------------------------------------------

; todo: move to the correct segment
_c0e7b8:
        .word   $0080,$8000,$0040,$4000,$0020,$0010,$2000

_c0e7c6:
        .word   $0080,$8000,$0800,$0400,$0200,$0100

; ---------------------------------------------------------------------------
