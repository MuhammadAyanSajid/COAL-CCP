INCLUDE config.inc

.code
ProcessRuntimeTx PROC USES esi edi,
    pArray:PTR Product,
    arraySize:DWORD,
    txType:DWORD,
    prodID:DWORD,
    val:DWORD

    ; Search for the dynamic record index offset
    INVOKE SearchByID, pArray, arraySize, prodID
    cmp eax, -1
    je FailureExit
    
    imul eax, TYPE Product
    mov esi, pArray
    add esi, eax ; ESI now points directly to the matched structure memory address
    
    cmp txType, 1
    je AddTx
    cmp txType, 2
    je SaleTx
    cmp txType, 3
    je ReturnTx
    cmp txType, 4
    je PriceTx
    jmp FailureExit

AddTx:
    mov eax, val
    add (Product PTR [esi]).CurrentStock, eax
    jmp SuccessExit

SaleTx:
    mov eax, val
    mov ecx, (Product PTR [esi]).CurrentStock
    cmp ecx, eax
    jb FailureExit ; Avoid underflow errors
    
    sub (Product PTR [esi]).CurrentStock, eax
    add (Product PTR [esi]).TotalSold, eax
    jmp SuccessExit

ReturnTx:
    mov eax, val
    add (Product PTR [esi]).CurrentStock, eax
    ; Deduct from historical sold tracker
    mov ecx, (Product PTR [esi]).TotalSold
    cmp ecx, eax
    jb ForceZeroSold
    sub (Product PTR [esi]).TotalSold, eax
    jmp SuccessExit

ForceZeroSold:
    mov (Product PTR [esi]).TotalSold, 0
    jmp SuccessExit

PriceTx:
    mov eax, val
    mov (Product PTR [esi]).UnitPrice, eax
    jmp SuccessExit

FailureExit:
    mov eax, 0
    ret

SuccessExit:
    mov eax, 1
    ret
ProcessRuntimeTx ENDP
END