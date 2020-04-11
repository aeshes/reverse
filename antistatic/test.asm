format PE GUI
include 'win32ax.inc'

section 'data' readable writeable
    message db "AntiStatic",0
    caption db "Caption",0
        
.code
start:
    jmp L1
    db 0xE8, 01, 02, 03, 04
    db 0xFF, 0x15
L1:
    invoke MessageBox, HWND_DESKTOP, message, caption, MB_OK
    jmp Next
.end start

section 'code2' readable writeable executable
Next:
    invoke GetCommandLine
    invoke ExitProcess, 0