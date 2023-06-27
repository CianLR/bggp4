 BITS 32
  
                org     0x08048000
  
  ehdr:                                                 ; Elf32_Ehdr
                db      0x7F, "ELF", 1, 1, 1, 0         ;   e_ident
                ;   we use the padding to store data, must be 8 bytes
  msg:          db      '4', 0xa  
  filename:     db      '4', 0
  pad_entry:    mov cl, 0b1000010
                jmp short eflags_code
  
                dw      2                               ;   e_type
                dw      3                               ;   e_machine
                dd      1                               ;   e_version
                dd      pad_entry                   ;   e_entry
                dd      phdr - $$                       ;   e_phoff
                dd      0                               ;   e_shoff
 
  eflags_code:  ;   this section needs to be 4 bytes
                push filesize                           ;   e_flags
                jmp short p_paddr_code
 
                dw      ehdrsize                        ;   e_ehsize
                dw      phdrsize                        ;   e_phentsize
  phdr:         ;   Overlapping ehdr and phdr
                dd      1                               ;   e_phnum, p_type
                                                        ;   e_shentsize
                dd      0                               ;   e_shnum, p_offset
                                                        ;   e_shstrndx
  
  ehdrsize      equ     $ - ehdr
  
                dd      $$                              ;   p_vaddr
  p_paddr_code: ; this section has to be 4 bytes
                mov al, 5                               ;   p_paddr
                jmp short final_code
                dd      filesize                        ;   p_filesz
                dd      filesize                        ;   p_memsz
                dd      5                               ;   p_flags
                dd      0x1000                          ;   p_align
  
  phdrsize      equ     $ - phdr
  
  msg_offset    equ msg - ehdr
  fname_offset  equ filename - ehdr

  final_code:
                ; open '4' file, other args are set above.
                mov ebx, filename  ; filename
                mov dx, 0o775  ; mode
                int 0x80

                ; write bytes
                lea ecx, [ebx - fname_offset]  ; buf* (start of elf)
                mov ebx, eax   ; file descriptor returned from open sycall
                pop edx  ; bytes to write, popping filesize pushed from eflags_code.
                mov al, 4  ; write syscall
                int 0x80

                ; print 4
                mov dl, 2  ; byte count
                mov cl, msg_offset ; we only need to add 8 to the elf header to reach msg
                mov bl, 1  ; file descriptor (stdout)
                mov al, 4  ; write syscall
                int 0x80

                dec eax  ; eax has 2 for bytes written, dec to 1 for exit
                int 0x80
  
  filesize      equ     $ - $$

