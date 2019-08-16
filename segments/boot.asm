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

  hlt

msg db 'Fuck!', 0
db 510-($-start) dup(0x90), 0x55, 0xAA
