
; +----------------------------------------------------------------------------+
; |                                                                            |
; |                              FINAL FANTASY V                               |
; |                                                                            |
; +----------------------------------------------------------------------------+
; | file: src/gfx/gfx-main.asm                                                 |
; |                                                                            |
; | description: graphics assets main assembly file                            |
; +----------------------------------------------------------------------------+

.include "const.inc"
.include "macros.inc"

; ------------------------------------------------------------------------------

.segment "window_gfx"

.export WindowPal, WindowGfx

; c0/d340
WindowPal:
        .incbin "window.pal"

; c0/d380
WindowGfx:
        incbin_lang "window_%s.4bpp"

; ------------------------------------------------------------------------------

.segment "map_overlay"

.export MapOverlayGfx

; c0/df00
MapOverlayGfx:
        .incbin "map_overlay.1bpp"

; ------------------------------------------------------------------------------

.segment "map_pal"

.export MapPal

; c3/bb00
MapPal:
.repeat 44, i
        .incbin .sprintf("map_pal/map_pal_%04x.pal", i)
.endrep

; ------------------------------------------------------------------------------

.segment "big_font_gfx"

.export BigFontGfx

; c3/eb00
BigFontGfx:
        incbin_lang "big_font_%s.1bpp"

; ------------------------------------------------------------------------------

.segment "timer_font_gfx"

.export TimerFontGfx

; cd/fe00
TimerFontGfx:
        .incbin "timer_font.4bpp"

; ------------------------------------------------------------------------------

.segment "minimap_gfx"

.export MinimapGfx

; cf/d800
MinimapGfx:
        .incbin "minimap.4bpp"

; ------------------------------------------------------------------------------

.export WorldTileAttr

.segment "world_tile_attr"

; cf/f9c0
WorldTileAttr:
        .incbin "world_tile_attr/bartz_world.dat"
        .incbin "world_tile_attr/galuf_world.dat"
        .incbin "world_tile_attr/underwater.dat"

; ------------------------------------------------------------------------------

.export WorldPal

.segment "world_pal"

; cf/fcc0
WorldPal:
        .incbin "world_pal/bartz_world.pal"
        .incbin "world_pal/galuf_world.pal"
        .incbin "world_pal/underwater.pal"

; ------------------------------------------------------------------------------

.export MonsterStencil

.segment "monster_stencil"

; not sure why ld65 needs "near" below. using .addr should force it to 16-bit.

; d0/d000
MonsterStencil:
        .addr   near MonsterStencilSmall
        .addr   near MonsterStencilLarge

; d0/d004
MonsterStencilSmall:
        .incbin "monster_stencil_small.dat"

; d0/d334
MonsterStencilLarge:
        .incbin "monster_stencil_large.dat"

; ------------------------------------------------------------------------------

.segment "the_end_gfx"

.export TheEndGfx

; d0/e4cb
TheEndGfx:
        .incbin "the_end.4bpp.lz"

; ------------------------------------------------------------------------------

.export AttackTiles1, AttackTiles2, AttackTiles3
.export AttackGfx1, AttackGfx2, AttackGfx3
.export AnimalsTiles, AnimalsGfx
.export WeaponTiles, WeaponGfx
.export WeaponHitTiles, WeaponHitGfx
.export AttackPal

.segment "attack_gfx1"

; d1/7fa0
AttackTiles1:
        .incbin "attack1.scr"

; d1/87a0
AttackTiles2:
        .incbin "attack2.scr"

; d1/8fa0
AttackTiles3:
        .incbin "attack3.scr"

; d1/97a0
WeaponTiles:
        .incbin "weapons.scr"

; d1/9ba0
WeaponHitTiles:
        .incbin "weapon_hit.scr"

; d1/a3a0
AttackPal:
        .repeat 128, i
        .incbin .sprintf("attack_pal/pal_%04X.pal", i)
        .endrep

; d1/aba0
AnimalsGfx:
        .incbin "animals.4bpp"

; d1/be00
AnimalsTiles:
        .incbin "animals.scr"

; d1/c000
WeaponGfx:
        .incbin "weapons.3bpp"

; d1/d800
WeaponHitGfx:
        .incbin "weapon_hit.3bpp"

; ------------------------------------------------------------------------------

