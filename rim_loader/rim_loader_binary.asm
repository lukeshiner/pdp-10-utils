;   Rim Loader Binary
;
;   Places the RIM loader into memory so it can be punched to paper tape.

        LOC 770000
        XWD -8,1        ;77777000001    IOWORD for Read In Mode
        710600000060
        710740000010
        254000000003
        710440000010
        710740000010
        254000000006
        0
        254000000003
        END
        