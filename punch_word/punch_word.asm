;   Punch Word
;
;   Punches the word in AC0 to paper tape.
;
;   Useful for putting a jump or halt at the end of a RIM Loader tape.
;
;   Put the word to punch in AC0. Usually a JRST or HALT.
;   Start execution at 770400.
;
        LOC 770400
        CONO PTP,50     ; Set up paper tape punch
        MOVEI 4,6       ; Set byte counter in AC4 to 6
        HRLZI 5,440600  ; Set up the byte pointer in AC5
LOOP:   ILDB 7,5        ; Put byte to punch in AC7
        DATAO PTP,7     ; Punch AC7
        CONSO PTP,10    ; Check punch done
        JRST .-1        ; If not check again
        SOJE 4,FIN      ; Decrement AC4, if zero word is punched, skip next instruction
        JRST LOOP       ; Punch next byte
FIN:    HALT 770400
        END
