
; +-------------------------------------------------------------------------+
; |                                                                         |
; |                             FINAL FANTASY V                             |
; |                                                                         |
; +-------------------------------------------------------------------------+
; | file: sound/sound-data.s                                                |
; |                                                                         |
; | description: sound effects data                                         |
; +-------------------------------------------------------------------------+

; ---------------------------------------------------------------------------

;c4/1f4f
spc_block SfxLoopStart
        .word $4800,$4800
        .word $4824,$4824
        .word $4848,$4848
        .word $486c,$4887
        .word $48ab,$48c6
        .word $48d8,$48d8
        .word $48ea,$48ea
        .word $48fc,$48fc
end_spc_block

;c4/1F71
spc_block SfxADSR
        make_adsr 15,15,14,0
        make_adsr 15,15,14,0
        make_adsr 15,15,14,0
        make_adsr 15,15,14,0
        make_adsr 15,15,14,0
        make_adsr 15,15,14,0
        make_adsr 15,15,14,0
        make_adsr 15,15,14,0
end_spc_block

;c4/1f83
spc_block SfxFreqMult
        .byte $e0,$a0
        .byte $e0,$a0
        .byte $e0,$a0
        .byte $e0,$a0
        .byte $00,$00
        .byte $e0,$a0
        .byte $e0,$a0
        .byte $e0,$a0
end_spc_block

; ---------------------------------------------------------------------------