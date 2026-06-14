; ====================================================================
; MODULE 2: INVENTORY MANAGEMENT MODULE (inventory.asm)
; ====================================================================
INCLUDE config.inc

.data
header BYTE "ID      | Stock  | Price (PKR) | Total Sold", 0dh, 0ah,
            "--------------------------------------------", 0dh, 0ah, 0
pipeChar BYTE "    | ", 0

.code
; Performs standard linear search through structures
SearchByID PROC USES ecx edx esi,
    pArray:PTR Product,
    arraySize:DWORD,
    searchID:DWORD

    mov ecx, arraySize
    mov esi, pArray
    mov edx, 0 

SearchLoop:
    mov eax, (Product PTR [esi]).ProductID
    cmp eax, searchID
    je Found
    add esi, TYPE Product
    inc edx
    loop SearchLoop

    mov eax, -1
    ret

Found:
    mov eax, edx
    ret
SearchByID ENDP

; Renders tabular database display in the console window
DisplayInventory PROC USES ecx esi edx,
    pArray:PTR Product,
    arraySize:DWORD

    mov edx, OFFSET header
    call WriteString
    
    mov ecx, arraySize
    mov esi, pArray

DisplayLoop:
    mov eax, (Product PTR [esi]).ProductID
    call WriteDec
    
    mov edx, OFFSET pipeChar
    call WriteString
    
    mov eax, (Product PTR [esi]).CurrentStock
    call WriteDec
    
    mov edx, OFFSET pipeChar
    call WriteString
    
    mov eax, (Product PTR [esi]).UnitPrice
    call WriteDec
    
    mov edx, OFFSET pipeChar
    call WriteString
    
    mov eax, (Product PTR [esi]).TotalSold
    call WriteDec
    call Crlf
    
    add esi, TYPE Product
    loop DisplayLoop

    ret
DisplayInventory ENDP
END