;   Memory to Tape RIM
;
;   Punches data from memory to paper tape in RIM format for reloading.
;
;   This format consists of a DATAI instruction with the address of the word to be
;   stored as an operand, followed by the word to be stored at that address.
;
;   Set AC0 to the start address of the data to be punched.
;   Set AC1 to the number of words to punch.
;   Begin execution at 770300.
;   AC0 and AC1 are not changed when the program is executed.
;
;   AC2 is used to store the current address being punched.
;   AC3 stores the number of words remaining to be punched.
;   AC4 stores the number of bytes remaining in the current word.
;   AC5 is used for the byte pointer.
;   AC6 stores the word currently being punched.
;   AC7 stores the byte being punched.
;

        LOC 770300

; Set up

        CONO PTP,50         ; Set up paper tape punch
        MOVE 2,0            ; Copy start address to AC2
        MOVE 3,1            ; Copy number of words to punch to AC3

; Punch DATAI instruction word

NWORD:  HRLI 5,440600       ; Set up left half of byte pointer in AC5
        HRRI 5,6            ; Set target of byte pointer to AC6
        MOVEI 4,6           ; Set byte counter to 6
        HRLI 6,[DATAI PTR]  ; Set the left half of AC6 to DATAI instruction
        HRR 6,2             ; Set the right half of AC6 to the current address
ILOOP:  ILDB 7,5            ; Increment byte pointer and put byte in AC7
        DATAO PTP,7         ; Punch AC7
        CONSO PTP,10        ; Check punch complete
        JRST .-1            ; Check again if not
        SOJE 4,DWORD        ; If AC4 is zero DATAI instruction has been punched,
                            ; start punching data word
        JRST ILOOP          ; Otherwise continue punching instruction word

; Punch data word

DWORD:  HRLI 5,440600       ; Set up left  half of byte pointer
        HRR 5,6             ; Set target of byte pointer to AC6
        MOVEI 4,6           ; Set byte counter to 6
        MOVE 6,@2           ; Move the word to be punched to AC6
DLOOP:  ILDB 7,5            ; Increment byte pointer and put byte in AC7
        DATAO PTP,7         ; Punch AC7
        CONSO PTP,10        ; Check if punched
        JRST .-1            ; Check again if not
        SOJE 4,DDONE        ; Decrement byte pointer jump if zero
        JRST DLOOP          ; If not punch next byte
DDONE:  AOJ 2,0             ; Increment current address
        SOJG 3,NWORD        ; Decrement word count, new word if greater than zero
FIN:    HALT 770300
        END