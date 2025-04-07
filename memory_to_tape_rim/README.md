# Memory To Tape RIM

Punches data from memory in Read In Mode format.

When punched on a tape following the RIM loader the punched memory will be restored to the same location.

The RIM format consists of an instruction word containing a `DATAI` instruction pointing at the memory location a word should be stored in followed by the word that should be stored there for each word to be read in. A RIM tape consists of the RIM Loader program followed by the necessary data in this format. At the end of the tape a single instruction is punched that will be executed after all the data has been loaded, this is usually a jump to the start of the program or a HALT.

## Use

Put the start location of the memory to punch in `AC0`.
Put the number of words to punch in `AC1`.
Begin execution at `770300`.

## Assembly

| Location | Label    | Instruction          | Word           | Comment                                                                     |
| -------- | -------- | -------------------- | -------------- | --------------------------------------------------------------------------- |
|          |          | `LOC 770300`         |                |                                                                             |
| `770300` |          | `CONO PTP,50`        | `71020-50`     | Set up paper tape punch                                                     |
| `770301` |          | `MOVE 2,0`           | `2001-0`       | Copy start address to AC2                                                   |
| `770302` |          | `MOVE 3,1`           | `20014-1`      | Copy number of words to punch to AC3                                        |
| `770303` | `NWORD:` | `HRLI 5,440600`      | `50524-440600` | Set up left half of byte pointer in AC5                                     |
| `770304` |          | `HRRI 5,6`           | `54124-6`      | Set target of byte pointer to AC6                                           |
| `770305` |          | `MOVEI 4,6`          | `2012-6`       | Set byte counter to 6                                                       |
| `770306` |          | `HRLI 6,[DATAI PTR]` | `5053-710440`  | Set the left half of AC6 to DATAI instruction                               |
| `770307` |          | `HRR 6,2`            | `5403-2`       | Set the right half of AC6 to the current address                            |
| `770310` | `ILOOP:` | `ILDB 7,5`           | `13434-5`      | Increment byte pointer and put byte in AC7                                  |
| `770311` |          | `DATAO PTP,7`        | `71014-7`      | Punch AC7                                                                   |
| `770312` |          | `CONSO PTP,10`       | `71034-10`     | Check punch complete                                                        |
| `770314` |          | `SOJE 4,DWORD`       | `254-770312`   | Check again if not                                                          |
| `770313` |          | `JRST .-1`           | `3622-770316`  | If AC4 is zero DATAI instruction has been punched, start punching data word |
| `770315` |          | `JRST ILOOP`         | `254-770310`   | Otherwise continue punching instruction word                                |
| `770316` | `DWORD:` | `HRLI 5,440600`      | `50524-440600` | Set up left  half of byte pointer                                           |
| `770317` |          | `HRR 5,6`            | `54024-6 `     | Set target of byte pointer to AC6                                           |
| `770320` |          | `MOVEI 4,6`          | `2012-6`       | Set byte counter to 6                                                       |
| `770321` |          | `MOVE 6,@2`          | `20032-2`      | Move the word to be punched to AC6                                          |
| `770322` | `DLOOP:` | `ILDB 7,5`           | `13434-5`      | Increment byte pointer and put byte in AC7                                  |
| `770323` |          | `DATAO PTP,7`        | `71014-7`      | Punch AC7                                                                   |
| `770324` |          | `CONSO PTP,10`       | `71034-10`     | Check if punched                                                            |
| `770325` |          | `JRST .-1`           | `254-70324`    | Check again if not                                                          |
| `770326` |          | `SOJE 4,DDONE`       | `3622-770330`  | Decrement byte pointer jump if zero                                         |
| `770327` |          | `JRST DLOOP`         | `254-770322`   | If not punch next byte                                                      |
| `770330` | `DDONE:` | `AOJ 2,0`            | `3401-0`       | Increment current address                                                   |
| `770331` |          | `SOJG 3,NWORD`       | `36714-770303` | Decrement word count, new word if greater than zero                         |
| `770332` | `FIN:`   | `HALT 770300`        | `2542 770300`  |
