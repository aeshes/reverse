format binary
use16
org 0x7C00

BOOT_OFFSET    equ 0x7C00
TARGET_SEGMENT equ 0x1000
SECTOR_SIZE    equ 0x200

start:
  mov ax, 3
  int 10h
  mov ax, 0xB800
  mov es, ax
  lea si, [msg]
  xor di, di
  mov ah, 0x0D
print:
  lodsb
  stosw
  test al, al
  jnz print

  cld
  xor ax, ax

  mov ds, ax
  mov si, BOOT_OFFSET

  mov di, ax
  mov ax, TARGET_SEGMENT
  mov es, ax

  mov cx, SECTOR_SIZE
  mov bx, cx
  rep movsb

  mov ah, 2  ; read sector
  mov al, 1
  mov dx, 0
  mov cx, 2  ; second sector
  int 13h

  push TARGET_SEGMENT
  push TARGET_OFFSET - BOOT_OFFSET
  retf

TARGET_OFFSET:
  ;
  ; open A20 gate
  ;
  in al, 0x92
  or al, 2
  out 0x92, al

  cli
  mov al, 0x8F
  out 0x70, al
  in al, 0x71

  ; magic break
  xchg bx, bx

  ;
  ; calculate physical address
  ;
  mov eax, TARGET_SEGMENT
  shl eax, 4
  add eax, GDT - BOOT_OFFSET

  mov [(GDTR-BOOT_OFFSET) + 2], eax
  lgdt fword [GDTR - BOOT_OFFSET]

  ;
  ; turn on protected mode
  ;
  mov eax, cr0
  or al, 1
  mov cr0, eax

  ; magic break
  xchg bx, bx

  ; enter protected mode
  jmp fword 8:PM_ENTRY-BOOT_OFFSET

GDT:
  dq 0                  ; NULL descriptor

  ; code segment
  db 0xFF      ; segment limit
  db 0xFF
  db 0         ; base address
  db 0
  db 0xFF
  db 10011010b ; 1001, C/D - 1, R/W - 1, 0
  db 0         ; G - 0, 000, limit - 0000
  db 0         ; base address

  ; data segment
  db 0xFF      ; segment limit
  db 0xFF
  db 0         ; base address
  db 0x10
  db 0xFF
  db 10010010b ; 1001, C/D - 0, 0, R/W - 1, 0
  db 0         ; G - 0, 000, limit - 0000
  db 0         ; base address

  ; stack segment
  db 0xFF      ; segment limit
  db 0xFF
  db 0         ; base address
  db 0x20
  db 0xFF
  db 10010010b ; 1001, C/D - 0, 0, R/W - 1, 0
  db 01000000b ; G - 0, D - 1, limit - 0
  db 0         ; base address

  ; video segment
  db 0xFF      ; segment limit
  db 0xFF
  db 0         ; base address
  db 0x80
  db 0x0B
  db 10010010b ; 1001, C/D - 0, 0, R/W - 1, 0
  db 0         ; G - 0, 000, limit - 0000
  db 0         ; base address

GDTR:
  dw (GDTR - BOOT_OFFSET - GDT - 1)
  dd ?

msg db 'Fuck!', 0
db 510-($-start) dup(0x90), 0x55, 0xAA

use32
PM_ENTRY:
  ;
  ; set segment registers
  ;
  mov ax, 0x10 ; data selector
  mov ds, ax   ; set data segment
  mov ax, 0x18 ; video selector
  mov gs, ax   ; set video segment
