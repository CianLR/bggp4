# bggp4
Entry for [binary.golf](http://binary.golf) BGGP4. This compiles to an ELF file that replicates itself to a file called '4' and prints '4' to stdout. 

## Versions
Compiled with NASM version 2.14.02

Developed and tested on Ubuntu 20.04, kernel 5.15.0.

## Compiling

Run NASM: `nasm -f bin -o bggp.elf bggp.S`

Make the file executable: `chmod +x bggp.elf`

## Execution

```
$ ls
bggp.elf

$ ./bggp.elf
4

$ ls
4  bggp.elf

$ sha256sum *
9066f4ab52161d1e07b353b4aa40b4bd1a32632a7481439e94f87cd3708e4388  4
9066f4ab52161d1e07b353b4aa40b4bd1a32632a7481439e94f87cd3708e4388  bggp.elf

$ ls -la bggp.elf
-rwxrwxr-x 1 cian cian 110 Jun 27 22:24 bggp.elf
```


