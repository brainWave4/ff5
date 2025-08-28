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
@a02d:  jsr $b2bd
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
_a043:  jsr $a1f0       ; init config settings
        jsr $ff7d       ; update joypad config
        jsr $d447       ; update window color
        jsr $f5a9       ; update mono/stereo setting
        lda #$0c
        bra _a06b       ; show menu

; ---------------------------------------------------------------------------

; [ menu command $04: tutorial ]

_c2a053:
_a053:  lda #$80
        tsb $45         ; enable tutorial mode
        stz $49         ; clear pause counter
        stz $41
        jsr $a394       ; init tutorial script
        lda #$01
        bra _a06b       ; show menu

; ---------------------------------------------------------------------------

; [ menu command $06: transfer galuf's stats to krile ]

_c2a062:
_a062:  stz $35
        jsr $d958
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
        jsr $c16a       ; load tilemap/???/cursor data
        jsr $a16e       ; reset sprite data
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
        jsr $a0f6
        ldx #$f5b9      ; 02 22 00 73 7E 00 02 (color palettes)
        jsr $a0f6
        ldx #$f58b      ; 01 18 00 30 7E 00 40 (vram)
        jsr $a0f6
        shorta
        lda #$04
        sta $ca
        lda #$00
        sta $7e7511
        jsr $a106       ; wait for vblank
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
; @a11b:  longai
;         lda     #$0100
;         tcd

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
