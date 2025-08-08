.list off
.ifndef PASSIVE_ABILITY_NAME_INC
PASSIVE_ABILITY_NAME_INC = 1

.global PassiveAbilityName

.scope PassiveAbilityName

        ARRAY_LENGTH = 3
        ITEM_SIZE = 8
        SIZE = ARRAY_LENGTH * ITEM_SIZE

.endscope

.endif
.list on
