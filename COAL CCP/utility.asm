INCLUDE config.inc

.code
GenerateShipmentCode PROC,
    prodID:DWORD,
    stock:DWORD

    mov eax, prodID
    rol eax, 6          ; Shifting bits left by 6 steps
    xor eax, stock      ; Apply unique mask
    ror eax, 2          ; Rotate right by 2 steps
    ret
GenerateShipmentCode ENDP
END