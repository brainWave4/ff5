; +-------------------------------------------------------------------------+
; |                                                                         |
; |                             FINAL FANTASY V                             |
; |                                                                         |
; +-------------------------------------------------------------------------+
; | file: sound/song-data.s                                                 |
; |                                                                         |
; | description: background music data                                      |
; +-------------------------------------------------------------------------+

; ---------------------------------------------------------------------------

; c4/3cd8
SampleLoopStart:
        .word   $0a8c
        .word   $0a8c
        .word   $0bd9
        .word   $1194
        .word   $05fa
        .word   $0465
        .word   $1194
        .word   $1194
        .word   $04f5
        .word   $029a
        .word   $08f7
        .word   $02c7
        .word   $034e
        .word   $04da
        .word   $0252
        .word   $0489
        .word   $0936
        .word   $0642
        .word   $0144
        .word   $044a
        .word   $05bb
        .word   $0666
        .word   $1194
        .word   $09bd
        .word   $0384
        .word   $05bb
        .word   $092d
        .word   $15f9
        .word   $0318
        .word   $077d
        .word   $08dc
        .word   $088d
        .word   $09e1
        .word   $0e7c
        .word   $0b6d

; ---------------------------------------------------------------------------

; c4/3d1e
SampleFreqMult:
        .byte   $c0,$00
        .byte   $00,$00
        .byte   $c0,$00
        .byte   $00,$00
        .byte   $60,$00
        .byte   $00,$00
        .byte   $00,$00
        .byte   $fb,$00
        .byte   $fe,$48
        .byte   $e0,$a0
        .byte   $00,$7c
        .byte   $fd,$00
        .byte   $51,$00
        .byte   $fe,$00
        .byte   $e0,$90
        .byte   $fc,$60
        .byte   $fc,$7f
        .byte   $ff,$00
        .byte   $fc,$c0
        .byte   $fc,$a0
        .byte   $fc,$d0
        .byte   $fc,$a0
        .byte   $00,$00
        .byte   $00,$00
        .byte   $00,$00
        .byte   $00,$00
        .byte   $fe,$00
        .byte   $e0,$b0
        .byte   $fc,$90
        .byte   $e0,$c0
        .byte   $00,$00
        .byte   $00,$00
        .byte   $e0,$00
        .byte   $00,$00
        .byte   $00,$00

; ---------------------------------------------------------------------------

; c4/3d64
SampleADSR:
        make_adsr 15,15,14,0
        make_adsr 15,15,14,0
        make_adsr 15,15,14,0
        make_adsr 15,15,15,0
        make_adsr 15,15,14,0
        make_adsr 15,15,14,0
        make_adsr 15,15,14,0
        make_adsr 15,15,14,0
        make_adsr 15,15,15,0
        make_adsr 15,15,15,5
        make_adsr 15,15,14,0
        make_adsr 15,15,14,0
        make_adsr 15,15,15,2
        make_adsr 15,15,14,1
        make_adsr 15,15,14,1
        make_adsr 15,15,14,1
        make_adsr 15,15,14,0
        make_adsr 15,15,14,13
        make_adsr 15,15,14,0
        make_adsr 15,15,14,12
        make_adsr 15,15,14,10
        make_adsr 15,15,15,3
        make_adsr 15,15,14,0
        make_adsr 15,15,14,10
        make_adsr 15,15,14,10
        make_adsr 15,15,14,8
        make_adsr 15,15,15,3
        make_adsr 15,15,14,1
        make_adsr 15,15,15,1
        make_adsr 15,15,15,4
        make_adsr 15,15,15,3
        make_adsr 15,15,14,0
        make_adsr 15,15,14,0
        make_adsr 15,15,14,0
        make_adsr 15,15,14,0

; ---------------------------------------------------------------------------