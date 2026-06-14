INCLUDE config.inc

.data
pArray Product MAX_PRODUCTS DUP(<>)
arraySize DWORD 5

; File paths
txFile     BYTE "transactions.txt", 0
reportFile BYTE "report.txt", 0

; Menu strings - Split into clean, consecutive BYTE statements
menuPrompt BYTE "==================================================", 0dh, 0ah
           BYTE "      SMART WAREHOUSE MANAGEMENT SYSTEM           ", 0dh, 0ah
           BYTE "==================================================", 0dh, 0ah
           BYTE "1. Display System Date & Time", 0dh, 0ah
           BYTE "2. Display Current Inventory Status", 0dh, 0ah
           BYTE "3. Process Bulk Transaction File (transactions.txt)", 0dh, 0ah
           BYTE "4. Calculate Financials & Generate Report File", 0dh, 0ah
           BYTE "5. Search Product Details & Generate Shipment Code", 0dh, 0ah
           BYTE "6. Exit", 0dh, 0ah
           BYTE "Enter your selection (1-6): ", 0

choiceErr   BYTE "Invalid selection. Please try again.", 0dh, 0ah, 0
searchPrompt BYTE "Enter Product ID to query: ", 0
notFoundMsg BYTE "Error: Product ID not found.", 0dh, 0ah, 0
foundMsg    BYTE "Product Record Found successfully.", 0dh, 0ah, 0
shipMsg     BYTE "Generated Shipment Tracking Hash: ", 0
pressKey    BYTE "Press any key to return to menu...", 0

.code
main PROC
    ; Initialize Inventory Database with Seed Data
    mov (Product PTR pArray[0 * TYPE Product]).ProductID, 101
    mov (Product PTR pArray[0 * TYPE Product]).CurrentStock, 150
    mov (Product PTR pArray[0 * TYPE Product]).UnitPrice, 1200       ; $12.00
    mov (Product PTR pArray[0 * TYPE Product]).TotalSold, 25
    mov edx, OFFSET (Product PTR pArray[0 * TYPE Product]).ProductName
    push esi
    mov esi, OFFSET (Product PTR pArray[0 * TYPE Product]).ProductName
    mov dword ptr [esi], "dorP"   ; "Prod"
    mov dword ptr [esi+4], "A_tc" ; "ct_A"
    pop esi

    mov (Product PTR pArray[1 * TYPE Product]).ProductID, 102
    mov (Product PTR pArray[1 * TYPE Product]).CurrentStock, 15
    mov (Product PTR pArray[1 * TYPE Product]).UnitPrice, 2500       ; $25.00
    mov (Product PTR pArray[1 * TYPE Product]).TotalSold, 40

    mov (Product PTR pArray[2 * TYPE Product]).ProductID, 103
    mov (Product PTR pArray[2 * TYPE Product]).CurrentStock, 80
    mov (Product PTR pArray[2 * TYPE Product]).UnitPrice, 550        ; $5.50
    mov (Product PTR pArray[2 * TYPE Product]).TotalSold, 10

    mov (Product PTR pArray[3 * TYPE Product]).ProductID, 104
    mov (Product PTR pArray[3 * TYPE Product]).CurrentStock, 8
    mov (Product PTR pArray[3 * TYPE Product]).UnitPrice, 4500       ; $45.00
    mov (Product PTR pArray[3 * TYPE Product]).TotalSold, 5

    mov (Product PTR pArray[4 * TYPE Product]).ProductID, 105
    mov (Product PTR pArray[4 * TYPE Product]).CurrentStock, 120
    mov (Product PTR pArray[4 * TYPE Product]).UnitPrice, 150        ; $1.50
    mov (Product PTR pArray[4 * TYPE Product]).TotalSold, 110

MenuLoop:
    call Clrscr
    mov edx, OFFSET menuPrompt
    call WriteString
    call ReadInt
    
    cmp eax, 1
    je OptDate
    cmp eax, 2
    je OptDisplay
    cmp eax, 3
    je OptProcessFile
    cmp eax, 4
    je OptReport
    cmp eax, 5
    je OptSearch
    cmp eax, 6
    je OptExit
    
    mov edx, OFFSET choiceErr
    call WriteString
    call WaitForKey
    jmp MenuLoop

OptDate:
    call Clrscr
    INVOKE LoadSystemDate
    call Crlf
    call WaitForKey
    jmp MenuLoop

OptDisplay:
    call Clrscr
    INVOKE DisplayInventory, ADDR pArray, arraySize
    call Crlf
    call WaitForKey
    jmp MenuLoop

OptProcessFile:
    call Clrscr
    INVOKE ProcessTransactionFile, ADDR txFile, ADDR pArray, arraySize
    call Crlf
    call WaitForKey
    jmp MenuLoop

OptReport:
    call Clrscr
    INVOKE WriteReportFile, ADDR reportFile, ADDR pArray, arraySize
    call Crlf
    call WaitForKey
    jmp MenuLoop

OptSearch:
    call Clrscr
    mov edx, OFFSET searchPrompt
    call WriteString
    call ReadInt
    
    INVOKE SearchByID, ADDR pArray, arraySize, eax
    cmp eax, -1
    je ErrSearch
    
    ; Output item details and generate tracking hex code
    mov esi, eax
    imul esi, TYPE Product
    mov edx, OFFSET foundMsg
    call WriteString
    
    ; Run shipment rotation generator (Module 5)
    mov ebx, pArray[esi].ProductID
    mov ecx, pArray[esi].CurrentStock
    INVOKE GenerateShipmentCode, ebx, ecx
    
    mov edx, OFFSET shipMsg
    call WriteString
    call WriteHex
    call Crlf
    call WaitForKey
    jmp MenuLoop

ErrSearch:
    mov edx, OFFSET notFoundMsg
    call WriteString
    call WaitForKey
    jmp MenuLoop

OptExit:
    exit
main ENDP

WaitForKey PROC
    mov edx, OFFSET pressKey
    call WriteString
    call ReadChar
    ret
WaitForKey ENDP

END main