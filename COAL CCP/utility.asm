INCLUDE config.inc

.code
; Generates unique shipment tracking hash using shift and rotate instructions
GenerateShipmentCode PROC,
    prodID:DWORD,
    stock:DWORD

    mov eax, prodID
    rol eax, 7          ; Rotate bits left
    xor eax, stock      ; Apply XOR transformation
    ror eax, 3          ; Rotate bits right
    ret
GenerateShipmentCode ENDP

; Checks if two strings are identical (returns 1 if equal, 0 if not)
StringCompare PROC USES esi edi,
    str1:PTR BYTE,
    str2:PTR BYTE

    mov esi, str1
    mov edi, str2

CompareLoop:
    mov al, [esi]
    mov bl, [edi]
    cmp al, bl
    jne MatchFailed
    cmp al, 0
    je MatchSuccess
    inc esi
    inc edi
    jmp CompareLoop

MatchFailed:
    mov eax, 0
    ret

MatchSuccess:
    mov eax, 1
    ret
StringCompare ENDP

; Helper to parse character byte digits into integer values
ParseInt PROC USES esi edx ecx,
    strPtr:PTR BYTE

    mov esi, strPtr
    mov eax, 0 ; Accumulator
    mov ecx, 10

ConvertLoop:
    movzx edx, byte ptr [esi]
    cmp dl, 0
    je Done
    cmp dl, '0'
    jb Done
    cmp dl, '9'
    ja Done
    
    sub dl, '0'
    imul eax, ecx
    add eax, edx
    inc esi
    jmp ConvertLoop

Done:
    ret
ParseInt ENDP
END