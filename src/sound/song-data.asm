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
        .word   $0a8c           ; BASS_DRUM
        .word   $0bd9           ; SNARE
        .word   $1194           ; HARD_SNARE
        .word   $05fa           ; CYMBAL
        .word   $15f9           ; TOM
        .word   $0465           ; CLOSED_HIHAT
        .word   $1194           ; OPEN_HIHAT
        .word   $1194           ; TIMPANI
        .word   $04f5           ; VIBRAPHONE
        .word   $029a           ; MARIMBA
        .word   $08f7           ; STRINGS
        .word   $02c7           ; CHOIR
        .word   $034e           ; HARP
        .word   $04da           ; TRUMPET
        .word   $0252           ; OBOE
        .word   $0489           ; FLUTE
        .word   $0936           ; ORGAN
        .word   $0642           ; PIANO
        .word   $0144           ; ELECTRIC_BASS
        .word   $044a           ; BASS_GUITAR
        .word   $05bb           ; GRAND_PIANO
        .word   $0666           ; MUSIC_BOX_INSTR
        .word   $1194           ; WOO
        .word   $09bd           ; METAL_SYSTEM
        .word   $0384           ; SYNTH_CHORD
        .word   $05bb           ; DIST_GUITAR
        .word   $092d           ; KRABI
        .word   $15f9           ; HORN
        .word   $0318           ; MANDOLIN
        .word   $077d           ; UNKNOWN_1
        .word   $08dc           ; CONGA
        .word   $088d           ; CASABA
        .word   $09e1           ; KLAVES
        .word   $0e7c           ; UNKNOWN_2
        .word   $0b6d           ; HAND_CLAP

; ---------------------------------------------------------------------------

; c4/3d1e
SampleFreqMult:
        .byte   $c0,$00         ; BASS_DRUM
        .byte   $00,$00         ; SNARE
        .byte   $c0,$00         ; HARD_SNARE
        .byte   $00,$00         ; CYMBAL
        .byte   $60,$00         ; TOM
        .byte   $00,$00         ; CLOSED_HIHAT
        .byte   $00,$00         ; OPEN_HIHAT
        .byte   $fb,$00         ; TIMPANI
        .byte   $fe,$48         ; VIBRAPHONE
        .byte   $e0,$a0         ; MARIMBA
        .byte   $00,$7c         ; STRINGS
        .byte   $fd,$00         ; CHOIR
        .byte   $51,$00         ; HARP
        .byte   $fe,$00         ; TRUMPET
        .byte   $e0,$90         ; OBOE
        .byte   $fc,$60         ; FLUTE
        .byte   $fc,$7f         ; ORGAN
        .byte   $ff,$00         ; PIANO
        .byte   $fc,$c0         ; ELECTRIC_BASS
        .byte   $fc,$a0         ; BASS_GUITAR
        .byte   $fc,$d0         ; GRAND_PIANO
        .byte   $ff,$a0         ; MUSIC_BOX_INSTR
        .byte   $00,$00         ; WOO
        .byte   $00,$00         ; METAL_SYSTEM
        .byte   $00,$00         ; SYNTH_CHORD
        .byte   $00,$00         ; DIST_GUITAR
        .byte   $fe,$00         ; KRABI
        .byte   $e0,$b0         ; HORN
        .byte   $fc,$90         ; MANDOLIN
        .byte   $e0,$c0         ; UNKNOWN_1
        .byte   $00,$00         ; CONGA
        .byte   $00,$00         ; CASABA
        .byte   $0e,$00         ; KLAVES
        .byte   $00,$00         ; UNKNOWN_2
        .byte   $00,$00         ; HAND_CLAP

; ---------------------------------------------------------------------------

