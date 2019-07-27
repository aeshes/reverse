format PE

section '.text' code readable executable
  push 9   ; length
  push buf ; string pointer
  call crc32_proc

  ret

crc32_proc:
  mov esi, [esp+4]    ; get string pointer
  mov ecx, [esp+8]    ; get length parameter
  mov edi, 0FFFFFFFFh ; crc (initial value)
  xor ebx, ebx        ; y = 0
  xor edx, edx        ; a = 0
crc32_loop:
  xor eax, eax        ; clear eax for next data byte
  lodsb               ; get next data byte (= x)
  mov ebx, edi        ; y = crc
  xor ebx, eax        ; y = crc xor x
  and ebx, 0FFh       ; y = y and 0xFF
  shl ebx, 2          ; y = y * 4
  mov ebx, [crc32_table + ebx] ; b = crc32_table[y]
  mov edx, edi        ; edx = crc
  shr edx, 8          ; a = crc >> 8
  mov edi, edx        ; crc = a
  xor edi, ebx        ; crc = a xor b
  loop crc32_loop
  mov ecx, 0FFFFFFFFh
  xor edi, ecx        ; crc = crc xor 0xFFFFFFFF
  mov eax, edi

  ret 8

section '.data' data readable writeable
crc32_table:
dd  00000000h,  77073096h,  0ee0e612ch, 990951bah,  076dc419h,  706af48fh
dd  0e963a535h, 9e6495a3h,  0edb8832h,  79dcb8a4h,  0e0d5e91eh, 97d2d988h
dd  09b64c2bh,  7eb17cbdh,  0e7b82d07h, 90bf1d91h,  1db71064h,  6ab020f2h
dd  0f3b97148h, 84be41deh,  1adad47dh,  6ddde4ebh,  0f4d4b551h, 83d385c7h
dd  136c9856h,  646ba8c0h,  0fd62f97ah, 8a65c9ech,  14015c4fh,  63066cd9h
dd  0fa0f3d63h, 8d080df5h,  3b6e20c8h,  4c69105eh,  0d56041e4h, 0a2677172h
dd  3c03e4d1h,  4b04d447h,  0d20d85fdh, 0a50ab56bh, 35b5a8fah,  42b2986ch
dd  0dbbbc9d6h, 0acbcf940h, 32d86ce3h,  45df5c75h,  0dcd60dcfh, 0abd13d59h
dd  26d930ach,  51de003ah,  0c8d75180h, 0bfd06116h, 21b4f4b5h,  56b3c423h
dd  0cfba9599h, 0b8bda50fh, 2802b89eh,  5f058808h,  0c60cd9b2h, 0b10be924h
dd  2f6f7c87h,  58684c11h,  0c1611dabh, 0b6662d3dh, 76dc4190h,  01db7106h
dd  98d220bch,  0efd5102ah, 71b18589h,  06b6b51fh,  9fbfe4a5h,  0e8b8d433h
dd  7807c9a2h,  0f00f934h,  9609a88eh,  0e10e9818h, 7f6a0dbbh,  086d3d2dh
dd  91646c97h,  0e6635c01h, 6b6b51f4h,  1c6c6162h,  856530d8h,  0f262004eh
dd  6c0695edh,  1b01a57bh,  8208f4c1h,  0f50fc457h, 65b0d9c6h,  12b7e950h
dd  8bbeb8eah,  0fcb9887ch, 62dd1ddfh,  15da2d49h,  8cd37cf3h,  0fbd44c65h
dd  4db26158h,  3ab551ceh,  0a3bc0074h, 0d4bb30e2h, 4adfa541h,  3dd895d7h
dd  0a4d1c46dh, 0d3d6f4fbh, 4369e96ah,  346ed9fch,  0ad678846h, 0da60b8d0h
dd  44042d73h,  33031de5h,  0aa0a4c5fh, 0dd0d7cc9h, 5005713ch,  270241aah
dd  0be0b1010h, 0c90c2086h, 5768b525h,  206f85b3h,  0b966d409h, 0ce61e49fh
dd  5edef90eh,  29d9c998h,  0b0d09822h, 0c7d7a8b4h, 59b33d17h,  2eb40d81h
dd  0b7bd5c3bh, 0c0ba6cadh, 0edb88320h, 9abfb3b6h,  03b6e20ch,  74b1d29ah
dd  0ead54739h, 9dd277afh,  04db2615h,  73dc1683h,  0e3630b12h, 94643b84h
dd  0d6d6a3eh,  7a6a5aa8h,  0e40ecf0bh, 9309ff9dh,  0a00ae27h,  7d079eb1h
dd  0f00f9344h, 8708a3d2h,  1e01f268h,  6906c2feh,  0f762575dh, 806567cbh
dd  196c3671h,  6e6b06e7h,  0fed41b76h, 89d32be0h,  10da7a5ah,  67dd4acch
dd  0f9b9df6fh, 8ebeeff9h,  17b7be43h,  60b08ed5h,  0d6d6a3e8h, 0a1d1937eh
dd  38d8c2c4h,  4fdff252h,  0d1bb67f1h, 0a6bc5767h, 3fb506ddh,  48b2364bh
dd  0d80d2bdah, 0af0a1b4ch, 36034af6h,  41047a60h,  0df60efc3h, 0a867df55h
dd  316e8eefh,  4669be79h,  0cb61b38ch, 0bc66831ah, 256fd2a0h,  5268e236h
dd  0cc0c7795h, 0bb0b4703h, 220216b9h,  5505262fh,  0c5ba3bbeh, 0b2bd0b28h
dd  2bb45a92h,  5cb36a04h,  0c2d7ffa7h, 0b5d0cf31h, 2cd99e8bh,  5bdeae1dh
dd  9b64c2b0h,  0ec63f226h, 756aa39ch,  026d930ah,  9c0906a9h,  0eb0e363fh
dd  72076785h,  05005713h,  95bf4a82h,  0e2b87a14h, 7bb12baeh,  0cb61b38h
dd  92d28e9bh,  0e5d5be0dh, 7cdcefb7h,  0bdbdf21h,  86d3d2d4h,  0f1d4e242h
dd  68ddb3f8h,  1fda836eh,  81be16cdh,  0f6b9265bh, 6fb077e1h,  18b74777h
dd  88085ae6h,  0ff0f6a70h, 66063bcah,  11010b5ch,  8f659effh,  0f862ae69h
dd  616bffd3h,  166ccf45h,  0a00ae278h, 0d70dd2eeh, 4e048354h,  3903b3c2h
dd  0a7672661h, 0d06016f7h, 4969474dh,  3e6e77dbh,  0aed16a4ah, 0d9d65adch
dd  40df0b66h,  37d83bf0h,  0a9bcae53h, 0debb9ec5h, 47b2cf7fh,  30b5ffe9h
dd  0bdbdf21ch, 0cabac28ah, 53b39330h,  24b4a3a6h,  0bad03605h, 0cdd70693h
dd  54de5729h,  23d967bfh,  0b3667a2eh, 0c4614ab8h, 5d681b02h,  2a6f2b94h
dd  0b40bbe37h, 0c30c8ea1h, 5a05df1bh,  2d02ef8dh

buf db '123456789',0