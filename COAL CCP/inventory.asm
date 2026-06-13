INCLUDE config.inc

.data
promptID    BYTE "Assign Product ID (Integer): ", 0
promptName  BYTE "Enter Product Name: ", 0
promptCat   BYTE "Enter Category Code (Max 3 chars): ", 0
promptStock BYTE "Enter Initial Stock: ", 0
promptPrice BYTE "Enter Unit Price (in Cents): ", 0

.code
; Linear search algorithm over the initialized structures
SearchByID PROC USES ecx esi,
    pArray:PTR Product,
    arraySize:DWORD,
    searchID:DWORD

    mov ecx, arraySize
    mov esi, pArray
    mov edx, 0 ; index

SearchLoop:
    cmp ecx, 0
    je NotFound
    mov eax, (Product PTR [esi]).ProductID
    cmp eax, searchID
    je Found
    add esi, TYPE Product
    inc edx
    loop SearchLoop

NotFound:
    mov eax, -1
    ret

Found:
    mov eax, edx ; Return index of found element
    ret
SearchByID ENDP

; Appends a new product item record using keyboard input values
AddProductRuntime PROC USES ebx esi,
    pArray:PTR Product,
    pSize:PTR DWORD

    mov ebx, pSize
    mov eax, [ebx] ; Get current array size
    cmp eax, MAX_PRODUCTS
    jae ListFull
    
    ; Compute offset address for insertion index
    imul eax, TYPE Product
    mov esi, pArray
    add esi, eax
    
    ; Input Product ID
    mov edx, OFFSET promptID
    call WriteString
    call ReadInt
    mov (Product PTR [esi]).ProductID, eax
    
    ; Input Product Name
    mov edx, OFFSET promptName
    call WriteString
    lea edx, (Product PTR [esi]).ProductName
    mov ecx, NAME_SIZE
    call ReadString
    
    ; Input Category
    mov edx, OFFSET promptCat
    call WriteString
    lea edx, (Product PTR [esi]).CategoryCode
    mov ecx, CAT_SIZE
    call ReadString

    ; Input Stock
    mov edx, OFFSET promptStock
    call WriteString
    call ReadInt
    mov (Product PTR [esi]).CurrentStock, eax
    
    ; Input Price
    mov edx, OFFSET promptPrice
    call WriteString
    call ReadInt
    mov (Product PTR [esi]).UnitPrice, eax
    
    ; Increment the array counter variable
    mov eax, [ebx]
    inc eax
    mov [ebx], eax
    
ListFull:
    ret
AddProductRuntime ENDP
END