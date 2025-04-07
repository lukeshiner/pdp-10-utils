# Memory To Tape Raw

Punches the raw binary of an area of memory to paper tape.

## Use

Put the start location of the memory to punch in `AC0`.
Put the number of words to punch in `AC1`.
Begin execution at `770200`.

## Assembly

| Location | Label    | Instruction     | Word            | Comment                                                       |
| -------- | -------- | --------------- | --------------- | ------------------------------------------------------------- |
|          |          | `LOC 770200`    |                 |                                                               |
| `770200` | `START:` | `CONO PTP,50`   | `71020-30`      | Set up tape punch                                             |
| `770201` |          | `MOVE 3,1`      | `20014-1`       | Copy the number of words to punch to AC3                      |
| `770202` |          | `HRLI 2,440600` | `5051-440600`   | Set the left half of the byte pointer in AC2                  |
| `770203` |          | `HRR 2,0`       | `5401-0`        | Add the start address to the byte pointer                     |
| `770204` | `WLOOP:` | `MOVEI 4,6`     | `2012-6`        | Set the byte counter in AC4                                   |
| `770205` | `BLOOP:` | `ILDB 5,2`      | `13424-2`       | Increment the counter and move a byte to AC5                  |
| `770206` |          | `DATAO PTP,5`   | `71014-5`       | Punch the byte in AC5                                         |
| `770207` |          | `CONSO PTP,10`  | `71034-10`      | Check if the punch is ready                                   |
| `770210` |          | `JRST .-1`      | `254-770207`    | If not jump back to the previouis instruction                 |
| `770211` |          | `SOJE 4,NWORD`  | `3622-770213`   | If the word is complete jump out of the loop                  |
| `770212` |          | `JRST BLOOP`    | `254-770205`    | Jump back to punch the next byte                              |
| `770213` | `NWORD:` | `SOJL 3,FIN`    | `361114-770215` | Decrement the word counter. If it is now zero jump to the end |
| `770214` |          | `JRST WLOOP`    | `254-770204`    | Jump back to punch the next word                              |
| `770215` | `FIN:`   | `HALT START`    | `2542-770200`   |
|          | `END`    |                 |                 |                                                               |