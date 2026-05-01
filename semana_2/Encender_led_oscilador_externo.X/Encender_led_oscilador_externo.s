PROCESSOR 18F57Q43
#include <xc.inc>
#include <pic18f57q43.inc>
#include "cabecera.inc"

PSECT code, reloc = 2, abs

variable1 equ 500H
variable2 equ 501H
variable3 equ 502H

ORG 0H
goto configuro

ORG 20H

configuro:
    movlb 0H
    movlw 70H ; es el 0111 0000 
    movwf OSCCON1, b
    
    movlw 80H
    movwf OSCEN, b 
    

    
    movlb 04H
    bcf TRISF,3 ,b
    bcf ANSELF, 3, b
    bsf LATF, 3, b

inicio:
    movlb 05H
    call retardo
    movlb 04H
    btg LATF, 3, b
    goto inicio

retardo:
    movlw 100
    movwf variable1, b

xxx:
    movlw 250
    movwf variable2, b

yyy:
    movlw 5
    movwf variable3, b

zzz:
    decfsz variable3, 1,1
    goto zzz

    decfsz variable2, 1, 1
    goto yyy

    decfsz variable1, 1, 1
    goto xxx

    return
end