; +-------------------------------------------------------------------------+
; |                                                                         |
; |                             FINAL FANTASY V                             |
; |                                                                         |
; +-------------------------------------------------------------------------+
; | file: battle/battle-main.asm                                            |
; |                                                                         |
; | description: battle program                                             |
; +-------------------------------------------------------------------------+

.p816

; ===========================================================================

.include "macros.inc"
.include "hardware.inc"
.include "const.inc"

.export ExecBattle_ext

; ===========================================================================

.segment "battle_code"

; ==============================[ battle main ]==============================

.proc ExecBattle_ext
_0000:
        jmp     ExecBattle
.endproc

.proc BackgroundEnablingRoutine_ext
_0003:
        jmp $F75F ; bg enabling routine
.endproc


.proc UnknownRoutine1_ext
_0006:
        jmp $E999 ; unknown routine
.endproc

.proc DAphx_ext
_0009:
        jmp $003F
.endproc


.proc JumpTable_ext
_000C:
        asl A
        tax
        lda $C10021,X ; jump table
        sta $7A
        lda $C10022,X
        sta $7B
        jsr $001E
        rtl
 .endproc

; ---------------------------------------------------------------------------

; [ execute battle ]

.proc ExecBattle

_0003:  php
        longai
        phb
        phd
        pha
        phx
        phy
        lda     #0
        shorta
        longi
        jsr     $0053
        longa
        clc
        lda     $09c0
        adc     #1                      ; increment battle count
        bcc     _0023
        lda     #$ffff
_0023:  sta     $09c0
        shorta0
        stz     $7cd8
_002c:  jsr     $4ce0
        lda     #0
        sta     f:hINIDISP
        sta     f:hHDMAEN
        sta     f:hMDMAEN
        sta     f:hNMITIMEN
        lda     $7cd8
        bne     _002c
        sei
        jsr     $0053
        longai
        ply
        plx
        pla
        pld
        plb
        plp
        rtl

.endproc

; ---------------------------------------------------------------------------
