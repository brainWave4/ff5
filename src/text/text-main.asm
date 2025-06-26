
; +----------------------------------------------------------------------------+
; |                                                                            |
; |                              FINAL FANTASY V                               |
; |                                                                            |
; +----------------------------------------------------------------------------+
; | file: src/text/text-main.asm                                               |
; |                                                                            |
; | description: game text                                                     |
; +----------------------------------------------------------------------------+

.p816

.include "macros.inc"
.include "const.inc"

; ------------------------------------------------------------------------------

inc_lang "text/dlg_%s.inc"
inc_lang "text/item_name_%s.inc"
.include "text/magic_name_jp.inc"
inc_lang "text/map_title_%s.inc"

; ------------------------------------------------------------------------------

.segment "dlg_ptrs"

; c8/2220
.if !LANG_EN
DlgPtrs:
.endif
        ptr_tbl Dlg

; ------------------------------------------------------------------------------

.segment "dlg"

; ca/0000
.if !LANG_EN
Dlg:
.endif
        .incbin "dlg_jp.dat"

; ------------------------------------------------------------------------------

.segment "map_title"

; d0/7000
MapTitlePtrs:
        fixed_block $0200
        ptr_tbl MapTitle
        end_fixed_block

; d0/7200
.if !LANG_EN
MapTitle:
.endif
        fixed_block $0600
        .incbin "map_title_jp.dat"
        end_fixed_block

; ------------------------------------------------------------------------------

.segment "item_name"

; d1/1380
.if !LANG_EN
ItemName:
.endif
        .incbin "item_name_jp.dat"

; ------------------------------------------------------------------------------

.segment "magic_name"

; d1/1c80
MagicName:
        incbin_lang "magic_name_%s.dat"

; ------------------------------------------------------------------------------

.if LANG_EN

.segment "dlg_en_ptrs"

; e0/13f0
DlgPtrs:
        ptr_tbl_far Dlg

.segment "dlg_en"

; e1/0000
Dlg:
        .incbin "dlg_en.dat"

.segment "map_title_en"

; e7/7000
MapTitle:
        .incbin "map_title_en.dat"

.segment "item_name_en"
; e7/5860
ItemName:
        .incbin "item_name_en.dat"

.endif
