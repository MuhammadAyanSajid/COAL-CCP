INCLUDE config.inc

.data
dateTag BYTE "Current Local Date: ", 0
sysTime SYSTEMTIME <>

.code
LoadSystemDate PROC USES edx
    mov edx, OFFSET dateTag
    call WriteString
    
    INVOKE GetLocalTime, ADDR sysTime
    
    ; Day
    movzx eax, sysTime.wDay
    call WriteDec
    mov al, '-'
    call WriteChar
    
    ; Month
    movzx eax, sysTime.wMonth
    call WriteDec
    mov al, '-'
    call WriteChar
    
    ; Year
    movzx eax, sysTime.wYear
    call WriteDec
    ret
LoadSystemDate ENDP
END