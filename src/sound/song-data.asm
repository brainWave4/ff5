; +-------------------------------------------------------------------------+
; |                                                                         |
; |                             FINAL FANTASY V                             |
; |                                                                         |
; +-------------------------------------------------------------------------+
; | file: sound/song-data.s                                                 |
; |                                                                         |
; | description: background music data                                      |
; +-------------------------------------------------------------------------+

.include "sound/song_script.inc"
.include "sound/sample_brr.inc"

; c4/3b97: pointers to song scripts
SongScriptPtrs:
        ptr_tbl_far SongScript

; c4/3c6f: pointers to instrument brr samples
SampleBRRPtrs:
        ptr_tbl_far SampleBRR

; c4/3cd8
SampleLoopStart:
        .word   $0a8c
        .word   $0bd9
        .word   $1194
        .word   $05fa
        .word   $15f9
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
        .byte   $ff,$a0
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
        .byte   $0e,$00
        .byte   $00,$00
        .byte   $00,$00

; ---------------------------------------------------------------------------

; c4/3d64
SampleADSR:
        make_adsr 15,15,7,0
        make_adsr 15,15,7,0
        make_adsr 15,15,7,0
        make_adsr 15,15,7,16
        make_adsr 15,15,7,0
        make_adsr 15,15,7,0
        make_adsr 15,15,7,0
        make_adsr 15,15,7,0
        make_adsr 15,15,7,16
        make_adsr 15,15,7,21
        make_adsr 15,15,7,0
        make_adsr 15,15,7,0
        make_adsr 15,15,7,18
        make_adsr 15,15,7,1
        make_adsr 15,15,7,1
        make_adsr 15,15,7,1
        make_adsr 15,15,7,0
        make_adsr 15,15,7,13
        make_adsr 15,15,7,0
        make_adsr 15,15,7,12
        make_adsr 15,15,7,10
        make_adsr 15,15,7,19
        make_adsr 15,15,7,0
        make_adsr 15,15,7,10
        make_adsr 15,15,7,10
        make_adsr 15,15,7,8
        make_adsr 15,15,7,19
        make_adsr 15,15,7,1
        make_adsr 15,15,7,17
        make_adsr 15,15,7,20
        make_adsr 15,15,7,19
        make_adsr 15,15,7,0
        make_adsr 15,15,7,0
        make_adsr 15,15,7,0
        make_adsr 15,15,7,0

; ---------------------------------------------------------------------------

; c4/3daa

