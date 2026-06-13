; Config file containing constants, structures, and external declarations
INCLUDE C:/irvine/Irvine32.inc

; Constants
MAX_PRODUCTS EQU 100
NAME_SIZE    EQU 21
CAT_SIZE     EQU 4

; Structures
Product STRUCT
    ProductID      DWORD 0
    ProductName    BYTE NAME_SIZE DUP(0)
    CategoryCode   BYTE CAT_SIZE DUP(0)
    CurrentStock   DWORD 0
    UnitPrice      DWORD 0             ; Stored in cents (e.g., 1000 = $10.00)
    TotalSold      DWORD 0
Product ENDS

; Module Prototypes
; Module 2 (Inventory)
SearchByID PROTO, pArray:PTR Product, arraySize:DWORD, searchID:DWORD
AddProductRuntime PROTO, pArray:PTR Product, pSize:PTR DWORD

; Module 3 (Transaction Processing)
ProcessRuntimeTx PROTO, pArray:PTR Product, arraySize:DWORD, txType:DWORD, prodID:DWORD, val:DWORD

; Module 5 (Utility)
GenerateShipmentCode PROTO, prodID:DWORD, stock:DWORD

; Module 6 (System Services)
LoadSystemDate PROTO