;   RIM Loader
;
;   A simple data loading routine that can be read in using the PDP-10 Read In Mode.
;
;   Reads in data from the paper tape reader in the following format:
;       For each word of data two words (6 lines) are punched to the tape.
;       The first line is a DATAI PTR instruction with the address at which the data
;       is to be stored as an arument. This is followed by the word to be stored.
;       Finally a one word instruction is punched to either halt the machine or
;       jump to the start of execution.
;
;   The loader is located in AC2 - AC11.
;
;   This loader is from the PDP-10 Reference Handbook - Book 2 - Assembling the Source
;   Program (page 252). Here it states that the program is usually toggled into
;   memory starting at location 20 though for use with Read In Mode I have put it in
;   the accumulators.

        LOC 2
        CONO PTR,60         ; Set up paper tape reader and read first word
A:      CONSO PTR,10        ; Check if next word is ready
        JRST .-1            ; Jump back one instruction and check again if not
        DATAI PTR,B         ; Read one word from PTR
        CONSO PTR,10        ; Check if next word is ready...
        JRST .-1            ; Jump back one if not
B:      0                   ; Space for the instruction read from the tape
        JRST A              ; Loop
        END