; c4/3d64
SampleADSR:
        make_adsr 15,15,7,0    ; BASS_DRUM
        make_adsr 15,15,7,0    ; SNARE
        make_adsr 15,15,7,0    ; HARD_SNARE
        make_adsr 15,15,7,16   ; CYMBAL
        make_adsr 15,15,7,0    ; TOM
        make_adsr 15,15,7,0    ; CLOSED_HIHAT
        make_adsr 15,15,7,0    ; OPEN_HIHAT
        make_adsr 15,15,7,0    ; TIMPANI
        make_adsr 15,15,7,16   ; VIBRAPHONE
        make_adsr 15,15,7,21   ; MARIMBA
        make_adsr 15,15,7,0    ; STRINGS
        make_adsr 15,15,7,0    ; CHOIR
        make_adsr 15,15,7,18   ; HARP
        make_adsr 15,15,7,1    ; TRUMPET
        make_adsr 15,15,7,1    ; OBOE
        make_adsr 15,15,7,1    ; FLUTE
        make_adsr 15,15,7,0    ; ORGAN
        make_adsr 15,15,7,13   ; PIANO
        make_adsr 15,15,7,0    ; ELECTRIC_BASS
        make_adsr 15,15,7,12   ; BASS_GUITAR
        make_adsr 15,15,7,10   ; GRAND_PIANO
        make_adsr 15,15,7,19   ; MUSIC_BOX_INSTR
        make_adsr 15,15,7,0    ; WOO
        make_adsr 15,15,7,10   ; METAL_SYSTEM
        make_adsr 15,15,7,10   ; SYNTH_CHORD
        make_adsr 15,15,7,8    ; DIST_GUITAR
        make_adsr 15,15,7,19   ; KRABI
        make_adsr 15,15,7,1    ; HORN
        make_adsr 15,15,7,17   ; MANDOLIN
        make_adsr 15,15,7,20   ; UNKNOWN_1
        make_adsr 15,15,7,19   ; CONGA
        make_adsr 15,15,7,0    ; CASABA
        make_adsr 15,15,7,0    ; KLAVES
        make_adsr 15,15,7,0    ; UNKNOWN_2
        make_adsr 15,15,7,0    ; HAND_CLAP

; ---------------------------------------------------------------------------

; c4/3daa

