.list off
.ifndef JOB_NAME_INC
JOB_NAME_INC = 1

.global JobName

.scope JobName

        ARRAY_LENGTH = 22
        ITEM_SIZE = 8
        SIZE = ARRAY_LENGTH * ITEM_SIZE

.endscope

.endif
.list on