.segment "small_font_gfx"

.export SmallFontGfx

; d1/f000
SmallFontGfx:
        .incbin "small_font.2bpp"

; ------------------------------------------------------------------------------

.segment "battle_char_gfx"

.export BattleCharGfx

; d2/0000
BattleCharGfx:
        .repeat 110, i
        .incbin .sprintf("battle_char_gfx/gfx_%04X.4bpp", i)
        .endrep

; ------------------------------------------------------------------------------

.include "gfx/battle_bg_anim.inc"
.include "gfx/battle_bg_pal_anim.inc"
.include "gfx/battle_bg_flip.inc"
.include "gfx/battle_bg_tiles.inc"

.export BattleBGProp, BattleBGPal
.export BattleBGAnim, BattleBGAnimPtrs
.export BattleBGPalAnim, BattleBGPalAnimPtrs
.export BattleBGFlip, BattleBGFlipPtrs
.export BattleBGTiles, BattleBGTilesPtrs

.segment "battle_bg"

; d4/ba21
BattleBGProp:
        .incbin "battle_bg_prop.dat"

; d4/bb31: battle bg palettes (84 items, 32 bytes each)
BattleBGPal:
        .repeat 84, i
        .incbin .sprintf("battle_bg_pal/pal_%04X.pal", i)
        .endrep

; d4/c5b1: pointers to battle bg animation data (+$D40000)
BattleBGAnimPtrs:
        ptr_tbl BattleBGAnim

; d4/c5c1: battle bg animation data (8 items, variable size)
BattleBGAnim:
        .incbin "battle_bg_anim.dat"

; d4/c6cd: pointers to battle bg palette animation data (+$D4000)
BattleBGPalAnimPtrs:
        ptr_tbl BattleBGPalAnim

; d4/c6d3: battle bg palette animation data (3 items, variable size)
BattleBGPalAnim:
        .incbin "battle_bg_pal_anim.dat"

; d4/c736: pointers to battle bg tile flip data (+$D40000)
BattleBGFlipPtrs:
        ptr_tbl BattleBGFlip

; d4/c748: battle bg tile flip data (9 items, variable size)
BattleBGFlip:
        .incbin "battle_bg_flip.dat"

; d4/c86d: pointers to battle bg tile layout (+$D40000)
BattleBGTilesPtrs:
        ptr_tbl BattleBGTiles

; d4/c8a5: battle bg tile layout (28 items, variable size)
BattleBGTiles:
        .incbin "battle_bg_tiles.dat"

; ------------------------------------------------------------------------------

.export MonsterGfx

.segment "monster_gfx"

; d5/0000
MonsterGfx:
        .incbin "monster_gfx.dat"

; ------------------------------------------------------------------------------

.export _d84157, BattleBGGfxPtrs

.segment "battle_bg_gfx"

_d84157:
        .faraddr $7fc000
        .faraddr $7fc600
        .faraddr $7fcc00
        .faraddr $7fd600
        .faraddr $7fc000
        .faraddr $7fc200
        .faraddr $7fc000
        .faraddr $7fd000
        .faraddr $7fc000
        .faraddr $7fcc00
        .faraddr $7fca00
        .faraddr $7fd200
        .faraddr $7fc000
        .faraddr $7fc000
        .faraddr $7fda00
        .faraddr $7fe000
        .faraddr $7fc000
        .faraddr $7fce00
        .faraddr $7fce00
        .faraddr $7fc000
        .faraddr $7fc000

.scope BattleBGGfx
        ARRAY_LENGTH = 21
.endscope

; d8/4196
BattleBGGfxPtrs:
        ptr_tbl_far BattleBGGfx

; d8/41d5
BattleBGGfx::_6:
BattleBGGfx::_7:
        .incbin "battle_bg_gfx/gfx_0000.4bpp.lz"

; d8/5a3d
BattleBGGfx::_8:
BattleBGGfx::_9:
BattleBGGfx::_14:
BattleBGGfx::_15:
        .incbin "battle_bg_gfx/gfx_0001.4bpp.lz"

; d8/7878
BattleBGGfx::_16:
BattleBGGfx::_18:
        .incbin "battle_bg_gfx/gfx_0002.4bpp.lz"

