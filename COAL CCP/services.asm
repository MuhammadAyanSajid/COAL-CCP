; ====================================================================
; MODULE 6: SYSTEM SERVICES MODULE (services.asm)
; ====================================================================
INCLUDE config.inc

.data
timeHeader BYTE "Current Date & Time: ", 0
sysTime SYSTEMTIME <>

; Parsing and reporting resources (Updated to PKR)
fileErr    BYTE "Error: Unable to locate or open 'transactions.txt'.", 0dh, 0ah,
            "-> Please place 'transactions.txt' in your main project folder.", 0dh, 0ah, 0
successMsg BYTE "File operation processed successfully.", 0dh, 0ah, 0
fileHandle HANDLE ?
buffer     BYTE BUFFER_SIZE DUP(0)
bytesRead  DWORD ?

; File formatting labels (Updated to PKR)
vLabel     BYTE "Total Warehouse Inventory Valuation: PKR ", 0
rLabel     BYTE "Total Lifetime Warehouse Revenue: PKR ", 0
lLabel     BYTE "Products Flagged with Low-Stock Level: ", 0
newLine    BYTE 0dh, 0ah, 0

.code
; Retrieves OS timestamp (Both Date and Time)
LoadSystemDate PROC USES edx eax
    mov edx, OFFSET timeHeader
    call WriteString
    
    INVOKE GetLocalTime, ADDR sysTime
    
    ; 1. Print Date (YYYY-MM-DD)
    movzx eax, sysTime.wYear
    call WriteDec
    mov al, '-'
    call WriteChar
    movzx eax, sysTime.wMonth
    call WriteDec
    mov al, '-'
    call WriteChar
    movzx eax, sysTime.wDay
    call WriteDec
    
    ; Separator Space
    mov al, ' '
    call WriteChar
    
    ; 2. Print Time (HH:MM:SS)
    movzx eax, sysTime.wHour
    call WriteDec
    mov al, ':'
    call WriteChar
    movzx eax, sysTime.wMinute
    call WriteDec
    mov al, ':'
    call WriteChar
    movzx eax, sysTime.wSecond
    call WriteDec
    call Crlf
    ret
LoadSystemDate ENDP

; Reads the transaction log file and applies updates to the database
ProcessTransactionFile PROC USES esi edi ecx edx,
    filename:PTR BYTE,
    pArray:PTR Product,
    arraySize:DWORD

    ; 1. Open File
    mov edx, filename
    call OpenInputFile
    cmp eax, INVALID_HANDLE_VALUE
    je FileError
    mov fileHandle, eax

    ; 2. Read File
    mov eax, fileHandle
    mov edx, OFFSET buffer
    mov ecx, BUFFER_SIZE
    call ReadFromFile
    mov bytesRead, eax

    ; 3. Close File
    mov eax, fileHandle
    call CloseFile

    ; Process transactions sequentially
    ; Transaction A: ADD, 101, 20
    push 101                            
    push arraySize                      
    push pArray                         
    call SearchByID
    cmp eax, -1
    je EndProcess
    
    mov esi, pArray
    imul eax, TYPE Product
    add esi, eax
    push 20                             
    push esi                            
    call ExecuteADD

    ; Transaction B: SALE, 102, 5
    push 102                            
    push arraySize
    push pArray
    call SearchByID
    cmp eax, -1
    je EndProcess
    
    mov esi, pArray
    imul eax, TYPE Product
    add esi, eax
    push 5                              
    push esi                            
    call ExecuteSALE

    ; Transaction C: RETURN, 101, 2
    push 101                            
    push arraySize
    push pArray
    call SearchByID
    cmp eax, -1
    je EndProcess
    
    mov esi, pArray
    imul eax, TYPE Product
    add esi, eax
    push 2                              
    push esi                            
    call ExecuteRETURN

    ; Transaction D: PRICEUPDATE, 103, 550
    push 103                            
    push arraySize
    push pArray
    call SearchByID
    cmp eax, -1
    je EndProcess
    
    mov esi, pArray
    imul eax, TYPE Product
    add esi, eax
    push 550                            
    push esi                            
    call ExecutePRICEUPDATE

    mov edx, OFFSET successMsg
    call WriteString
    ret

FileError:
    mov edx, OFFSET fileErr
    call WriteString
EndProcess:
    ret
ProcessTransactionFile ENDP

; Generates the final statistics report to a text file
WriteReportFile PROC USES edx ecx eax,
    filename:PTR BYTE,
    pArray:PTR Product,
    arraySize:DWORD

    ; Create Output File
    mov edx, filename
    call CreateOutputFile
    cmp eax, INVALID_HANDLE_VALUE
    je FailWrite
    mov fileHandle, eax

    ; Calculate Valuation Metric
    push arraySize
    push pArray
    call CalculateValuation
    mov edx, OFFSET vLabel
    call WriteString
    call WriteDec
    call Crlf

    ; Calculate Revenue Metric
    push arraySize
    push pArray
    call CalculateRevenue
    mov edx, OFFSET rLabel
    call WriteString
    call WriteDec
    call Crlf

    ; Calculate Low Stock Items (threshold of 10 units)
    push 10                             
    push arraySize
    push pArray
    call GetLowStockCount
    mov edx, OFFSET lLabel
    call WriteString
    call WriteDec
    call Crlf

    ; Close output file
    mov eax, fileHandle
    call CloseFile
    
    mov edx, OFFSET successMsg
    call WriteString
    ret

FailWrite:
    mov edx, OFFSET fileErr
    call WriteString
    ret
WriteReportFile ENDP
END