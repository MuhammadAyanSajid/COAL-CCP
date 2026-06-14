INCLUDE config.inc

.code
; ADD Transaction
ExecuteADD PROC USES ebx,
    pProduct:PTR Product,
    qty:DWORD

    mov ebx, pProduct
    mov eax, qty
    add (Product PTR [ebx]).CurrentStock, eax
    mov eax, 1 ; Success
    ret
ExecuteADD ENDP

; SALE Transaction with stock underflow protection
ExecuteSALE PROC USES ebx ecx,
    pProduct:PTR Product,
    qty:DWORD

    mov ebx, pProduct
    mov ecx, (Product PTR [ebx]).CurrentStock
    cmp ecx, qty
    jb UnderflowError
    
    ; Deduct stock and increment lifetime sales metric
    mov eax, qty
    sub (Product PTR [ebx]).CurrentStock, eax
    add (Product PTR [ebx]).TotalSold, eax
    mov eax, 1 ; Success
    ret

UnderflowError:
    mov eax, 0 ; Failed validation check
    ret
ExecuteSALE ENDP

; RETURN Transaction
ExecuteRETURN PROC USES ebx,
    pProduct:PTR Product,
    qty:DWORD

    mov ebx, pProduct
    ; Ensure we don't reduce lifetime sales below zero
    mov eax, qty
    mov ecx, (Product PTR [ebx]).TotalSold
    cmp ecx, eax
    jae DeductSales
    mov (Product PTR [ebx]).TotalSold, 0
    jmp AdjustStock

DeductSales:
    sub (Product PTR [ebx]).TotalSold, eax

AdjustStock:
    add (Product PTR [ebx]).CurrentStock, eax
    mov eax, 1 ; Success
    ret
ExecuteRETURN ENDP

; PRICEUPDATE Transaction
ExecutePRICEUPDATE PROC USES ebx,
    pProduct:PTR Product,
    newPrice:DWORD

    mov ebx, pProduct
    mov eax, newPrice
    cmp eax, 0
    jle PriceError
    
    mov (Product PTR [ebx]).UnitPrice, eax
    mov eax, 1 ; Success
    ret

PriceError:
    mov eax, 0 ; Invalid update value
    ret
ExecutePRICEUPDATE ENDP
END