; d8/88b2
BattleBGGfx::_0:
BattleBGGfx::_1:
BattleBGGfx::_2:
BattleBGGfx::_3:
BattleBGGfx::_5:
        .incbin "battle_bg_gfx/gfx_0003.4bpp.lz"

; d8/a517
BattleBGGfx::_4:
BattleBGGfx::_10:
BattleBGGfx::_11:
        .incbin "battle_bg_gfx/gfx_0004.4bpp.lz"

; d8/b959
BattleBGGfx::_13:
BattleBGGfx::_17:
        .incbin "battle_bg_gfx/gfx_0005.4bpp.lz"

; d8/cdd8
BattleBGGfx::_20:
        .incbin "battle_bg_gfx/gfx_0006.4bpp.lz"

; d8/d881
BattleBGGfx::_19:
        .incbin "battle_bg_gfx/gfx_0007.4bpp.lz"

; d8/dc32
BattleBGGfx::_12:
        .incbin "battle_bg_gfx/gfx_0008.4bpp.lz"

; ------------------------------------------------------------------------------

.segment "attack_gfx2"

.export AttackGfx1, AttackGfx2, AttackGfx3

; d9/0000
AttackGfx1:
        .incbin "attack1.3bpp"

; d9/2ec8
AttackGfx2:
        .incbin "attack2.3bpp"

; d9/5760
AttackGfx3:
        .incbin "attack3.3bpp"


; ------------------------------------------------------------------------------

.segment "world_gfx"

.export WorldGfx

; db/8000
WorldGfx:
        .incbin "world_gfx/bartz_world.4bpp"
        .incbin "world_gfx/galuf_world.4bpp"
        .incbin "world_gfx/underwater.4bpp"

; ------------------------------------------------------------------------------

.segment "map_sprite_gfx"

.export MapSpriteGfx, VehicleGfx, WorldSpriteGfx

; da/0000
MapSpriteGfx:
        .incbin "map_sprite.4bpp"

; db/3a00
VehicleGfx:
        .incbin "vehicle.3bpp"

; db/4d80
WorldSpriteGfx:
        .incbin "world_sprite.4bpp"

; ------------------------------------------------------------------------------

.segment "kanji_gfx"

.export KanjiGfx

; db/d000
KanjiGfx:
        .incbin "kanji.1bpp"

; ------------------------------------------------------------------------------

.segment "map_gfx"

.export MapBG3Gfx, MapBG3GfxPtrs, MapGfx, MapGfxPtrs

.enum MapBG3Gfx
        ARRAY_LENGTH = 17
        Start = MapBG3Gfx
.endenum

; dc/0000
MapBG3GfxPtrs:
        ptr_tbl MapBG3Gfx
        end_ptr MapBG3Gfx

; dc/0024
MapBG3Gfx:

.repeat MapBG3Gfx::ARRAY_LENGTH, i
        array_item MapBG3Gfx, {i} := *
        .incbin .sprintf("map_bg3_gfx/map_bg3_gfx_%04x.2bpp", i)
.endrep
MapBG3Gfx::End:

; ------------------------------------------------------------------------------

.enum MapGfx
        ARRAY_LENGTH = 39
        Start = MapGfx
.endenum

; dc/2d84
MapGfxPtrs:
        ptr_tbl_dword MapGfx
        end_ptr_dword MapGfx

; dc/2e24
MapGfx:
.repeat MapGfx::ARRAY_LENGTH, i
        array_item MapGfx, {i} := *
        .incbin .sprintf("map_gfx/map_gfx_%04x.4bpp", i)
.endrep
MapGfx::End:

; ------------------------------------------------------------------------------

.segment "map_anim_gfx"

.export MapAnimGfx

; df/9b00
MapAnimGfx:
        .incbin "map_anim.4bpp"

; ------------------------------------------------------------------------------

.segment "map_sprite_pal"

.export MapSpritePal

; df/fc00
MapSpritePal:
.repeat 32, i
        .incbin .sprintf("map_sprite_pal/map_sprite_%04x.pal", i)
.endrep

.export MapSpritePal_8 := MapSpritePal + 8 * 32
.export VehiclePal := MapSpritePal + 26 * 32
.export MapSpritePal_bf05 := MapSpritePal + $224

; ------------------------------------------------------------------------------
