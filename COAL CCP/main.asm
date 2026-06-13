INCLUDE config.inc

.data
pArray Product MAX_PRODUCTS DUP(<>)
arraySize DWORD 0  ; Dynamically increments as products are added at runtime

menuPrompt BYTE "--- Smart Warehouse System (Runtime Mode) ---", 0dh, 0ah,
            "1. Register New Product", 0dh, 0ah,
            "2. Process Transaction (ADD/SALE/RETURN/PRICEUPDATE)", 0dh, 0ah,
            "3. Search Product Status", 0dh, 0ah,
            "4. Generate Shipment Code", 0dh, 0ah,
            "5. Display System Date", 0dh, 0ah,
            "6. Exit", 0dh, 0ah,
            "Enter selection: ", 0

txTypePrompt BYTE "Select Transaction Type:", 0dh, 0ah,
               "1. ADD (Increase Stock)", 0dh, 0ah,
               "2. SALE (Decrease Stock / Track Sold)", 0dh, 0ah,
               "3. RETURN (Increase Stock / Revert Sale)", 0dh, 0ah,
               "4. PRICEUPDATE (Modify Price)", 0dh, 0ah,
               "Selection: ", 0

idPrompt      BYTE "Enter Product ID: ", 0
valPrompt     BYTE "Enter Value/Quantity: ", 0
successMsg    BYTE "Operation completed successfully.", 0dh, 0ah, 0
failMsg       BYTE "Operation failed (Invalid ID or logical error).", 0dh, 0ah, 0
emptyMsg      BYTE "Database empty. Please register a product first.", 0dh, 0ah, 0
shipCodeMsg   BYTE "Generated Shipment Code (Hex): ", 0
invalidPrompt BYTE "Invalid selection. Please try again.", 0dh, 0ah, 0

.code
main PROC
MenuLoop:
    call Clrscr ; Replaced invalid "call Cld" with the correct Irvine32 screen clearing procedure
    mov edx, OFFSET menuPrompt
    call WriteString
    call ReadInt
    call Crlf

    cmp eax, 1
    je OptAddProduct
    cmp eax, 2
    je OptTransaction
    cmp eax, 3
    je OptSearch
    cmp eax, 4
    je OptShip
    cmp eax, 5
    je OptDate
    cmp eax, 6
    je OptExit
    
    mov edx, OFFSET invalidPrompt
    call WriteString
    call WaitMsg ; Allows the user to read the message before clearing screen
    jmp MenuLoop

OptAddProduct:
    INVOKE AddProductRuntime, ADDR pArray, ADDR arraySize
    jmp MenuLoop

OptTransaction:
    cmp arraySize, 0
    je DatabaseEmpty
    
    ; Get product ID
    mov edx, OFFSET idPrompt
    call WriteString
    call ReadInt
    mov ebx, eax ; Store target product ID in EBX
    
    ; Get transaction type
    mov edx, OFFSET txTypePrompt
    call WriteString
    call ReadInt
    mov ecx, eax ; Store selection in ECX
    
    ; Get quantity or new price
    mov edx, OFFSET valPrompt
    call WriteString
    call ReadInt
    
    ; Process transaction at runtime
    INVOKE ProcessRuntimeTx, ADDR pArray, arraySize, ecx, ebx, eax
    cmp eax, 1
    je ActionSuccess
    jmp ActionFail

OptSearch:
    cmp arraySize, 0
    je DatabaseEmpty
    
    mov edx, OFFSET idPrompt
    call WriteString
    call ReadInt
    
    INVOKE SearchByID, ADDR pArray, arraySize, eax
    cmp eax, -1
    je ActionFail
    
    ; Display search result
    mov esi, eax
    imul esi, TYPE Product
    
    mov edx, OFFSET successMsg
    call WriteString
    
    mov eax, (Product PTR pArray[esi]).ProductID
    call WriteDec
    call Crlf
    
    mov eax, (Product PTR pArray[esi]).CurrentStock
    call WriteDec
    call Crlf
    call WaitMsg
    jmp MenuLoop

OptShip:
    cmp arraySize, 0
    je DatabaseEmpty
    
    mov edx, OFFSET idPrompt
    call WriteString
    call ReadInt
    
    INVOKE SearchByID, ADDR pArray, arraySize, eax
    cmp eax, -1
    je ActionFail
    
    mov esi, eax
    imul esi, TYPE Product
    mov ebx, (Product PTR pArray[esi]).ProductID
    mov ecx, (Product PTR pArray[esi]).CurrentStock
    
    INVOKE GenerateShipmentCode, ebx, ecx
    mov edx, OFFSET shipCodeMsg
    call WriteString
    call WriteHex
    call Crlf
    call WaitMsg
    jmp MenuLoop

OptDate:
    INVOKE LoadSystemDate
    call Crlf
    call WaitMsg
    jmp MenuLoop

DatabaseEmpty:
    mov edx, OFFSET emptyMsg
    call WriteString
    call WaitMsg
    jmp MenuLoop

ActionSuccess:
    mov edx, OFFSET successMsg
    call WriteString
    call WaitMsg
    jmp MenuLoop

ActionFail:
    mov edx, OFFSET failMsg
    call WriteString
    call WaitMsg
    jmp MenuLoop

OptExit:
    exit
main ENDP
END main