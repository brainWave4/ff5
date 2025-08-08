.list off
.ifndef BATTLE_CMD_NAME_INC
BATTLE_CMD_NAME_INC = 1

.global BattleCmdName

.scope BattleCmdName

        ARRAY_LENGTH = 96
        ITEM_SIZE = 5
        SIZE = ARRAY_LENGTH * ITEM_SIZE

.endscope

.endif
.list on
