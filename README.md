# Smart Warehouse Inventory and Shipment Management System

An efficient, modular 32-bit x86 assembly language application designed to manage warehouse stock records, process bulk transactions, perform financial calculations in Pakistani Rupees (PKR), and generate unique shipment tracking codes using low-overhead bitwise operations.

This system was developed as a Complex Computing Problem (CCP) for the **CSC205: Computer Organization and Assembly Language** course.

## Project Contributors

*   [**Muhammad Ayan Sajid**](https://github.com/MuhammadAyanSajid)
*   [**Muhammad Husnain**](https://github.com/nexhus)
*   [**Fiza Shahid Khan**](https://www.linkedin.com/in/shareen-asim-9987a33a8/)
*   [**Shareen Asim**](https://www.linkedin.com/in/fiza-shahid-khan-a657713b2/)

**Submitted To:** [Mr. Nadeem Iqbal](https://www.linkedin.com/in/nadeem-iqbal-b29690252/)  
**Institution:** Department of Computer Science, UET Lahore (New Campus)  
**Session:** Fall 2024

---

## Key Features

*   **Multi-Module Architecture:** Adheres to a strict six-module structure to ensure separation of concerns.
*   **In-Memory Database:** Maintains an array of structures representing up to 100 products with 41-byte records aligned to memory boundaries.
*   **Transactional Integrity:** Supports `ADD`, `SALE`, `RETURN`, and `PRICEUPDATE` transactions with boundary validation to prevent stock underflows and price anomalies.
*   **PKR Pricing Integration:** Performs math calculations in integer spaces to eliminate floating-point rounding errors.
*   **System Services Integration:** Utilizes register-based calls to interface with the operating system via the Irvine32 library for file handling and date/time retrieval.
*   **Bitwise Hashing:** Implements single-cycle bitwise shift and rotate operations (`rol`, `ror`, `xor`) to generate tracking codes with minimal CPU cycle overhead.

---

## Directory Structure

```text
WarehouseSystem/
│
├── main.asm          ; Module 1: Program loop and menu selection control
├── inventory.asm     ; Module 2: Traversal, linear searching, and console display
├── transaction.asm   ; Module 3: Transaction execution and boundary checks
├── statistics.asm    ; Module 4: Valuation, total revenue, and low-stock count
├── utility.asm       ; Module 5: String comparisons, parsing, and bitwise hashing
├── services.asm      ; Module 6: File open/read/write routines and system date/time
│
├── config.inc        ; Constants, STRUCT definitions, and prototypes
├── transactions.txt  ; Input transactional log file
└── README.md         ; Repository documentation
```

---

## Data Structure Specification

Each product record is represented by a structured memory block defined as follows:

```assembly
Product STRUCT
    ProductID      DWORD ?             ; 4-Byte Unique Identifier
    ProductName    BYTE 21 DUP(0)      ; 21-Byte Name String (Null-Terminated)
    CategoryCode   BYTE 4 DUP(0)       ; 4-Byte Category Code (Null-Terminated)
    CurrentStock   DWORD ?             ; 4-Byte Unsigned Integer (Stock Count)
    UnitPrice      DWORD ?             ; 4-Byte Unsigned Integer (Price in PKR)
    TotalSold      DWORD ?             ; 4-Byte Unsigned Integer (Lifetime Units Sold)
Product ENDS                           ; Size of Structure = 41 Bytes
```

---

## Setup & Compilation Instructions

### Prerequisites
*   Windows OS
*   Visual Studio (2019, 2022, or newer) with the **C++ Desktop Development** workload installed.
*   The **Irvine32** library installed on your system (typically in `C:\Irvine`).

### Configuration Steps
1.  Open Visual Studio and create a new **C++ Empty Project**.
2.  Right-click the project in the Solution Explorer, select **Build Dependencies** > **Build Customizations**, and check **masm**.
3.  Add all six `.asm` files, `config.inc`, and `transactions.txt` to the project directory.
4.  Configure the project properties:
    *   **Linker** > **General** > **Additional Library Directories**: Set to `C:\Irvine`.
    *   **Linker** > **Input** > **Additional Dependencies**: Add `Irvine32.lib;user32.lib;kernel32.lib;gdi32.lib;`.
    *   **Microsoft Macro Assembler** > **General** > **Include Paths**: Set to `C:\Irvine`.
5.  Ensure your solution platform is set to **x86** (32-bit).

---

## Execution Guide

### Preparing the Transaction Log
Place your **`transactions.txt`** file in the same directory as your source code. The file should format transactional events sequentially. For example:
```text
ADD,101,20
SALE,102,5
RETURN,101,2
PRICEUPDATE,103,550
```

### Navigating the Interactive Interface
Upon running the executable, navigate the program through the console menu selections:
1.  **Display System Date & Time:** Pulls and displays the OS timestamp down to the second.
2.  **Display Current Inventory Status:** Renders a clean table of the database array with PKR indicators.
3.  **Process Bulk Transaction File:** Reads `transactions.txt` to apply transactional updates in memory.
4.  **Calculate Financials & Generate Report:** Writes a processed summary file named `report.txt` directly to your folder.
5.  **Search Product & Generate Shipment Code:** Resolves product indices and outputs an 8-character hexadecimal tracking hash.
6.  **Exit:** Closes the console safely.
```