SongSamples:

        begin_song_samples 0
        def_song_sample $0f
        def_song_sample $0e
        def_song_sample $0b
        def_song_sample $14
        def_song_sample $06
        def_song_sample $07
        def_song_sample $01
        def_song_sample $02
        def_song_sample $0d
        def_song_sample $04
        end_song_samples 0

        begin_song_samples 1
        def_song_sample $08
        def_song_sample $0e
        def_song_sample $14
        def_song_sample $0b
        def_song_sample $04
        def_song_sample $02
        end_song_samples 1

        begin_song_samples 2
        def_song_sample $0f
        def_song_sample $10
        def_song_sample $0b
        def_song_sample $15
        def_song_sample $1c
        def_song_sample $16
        def_song_sample $0c
        def_song_sample $19
        def_song_sample $04
        end_song_samples 2

        begin_song_samples 3
        def_song_sample $0f
        def_song_sample $0a
        def_song_sample $14
        def_song_sample $0e
        def_song_sample $06
        def_song_sample $07
        def_song_sample $01
        def_song_sample $02
        def_song_sample $05
        end_song_samples 3

        begin_song_samples 4
        def_song_sample $0f
        def_song_sample $10
        def_song_sample $0e
        def_song_sample $1d
        def_song_sample $14
        def_song_sample $08
        end_song_samples 4

        begin_song_samples 5
        def_song_sample $0d
        def_song_sample $0f
        def_song_sample $1c
        def_song_sample $0b
        def_song_sample $1d
        end_song_samples 5

        begin_song_samples 6
        def_song_sample $10
        def_song_sample $0d
        def_song_sample $0b
        def_song_sample $14
        def_song_sample $05
        def_song_sample $20
        def_song_sample $1f
        def_song_sample $04
        end_song_samples 6

        begin_song_samples 7
        def_song_sample $0f
        def_song_sample $10
        def_song_sample $0a
        def_song_sample $08
        def_song_sample $14
        end_song_samples 7

        begin_song_samples 8
        def_song_sample $0d
        def_song_sample $0b
        def_song_sample $0f
        def_song_sample $1c
        end_song_samples 8

        begin_song_samples 9
        def_song_sample $0e
        def_song_sample $0b
        def_song_sample $14
        def_song_sample $04
        def_song_sample $10
        def_song_sample $06
        def_song_sample $07
        def_song_sample $01
        def_song_sample $03
        end_song_samples 9

        begin_song_samples 10
        def_song_sample $10
        def_song_sample $0b
        end_song_samples 10

        begin_song_samples 11
        def_song_sample $12
        def_song_sample $0c
        def_song_sample $0b
        def_song_sample $16
        end_song_samples 11

        begin_song_samples 12
        def_song_sample $0f
        def_song_sample $0b
        def_song_sample $15
        def_song_sample $05
        def_song_sample $08
        def_song_sample $18
        end_song_samples 12

        begin_song_samples 13
        def_song_sample $10
        def_song_sample $0b
        def_song_sample $16
        def_song_sample $14
        def_song_sample $09
        end_song_samples 13

        begin_song_samples 14
        def_song_sample $0e
        def_song_sample $14
        def_song_sample $02
        def_song_sample $01
        def_song_sample $11
        end_song_samples 14

        begin_song_samples 15
        def_song_sample $0d
        def_song_sample $0b
        def_song_sample $10
        end_song_samples 15

        begin_song_samples 16
        def_song_sample $0f
        def_song_sample $0d
        def_song_sample $0b
        def_song_sample $14
        def_song_sample $0c
        end_song_samples 16

        begin_song_samples 17
        end_song_samples 17

        begin_song_samples 18
        def_song_sample $0b
        def_song_sample $14
        def_song_sample $0e
        def_song_sample $11
        def_song_sample $04
        def_song_sample $08
        end_song_samples 18

        begin_song_samples 19
        def_song_sample $10
        def_song_sample $12
        def_song_sample $0b
        def_song_sample $1d
        end_song_samples 19

        begin_song_samples 20
        def_song_sample $0b
        def_song_sample $10
        def_song_sample $0f
        def_song_sample $02
        def_song_sample $1c
        def_song_sample $08
        end_song_samples 20

        begin_song_samples 21
        def_song_sample $0f
        def_song_sample $21
        def_song_sample $0b
        def_song_sample $14
        def_song_sample $08
        def_song_sample $1b
        def_song_sample $0d
        def_song_sample $1c
        end_song_samples 21

        begin_song_samples 22
        def_song_sample $0e
        def_song_sample $0b
        def_song_sample $14
        def_song_sample $08
        def_song_sample $02
        def_song_sample $04
        end_song_samples 22

        begin_song_samples 23
        def_song_sample $0b
        def_song_sample $14
        def_song_sample $04
        def_song_sample $01
        def_song_sample $03
        end_song_samples 23

        begin_song_samples 24
        def_song_sample $14
        def_song_sample $0b
        def_song_sample $02
        def_song_sample $0e
        def_song_sample $04
        end_song_samples 24

        begin_song_samples 25
        def_song_sample $0b
        def_song_sample $0f
        def_song_sample $0d
        def_song_sample $10
        end_song_samples 25

        begin_song_samples 26
        def_song_sample $0e
        def_song_sample $1e
        def_song_sample $14
        def_song_sample $21
        def_song_sample $17
        def_song_sample $20
        def_song_sample $22
        def_song_sample $1f
        end_song_samples 26

        begin_song_samples 27
        def_song_sample $16
        end_song_samples 27

        begin_song_samples 28
        def_song_sample $0f
        def_song_sample $0d
        def_song_sample $0b
        def_song_sample $14
        def_song_sample $13
        def_song_sample $21
        def_song_sample $04
        end_song_samples 28

        begin_song_samples 29
        def_song_sample $0e
        def_song_sample $0d
        def_song_sample $14
        def_song_sample $0b
        def_song_sample $06
        def_song_sample $01
        def_song_sample $02
        end_song_samples 29

        begin_song_samples 30
        def_song_sample $10
        def_song_sample $0d
        def_song_sample $0b
        end_song_samples 30

        begin_song_samples 31
        def_song_sample $01
        def_song_sample $14
        def_song_sample $0b
        def_song_sample $0e
        def_song_sample $10
        def_song_sample $21
        def_song_sample $23
        def_song_sample $04
        end_song_samples 31

        begin_song_samples 32
        def_song_sample $0e
        def_song_sample $0b
        def_song_sample $14
        def_song_sample $02
        def_song_sample $04
        def_song_sample $08
        end_song_samples 32

        begin_song_samples 33
        def_song_sample $0f
        def_song_sample $23
        def_song_sample $10
        def_song_sample $13
        def_song_sample $1d
        def_song_sample $05
        end_song_samples 33

        begin_song_samples 34
        def_song_sample $11
        def_song_sample $0e
        def_song_sample $14
        def_song_sample $1a
        def_song_sample $04
        def_song_sample $06
        def_song_sample $07
        def_song_sample $01
        def_song_sample $03
        def_song_sample $05
        end_song_samples 34

        begin_song_samples 35
        def_song_sample $10
        def_song_sample $0b
        def_song_sample $08
        def_song_sample $14
        def_song_sample $02
        def_song_sample $0d
        def_song_sample $04
        def_song_sample $1c
        def_song_sample $0e
        end_song_samples 35

        begin_song_samples 36
        def_song_sample $0d
        def_song_sample $09
        def_song_sample $18
        def_song_sample $0c
        def_song_sample $1f
        def_song_sample $0b
        def_song_sample $1d
        def_song_sample $04
        end_song_samples 36

        begin_song_samples 37
        def_song_sample $05
        def_song_sample $1f
        def_song_sample $20
        def_song_sample $14
        def_song_sample $09
        def_song_sample $17
        end_song_samples 37

        begin_song_samples 38
        def_song_sample $0b
        def_song_sample $1b
        def_song_sample $06
        def_song_sample $07
        def_song_sample $1f
        def_song_sample $01
        def_song_sample $02
        def_song_sample $09
        def_song_sample $14
        def_song_sample $04
        end_song_samples 38

        begin_song_samples 39
        def_song_sample $10
        def_song_sample $0b
        def_song_sample $0d
        def_song_sample $14
        def_song_sample $07
        def_song_sample $06
        def_song_sample $01
        def_song_sample $03
        def_song_sample $02
        end_song_samples 39

        begin_song_samples 40
        def_song_sample $10
        def_song_sample $0e
        def_song_sample $0b
        def_song_sample $14
        def_song_sample $04
        def_song_sample $06
        def_song_sample $07
        def_song_sample $08
        def_song_sample $01
        def_song_sample $02
        end_song_samples 40

        begin_song_samples 41
        def_song_sample $0e
        def_song_sample $08
        def_song_sample $04
        def_song_sample $0b
        end_song_samples 41

        begin_song_samples 42
        def_song_sample $0e
        def_song_sample $0b
        def_song_sample $10
        def_song_sample $04
        def_song_sample $02
        def_song_sample $08
        end_song_samples 42

        begin_song_samples 43
        def_song_sample $0b
        def_song_sample $0e
        def_song_sample $14
        def_song_sample $04
        def_song_sample $06
        def_song_sample $07
        def_song_sample $01
        def_song_sample $02
        def_song_sample $09
        end_song_samples 43

        begin_song_samples 44
        def_song_sample $0e
        def_song_sample $11
        def_song_sample $1d
        def_song_sample $14
        def_song_sample $1a
        def_song_sample $04
        def_song_sample $06
        def_song_sample $07
        def_song_sample $01
        def_song_sample $02
        def_song_sample $19
        end_song_samples 44

        begin_song_samples 45
        def_song_sample $0b
        def_song_sample $0c
        def_song_sample $14
        def_song_sample $04
        def_song_sample $01
        def_song_sample $03
        def_song_sample $1a
        end_song_samples 45

        begin_song_samples 46
        def_song_sample $0e
        def_song_sample $0b
        def_song_sample $14
        def_song_sample $1c
        def_song_sample $02
        def_song_sample $04
        end_song_samples 46

        begin_song_samples 47
        def_song_sample $14
        def_song_sample $0e
        def_song_sample $1d
        def_song_sample $21
        def_song_sample $23
        end_song_samples 47

        begin_song_samples 48
        end_song_samples 48

        begin_song_samples 49
        def_song_sample $0e
        def_song_sample $0b
        def_song_sample $10
        def_song_sample $0a
        def_song_sample $08
        def_song_sample $04
        def_song_sample $1c
        def_song_sample $02
        end_song_samples 49

        begin_song_samples 50
        def_song_sample $05
        def_song_sample $07
        def_song_sample $02
        def_song_sample $22
        def_song_sample $21
        def_song_sample $0b
        def_song_sample $14
        end_song_samples 50

        begin_song_samples 51
        def_song_sample $0f
        def_song_sample $0e
        def_song_sample $0b
        def_song_sample $14
        def_song_sample $0d
        def_song_sample $02
        def_song_sample $08
        def_song_sample $09
        end_song_samples 51

        begin_song_samples 52
        end_song_samples 52

        begin_song_samples 53
        def_song_sample $09
        def_song_sample $21
        def_song_sample $09
        def_song_sample $11
        end_song_samples 53

        begin_song_samples 54
        def_song_sample $09
        def_song_sample $21
        def_song_sample $09
        def_song_sample $11
        end_song_samples 54

        begin_song_samples 55
        def_song_sample $09
        def_song_sample $21
        def_song_sample $09
        def_song_sample $11
        end_song_samples 55

        begin_song_samples 56
        def_song_sample $09
        def_song_sample $21
        def_song_sample $09
        def_song_sample $22
        def_song_sample $11
        end_song_samples 56

        begin_song_samples 57
        def_song_sample $09
        def_song_sample $11
        end_song_samples 57

        begin_song_samples 58
        def_song_sample $09
        def_song_sample $11
        end_song_samples 58

        begin_song_samples 59
        def_song_sample $09
        def_song_sample $11
        end_song_samples 59

        begin_song_samples 60
        def_song_sample $09
        def_song_sample $11
        end_song_samples 60

        begin_song_samples 61
        def_song_sample $08
        def_song_sample $14
        def_song_sample $04
        def_song_sample $0b
        def_song_sample $0e
        def_song_sample $10
        end_song_samples 61

        begin_song_samples 62
        end_song_samples 62

        begin_song_samples 63
        def_song_sample $1d
        def_song_sample $0d
        def_song_sample $0c
        def_song_sample $0b
        def_song_sample $14
        def_song_sample $10
        def_song_sample $01
        def_song_sample $20
        def_song_sample $09
        def_song_sample $21
        end_song_samples 63

        begin_song_samples 64
        def_song_sample $0b
        def_song_sample $0e
        def_song_sample $05
        def_song_sample $14
        def_song_sample $04
        def_song_sample $02
        def_song_sample $07
        def_song_sample $06
        def_song_sample $01
        def_song_sample $1a
        end_song_samples 64

        begin_song_samples 65
        def_song_sample $10
        def_song_sample $0f
        def_song_sample $0d
        def_song_sample $14
        def_song_sample $0b
        end_song_samples 65

        begin_song_samples 66
        def_song_sample $1d
        def_song_sample $10
        end_song_samples 66

        begin_song_samples 67
        def_song_sample $1c
        def_song_sample $0b
        def_song_sample $0d
        def_song_sample $16
        def_song_sample $10
        def_song_sample $09
        end_song_samples 67

        begin_song_samples 68
        def_song_sample $0b
        def_song_sample $0e
        def_song_sample $1c
        def_song_sample $04
        def_song_sample $02
        def_song_sample $08
        def_song_sample $10
        def_song_sample $0d
        end_song_samples 68

        begin_song_samples 69
        end_song_samples 69

        begin_song_samples 70
        end_song_samples 70

        begin_song_samples 71
        end_song_samples 71

; ---------------------------------------------------------------------------

; c4/46aa
SampleBRR:
        .incbin "sample_brr.dat"

; ---------------------------------------------------------------------------

; c5/e5e8
SongScript:
        .incbin "song_script.dat"

; ---------------------------------------------------------------------------

.segment "song_script_41"

; d0/c800
        .incbin "song_script_41.dat"

; ---------------------------------------------------------------------------

.segment "sample_brr_33"

; d4/f000
        .incbin "sample_brr_33.dat"

.segment "sample_brr_2f"

; db/f800
        .incbin "sample_brr_2f.dat"

; ---------------------------------------------------------------------------
