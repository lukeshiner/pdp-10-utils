;   Memory to Tape Raw
;
;   Punches a chunk of memory to paper tape.
;
;   Set AC0 to the start address of the data.
;   Set AC1 to the number of words to output.
;   Begin execution at 770200.
;

        LOC 770200
START:  CONO PTP,50     ; Set up tape punch
        MOVE 3,1        ; Copy the number of words to punch to AC3
        HRLI 2,440600   ; Set left half of byte pointer in AC2
        HRR 2,0         ; Add the start address to the byte pointer
WLOOP:  MOVEI 4,6       ; Set the byte counter in AC4
BLOOP:  ILDB 5,2        ; Increment the counter and move a byte to AC5
        DATAO PTP,5     ; Punch the byte in AC5
        CONSO PTP,10    ; Check if the punch is ready
        JRST .-1        ; Jump back one if not
        SOJE 4,NWORD    ; If word is complete start next word
        JRST BLOOP      ; Word is incomplete, go to next byte
NWORD:  SOJL 3,FIN      ; Subtract 1 from remaining words, if zero jump
        JRST WLOOP      ; Start punching next word
FIN:    HALT START
        END