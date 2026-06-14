INCLUDE config.inc

.code
; Calculates total value of current stock (Valuation = Stock * Price)
CalculateValuation PROC USES ecx esi edx,
    pArray:PTR Product,
    arraySize:DWORD

    mov ecx, arraySize
    mov esi, pArray
    mov edx, 0 ; Accumulator

ValLoop:
    mov eax, (Product PTR [esi]).CurrentStock
    imul eax, (Product PTR [esi]).UnitPrice
    add edx, eax
    add esi, TYPE Product
    loop ValLoop

    mov eax, edx
    ret
CalculateValuation ENDP

; Calculates total historical revenue (Revenue = Sold * Price)
CalculateRevenue PROC USES ecx esi edx,
    pArray:PTR Product,
    arraySize:DWORD

    mov ecx, arraySize
    mov esi, pArray
    mov edx, 0 ; Accumulator

RevLoop:
    mov eax, (Product PTR [esi]).TotalSold
    imul eax, (Product PTR [esi]).UnitPrice
    add edx, eax
    add esi, TYPE Product
    loop RevLoop

    mov eax, edx
    ret
CalculateRevenue ENDP

; Identifies products below the low stock threshold
GetLowStockCount PROC USES ecx esi edx,
    pArray:PTR Product,
    arraySize:DWORD,
    threshold:DWORD

    mov ecx, arraySize
    mov esi, pArray
    mov edx, 0 ; Counter

ThresholdLoop:
    mov eax, (Product PTR [esi]).CurrentStock
    cmp eax, threshold
    jae KeepGoing
    inc edx

KeepGoing:
    add esi, TYPE Product
    loop ThresholdLoop

    mov eax, edx
    ret
GetLowStockCount ENDP
END