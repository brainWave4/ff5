.list off
.ifndef SAMPLE_BRR_INC
SAMPLE_BRR_INC = 1

.global SampleBRR, SampleBRRPtrs

; instrument sample ids
.enum SAMPLE_BRR
    BASS_DRUM       ; $01
    SNARE           ; $02
    HARD_SNARE      ; $03
    CYMBAL          ; $04
    TOM             ; $05
    CLOSED_HIHAT    ; $06
    OPEN_HIHAT      ; $07
    TIMPANI         ; $08
    VIBRAPHONE      ; $09
    MARIMBA         ; $0a
    STRINGS         ; $0b
    CHOIR           ; $0c
    HARP            ; $0d
    TRUMPET         ; $0e
    OBOE            ; $0f
    FLUTE           ; $10
    ORGAN           ; $11
    PIANO           ; $12
    ELECTRIC_BASS   ; $13
    BASS_GUITAR     ; $14
    GRAND_PIANO     ; $15
    MUSIC_BOX_INSTR ; $16
    WOO             ; $17
    METAL_SYSTEM    ; $18
    SYNTH_CHORD     ; $19
    DIST_GUITAR     ; $1a
    KRABI           ; $1b
    HORN            ; $1c
    MANDOLIN        ; $1d
    UNKNOWN_1       ; $1e
    CONGA           ; $1f
    CASABA          ; $20
    KLAVES          ; $21
    UNKNOWN_2       ; $22
    HAND_CLAP       ; $23
.endenum

.scope SampleBRR

; ##############################################################################
; ###          AUTOMATICALLY GENERATED CODE, DO NOT MODIFY MANUALLY          ###
; ##############################################################################


; ##############################################################################

.endscope

.endif
.list on