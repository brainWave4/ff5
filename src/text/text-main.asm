
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
inc_lang "text/map_title_%s.inc"
inc_lang "text/battle_dlg_%s.inc"
inc_lang "text/battle_msg_%s.inc"

.export ItemName, JobName, MagicName, AttackName, MonsterName
.export MonsterSpecialName, StatusName, BattleCmdName
.export PassiveAbilityName, SpecialAbilityName

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

.segment "monster_name"

; d0/5c00
.if LANG_EN
        .res 384 * 8, $ff
.else
MonsterName:
        .incbin "monster_name_jp.dat"
.endif

; ------------------------------------------------------------------------------

.segment "monster_special_name"

; d0/8700
.if !LANG_EN
MonsterSpecialName:
.endif
        .incbin "monster_special_name_jp.dat"

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

.segment "battle_dlg"

; d0/f000
BattleDlgPtrs:
        ptr_tbl BattleDlg

; d0/f1d4
.if !LANG_EN
BattleDlg:
        .incbin "battle_dlg_jp.dat"
.endif

; ------------------------------------------------------------------------------

.segment "item_name"

; d1/1380
.if LANG_EN
.export ItemNameShort := *
.else
ItemName:
.endif
        incbin_lang "item_name_%s.dat"

; ------------------------------------------------------------------------------

.segment "attack_name"

        fixed_block $0800

; d1/1c80
MagicName:
        incbin_lang "magic_name_%s.dat"

; d1/1e8a
AttackName:
        incbin_lang "attack_name_%s.dat"

        end_fixed_block

; ------------------------------------------------------------------------------

.segment "status_name"

; d1/28b6: status names (24 items, 8 bytes each)
StatusName:
        incbin_lang "src/text/status_name_%s.dat"

; ------------------------------------------------------------------------------

.export AttackMessageTbl

.segment "battle_msg"

; d1/3840
AttackMessageTbl:
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
        .byte   $00,$00,$00,$00,$00,$00,$00,$34,$00,$00,$00,$00,$00,$00,$00,$00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
        .byte   $00,$00,$00,$4d,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
        .byte   $00,$00,$35,$00,$00,$36,$37,$38,$39,$00,$00,$00,$00,$00,$00,$00
        .byte   $00,$00,$00,$00,$40,$3d,$00,$46,$00,$43,$00,$00,$00,$00,$00,$00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$45,$00,$00,$00,$00,$00,$00,$00
        .byte   $00,$00,$00,$3a,$00,$00,$00,$3b,$3b,$3b,$00,$00,$00,$00,$00,$00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
        .byte   $00,$00,$00,$40,$41,$42,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
        .byte   $00,$00,$47,$48,$00,$00,$00,$00,$00,$34,$00,$00,$00,$00,$00,$00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
        .byte   $49,$00,$00,$00,$4a,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00

; d1/39a9
BattleMsgPtrs:
        ptr_tbl BattleMsg

; d1/3ba9
.if !LANG_EN
BattleMsg:
        .incbin "battle_msg_jp.dat"
.endif

; ------------------------------------------------------------------------------

.segment "job_name"

; d1/5600
JobName:
        .incbin "job_name_jp.dat"

; ------------------------------------------------------------------------------

.segment "battle_cmd_name"

; d1/5800
.if LANG_EN
        .res 96 * 5, $ff
.else
BattleCmdName:
        .incbin "battle_cmd_name_jp.dat"
.endif

; ------------------------------------------------------------------------------

.segment "passive_ability_name"

; d1/6200
.if !LANG_EN
PassiveAbilityName:
.endif
        .incbin "passive_ability_name_jp.dat"

; ------------------------------------------------------------------------------

.segment "special_ability_name"

; d1/6700
.if LANG_EN
        .res 105 * 9
.else
SpecialAbilityName:
        .incbin "special_ability_name_jp.dat"
.endif

; ------------------------------------------------------------------------------

.if LANG_EN

.segment "monster_name_en"

; e0/0050
MonsterName:
        .incbin "monster_name_en.dat"

.segment "battle_cmd_name_en"

; e0/1150
BattleCmdName:
        .incbin "battle_cmd_name_en.dat"

.segment "dlg_en_ptrs"

; e0/13f0
DlgPtrs:
        ptr_tbl_far Dlg

.segment "dlg_en"

; e1/0000
Dlg:
        .incbin "dlg_en.dat"

.segment "special_ability_name_en"

; e7/0900
SpecialAbilityName:
        .incbin "special_ability_name_en.dat"

.segment "attack_name_short_en"

.export AttackNameShort

; e7/0900
AttackNameShort:
        .incbin "attack_name_short_en.dat"

.export AttackNameLong

.segment "attack_name_long_en"

; e7/1780
AttackNameLong:
        .incbin "attack_name_long_en.dat"

.segment "battle_msg_en"

; e7/2760
BattleMsg:
        .incbin "battle_msg_en.dat"

.segment "monster_special_name_en"

; e7/3700
MonsterSpecialName:
        .incbin "monster_special_name_en.dat"

.segment "battle_dlg_en"

; e7/3b00
BattleDlg:
        .incbin "battle_dlg_en.dat"

.segment "map_title_en"

; e7/7000
MapTitle:
        .incbin "map_title_en.dat"

.segment "item_name_en"

; e7/5860
ItemName:
        .incbin "item_name_long_en.dat"

.segment "passive_ability_name_en"

; e7/7060
PassiveAbilityName:
        .incbin "passive_ability_name_en.dat"

.endif
