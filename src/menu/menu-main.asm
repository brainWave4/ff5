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
        bra @a030

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
        jmp @a030
        shorta
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
        mvn $7e,$co
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
        plb2
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
        jmp (01c7)

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
        bra @a386

; ---------------------------------------------------------------------------

; [ menu state $0F: B button pressed ]

_c2a378:
_a378:  jsr _c2e0b8     ; play sound effect
        lda $54
        longa
        and #$007f
        asl2
        inc2
        tax
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
        plb2
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
        shorta
        lda #$02
        trb $7500
        lda #$04
        tsb $ca
        stz $750f
        stz $751e
        rts
        jsr $aba0
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
        amd #$07
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
        jsr $e42c       ; draw spell name
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
