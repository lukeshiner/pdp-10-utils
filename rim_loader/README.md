# RIM Loader

A RIM loader is a small program that can be put in memory using the Read In Mode of the PDP-10. This program then loads more data into memory.

Read In Mode uses an IOWORD at the start of the data that is used internally with BLKI instructions to read in a block of data. The IOWORD consists of the [two's complement](https://en.wikipedia.org/wiki/Two%27s_complement) negative of the number of words to write in the left half and a memory location one less than the start location of the data in memory. This is followed by the data to be loaded. The RIM loader is punched at the start of a paper tape and after being read in is executed to load more data in in a more versatile format. While the PDP-10 usually used a RIM loader that included error checking I have used a much simpler one intended for the PDP-6 as this format is much easier to punch out and error checking is not all that necessary when your paper tape and reader are both simulated. It does require a lot more tape but, again, as the tape is simulated this doesn't seem like much of an issue.

This loader is from the [PDP-10 Reference Handbook - Book 2 - Assembling the Source Program](http://www.bitsavers.org/pdf/dec/pdp10/1970_PDP-10_Ref/1970PDP10Ref_Part2.pdf) (page 252).

Data that is read in with this loader is formated as:
- First a word is punched containing a DATAI PTR (data in from paper tape reader) instruction with a memory location as an argument.
- Second a word is punched that will be placed at the location referenced by the previous word.
- This is repeated for each word that is to be loaded in.
- Finally an instruction word is punched at the end of the tape that will be executed after the data has been read in. This is usually a jump to start the program that has just been read in running or a HALT.

`rim_loader.asm` contains an assembly file for the RIM loader as it would appear in memory after being read in. While this loader would originaly have been toggled in to memory with the front pannel starting at location 20 I have relocated it into the Accumulator Registers so it doesn't overwrite anything in low memory. It now starts at location 2.

`rim_loader_binary.asm` contains the rim loader as raw data to be stored out of the way in high memory from where it can be punched at the start of a new tape.

## Use

The RIM loader can be punched to a paper tape using `memory to tape raw`. This can then be followed by one or more blocks of data punched with `memory to tape rim` and finally an instruction punched with `punch word` to start execution or halt the computer. This will created a RIM file that can be loaded back into the PDP-10.

## Assembly

| Location | Label | Instruction    | Word        | Comment                                                      |
| -------- | ----- | -------------- | ----------- | ------------------------------------------------------------ |
|          |       | `LOC 2`        |             |                                                              |
| `2`      |       | `CONO PTR 60`  | `7106-60`   | Set up paper tape reader and read first word                 |
| `3`      | `A`   | `CONSO PTR,10` | `71074-10`  | Check if next word is ready                                  |
| `4`      |       | `JRST .-1`     | `254-3`     | Jump back one instruction and check again if not             |
| `5`      |       | `DATAI PTR,B`  | `71044-10`  | Read one word from paper tape reader                         |
| `6`      |       | `CONSO PTR,10` | `71074-10 ` | Check if next word is ready...                               |
| `7`      |       | `JRST .-1`     | `254-6`     | Jump back one if not                                         |
| `10`     | `B:`  | `0`            | `0`         | Space for the instruction read from the tape                 |
| `11`     |       | `JRST A`       | `254-3`     | Loop until an instruction is read in that jumps out or halts |
|          |       | `END`          |             |

## Binary

The RIM loader located in high memory for punching to tape.

| Location | Instruction    | Word        |
| -------- | -------------- | ----------- |
| `770000` | `XWD -8,1`     | `777770-1`  |
| `770001` | `CONO PTR,60`  | `7106-60`   |
| `770002` | `CONSO PTR,10` | `71074-10	` |
| `770003` | `JRST .-1`     | `254-3`     |
| `770004` | `DATAI PTR,B`  | `71044-10`  |
| `770005` | `CONSO PTR,10` | `71074-10`  |
| `770006` | `JRST .-1`     | `254-6`     |
| `770007` | `0`            | `0`         |
| `770010` | `JRST A`       | `254-3`     |
