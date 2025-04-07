# Punch Word to Paper Tape

Punches the contents of `AC0` to paper tape.
This can be used for adding a `JRST` or `HALT` instruction to the end of a RIM tape.

## Use

Put the word to punch in `AC0` and begin execution at `770400`.

## Assembly

| Location | Label   | Instruction      | Word           | Comment                                       |
| -------- | ------- | ---------------- | -------------- | --------------------------------------------- |
|          |         | `LOC 770400`     |                |                                               |
| `770400` |         | `CONO PTP,50`    | `71020-50`     | Set up paper tape punch                       |
| `770401` |         | `MOVEI 4,6`      | `2012-6`       | Set byte counter in AC4 to 6                  |
| `770402` |         | `HRLZI 5,440600` | `51524-440600` | Set up the byte pointer in AC5                |
| `770403` | `LOOP:` | `ILDB 7,5`       | `13434-5`      | Put byte to punch in AC7                      |
| `770404` |         | `DATAO PTP,7`    | `71014-7`      | Punch AC7                                     |
| `770405` |         | `CONSO PTP,10`   | `71034-10`     | Check punch done                              |
| `770406` |         | `JRST .-1`       | `254-770405`   | If not check again                            |
| `770407` |         | `SOJE 5,FIN`     | `3622-770411`  | Decrement AC4, if it is zero the word is done |
| `770410` |         | `JRST LOOP`      | `254-770403`   | Punch next byte                               |
| `770411` | `FIN:`  | `HALT 770400`    | `2542-770400`  |                                               |