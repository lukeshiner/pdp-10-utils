# PDP-10 Utils

## What is this?

This is a set of utilites written for working on the bare metal of a DEC PDP-10 ([PiDP-10](https://obsolescence.dev/pdp10.html)). Currently it can produce binary data or RIM (Read In Mode) paper tape files using the PiDP-10's simuated paper tape punch. More features may be added later.

It is capable of using the simulated paper tape punch to recreate itself.

## Why is this?

I have been experimenting with bare metal programming using a [PiDP-10](https://obsolescence.dev/pdp10.html) and needed to have some software I could use to save and load my work. This is a RIM file meaning it can easily be read into memory using the PDP-10 Read In Mode and the simulated paper tape reader.

## What can it do?

Each of the programs contained on the RIM is presented here as an assembly file. As I manually assembled the programs and entered them with the PiDP-10 front panel I am not sure if they will work correcly with an assembler. I followed the format of the Macro assembler from the [PDP-10 Reference Handbook (1970)](http://www.bitsavers.org/pdf/dec/pdp10/1970_PDP-10_Ref/1970PDP10Ref_Part2.pdf) so they should work with that but remain untested. The programs themselves have been tested. In the README for each program I have included the assembly along with each assembled instruction for easy entry into the front panel. Because PDP-10 instructions tend to have a lot of zeros in the middle I have formated the instruction words as a left and right half. The left half should start at bit 0 (all the way to the left) and the right half should finish at bit 35 (all the way to the right) with zeros in between. All instructions and memory locations are in octal.

### Memory to Tape Raw

A program to punch the contents of a block of memory to paper tape.

Put the start address of the data to be punched in `AC0` (memory location `0`).
Put the number of words to punch in `AC1` (memory location `1`).
Begin execution from memory location `770200`.

### Memory to Tape RIM

A program to punch the contents of a block of memory to paper tape in Read In Mode format for easy loading back into memory.

Put the start address of the data to be punched in `AC0` (memory location `0`).
Put the number of words to punch in `AC1` (memory location `1`).
Begin execution from memory location `770300`.

### Punch Word

A short program that punches a single word to paper tape. This is intended for adding the last Jump or Halt instruction to a RIM tape.

Put the word to punch in `AC0` (memory location 0).
Begin execution from memory location `770400`.


### RIM Loader

The RIM loader is a small program that is placed in memory by Read In Mode and then executed to load the rest of a RIM tape. The RIM loader is included in binary so it can be punched to the start of a tape using `Memory to Tape Raw`. It is located at memory location `770000`.

## Loading

Do not load this into the PiDP-10 when it is running an operating system. By default it boots into the Bilnky program if no switches are pressed when booting. Loading the utils in this state cannot do any damage. If an operating system is loaded (TOPS or ITS) the operating system files could be altered and will need to be downloaded again.

The utils.rim file can be read in to the memory of the PiDP-10 using Read In Mode. 

- Download the utils.rim file to the Raspberry Pi host of the PiDP-10.
- Access the `simh` emulator running the PDP-10 simulation by entering `pdp` in the Raspberry Pi console.
- Ensure the simluation is stopped by pressing the Stop siwtch on the PiDP-10 or pressing `ctrl-e` on the `simh` window. If you have a cursor the simulation is stopped.
- Set the PDP-10 Read In Device to the paper tape reader. This can be done in either of two ways:
  - In the `simh` window type `d readin 104`.
  - On the PiDP-10 front pannel:
    - Switch on the PAR Stop siwtch.
    - Enter 104 on the address switches.
    - Press the Read In switch.
    - Disable the PAR Stop switch.
- Attach the `utils.rim` file the the paper tape reader by entering `at ptr [path to utils.bin]` in `simh`. For example `at ptr ~/Downloads/utils.rim`.
- Everything is now set up. Just press the Read In switch on the PiDP-10 and the programs will be loaded.

## Recreating the File from the PDP-10

Load `utils.rim` as above.

Enable the simulated paper tape punch with a new file.
```
at ptp ~/new_utiles.rim
```
You can now punch the tape. This is done in several stages. For each stage a value is entered into `AC1` and `AC2` before executing a program at a given memory location. The values and memory locations are given below in the correct order along with an explaination of each step. All values are in octal.

| AC0          | AC1    | Execute From | Step                                                 |
| ------------ | ------ | ------------ | ---------------------------------------------------- |
| 770000       | 10     | 770200       | Punch the RIM loader program                         |
| 770000       | 11     | 770300       | Punch the RIM loader source in RIM format            |
| 770200       | 16     | 770300       | Punch the `Memory to Tape Raw` program in RIM format |
| 770300       | 33     | 770300       | Punch the `Memory to Tape RIM` program in RIM format |
| 770400       | 12     | 770300       | Punch the `Punch Word` program in RIM format         |
| 254200000000 | Unused | 770400       | Punch a HALT instruction to finish the RIM loader    |