SongSamples:

        begin_song_samples 0
        def_song_sample OBOE
        def_song_sample TRUMPET
        def_song_sample STRINGS
        def_song_sample BASS_GUITAR
        def_song_sample CLOSED_HIHAT
        def_song_sample OPEN_HIHAT
        def_song_sample BASS_DRUM
        def_song_sample SNARE
        def_song_sample HARP
        def_song_sample CYMBAL
        end_song_samples 0

        begin_song_samples 1
        def_song_sample TIMPANI
        def_song_sample TRUMPET
        def_song_sample BASS_GUITAR
        def_song_sample STRINGS
        def_song_sample CYMBAL
        def_song_sample SNARE
        end_song_samples 1

        begin_song_samples 2
        def_song_sample OBOE
        def_song_sample FLUTE
        def_song_sample STRINGS
        def_song_sample GRAND_PIANO
        def_song_sample HORN
        def_song_sample MUSIC_BOX_INSTR
        def_song_sample CHOIR
        def_song_sample SYNTH_CHORD
        def_song_sample CYMBAL
        end_song_samples 2

        begin_song_samples 3
        def_song_sample OBOE
        def_song_sample MARIMBA
        def_song_sample BASS_GUITAR
        def_song_sample TRUMPET
        def_song_sample CLOSED_HIHAT
        def_song_sample OPEN_HIHAT
        def_song_sample BASS_DRUM
        def_song_sample SNARE
        def_song_sample TOM
        end_song_samples 3

        begin_song_samples 4
        def_song_sample OBOE
        def_song_sample FLUTE
        def_song_sample TRUMPET
        def_song_sample MANDOLIN
        def_song_sample BASS_GUITAR
        def_song_sample TIMPANI
        end_song_samples 4

        begin_song_samples 5
        def_song_sample HARP
        def_song_sample OBOE
        def_song_sample HORN
        def_song_sample STRINGS
        def_song_sample MANDOLIN
        end_song_samples 5

        begin_song_samples 6
        def_song_sample FLUTE
        def_song_sample HARP
        def_song_sample STRINGS
        def_song_sample BASS_GUITAR
        def_song_sample TOM
        def_song_sample CASABA
        def_song_sample CONGA
        def_song_sample CYMBAL
        end_song_samples 6

        begin_song_samples 7
        def_song_sample OBOE
        def_song_sample FLUTE
        def_song_sample MARIMBA
        def_song_sample TIMPANI
        def_song_sample BASS_GUITAR
        end_song_samples 7

        begin_song_samples 8
        def_song_sample HARP
        def_song_sample STRINGS
        def_song_sample OBOE
        def_song_sample HORN
        end_song_samples 8

        begin_song_samples 9
        def_song_sample TRUMPET
        def_song_sample STRINGS
        def_song_sample BASS_GUITAR
        def_song_sample CYMBAL
        def_song_sample FLUTE
        def_song_sample CLOSED_HIHAT
        def_song_sample OPEN_HIHAT
        def_song_sample BASS_DRUM
        def_song_sample HARD_SNARE
        end_song_samples 9

        begin_song_samples 10
        def_song_sample FLUTE
        def_song_sample STRINGS
        end_song_samples 10

        begin_song_samples 11
        def_song_sample PIANO
        def_song_sample CHOIR
        def_song_sample STRINGS
        def_song_sample MUSIC_BOX_INSTR
        end_song_samples 11

        begin_song_samples 12
        def_song_sample OBOE
        def_song_sample STRINGS
        def_song_sample GRAND_PIANO
        def_song_sample TOM
        def_song_sample TIMPANI
        def_song_sample METAL_SYSTEM
        end_song_samples 12

        begin_song_samples 13
        def_song_sample FLUTE
        def_song_sample STRINGS
        def_song_sample MUSIC_BOX_INSTR
        def_song_sample BASS_GUITAR
        def_song_sample VIBRAPHONE
        end_song_samples 13

        begin_song_samples 14
        def_song_sample TRUMPET
        def_song_sample BASS_GUITAR
        def_song_sample SNARE
        def_song_sample BASS_DRUM
        def_song_sample ORGAN
        end_song_samples 14

        begin_song_samples 15
        def_song_sample HARP
        def_song_sample STRINGS
        def_song_sample FLUTE
        end_song_samples 15

        begin_song_samples 16
        def_song_sample OBOE
        def_song_sample HARP
        def_song_sample STRINGS
        def_song_sample BASS_GUITAR
        def_song_sample CHOIR
        end_song_samples 16

        begin_song_samples 17
        end_song_samples 17

        begin_song_samples 18
        def_song_sample STRINGS
        def_song_sample BASS_GUITAR
        def_song_sample TRUMPET
        def_song_sample ORGAN
        def_song_sample CYMBAL
        def_song_sample TIMPANI
        end_song_samples 18

        begin_song_samples 19
        def_song_sample FLUTE
        def_song_sample PIANO
        def_song_sample STRINGS
        def_song_sample MANDOLIN
        end_song_samples 19

        begin_song_samples 20
        def_song_sample STRINGS
        def_song_sample FLUTE
        def_song_sample OBOE
        def_song_sample SNARE
        def_song_sample HORN
        def_song_sample TIMPANI
        end_song_samples 20

        begin_song_samples 21
        def_song_sample OBOE
        def_song_sample KLAVES
        def_song_sample STRINGS
        def_song_sample BASS_GUITAR
        def_song_sample TIMPANI
        def_song_sample KRABI
        def_song_sample HARP
        def_song_sample HORN
        end_song_samples 21

        begin_song_samples 22
        def_song_sample TRUMPET
        def_song_sample STRINGS
        def_song_sample BASS_GUITAR
        def_song_sample TIMPANI
        def_song_sample SNARE
        def_song_sample CYMBAL
        end_song_samples 22

        begin_song_samples 23
        def_song_sample STRINGS
        def_song_sample BASS_GUITAR
        def_song_sample CYMBAL
        def_song_sample BASS_DRUM
        def_song_sample HARD_SNARE
        end_song_samples 23

        begin_song_samples 24
        def_song_sample BASS_GUITAR
        def_song_sample STRINGS
        def_song_sample SNARE
        def_song_sample TRUMPET
        def_song_sample CYMBAL
        end_song_samples 24

        begin_song_samples 25
        def_song_sample STRINGS
        def_song_sample OBOE
        def_song_sample HARP
        def_song_sample FLUTE
        end_song_samples 25

        begin_song_samples 26
        def_song_sample TRUMPET
        def_song_sample UNKNOWN_1
        def_song_sample BASS_GUITAR
        def_song_sample KLAVES
        def_song_sample WOO
        def_song_sample CASABA
        def_song_sample UNKNOWN_2
        def_song_sample CONGA
        end_song_samples 26

        begin_song_samples 27
        def_song_sample MUSIC_BOX_INSTR
        end_song_samples 27

        begin_song_samples 28
        def_song_sample OBOE
        def_song_sample HARP
        def_song_sample STRINGS
        def_song_sample BASS_GUITAR
        def_song_sample ELECTRIC_BASS
        def_song_sample KLAVES
        def_song_sample CYMBAL
        end_song_samples 28

        begin_song_samples 29
        def_song_sample TRUMPET
        def_song_sample HARP
        def_song_sample BASS_GUITAR
        def_song_sample STRINGS
        def_song_sample CLOSED_HIHAT
        def_song_sample BASS_DRUM
        def_song_sample SNARE
        end_song_samples 29

        begin_song_samples 30
        def_song_sample FLUTE
        def_song_sample HARP
        def_song_sample STRINGS
        end_song_samples 30

        begin_song_samples 31
        def_song_sample BASS_DRUM
        def_song_sample BASS_GUITAR
        def_song_sample STRINGS
        def_song_sample TRUMPET
        def_song_sample FLUTE
        def_song_sample KLAVES
        def_song_sample HAND_CLAP
        def_song_sample CYMBAL
        end_song_samples 31

        begin_song_samples 32
        def_song_sample TRUMPET
        def_song_sample STRINGS
        def_song_sample BASS_GUITAR
        def_song_sample SNARE
        def_song_sample CYMBAL
        def_song_sample TIMPANI
        end_song_samples 32

        begin_song_samples 33
        def_song_sample OBOE
        def_song_sample HAND_CLAP
        def_song_sample FLUTE
        def_song_sample ELECTRIC_BASS
        def_song_sample MANDOLIN
        def_song_sample TOM
        end_song_samples 33

        begin_song_samples 34
        def_song_sample ORGAN
        def_song_sample TRUMPET
        def_song_sample BASS_GUITAR
        def_song_sample DIST_GUITAR
        def_song_sample CYMBAL
        def_song_sample CLOSED_HIHAT
        def_song_sample OPEN_HIHAT
        def_song_sample BASS_DRUM
        def_song_sample HARD_SNARE
        def_song_sample TOM
        end_song_samples 34

        begin_song_samples 35
        def_song_sample FLUTE
        def_song_sample STRINGS
        def_song_sample TIMPANI
        def_song_sample BASS_GUITAR
        def_song_sample SNARE
        def_song_sample HARP
        def_song_sample CYMBAL
        def_song_sample HORN
        def_song_sample TRUMPET
        end_song_samples 35

        begin_song_samples 36
        def_song_sample HARP
        def_song_sample VIBRAPHONE
        def_song_sample METAL_SYSTEM
        def_song_sample CHOIR
        def_song_sample CONGA
        def_song_sample STRINGS
        def_song_sample MANDOLIN
        def_song_sample CYMBAL
        end_song_samples 36

        begin_song_samples 37
        def_song_sample TOM
        def_song_sample CONGA
        def_song_sample CASABA
        def_song_sample BASS_GUITAR
        def_song_sample VIBRAPHONE
        def_song_sample WOO
        end_song_samples 37

        begin_song_samples 38
        def_song_sample STRINGS
        def_song_sample KRABI
        def_song_sample CLOSED_HIHAT
        def_song_sample OPEN_HIHAT
        def_song_sample CONGA
        def_song_sample BASS_DRUM
        def_song_sample SNARE
        def_song_sample VIBRAPHONE
        def_song_sample BASS_GUITAR
        def_song_sample CYMBAL
        end_song_samples 38

        begin_song_samples 39
        def_song_sample FLUTE
        def_song_sample STRINGS
        def_song_sample HARP
        def_song_sample BASS_GUITAR
        def_song_sample OPEN_HIHAT
        def_song_sample CLOSED_HIHAT
        def_song_sample BASS_DRUM
        def_song_sample HARD_SNARE
        def_song_sample SNARE
        end_song_samples 39

        begin_song_samples 40
        def_song_sample FLUTE
        def_song_sample TRUMPET
        def_song_sample STRINGS
        def_song_sample BASS_GUITAR
        def_song_sample CYMBAL
        def_song_sample CLOSED_HIHAT
        def_song_sample OPEN_HIHAT
        def_song_sample TIMPANI
        def_song_sample BASS_DRUM
        def_song_sample SNARE
        end_song_samples 40

        begin_song_samples 41
        def_song_sample TRUMPET
        def_song_sample TIMPANI
        def_song_sample CYMBAL
        def_song_sample STRINGS
        end_song_samples 41

        begin_song_samples 42
        def_song_sample TRUMPET
        def_song_sample STRINGS
        def_song_sample FLUTE
        def_song_sample CYMBAL
        def_song_sample SNARE
        def_song_sample TIMPANI
        end_song_samples 42

        begin_song_samples 43
        def_song_sample STRINGS
        def_song_sample TRUMPET
        def_song_sample BASS_GUITAR
        def_song_sample CYMBAL
        def_song_sample CLOSED_HIHAT
        def_song_sample OPEN_HIHAT
        def_song_sample BASS_DRUM
        def_song_sample SNARE
        def_song_sample VIBRAPHONE
        end_song_samples 43

        begin_song_samples 44
        def_song_sample TRUMPET
        def_song_sample ORGAN
        def_song_sample MANDOLIN
        def_song_sample BASS_GUITAR
        def_song_sample DIST_GUITAR
        def_song_sample CYMBAL
        def_song_sample CLOSED_HIHAT
        def_song_sample OPEN_HIHAT
        def_song_sample BASS_DRUM
        def_song_sample SNARE
        def_song_sample SYNTH_CHORD
        end_song_samples 44

        begin_song_samples 45
        def_song_sample STRINGS
        def_song_sample CHOIR
        def_song_sample BASS_GUITAR
        def_song_sample CYMBAL
        def_song_sample BASS_DRUM
        def_song_sample HARD_SNARE
        def_song_sample DIST_GUITAR
        end_song_samples 45

        begin_song_samples 46
        def_song_sample TRUMPET
        def_song_sample STRINGS
        def_song_sample BASS_GUITAR
        def_song_sample HORN
        def_song_sample SNARE
        def_song_sample CYMBAL
        end_song_samples 46

        begin_song_samples 47
        def_song_sample BASS_GUITAR
        def_song_sample TRUMPET
        def_song_sample MANDOLIN
        def_song_sample KLAVES
        def_song_sample HAND_CLAP
        end_song_samples 47

        begin_song_samples 48
        end_song_samples 48

        begin_song_samples 49
        def_song_sample TRUMPET
        def_song_sample STRINGS
        def_song_sample FLUTE
        def_song_sample MARIMBA
        def_song_sample TIMPANI
        def_song_sample CYMBAL
        def_song_sample HORN
        def_song_sample SNARE
        end_song_samples 49

        begin_song_samples 50
        def_song_sample TOM
        def_song_sample OPEN_HIHAT
        def_song_sample SNARE
        def_song_sample UNKNOWN_2
        def_song_sample KLAVES
        def_song_sample STRINGS
        def_song_sample BASS_GUITAR
        end_song_samples 50

        begin_song_samples 51
        def_song_sample OBOE
        def_song_sample TRUMPET
        def_song_sample STRINGS
        def_song_sample BASS_GUITAR
        def_song_sample HARP
        def_song_sample SNARE
        def_song_sample TIMPANI
        def_song_sample VIBRAPHONE
        end_song_samples 51

        begin_song_samples 52
        end_song_samples 52

        begin_song_samples 53
        def_song_sample VIBRAPHONE
        def_song_sample KLAVES
        def_song_sample VIBRAPHONE
        def_song_sample ORGAN
        end_song_samples 53

        begin_song_samples 54
        def_song_sample VIBRAPHONE
        def_song_sample KLAVES
        def_song_sample VIBRAPHONE
        def_song_sample ORGAN
        end_song_samples 54

        begin_song_samples 55
        def_song_sample VIBRAPHONE
        def_song_sample KLAVES
        def_song_sample VIBRAPHONE
        def_song_sample ORGAN
        end_song_samples 55

        begin_song_samples 56
        def_song_sample VIBRAPHONE
        def_song_sample KLAVES
        def_song_sample VIBRAPHONE
        def_song_sample UNKNOWN_2
        def_song_sample ORGAN
        end_song_samples 56

        begin_song_samples 57
        def_song_sample VIBRAPHONE
        def_song_sample ORGAN
        end_song_samples 57

        begin_song_samples 58
        def_song_sample VIBRAPHONE
        def_song_sample ORGAN
        end_song_samples 58

        begin_song_samples 59
        def_song_sample VIBRAPHONE
        def_song_sample ORGAN
        end_song_samples 59

        begin_song_samples 60
        def_song_sample VIBRAPHONE
        def_song_sample ORGAN
        end_song_samples 60

        begin_song_samples 61
        def_song_sample TIMPANI
        def_song_sample BASS_GUITAR
        def_song_sample CYMBAL
        def_song_sample STRINGS
        def_song_sample TRUMPET
        def_song_sample FLUTE
        end_song_samples 61

        begin_song_samples 62
        end_song_samples 62

        begin_song_samples 63
        def_song_sample MANDOLIN
        def_song_sample HARP
        def_song_sample CHOIR
        def_song_sample STRINGS
        def_song_sample BASS_GUITAR
        def_song_sample FLUTE
        def_song_sample BASS_DRUM
        def_song_sample CASABA
        def_song_sample VIBRAPHONE
        def_song_sample KLAVES
        end_song_samples 63

        begin_song_samples 64
        def_song_sample STRINGS
        def_song_sample TRUMPET
        def_song_sample TOM
        def_song_sample BASS_GUITAR
        def_song_sample CYMBAL
        def_song_sample SNARE
        def_song_sample OPEN_HIHAT
        def_song_sample CLOSED_HIHAT
        def_song_sample BASS_DRUM
        def_song_sample DIST_GUITAR
        end_song_samples 64

        begin_song_samples 65
        def_song_sample FLUTE
        def_song_sample OBOE
        def_song_sample HARP
        def_song_sample BASS_GUITAR
        def_song_sample STRINGS
        end_song_samples 65

        begin_song_samples 66
        def_song_sample MANDOLIN
        def_song_sample FLUTE
        end_song_samples 66

        begin_song_samples 67
        def_song_sample HORN
        def_song_sample STRINGS
        def_song_sample HARP
        def_song_sample MUSIC_BOX_INSTR
        def_song_sample FLUTE
        def_song_sample VIBRAPHONE
        end_song_samples 67

        begin_song_samples 68
        def_song_sample STRINGS
        def_song_sample TRUMPET
        def_song_sample HORN
        def_song_sample CYMBAL
        def_song_sample SNARE
        def_song_sample TIMPANI
        def_song_sample FLUTE
        def_song_sample HARP
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
