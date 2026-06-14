; ====================================================================
; MODULE CONFIGURATION AND PROTOTYPES (config.inc)
; ====================================================================
INCLUDE C:/irvine/Irvine32.inc

; Constants
MAX_PRODUCTS     EQU 10
NAME_SIZE        EQU 21
CAT_SIZE         EQU 4
BUFFER_SIZE      EQU 500

; Product Record Structure
Product STRUCT
    ProductID      DWORD ?
    ProductName    BYTE NAME_SIZE DUP(0)
    CategoryCode   BYTE CAT_SIZE DUP(0)
    CurrentStock   DWORD ?
    UnitPrice      DWORD ?             ; Stored in cents (e.g., 1000 = $10.00)
    TotalSold      DWORD ?             ; Tracks total units sold
Product ENDS

; ==================== FUNCTION PROTOTYPES ====================

; Module 2: Inventory Prototypes
SearchByID PROTO, pArray:PTR Product, arraySize:DWORD, searchID:DWORD
DisplayInventory PROTO, pArray:PTR Product, arraySize:DWORD

; Module 3: Transaction Prototypes
ExecuteADD PROTO, pProduct:PTR Product, qty:DWORD
ExecuteSALE PROTO, pProduct:PTR Product, qty:DWORD
ExecuteRETURN PROTO, pProduct:PTR Product, qty:DWORD
ExecutePRICEUPDATE PROTO, pProduct:PTR Product, newPrice:DWORD

; Module 4: Statistics Prototypes
CalculateValuation PROTO, pArray:PTR Product, arraySize:DWORD
CalculateRevenue PROTO, pArray:PTR Product, arraySize:DWORD
GetLowStockCount PROTO, pArray:PTR Product, arraySize:DWORD, threshold:DWORD

; Module 5: Utility Prototypes
GenerateShipmentCode PROTO, prodID:DWORD, stock:DWORD
StringCompare PROTO, str1:PTR BYTE, str2:PTR BYTE
ParseInt PROTO, strPtr:PTR BYTE

; Module 6: System Services Prototypes
LoadSystemDate PROTO
ProcessTransactionFile PROTO, filename:PTR BYTE, pArray:PTR Product, arraySize:DWORD
WriteReportFile PROTO, filename:PTR BYTE, pArray:PTR Product, arraySize:DWORD